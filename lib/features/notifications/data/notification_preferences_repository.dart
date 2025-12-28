import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/notification_settings.dart';

part 'notification_preferences_repository.g.dart';

/// Repository for managing user notification preferences
class NotificationPreferencesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _settingsCollection =>
      _firestore.collection('notificationSettings');

  // ═══════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════

  /// Get user's notification settings
  Future<NotificationSettings> getSettings(String userId) async {
    try {
      final doc = await _settingsCollection.doc(userId).get();

      if (!doc.exists) {
        // Create default settings if not exists
        final defaultSettings = NotificationSettings.defaultSettings(userId);
        await _settingsCollection.doc(userId).set(defaultSettings.toFirestore());
        return defaultSettings;
      }

      return NotificationSettings.fromFirestore(doc);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting notification settings',
          error: e, stackTrace: stackTrace);
      // Return default settings on error
      return NotificationSettings.defaultSettings(userId);
    }
  }

  /// Watch user's notification settings (real-time)
  Stream<NotificationSettings> watchSettings(String userId) {
    return _settingsCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) {
        return NotificationSettings.defaultSettings(userId);
      }
      return NotificationSettings.fromFirestore(doc);
    });
  }

  // ═══════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════

  /// Update notification settings
  Future<bool> updateSettings(NotificationSettings settings) async {
    try {
      await _settingsCollection.doc(settings.userId).set(
            settings.toFirestore(),
            SetOptions(merge: true),
          );
      AppLogger.info('Notification settings updated for ${settings.userId}');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error updating notification settings',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Toggle a specific notification type
  Future<bool> toggleNotification({
    required String userId,
    required String notificationType,
    required bool enabled,
  }) async {
    try {
      await _settingsCollection.doc(userId).update({
        notificationType: enabled,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      AppLogger.info('Toggled $notificationType to $enabled for $userId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error toggling notification',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Update nearby radius
  Future<bool> updateNearbyRadius({
    required String userId,
    required int radiusMeters,
  }) async {
    try {
      await _settingsCollection.doc(userId).update({
        'nearbyRadius': radiusMeters,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      AppLogger.info('Updated nearby radius to $radiusMeters meters for $userId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error updating nearby radius',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Enable all notifications
  Future<bool> enableAllNotifications(String userId) async {
    try {
      await _settingsCollection.doc(userId).update({
        'truckOpenings': true,
        'orderUpdates': true,
        'newCoupons': true,
        'reviews': true,
        'promotions': true,
        'followedTrucks': true,
        'chatMessages': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      AppLogger.info('Enabled all notifications for $userId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error enabling all notifications',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Disable all notifications
  Future<bool> disableAllNotifications(String userId) async {
    try {
      await _settingsCollection.doc(userId).update({
        'truckOpenings': false,
        'orderUpdates': false,
        'newCoupons': false,
        'reviews': false,
        'promotions': false,
        'nearbyTrucks': false,
        'followedTrucks': false,
        'chatMessages': false,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      AppLogger.info('Disabled all notifications for $userId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error disabling all notifications',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BATCH OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Get all users with a specific notification type enabled
  Future<List<String>> getUsersWithNotificationEnabled(
      String notificationType) async {
    try {
      final snapshot = await _settingsCollection
          .where(notificationType, isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting users with notification enabled',
          error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Get all users within a certain radius (for location-based notifications)
  Future<List<String>> getUsersWithNearbyEnabled({
    required int maxRadiusMeters,
  }) async {
    try {
      final snapshot = await _settingsCollection
          .where('nearbyTrucks', isEqualTo: true)
          .where('nearbyRadius', isLessThanOrEqualTo: maxRadiusMeters)
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting users with nearby enabled',
          error: e, stackTrace: stackTrace);
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════

  /// Reset settings to default
  Future<bool> resetToDefault(String userId) async {
    try {
      final defaultSettings = NotificationSettings.defaultSettings(userId);
      await _settingsCollection.doc(userId).set(defaultSettings.toFirestore());
      AppLogger.info('Reset notification settings to default for $userId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error resetting notification settings',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
NotificationPreferencesRepository notificationPreferencesRepository(
  Ref ref,
) {
  return NotificationPreferencesRepository();
}

@riverpod
Future<NotificationSettings> notificationSettings(
  Ref ref,
  String userId,
) {
  final repository = ref.watch(notificationPreferencesRepositoryProvider);
  return repository.getSettings(userId);
}

@riverpod
Stream<NotificationSettings> notificationSettingsStream(
  Ref ref,
  String userId,
) {
  final repository = ref.watch(notificationPreferencesRepositoryProvider);
  return repository.watchSettings(userId);
}
