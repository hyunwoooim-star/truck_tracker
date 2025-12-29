import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../../core/utils/app_logger.dart';

/// Service for handling user location and distance calculations
class LocationService {
  // Geofencing state
  Position? _lastPosition;
  DateTime? _lastPositionTime;
  DateTime? _highVelocityStartTime;
  StreamController<bool>? _movingStatusController;

  /// Stream that emits true when truck should auto-switch to "Moving" status
  Stream<bool> get movingStatusStream {
    _movingStatusController ??= StreamController<bool>.broadcast();
    return _movingStatusController!.stream;
  }
  // ═══════════════════════════════════════════════════════════
  // PERMISSION & INITIALIZATION
  // ═══════════════════════════════════════════════════════════

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    AppLogger.debug('Requesting location permission', tag: 'LocationService');

    final permission = await Geolocator.requestPermission();

    AppLogger.debug('Permission result: ${permission.name}', tag: 'LocationService');
    return permission;
  }

  /// Ensure location permission is granted
  Future<bool> ensurePermission() async {
    // Check if location service is enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.error('Location services are disabled', tag: 'LocationService');
      return false;
    }

    // Check permission
    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        AppLogger.error('Location permission denied', tag: 'LocationService');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppLogger.error('Location permission permanently denied', tag: 'LocationService');
      return false;
    }

    AppLogger.success('Location permission granted', tag: 'LocationService');
    return true;
  }

  // ═══════════════════════════════════════════════════════════
  // GET LOCATION
  // ═══════════════════════════════════════════════════════════

  /// Get current position (one-time)
  Future<Position?> getCurrentPosition() async {
    AppLogger.debug('Getting current position', tag: 'LocationService');

    try {
      // Ensure permission first
      final hasPermission = await ensurePermission();
      if (!hasPermission) {
        AppLogger.error('Cannot get position: No permission', tag: 'LocationService');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      AppLogger.success('Position acquired:', tag: 'LocationService');
      AppLogger.debug('Latitude: ${position.latitude}', tag: 'LocationService');
      AppLogger.debug('Longitude: ${position.longitude}', tag: 'LocationService');
      AppLogger.debug('Accuracy: ${position.accuracy}m', tag: 'LocationService');

      return position;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting position', error: e, stackTrace: stackTrace, tag: 'LocationService');
      return null;
    }
  }

  /// Get last known position (faster, but might be outdated)
  Future<Position?> getLastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();

      if (position != null) {
        AppLogger.debug('Last known position:', tag: 'LocationService');
        AppLogger.debug('Latitude: ${position.latitude}', tag: 'LocationService');
        AppLogger.debug('Longitude: ${position.longitude}', tag: 'LocationService');
      }

      return position;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting last known position', error: e, stackTrace: stackTrace, tag: 'LocationService');
      return null;
    }
  }

  /// Watch position changes (real-time stream)
  Stream<Position> watchPosition() {
    AppLogger.debug('Starting position stream', tag: 'LocationService');

    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DISTANCE CALCULATION
  // ═══════════════════════════════════════════════════════════

  /// Calculate distance between two points (in meters)
  /// Uses Haversine formula
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Calculate distance and return formatted string
  String getDistanceText(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    final distanceInMeters = calculateDistance(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    if (distanceInMeters < 1000) {
      // Less than 1km: show in meters
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      // 1km or more: show in kilometers
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  /// Calculate bearing (direction) between two points
  /// Returns angle in degrees (0-360)
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Get direction text (N, NE, E, SE, S, SW, W, NW)
  String getDirectionText(double bearing) {
    const directions = ['북', '북동', '동', '남동', '남', '남서', '서', '북서'];
    final index = ((bearing + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  // ═══════════════════════════════════════════════════════════
  // GEOFENCING & AUTO-STATUS
  // ═══════════════════════════════════════════════════════════

  /// Calculate current velocity in km/h based on position changes
  double? calculateVelocity(Position currentPosition) {
    if (_lastPosition == null || _lastPositionTime == null) {
      _lastPosition = currentPosition;
      _lastPositionTime = DateTime.now();
      return null;
    }

    final now = DateTime.now();
    final timeDiff = now.difference(_lastPositionTime!).inSeconds;

    if (timeDiff == 0) return null;

    final distance = calculateDistance(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    // Velocity in km/h
    final velocityKmh = (distance / timeDiff) * 3.6;

    _lastPosition = currentPosition;
    _lastPositionTime = now;

    return velocityKmh;
  }

  /// Monitor position stream for auto-status detection
  /// Returns true if truck has been moving at >20km/h for 5 minutes
  void monitorMovingStatus(Position position) {
    const velocityThreshold = 20.0; // km/h
    const duration = Duration(minutes: 5);

    final velocity = calculateVelocity(position);

    if (velocity == null) return;

    AppLogger.debug('Velocity: ${velocity.toStringAsFixed(1)} km/h', tag: 'LocationService');

    if (velocity > velocityThreshold) {
      // High velocity detected
      _highVelocityStartTime ??= DateTime.now();

      final elapsed = DateTime.now().difference(_highVelocityStartTime!);
      AppLogger.debug('High velocity duration: ${elapsed.inSeconds}s / ${duration.inSeconds}s', tag: 'LocationService');

      if (elapsed >= duration) {
        // Emit moving status
        AppLogger.success('Auto-switching to Moving status (velocity >20km/h for 5 min)', tag: 'LocationService');
        _movingStatusController?.add(true);
        _highVelocityStartTime = null; // Reset
      }
    } else {
      // Reset if velocity drops
      if (_highVelocityStartTime != null) {
        AppLogger.debug('Velocity dropped below threshold, resetting timer', tag: 'LocationService');
      }
      _highVelocityStartTime = null;
    }
  }

  /// Watch position with auto-status monitoring
  Stream<Position> watchPositionWithGeofencing() {
    AppLogger.debug('Starting position stream with geofencing', tag: 'LocationService');

    return watchPosition().map((position) {
      monitorMovingStatus(position);
      return position;
    });
  }

  /// Dispose resources
  void dispose() {
    _movingStatusController?.close();
  }

  // ═══════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════

  /// Check if a point is within a certain radius
  bool isWithinRadius(
    double centerLat,
    double centerLng,
    double pointLat,
    double pointLng,
    double radiusInMeters,
  ) {
    final distance = calculateDistance(
      centerLat,
      centerLng,
      pointLat,
      pointLng,
    );
    
    return distance <= radiusInMeters;
  }

  /// Get approximate walking time (assumes 5 km/h walking speed)
  Duration getWalkingTime(double distanceInMeters) {
    const walkingSpeedKmh = 5.0;
    const walkingSpeedMs = walkingSpeedKmh * 1000 / 3600; // m/s
    
    final timeInSeconds = distanceInMeters / walkingSpeedMs;
    return Duration(seconds: timeInSeconds.round());
  }

  /// Format walking time as text
  String getWalkingTimeText(double distanceInMeters) {
    final duration = getWalkingTime(distanceInMeters);
    
    if (duration.inMinutes < 1) {
      return '도보 1분 이내';
    } else if (duration.inMinutes < 60) {
      return '도보 약 ${duration.inMinutes}분';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '도보 약 $hours시간 $minutes분';
    }
  }

  // ═══════════════════════════════════════════════════════════
  // LOCATION SETTINGS
  // ═══════════════════════════════════════════════════════════

  /// Open location settings
  Future<bool> openLocationSettings() async {
    AppLogger.debug('Opening location settings', tag: 'LocationService');
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    AppLogger.debug('Opening app settings', tag: 'LocationService');
    return await Geolocator.openAppSettings();
  }
}





