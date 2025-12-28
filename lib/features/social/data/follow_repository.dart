import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../../notifications/fcm_service.dart';
import '../domain/truck_follow.dart';

part 'follow_repository.g.dart';

/// Repository for managing truck follows (social feature)
class FollowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _followsCollection =>
      _firestore.collection('follows');

  // ═══════════════════════════════════════════════════════════
  // WRITE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Follow a truck
  Future<void> followTruck({
    required String userId,
    required String truckId,
    bool notificationsEnabled = true,
  }) async {
    AppLogger.debug('Following truck', tag: 'FollowRepository');
    AppLogger.debug('User: $userId, Truck: $truckId', tag: 'FollowRepository');

    try {
      final docId = '${userId}_$truckId';

      final follow = TruckFollow(
        id: docId,
        userId: userId,
        truckId: truckId,
        followedAt: DateTime.now(),
        notificationsEnabled: notificationsEnabled,
      );

      await _followsCollection.doc(docId).set(follow.toFirestore());

      // Subscribe to FCM topic if notifications enabled
      if (notificationsEnabled) {
        await FcmService().subscribeToTruck(truckId);
      }

      // Update user's following count in subcollection (for quick lookup)
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .doc(truckId)
          .set({'followedAt': FieldValue.serverTimestamp()});

      // Update truck's follower count in subcollection
      await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('followers')
          .doc(userId)
          .set({'followedAt': FieldValue.serverTimestamp()});

      AppLogger.success('Successfully followed truck', tag: 'FollowRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error following truck',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      rethrow;
    }
  }

  /// Unfollow a truck
  Future<void> unfollowTruck({
    required String userId,
    required String truckId,
  }) async {
    AppLogger.debug('Unfollowing truck', tag: 'FollowRepository');
    AppLogger.debug('User: $userId, Truck: $truckId', tag: 'FollowRepository');

    try {
      final docId = '${userId}_$truckId';

      // Get follow document to check notification settings
      final doc = await _followsCollection.doc(docId).get();
      final wasSubscribed = doc.exists &&
          (doc.data()?['notificationsEnabled'] as bool? ?? false);

      // Delete follow document
      await _followsCollection.doc(docId).delete();

      // Unsubscribe from FCM topic if was subscribed
      if (wasSubscribed) {
        await FcmService().unsubscribeFromTruck(truckId);
      }

      // Remove from user's following subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('following')
          .doc(truckId)
          .delete();

      // Remove from truck's followers subcollection
      await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('followers')
          .doc(userId)
          .delete();

      AppLogger.success('Successfully unfollowed truck', tag: 'FollowRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error unfollowing truck',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      rethrow;
    }
  }

  /// Toggle notification settings for a followed truck
  Future<void> toggleNotifications({
    required String userId,
    required String truckId,
    required bool enabled,
  }) async {
    AppLogger.debug('Toggling notifications', tag: 'FollowRepository');

    try {
      final docId = '${userId}_$truckId';

      await _followsCollection.doc(docId).update({
        'notificationsEnabled': enabled,
      });

      // Subscribe/unsubscribe from FCM topic
      if (enabled) {
        await FcmService().subscribeToTruck(truckId);
      } else {
        await FcmService().unsubscribeFromTruck(truckId);
      }

      AppLogger.success('Notifications ${enabled ? "enabled" : "disabled"}',
          tag: 'FollowRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error toggling notifications',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Check if user is following a truck
  Future<bool> isFollowing({
    required String userId,
    required String truckId,
  }) async {
    try {
      final docId = '${userId}_$truckId';
      final doc = await _followsCollection.doc(docId).get();
      return doc.exists;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking follow status',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      return false;
    }
  }

  /// Get a specific follow document
  Future<TruckFollow?> getFollow({
    required String userId,
    required String truckId,
  }) async {
    try {
      final docId = '${userId}_$truckId';
      final doc = await _followsCollection.doc(docId).get();

      if (!doc.exists) return null;

      return TruckFollow.fromFirestore(doc);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting follow',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      return null;
    }
  }

  /// Watch user's followed trucks (real-time stream)
  Stream<List<TruckFollow>> watchUserFollows(String userId) {
    AppLogger.debug('Watching follows for user $userId', tag: 'FollowRepository');

    return _followsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('followedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final follows = snapshot.docs
          .map((doc) => TruckFollow.fromFirestore(doc))
          .toList();

      AppLogger.debug('User follows ${follows.length} trucks',
          tag: 'FollowRepository');
      return follows;
    });
  }

  /// Get follower count for a truck
  Future<int> getFollowerCount(String truckId) async {
    try {
      final snapshot = await _followsCollection
          .where('truckId', isEqualTo: truckId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting follower count',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      return 0;
    }
  }

  /// Get all truck IDs that a user follows (one-time fetch)
  Future<List<String>> getUserFollowedTruckIds(String userId) async {
    try {
      final snapshot = await _followsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['truckId'] as String)
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user follows',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      return [];
    }
  }

  /// Get all followers for a truck (one-time fetch)
  Future<List<TruckFollow>> getTruckFollowers(String truckId) async {
    try {
      final snapshot = await _followsCollection
          .where('truckId', isEqualTo: truckId)
          .orderBy('followedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TruckFollow.fromFirestore(doc))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting truck followers',
          error: e, stackTrace: stackTrace, tag: 'FollowRepository');
      return [];
    }
  }
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
FollowRepository followRepository(Ref ref) {
  return FollowRepository();
}

/// Provider for watching user's followed trucks
@riverpod
Stream<List<TruckFollow>> userFollows(Ref ref, String userId) {
  final repository = ref.watch(followRepositoryProvider);
  return repository.watchUserFollows(userId);
}

/// Provider for checking if user is following a truck
@riverpod
Future<bool> isFollowingTruck(
  Ref ref, {
  required String userId,
  required String truckId,
}) {
  final repository = ref.watch(followRepositoryProvider);
  return repository.isFollowing(userId: userId, truckId: truckId);
}

/// Provider for truck follower count
@riverpod
Future<int> truckFollowerCount(Ref ref, String truckId) {
  final repository = ref.watch(followRepositoryProvider);
  return repository.getFollowerCount(truckId);
}
