// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoriteRepository)
final favoriteRepositoryProvider = FavoriteRepositoryProvider._();

final class FavoriteRepositoryProvider
    extends
        $FunctionalProvider<
          FavoriteRepository,
          FavoriteRepository,
          FavoriteRepository
        >
    with $Provider<FavoriteRepository> {
  FavoriteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoriteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoriteRepository create(Ref ref) {
    return favoriteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoriteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoriteRepository>(value),
    );
  }
}

String _$favoriteRepositoryHash() =>
    r'11bb25fec0ff72efae7673cfdf33e9a06818a261';

/// Provider for watching user's favorite truck IDs

@ProviderFor(userFavorites)
final userFavoritesProvider = UserFavoritesFamily._();

/// Provider for watching user's favorite truck IDs

final class UserFavoritesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  /// Provider for watching user's favorite truck IDs
  UserFavoritesProvider._({
    required UserFavoritesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userFavoritesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userFavoritesHash();

  @override
  String toString() {
    return r'userFavoritesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return userFavorites(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserFavoritesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userFavoritesHash() => r'a33edbfa084a94742fe65b9f1136bbd6a53f214f';

/// Provider for watching user's favorite truck IDs

final class UserFavoritesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<String>>, String> {
  UserFavoritesFamily._()
    : super(
        retry: null,
        name: r'userFavoritesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching user's favorite truck IDs

  UserFavoritesProvider call(String userId) =>
      UserFavoritesProvider._(argument: userId, from: this);

  @override
  String toString() => r'userFavoritesProvider';
}

/// Provider for checking if a truck is favorited

@ProviderFor(isTruckFavorited)
final isTruckFavoritedProvider = IsTruckFavoritedFamily._();

/// Provider for checking if a truck is favorited

final class IsTruckFavoritedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking if a truck is favorited
  IsTruckFavoritedProvider._({
    required IsTruckFavoritedFamily super.from,
    required ({String userId, String truckId}) super.argument,
  }) : super(
         retry: null,
         name: r'isTruckFavoritedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isTruckFavoritedHash();

  @override
  String toString() {
    return r'isTruckFavoritedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({String userId, String truckId});
    return isTruckFavorited(
      ref,
      userId: argument.userId,
      truckId: argument.truckId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsTruckFavoritedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isTruckFavoritedHash() => r'fb6bce1c7e3b07fba4b6047c31db4e7df87025f0';

/// Provider for checking if a truck is favorited

final class IsTruckFavoritedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String userId, String truckId})
        > {
  IsTruckFavoritedFamily._()
    : super(
        retry: null,
        name: r'isTruckFavoritedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for checking if a truck is favorited

  IsTruckFavoritedProvider call({
    required String userId,
    required String truckId,
  }) => IsTruckFavoritedProvider._(
    argument: (userId: userId, truckId: truckId),
    from: this,
  );

  @override
  String toString() => r'isTruckFavoritedProvider';
}

/// Provider for truck favorite count

@ProviderFor(truckFavoriteCount)
final truckFavoriteCountProvider = TruckFavoriteCountFamily._();

/// Provider for truck favorite count

final class TruckFavoriteCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Provider for truck favorite count
  TruckFavoriteCountProvider._({
    required TruckFavoriteCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckFavoriteCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckFavoriteCountHash();

  @override
  String toString() {
    return r'truckFavoriteCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return truckFavoriteCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckFavoriteCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckFavoriteCountHash() =>
    r'df637628fbef3c59afd1ff56ce2b00bbd8ea9bc9';

/// Provider for truck favorite count

final class TruckFavoriteCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  TruckFavoriteCountFamily._()
    : super(
        retry: null,
        name: r'truckFavoriteCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for truck favorite count

  TruckFavoriteCountProvider call(String truckId) =>
      TruckFavoriteCountProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckFavoriteCountProvider';
}
