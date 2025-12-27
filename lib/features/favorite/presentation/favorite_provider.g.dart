// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteTruckIdHash() => r'6bf088d50c6231570957555d01dce86fc6e6385c';

/// Temporary provider for truck ID (will be passed via constructor in UI)
///
/// Copied from [favoriteTruckId].
@ProviderFor(favoriteTruckId)
final favoriteTruckIdProvider = AutoDisposeProvider<String?>.internal(
  favoriteTruckId,
  name: r'favoriteTruckIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteTruckIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteTruckIdRef = AutoDisposeProviderRef<String?>;
String _$favoriteToggleHash() => r'f2af315200ab9a5847324a7d7be6f83b41c2c602';

/// Provider for toggling favorite status
///
/// Copied from [FavoriteToggle].
@ProviderFor(FavoriteToggle)
final favoriteToggleProvider =
    AutoDisposeAsyncNotifierProvider<FavoriteToggle, bool>.internal(
      FavoriteToggle.new,
      name: r'favoriteToggleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteToggleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteToggle = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
