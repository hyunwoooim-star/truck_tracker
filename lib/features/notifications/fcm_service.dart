import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    if (kDebugMode) {
      debugPrint('🔔 Initializing FCM Service');
    }

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

    if (kDebugMode) {
      debugPrint('🔔 Permission status: ${settings.authorizationStatus}');
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        debugPrint('✅ User granted notification permission');
      }

      // Get FCM token
      final token = await getToken();
      if (token != null) {
        if (kDebugMode) {
          debugPrint('🎫 FCM Token: $token');
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint('❌ User declined notification permission');
      }
    }

    // Handle foreground messages
    _foregroundMessageSubscription?.cancel();
    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('📨 Foreground message received: ${message.notification?.title}');
        debugPrint('   Body: ${message.notification?.body}');
        debugPrint('   Data: ${message.data}');
      }
    });

    // Handle background messages (requires top-level function)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('🎫 FCM Token retrieved: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Save FCM token to user document
  Future<void> saveFcmTokenToUser(String userId) async {
    try {
      final token = await getToken();
      if (token == null) {
        debugPrint('❌ No FCM token to save');
        return;
      }

      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ FCM token saved to user $userId');
    } catch (e) {
      debugPrint('❌ Error saving FCM token: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TRUCK OPENING NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════

  /// Notify all followers when truck opens
  Future<void> notifyFollowers(String truckId, String truckName) async {
    debugPrint('🔔 Notifying followers of truck $truckId ($truckName)');

    try {
      // Get all users who have this truck in their favorites
      final favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('truckId', isEqualTo: truckId)
          .get();

      debugPrint('📊 Found ${favoritesSnapshot.docs.length} followers');

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

      debugPrint('🎫 Found ${tokens.length} valid FCM tokens');

      if (tokens.isEmpty) {
        debugPrint('⚠️ No tokens to send notifications to');
        return;
      }

      // Note: Sending notifications requires a backend server or Cloud Functions
      // This is a placeholder for the client-side logic
      // In production, you would call a Cloud Function that sends the notification
      debugPrint('📨 Would send notification to ${tokens.length} users:');
      debugPrint('   Title: "$truckName is now open!"');
      debugPrint('   Body: "Your favorite truck is now serving. Come get your food!"');

      // TODO: Call Cloud Function to send notification
      // Example:
      // await http.post(
      //   Uri.parse('https://YOUR_CLOUD_FUNCTION_URL/sendTruckOpenNotification'),
      //   body: json.encode({
      //     'tokens': tokens,
      //     'truckId': truckId,
      //     'truckName': truckName,
      //   }),
      // );
    } catch (e) {
      debugPrint('❌ Error notifying followers: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // SUBSCRIPTION TO TOPICS
  // ═══════════════════════════════════════════════════════════

  /// Subscribe to truck topic (alternative to individual tokens)
  Future<void> subscribeToTruck(String truckId) async {
    try {
      await _messaging.subscribeToTopic('truck_$truckId');
      debugPrint('✅ Subscribed to truck_$truckId topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from truck topic
  Future<void> unsubscribeFromTruck(String truckId) async {
    try {
      await _messaging.unsubscribeFromTopic('truck_$truckId');
      debugPrint('✅ Unsubscribed from truck_$truckId topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
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
      debugPrint('🔄 FCM Token refreshed: $newToken');
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

    if (kDebugMode) {
      debugPrint('🧹 FcmService disposed - all subscriptions cancelled');
    }
  }
}

// ═══════════════════════════════════════════════════════════
// BACKGROUND MESSAGE HANDLER (must be top-level function)
// ═══════════════════════════════════════════════════════════

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🌙 Background message received: ${message.notification?.title}');
  debugPrint('   Body: ${message.notification?.body}');
  debugPrint('   Data: ${message.data}');
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDER
// ═══════════════════════════════════════════════════════════

/// Provider for FCM Service with proper lifecycle management
@riverpod
FcmService fcmService(FcmServiceRef ref) {
  final service = FcmService();

  // Ensure dispose is called when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}
