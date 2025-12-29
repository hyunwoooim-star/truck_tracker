import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/notification.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _notificationsCollection =>
      _firestore.collection('notifications');

  /// Watch notifications for a user (real-time)
  Stream<List<AppNotification>> watchUserNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromFirestore(doc))
            .toList());
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting unread count',
          error: e, stackTrace: stackTrace, tag: 'NotificationRepository');
      return 0;
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({
        'isRead': true,
      });
      AppLogger.info('Notification marked as read: $notificationId',
          tag: 'NotificationRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error marking notification as read',
          error: e, stackTrace: stackTrace, tag: 'NotificationRepository');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final unreadDocs = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in unreadDocs.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      AppLogger.info('All notifications marked as read for user: $userId',
          tag: 'NotificationRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error marking all notifications as read',
          error: e, stackTrace: stackTrace, tag: 'NotificationRepository');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
      AppLogger.info('Notification deleted: $notificationId',
          tag: 'NotificationRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting notification',
          error: e, stackTrace: stackTrace, tag: 'NotificationRepository');
    }
  }

  /// Delete all notifications for a user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final docs = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in docs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      AppLogger.info('All notifications deleted for user: $userId',
          tag: 'NotificationRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting all notifications',
          error: e, stackTrace: stackTrace, tag: 'NotificationRepository');
    }
  }

  /// Save a notification (called when receiving push)
  Future<void> saveNotification(AppNotification notification) async {
    try {
      await _notificationsCollection.add(notification.toFirestore());
      AppLogger.info('Notification saved: ${notification.title}',
          tag: 'NotificationRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error saving notification',
          error: e, stackTrace: stackTrace, tag: 'NotificationRepository');
    }
  }
}

// Riverpod Providers
@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository();
}

@riverpod
Stream<List<AppNotification>> userNotifications(Ref ref, String userId) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.watchUserNotifications(userId);
}

@riverpod
Future<int> notificationUnreadCount(Ref ref, String userId) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getUnreadCount(userId);
}
