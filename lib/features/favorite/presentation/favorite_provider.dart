import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/favorite_repository.dart';

part 'favorite_provider.g.dart';

/// Provider to check if a specific truck is favorited by the current user
/// Usage: ref.watch(isTruckFavoriteProvider(truckId))
@riverpod
Future<bool> isTruckFavorite(Ref ref, String truckId) async {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return false;
  }

  final repository = ref.watch(favoriteRepositoryProvider);
  return await repository.isFavorite(userId: userId, truckId: truckId);
}

/// Provider to get list of favorite truck IDs for current user
/// Usage: ref.watch(favoriteTruckIdsProvider)
@riverpod
Stream<List<String>> favoriteTruckIds(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.watchUserFavorites(userId);
}

/// Utility function to toggle favorite status
/// Use this directly instead of a notifier for simpler API
Future<bool> toggleTruckFavorite({
  required WidgetRef ref,
  required String truckId,
}) async {
  final userId = ref.read(currentUserIdProvider);

  if (userId == null) {
    AppLogger.warning('User not logged in', tag: 'FavoriteToggle');
    throw Exception('User not logged in');
  }

  final repository = ref.read(favoriteRepositoryProvider);
  final newStatus = await repository.toggleFavorite(
    userId: userId,
    truckId: truckId,
  );

  // Invalidate the favorite state for this truck to trigger refresh
  ref.invalidate(isTruckFavoriteProvider(truckId));
  ref.invalidate(favoriteTruckIdsProvider);

  AppLogger.debug('Favorite toggled: $newStatus for truck $truckId', tag: 'FavoriteToggle');
  return newStatus;
}





