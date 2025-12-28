import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/app_logger.dart';

part 'fcm_service.g.dart';

/// FCM Service for push notifications
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream subscriptions for proper cleanup
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;

  // ═══════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    AppLogger.debug('Initializing FCM Service', tag: 'FcmService');

    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AppLogger.debug('Permission status: ${settings.authorizationStatus}', tag: 'FcmService');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.success('User granted notification permission', tag: 'FcmService');

      // Get FCM token
      final token = await getToken();
      if (token != null) {
        AppLogger.debug('FCM Token: $token', tag: 'FcmService');
      }
    } else {
      AppLogger.warning('User declined notification permission', tag: 'FcmService');
    }

    // Handle foreground messages
    _foregroundMessageSubscription?.cancel();
    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.debug('Foreground message received: ${message.notification?.title}', tag: 'FcmService');
      AppLogger.debug('Body: ${message.notification?.body}', tag: 'FcmService');
      AppLogger.debug('Data: ${message.data}', tag: 'FcmService');
    });

    // Handle background messages (requires top-level function)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      AppLogger.debug('FCM Token retrieved: $token', tag: 'FcmService');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting FCM token', error: e, stackTrace: stackTrace, tag: 'FcmService');
      return null;
    }
  }

  /// Save FCM token to user document
  Future<void> saveFcmTokenToUser(String userId) async {
    try {
      final token = await getToken();
      if (token == null) {
        AppLogger.warning('No FCM token to save', tag: 'FcmService');
        return;
      }

      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('FCM token saved to user $userId', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error saving FCM token', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TRUCK OPENING NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════

  /// Notify all followers when truck opens
  Future<void> notifyFollowers(String truckId, String truckName) async {
    AppLogger.debug('Notifying followers of truck $truckId ($truckName)', tag: 'FcmService');

    try {
      // Get all users who have this truck in their favorites
      final favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('truckId', isEqualTo: truckId)
          .get();

      AppLogger.debug('Found ${favoritesSnapshot.docs.length} followers', tag: 'FcmService');

      // Get FCM tokens for all followers
      final List<String> tokens = [];
      for (final doc in favoritesSnapshot.docs) {
        final userId = doc.data()['userId'] as String?;
        if (userId != null) {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          final fcmToken = userDoc.data()?['fcmToken'] as String?;
          if (fcmToken != null && fcmToken.isNotEmpty) {
            tokens.add(fcmToken);
          }
        }
      }

      AppLogger.debug('Found ${tokens.length} valid FCM tokens', tag: 'FcmService');

      if (tokens.isEmpty) {
        AppLogger.warning('No tokens to send notifications to', tag: 'FcmService');
        return;
      }

      // Note: Notifications are handled automatically by Cloud Functions
      // The `notifyTruckOpening` function triggers on Firestore document update
      // when truck.isOpen changes from false to true.
      // Users subscribed to topic `truck_{truckId}` will receive push notifications.
      //
      // Cloud Function: functions/index.js#notifyTruckOpening
      // Trigger: Firestore onUpdate('trucks/{truckId}')
      //
      // This client-side method is kept for logging/debugging purposes.
      AppLogger.debug('Truck opened - Cloud Function will send notifications', tag: 'FcmService');
      AppLogger.debug('Followers count: ${tokens.length}', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error notifying followers', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // SUBSCRIPTION TO TOPICS
  // ═══════════════════════════════════════════════════════════

  /// Subscribe to truck topic (alternative to individual tokens)
  Future<void> subscribeToTruck(String truckId) async {
    try {
      await _messaging.subscribeToTopic('truck_$truckId');
      AppLogger.success('Subscribed to truck_$truckId topic', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error subscribing to topic', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  /// Unsubscribe from truck topic
  Future<void> unsubscribeFromTruck(String truckId) async {
    try {
      await _messaging.unsubscribeFromTopic('truck_$truckId');
      AppLogger.success('Unsubscribed from truck_$truckId topic', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error unsubscribing from topic', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TOKEN REFRESH
  // ═══════════════════════════════════════════════════════════

  /// Listen to token refresh
  void listenToTokenRefresh(String userId) {
    // Cancel existing subscription to prevent memory leaks
    _tokenRefreshSubscription?.cancel();

    // Start new subscription and store it for cleanup
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((newToken) {
      AppLogger.debug('FCM Token refreshed: $newToken', tag: 'FcmService');
      _firestore.collection('users').doc(userId).update({
        'fcmToken': newToken,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // ═══════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════

  /// Dispose of all stream subscriptions to prevent memory leaks
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;

    _foregroundMessageSubscription?.cancel();
    _foregroundMessageSubscription = null;

    AppLogger.debug('FcmService disposed - all subscriptions cancelled', tag: 'FcmService');
  }
}

// ═══════════════════════════════════════════════════════════
// BACKGROUND MESSAGE HANDLER (must be top-level function)
// ═══════════════════════════════════════════════════════════

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.debug('Background message received: ${message.notification?.title}', tag: 'FcmService');
  AppLogger.debug('Body: ${message.notification?.body}', tag: 'FcmService');
  AppLogger.debug('Data: ${message.data}', tag: 'FcmService');
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDER
// ═══════════════════════════════════════════════════════════

/// Provider for FCM Service with proper lifecycle management
@riverpod
FcmService fcmService(Ref ref) {
  final service = FcmService();

  // Ensure dispose is called when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}
