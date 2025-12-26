import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/presentation/auth_provider.dart';
import '../data/favorite_repository.dart';

part 'favorite_provider.g.dart';

/// Provider for toggling favorite status
@riverpod
class FavoriteToggle extends AutoDisposeAsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Initial state: check if favorited
    final userId = ref.watch(currentUserIdProvider);
    final truckId = ref.watch(favoriteTruckIdProvider);
    
    if (userId == null || truckId == null) {
      return false;
    }
    
    final repository = ref.watch(favoriteRepositoryProvider);
    return await repository.isFavorite(userId: userId, truckId: truckId);
  }

  /// Toggle favorite status
  Future<void> toggle(String truckId) async {
    final userId = ref.read(currentUserIdProvider);

    if (userId == null) {
      debugPrint('❌ User not logged in');
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoriteRepositoryProvider);
      final newStatus = await repository.toggleFavorite(
        userId: userId,
        truckId: truckId,
      );

      debugPrint('⭐ Favorite toggled: $newStatus');
      return newStatus;
    });
  }
}

/// Temporary provider for truck ID (will be passed via constructor in UI)
@riverpod
String? favoriteTruckId(FavoriteTruckIdRef ref) {
  return null;
}





