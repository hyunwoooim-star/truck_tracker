import 'dart:async';
import 'dart:ui' show Color;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/utils/app_logger.dart';
import '../../location/location_service.dart';
import '../../truck_list/domain/truck.dart';
import '../domain/notification_settings.dart';

/// Service for detecting nearby trucks and sending local notifications
/// Pokemon GO style: Notifies user when a truck enters their radius
class NearbyTruckService {
  // Singleton
  static final NearbyTruckService _instance = NearbyTruckService._internal();
  factory NearbyTruckService() => _instance;
  NearbyTruckService._internal();

  final LocationService _locationService = LocationService();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // State
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<QuerySnapshot>? _trucksSubscription;
  Timer? _checkTimer;

  List<Truck> _activeTrucks = [];
  final Set<String> _notifiedTruckIds = {}; // Prevent duplicate notifications
  NotificationSettings? _userSettings;
  String? _userId;

  bool _isInitialized = false;
  bool _isMonitoring = false;

  // Constants
  static const Duration _checkInterval = Duration(minutes: 2);
  static const Duration _notificationCooldown = Duration(hours: 1);

  // Notification cooldown tracking
  final Map<String, DateTime> _lastNotificationTime = {};

  /// Initialize the notification plugin
  Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.debug('Initializing NearbyTruckService...', tag: 'NearbyTruck');

    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    AppLogger.success('NearbyTruckService initialized', tag: 'NearbyTruck');
  }

  /// Start monitoring for nearby trucks
  Future<void> startMonitoring({
    required String userId,
    required NotificationSettings settings,
  }) async {
    if (_isMonitoring) {
      AppLogger.debug('Already monitoring, updating settings', tag: 'NearbyTruck');
      _userSettings = settings;
      return;
    }

    if (!settings.nearbyTrucks) {
      AppLogger.debug('Nearby notifications disabled by user', tag: 'NearbyTruck');
      return;
    }

    await initialize();

    _userId = userId;
    _userSettings = settings;
    _isMonitoring = true;

    AppLogger.debug('Starting nearby truck monitoring', tag: 'NearbyTruck');
    AppLogger.debug('Radius: ${settings.nearbyRadius}m', tag: 'NearbyTruck');

    // Check location permission
    final hasPermission = await _locationService.ensurePermission();
    if (!hasPermission) {
      AppLogger.warning('No location permission for nearby monitoring', tag: 'NearbyTruck');
      _isMonitoring = false;
      return;
    }

    // Start listening to truck updates
    _startTruckSubscription();

    // Start periodic location checks
    _startPeriodicCheck();

    AppLogger.success('Nearby monitoring started', tag: 'NearbyTruck');
  }

  /// Stop monitoring
  void stopMonitoring() {
    AppLogger.debug('Stopping nearby truck monitoring', tag: 'NearbyTruck');

    _positionSubscription?.cancel();
    _positionSubscription = null;

    _trucksSubscription?.cancel();
    _trucksSubscription = null;

    _checkTimer?.cancel();
    _checkTimer = null;

    _isMonitoring = false;
    _notifiedTruckIds.clear();
  }

  /// Subscribe to active trucks from Firestore
  void _startTruckSubscription() {
    _trucksSubscription?.cancel();

    _trucksSubscription = FirebaseFirestore.instance
        .collection('trucks')
        .where('status', whereIn: ['onRoute', 'resting'])
        .snapshots()
        .listen(
      (snapshot) {
        _activeTrucks = snapshot.docs.map((doc) {
          return Truck.fromFirestore(doc);
        }).toList();

        AppLogger.debug('Active trucks updated: ${_activeTrucks.length}', tag: 'NearbyTruck');

        // Check immediately when trucks update
        _checkNearbyTrucks();
      },
      onError: (error) {
        AppLogger.error('Error listening to trucks', error: error, tag: 'NearbyTruck');
      },
    );
  }

  /// Start periodic location check
  void _startPeriodicCheck() {
    _checkTimer?.cancel();

    _checkTimer = Timer.periodic(_checkInterval, (_) {
      _checkNearbyTrucks();
    });

    // Also do an immediate check
    _checkNearbyTrucks();
  }

  /// Check for nearby trucks and send notifications
  Future<void> _checkNearbyTrucks() async {
    if (!_isMonitoring || _userSettings == null) return;

    try {
      // Get current position
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        AppLogger.warning('Could not get current position', tag: 'NearbyTruck');
        return;
      }

      final radius = _userSettings!.nearbyRadius.toDouble();
      AppLogger.debug('Checking for trucks within ${radius}m', tag: 'NearbyTruck');
      AppLogger.debug('User location: ${position.latitude}, ${position.longitude}', tag: 'NearbyTruck');

      // Find trucks within radius
      for (final truck in _activeTrucks) {
        // Skip if already notified recently
        if (_isOnCooldown(truck.id)) continue;

        // Skip trucks with invalid coordinates
        if (truck.latitude == 0.0 && truck.longitude == 0.0) continue;

        final distance = _locationService.calculateDistance(
          position.latitude,
          position.longitude,
          truck.latitude,
          truck.longitude,
        );

        AppLogger.debug(
          'Truck ${truck.id}: ${distance.toStringAsFixed(0)}m away',
          tag: 'NearbyTruck',
        );

        if (distance <= radius) {
          // Truck is within radius!
          await _sendNearbyNotification(truck, distance);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error checking nearby trucks',
          error: e, stackTrace: stackTrace, tag: 'NearbyTruck');
    }
  }

  /// Check if we've notified about this truck recently
  bool _isOnCooldown(String truckId) {
    final lastTime = _lastNotificationTime[truckId];
    if (lastTime == null) return false;

    return DateTime.now().difference(lastTime) < _notificationCooldown;
  }

  /// Send a local notification about a nearby truck
  Future<void> _sendNearbyNotification(Truck truck, double distance) async {
    final distanceText = distance < 1000
        ? '${distance.toStringAsFixed(0)}m'
        : '${(distance / 1000).toStringAsFixed(1)}km';

    final statusEmoji = truck.status == TruckStatus.onRoute ? '🚚' : '✨';
    final statusText = truck.status == TruckStatus.onRoute ? '이동중' : '영업중';

    AppLogger.success(
      'Sending nearby notification for ${truck.foodType} ($distanceText)',
      tag: 'NearbyTruck',
    );

    const androidDetails = AndroidNotificationDetails(
      'nearby_trucks',
      '근처 트럭 알림',
      channelDescription: '내 주변에 푸드트럭이 나타났을 때 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFFFC107),
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      truck.id.hashCode, // Unique ID per truck
      '$statusEmoji ${truck.foodType} 트럭 발견!',
      '${truck.locationDescription} ($distanceText) - $statusText',
      details,
      payload: truck.id, // Pass truck ID for navigation
    );

    // Mark as notified
    _lastNotificationTime[truck.id] = DateTime.now();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final truckId = response.payload;
    if (truckId == null) return;

    AppLogger.debug('Notification tapped for truck: $truckId', tag: 'NearbyTruck');

    // Store pending navigation for handling when app context is available
    _pendingTruckNavigation = truckId;
  }

  /// Pending truck ID for navigation (set when notification is tapped)
  String? _pendingTruckNavigation;

  /// Get and clear pending navigation
  String? consumePendingNavigation() {
    final truckId = _pendingTruckNavigation;
    _pendingTruckNavigation = null;
    return truckId;
  }

  /// Check if there's a pending navigation
  bool get hasPendingNavigation => _pendingTruckNavigation != null;

  /// Update user settings
  void updateSettings(NotificationSettings settings) {
    _userSettings = settings;

    if (!settings.nearbyTrucks) {
      stopMonitoring();
    } else if (!_isMonitoring && _userId != null) {
      startMonitoring(userId: _userId!, settings: settings);
    }
  }

  /// Clear notification history (reset cooldowns)
  void clearNotificationHistory() {
    _notifiedTruckIds.clear();
    _lastNotificationTime.clear();
    AppLogger.debug('Notification history cleared', tag: 'NearbyTruck');
  }

  /// Get current monitoring status
  bool get isMonitoring => _isMonitoring;

  /// Get number of active trucks being tracked
  int get activeTruckCount => _activeTrucks.length;

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _isInitialized = false;
  }
}
