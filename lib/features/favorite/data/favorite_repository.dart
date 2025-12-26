import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../../notifications/fcm_service.dart';
import '../../truck_list/data/truck_repository.dart';

part 'favorite_repository.g.dart';

/// Repository for managing user favorites
class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TruckRepository _truckRepository = TruckRepository();

  CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      _firestore.collection('favorites');

  // ═══════════════════════════════════════════════════════════
  // WRITE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Add a truck to user's favorites
  Future<void> addFavorite({
    required String userId,
    required String truckId,
    String? fcmToken,
  }) async {
    AppLogger.debug('Adding favorite', tag: 'FavoriteRepository');
    AppLogger.debug('User: $userId, Truck: $truckId', tag: 'FavoriteRepository');

    try {
      final docId = '${userId}_$truckId';

      await _favoritesCollection.doc(docId).set({
        'userId': userId,
        'truckId': truckId,
        'fcmToken': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Subscribe to FCM topic for truck notifications
      await FcmService().subscribeToTruck(truckId);

      // Update truck's favorite count
      final newCount = await getFavoriteCount(truckId);
      await _truckRepository.updateFavoriteCount(truckId, newCount);

      AppLogger.success('Favorite added and subscribed to truck notifications', tag: 'FavoriteRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error adding favorite', error: e, stackTrace: stackTrace, tag: 'FavoriteRepository');
      rethrow;
    }
  }

  /// Remove a truck from user's favorites
  Future<void> removeFavorite({
    required String userId,
    required String truckId,
  }) async {
    AppLogger.debug('Removing favorite', tag: 'FavoriteRepository');
    AppLogger.debug('User: $userId, Truck: $truckId', tag: 'FavoriteRepository');

    try {
      final docId = '${userId}_$truckId';
      await _favoritesCollection.doc(docId).delete();

      // Unsubscribe from FCM topic
      await FcmService().unsubscribeFromTruck(truckId);

      // Update truck's favorite count
      final newCount = await getFavoriteCount(truckId);
      await _truckRepository.updateFavoriteCount(truckId, newCount);

      AppLogger.success('Favorite removed and unsubscribed from truck notifications', tag: 'FavoriteRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error removing favorite', error: e, stackTrace: stackTrace, tag: 'FavoriteRepository');
      rethrow;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite({
    required String userId,
    required String truckId,
    String? fcmToken,
  }) async {
    final isFavorite = await this.isFavorite(userId: userId, truckId: truckId);
    
    if (isFavorite) {
      await removeFavorite(userId: userId, truckId: truckId);
      return false;
    } else {
      await addFavorite(userId: userId, truckId: truckId, fcmToken: fcmToken);
      return true;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Check if truck is in user's favorites
  Future<bool> isFavorite({
    required String userId,
    required String truckId,
  }) async {
    try {
      final docId = '${userId}_$truckId';
      final doc = await _favoritesCollection.doc(docId).get();
      return doc.exists;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking favorite', error: e, stackTrace: stackTrace, tag: 'FavoriteRepository');
      return false;
    }
  }

  /// Watch user's favorite truck IDs (real-time stream)
  Stream<List<String>> watchUserFavorites(String userId) {
    AppLogger.debug('Watching favorites for user $userId', tag: 'FavoriteRepository');

    return _favoritesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final truckIds = snapshot.docs
          .map((doc) => doc.data()['truckId'] as String)
          .toList();

      AppLogger.debug('User has ${truckIds.length} favorites', tag: 'FavoriteRepository');
      return truckIds;
    });
  }

  /// Watch truck's favorite user IDs (for push notifications)
  Stream<List<String>> watchTruckFavorites(String truckId) {
    AppLogger.debug('Watching favorites for truck $truckId', tag: 'FavoriteRepository');

    return _favoritesCollection
        .where('truckId', isEqualTo: truckId)
        .snapshots()
        .map((snapshot) {
      final userIds = snapshot.docs
          .map((doc) => doc.data()['userId'] as String)
          .toList();

      AppLogger.debug('Truck has ${userIds.length} favorites', tag: 'FavoriteRepository');
      return userIds;
    });
  }

  /// Get favorite count for a truck
  Future<int> getFavoriteCount(String truckId) async {
    try {
      final snapshot = await _favoritesCollection
          .where('truckId', isEqualTo: truckId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting favorite count', error: e, stackTrace: stackTrace, tag: 'FavoriteRepository');
      return 0;
    }
  }

  /// Get FCM tokens for users who favorited a truck
  Future<List<String>> getFCMTokensForTruck(String truckId) async {
    try {
      final snapshot = await _favoritesCollection
          .where('truckId', isEqualTo: truckId)
          .get();

      final tokens = snapshot.docs
          .map((doc) => doc.data()['fcmToken'] as String?)
          .whereType<String>()
          .toList();

      AppLogger.debug('Found ${tokens.length} FCM tokens for truck $truckId', tag: 'FavoriteRepository');
      return tokens;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting FCM tokens', error: e, stackTrace: stackTrace, tag: 'FavoriteRepository');
      return [];
    }
  }

  /// Get all favorite trucks for a user (one-time fetch)
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['truckId'] as String)
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user favorites', error: e, stackTrace: stackTrace, tag: 'FavoriteRepository');
      return [];
    }
  }
}

@riverpod
FavoriteRepository favoriteRepository(FavoriteRepositoryRef ref) {
  return FavoriteRepository();
}

/// Provider for watching user's favorite truck IDs
@riverpod
Stream<List<String>> userFavorites(UserFavoritesRef ref, String userId) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.watchUserFavorites(userId);
}

/// Provider for checking if a truck is favorited
@riverpod
Future<bool> isTruckFavorited(
  IsTruckFavoritedRef ref, {
  required String userId,
  required String truckId,
}) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.isFavorite(userId: userId, truckId: truckId);
}

/// Provider for truck favorite count
@riverpod
Future<int> truckFavoriteCount(TruckFavoriteCountRef ref, String truckId) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.getFavoriteCount(truckId);
}





