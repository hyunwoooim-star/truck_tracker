// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteRepositoryHash() =>
    r'4db8ff3394d8f2a3e23519de3cb7972abf3044aa';

/// See also [favoriteRepository].
@ProviderFor(favoriteRepository)
final favoriteRepositoryProvider =
    AutoDisposeProvider<FavoriteRepository>.internal(
      favoriteRepository,
      name: r'favoriteRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteRepositoryRef = AutoDisposeProviderRef<FavoriteRepository>;
String _$userFavoritesHash() => r'ba323740eb66d016d7d9439b6ae20e439b4fad6e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for watching user's favorite truck IDs
///
/// Copied from [userFavorites].
@ProviderFor(userFavorites)
const userFavoritesProvider = UserFavoritesFamily();

/// Provider for watching user's favorite truck IDs
///
/// Copied from [userFavorites].
class UserFavoritesFamily extends Family<AsyncValue<List<String>>> {
  /// Provider for watching user's favorite truck IDs
  ///
  /// Copied from [userFavorites].
  const UserFavoritesFamily();

  /// Provider for watching user's favorite truck IDs
  ///
  /// Copied from [userFavorites].
  UserFavoritesProvider call(String userId) {
    return UserFavoritesProvider(userId);
  }

  @override
  UserFavoritesProvider getProviderOverride(
    covariant UserFavoritesProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userFavoritesProvider';
}

/// Provider for watching user's favorite truck IDs
///
/// Copied from [userFavorites].
class UserFavoritesProvider extends AutoDisposeStreamProvider<List<String>> {
  /// Provider for watching user's favorite truck IDs
  ///
  /// Copied from [userFavorites].
  UserFavoritesProvider(String userId)
    : this._internal(
        (ref) => userFavorites(ref as UserFavoritesRef, userId),
        from: userFavoritesProvider,
        name: r'userFavoritesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userFavoritesHash,
        dependencies: UserFavoritesFamily._dependencies,
        allTransitiveDependencies:
            UserFavoritesFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserFavoritesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<String>> Function(UserFavoritesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserFavoritesProvider._internal(
        (ref) => create(ref as UserFavoritesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<String>> createElement() {
    return _UserFavoritesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserFavoritesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserFavoritesRef on AutoDisposeStreamProviderRef<List<String>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserFavoritesProviderElement
    extends AutoDisposeStreamProviderElement<List<String>>
    with UserFavoritesRef {
  _UserFavoritesProviderElement(super.provider);

  @override
  String get userId => (origin as UserFavoritesProvider).userId;
}

String _$isTruckFavoritedHash() => r'359588c74516ea430200d23cb4b5c9525e37115e';

/// Provider for checking if a truck is favorited
///
/// Copied from [isTruckFavorited].
@ProviderFor(isTruckFavorited)
const isTruckFavoritedProvider = IsTruckFavoritedFamily();

/// Provider for checking if a truck is favorited
///
/// Copied from [isTruckFavorited].
class IsTruckFavoritedFamily extends Family<AsyncValue<bool>> {
  /// Provider for checking if a truck is favorited
  ///
  /// Copied from [isTruckFavorited].
  const IsTruckFavoritedFamily();

  /// Provider for checking if a truck is favorited
  ///
  /// Copied from [isTruckFavorited].
  IsTruckFavoritedProvider call({
    required String userId,
    required String truckId,
  }) {
    return IsTruckFavoritedProvider(userId: userId, truckId: truckId);
  }

  @override
  IsTruckFavoritedProvider getProviderOverride(
    covariant IsTruckFavoritedProvider provider,
  ) {
    return call(userId: provider.userId, truckId: provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isTruckFavoritedProvider';
}

/// Provider for checking if a truck is favorited
///
/// Copied from [isTruckFavorited].
class IsTruckFavoritedProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider for checking if a truck is favorited
  ///
  /// Copied from [isTruckFavorited].
  IsTruckFavoritedProvider({required String userId, required String truckId})
    : this._internal(
        (ref) => isTruckFavorited(
          ref as IsTruckFavoritedRef,
          userId: userId,
          truckId: truckId,
        ),
        from: isTruckFavoritedProvider,
        name: r'isTruckFavoritedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isTruckFavoritedHash,
        dependencies: IsTruckFavoritedFamily._dependencies,
        allTransitiveDependencies:
            IsTruckFavoritedFamily._allTransitiveDependencies,
        userId: userId,
        truckId: truckId,
      );

  IsTruckFavoritedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.truckId,
  }) : super.internal();

  final String userId;
  final String truckId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsTruckFavoritedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsTruckFavoritedProvider._internal(
        (ref) => create(ref as IsTruckFavoritedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsTruckFavoritedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsTruckFavoritedProvider &&
        other.userId == userId &&
        other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsTruckFavoritedRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _IsTruckFavoritedProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with IsTruckFavoritedRef {
  _IsTruckFavoritedProviderElement(super.provider);

  @override
  String get userId => (origin as IsTruckFavoritedProvider).userId;
  @override
  String get truckId => (origin as IsTruckFavoritedProvider).truckId;
}

String _$truckFavoriteCountHash() =>
    r'0d39e7dad197fe08d7d00d5a06eac8e5ea89a4b6';

/// Provider for truck favorite count
///
/// Copied from [truckFavoriteCount].
@ProviderFor(truckFavoriteCount)
const truckFavoriteCountProvider = TruckFavoriteCountFamily();

/// Provider for truck favorite count
///
/// Copied from [truckFavoriteCount].
class TruckFavoriteCountFamily extends Family<AsyncValue<int>> {
  /// Provider for truck favorite count
  ///
  /// Copied from [truckFavoriteCount].
  const TruckFavoriteCountFamily();

  /// Provider for truck favorite count
  ///
  /// Copied from [truckFavoriteCount].
  TruckFavoriteCountProvider call(String truckId) {
    return TruckFavoriteCountProvider(truckId);
  }

  @override
  TruckFavoriteCountProvider getProviderOverride(
    covariant TruckFavoriteCountProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckFavoriteCountProvider';
}

/// Provider for truck favorite count
///
/// Copied from [truckFavoriteCount].
class TruckFavoriteCountProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for truck favorite count
  ///
  /// Copied from [truckFavoriteCount].
  TruckFavoriteCountProvider(String truckId)
    : this._internal(
        (ref) => truckFavoriteCount(ref as TruckFavoriteCountRef, truckId),
        from: truckFavoriteCountProvider,
        name: r'truckFavoriteCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckFavoriteCountHash,
        dependencies: TruckFavoriteCountFamily._dependencies,
        allTransitiveDependencies:
            TruckFavoriteCountFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckFavoriteCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Override overrideWith(
    FutureOr<int> Function(TruckFavoriteCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckFavoriteCountProvider._internal(
        (ref) => create(ref as TruckFavoriteCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _TruckFavoriteCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckFavoriteCountProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckFavoriteCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckFavoriteCountProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with TruckFavoriteCountRef {
  _TruckFavoriteCountProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckFavoriteCountProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
