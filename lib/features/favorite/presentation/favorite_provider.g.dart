// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to check if a specific truck is favorited by the current user
/// Usage: ref.watch(isTruckFavoriteProvider(truckId))

@ProviderFor(isTruckFavorite)
final isTruckFavoriteProvider = IsTruckFavoriteFamily._();

/// Provider to check if a specific truck is favorited by the current user
/// Usage: ref.watch(isTruckFavoriteProvider(truckId))

final class IsTruckFavoriteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider to check if a specific truck is favorited by the current user
  /// Usage: ref.watch(isTruckFavoriteProvider(truckId))
  IsTruckFavoriteProvider._({
    required IsTruckFavoriteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isTruckFavoriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isTruckFavoriteHash();

  @override
  String toString() {
    return r'isTruckFavoriteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isTruckFavorite(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsTruckFavoriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isTruckFavoriteHash() => r'b9c7b8db566203dc3a56ff4de5415799d41561b9';

/// Provider to check if a specific truck is favorited by the current user
/// Usage: ref.watch(isTruckFavoriteProvider(truckId))

final class IsTruckFavoriteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  IsTruckFavoriteFamily._()
    : super(
        retry: null,
        name: r'isTruckFavoriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to check if a specific truck is favorited by the current user
  /// Usage: ref.watch(isTruckFavoriteProvider(truckId))

  IsTruckFavoriteProvider call(String truckId) =>
      IsTruckFavoriteProvider._(argument: truckId, from: this);

  @override
  String toString() => r'isTruckFavoriteProvider';
}

/// Provider to get list of favorite truck IDs for current user
/// Usage: ref.watch(favoriteTruckIdsProvider)

@ProviderFor(favoriteTruckIds)
final favoriteTruckIdsProvider = FavoriteTruckIdsProvider._();

/// Provider to get list of favorite truck IDs for current user
/// Usage: ref.watch(favoriteTruckIdsProvider)

final class FavoriteTruckIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  /// Provider to get list of favorite truck IDs for current user
  /// Usage: ref.watch(favoriteTruckIdsProvider)
  FavoriteTruckIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteTruckIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteTruckIdsHash();

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    return favoriteTruckIds(ref);
  }
}

String _$favoriteTruckIdsHash() => r'a530a22330981656ae71e20b8421be5d1ff0211d';
