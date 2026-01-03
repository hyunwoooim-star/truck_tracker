import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  /// Get FCM token with timeout to prevent infinite hanging on web
  Future<String?> getToken() async {
    try {
      // 웹에서 VAPID 키 없이 getToken() 호출 시 무한 대기 가능
      // 2초 타임아웃으로 단축 (모바일에서는 충분, 웹은 main.dart에서 스킵)
      final token = await _messaging.getToken().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          AppLogger.warning('FCM getToken timed out after 2 seconds', tag: 'FcmService');
          return null;
        },
      );
      if (token != null) {
        AppLogger.debug('FCM Token retrieved: ${token.substring(0, 20)}...', tag: 'FcmService');
      } else {
        AppLogger.warning('FCM Token is null', tag: 'FcmService');
      }
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting FCM token', error: e, stackTrace: stackTrace, tag: 'FcmService');
      return null;
    }
  }

  /// Save FCM token to user document
  /// Uses set with merge to handle case where document doesn't exist yet
  Future<void> saveFcmTokenToUser(String userId) async {
    try {
      final token = await getToken();
      if (token == null) {
        AppLogger.warning('No FCM token to save', tag: 'FcmService');
        return;
      }

      // set(merge: true) 사용하여 문서가 없어도 안전하게 처리
      // 타임아웃 추가하여 Firestore 지연 시 무한 대기 방지
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          AppLogger.warning('Firestore FCM token save timed out', tag: 'FcmService');
        },
      );

      AppLogger.success('FCM token saved to user $userId', tag: 'FcmService');
    } catch (e, stackTrace) {
      // 에러가 발생해도 회원가입 흐름은 계속 진행되어야 함
      AppLogger.error('Error saving FCM token (non-blocking)', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TRUCK OPENING NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════

  /// Notify all followers when truck opens
  /// OPTIMIZED: Uses batch fetching instead of N+1 queries
  Future<void> notifyFollowers(String truckId, String truckName) async {
    AppLogger.debug('Notifying followers of truck $truckId ($truckName)', tag: 'FcmService');

    try {
      final favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('truckId', isEqualTo: truckId)
          .get();

      final followerCount = favoritesSnapshot.docs.length;
      AppLogger.debug('Found $followerCount followers', tag: 'FcmService');

      if (followerCount == 0) {
        AppLogger.warning('No followers to notify', tag: 'FcmService');
        return;
      }

      // OPTIMIZED: Batch fetch user tokens instead of N+1 queries
      final userIds = favoritesSnapshot.docs
          .map((doc) => doc.data()['userId'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      if (userIds.isEmpty) {
        AppLogger.warning('No valid user IDs found', tag: 'FcmService');
        return;
      }

      // Batch fetch users in chunks of 30 (Firestore 'in' query limit)
      final List<String> tokens = [];
      const batchSize = 30;
      for (var i = 0; i < userIds.length; i += batchSize) {
        final batchIds = userIds.sublist(
          i,
          (i + batchSize > userIds.length) ? userIds.length : i + batchSize,
        );

        final usersSnapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: batchIds)
            .get();

        for (final userDoc in usersSnapshot.docs) {
          final fcmToken = userDoc.data()['fcmToken'] as String?;
          if (fcmToken != null && fcmToken.isNotEmpty) {
            tokens.add(fcmToken);
          }
        }
      }

      AppLogger.debug('Found ${tokens.length} valid FCM tokens', tag: 'FcmService');
      AppLogger.debug('Truck opened - Cloud Function will send notifications', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error notifying followers', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // SUBSCRIPTION TO TOPICS
  // ═══════════════════════════════════════════════════════════

  /// Subscribe to truck topic (alternative to individual tokens)
  /// NOTE: Topic subscription is NOT supported on web - only works on mobile
  Future<void> subscribeToTruck(String truckId) async {
    // 웹에서는 topic 구독이 지원되지 않음
    if (kIsWeb) {
      AppLogger.debug('Topic subscription not supported on web', tag: 'FcmService');
      return;
    }

    try {
      await _messaging.subscribeToTopic('truck_$truckId');
      AppLogger.success('Subscribed to truck_$truckId topic', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error subscribing to topic', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  /// Unsubscribe from truck topic
  /// NOTE: Topic subscription is NOT supported on web - only works on mobile
  Future<void> unsubscribeFromTruck(String truckId) async {
    // 웹에서는 topic 구독이 지원되지 않음
    if (kIsWeb) {
      AppLogger.debug('Topic unsubscription not supported on web', tag: 'FcmService');
      return;
    }

    try {
      await _messaging.unsubscribeFromTopic('truck_$truckId');
      AppLogger.success('Unsubscribed from truck_$truckId topic', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error unsubscribing from topic', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ADMIN NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════

  /// Subscribe to admin notifications topic (for admins only)
  /// Cloud Function sends notifications when new owner requests are submitted
  /// NOTE: Topic subscription is NOT supported on web - only works on mobile
  Future<void> subscribeToAdminNotifications() async {
    // 웹에서는 topic 구독이 지원되지 않음
    if (kIsWeb) {
      AppLogger.debug('Topic subscription not supported on web', tag: 'FcmService');
      return;
    }

    try {
      await _messaging.subscribeToTopic('admin_notifications');
      AppLogger.success('Subscribed to admin_notifications topic', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error subscribing to admin topic', error: e, stackTrace: stackTrace, tag: 'FcmService');
    }
  }

  /// Unsubscribe from admin notifications topic
  /// NOTE: Topic subscription is NOT supported on web - only works on mobile
  Future<void> unsubscribeFromAdminNotifications() async {
    // 웹에서는 topic 구독이 지원되지 않음
    if (kIsWeb) {
      AppLogger.debug('Topic unsubscription not supported on web', tag: 'FcmService');
      return;
    }

    try {
      await _messaging.unsubscribeFromTopic('admin_notifications');
      AppLogger.success('Unsubscribed from admin_notifications topic', tag: 'FcmService');
    } catch (e, stackTrace) {
      AppLogger.error('Error unsubscribing from admin topic', error: e, stackTrace: stackTrace, tag: 'FcmService');
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
