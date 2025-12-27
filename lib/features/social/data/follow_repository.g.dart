// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followRepositoryHash() => r'1534e9ed4d6c553f39db200bfac98591376072e2';

/// See also [followRepository].
@ProviderFor(followRepository)
final followRepositoryProvider = AutoDisposeProvider<FollowRepository>.internal(
  followRepository,
  name: r'followRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FollowRepositoryRef = AutoDisposeProviderRef<FollowRepository>;
String _$userFollowsHash() => r'98d2d9feb4518b2807a9a753accd1cf96597e52d';

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

/// Provider for watching user's followed trucks
///
/// Copied from [userFollows].
@ProviderFor(userFollows)
const userFollowsProvider = UserFollowsFamily();

/// Provider for watching user's followed trucks
///
/// Copied from [userFollows].
class UserFollowsFamily extends Family<AsyncValue<List<TruckFollow>>> {
  /// Provider for watching user's followed trucks
  ///
  /// Copied from [userFollows].
  const UserFollowsFamily();

  /// Provider for watching user's followed trucks
  ///
  /// Copied from [userFollows].
  UserFollowsProvider call(String userId) {
    return UserFollowsProvider(userId);
  }

  @override
  UserFollowsProvider getProviderOverride(
    covariant UserFollowsProvider provider,
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
  String? get name => r'userFollowsProvider';
}

/// Provider for watching user's followed trucks
///
/// Copied from [userFollows].
class UserFollowsProvider extends AutoDisposeStreamProvider<List<TruckFollow>> {
  /// Provider for watching user's followed trucks
  ///
  /// Copied from [userFollows].
  UserFollowsProvider(String userId)
    : this._internal(
        (ref) => userFollows(ref as UserFollowsRef, userId),
        from: userFollowsProvider,
        name: r'userFollowsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userFollowsHash,
        dependencies: UserFollowsFamily._dependencies,
        allTransitiveDependencies: UserFollowsFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserFollowsProvider._internal(
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
    Stream<List<TruckFollow>> Function(UserFollowsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserFollowsProvider._internal(
        (ref) => create(ref as UserFollowsRef),
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
  AutoDisposeStreamProviderElement<List<TruckFollow>> createElement() {
    return _UserFollowsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserFollowsProvider && other.userId == userId;
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
mixin UserFollowsRef on AutoDisposeStreamProviderRef<List<TruckFollow>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserFollowsProviderElement
    extends AutoDisposeStreamProviderElement<List<TruckFollow>>
    with UserFollowsRef {
  _UserFollowsProviderElement(super.provider);

  @override
  String get userId => (origin as UserFollowsProvider).userId;
}

String _$isFollowingTruckHash() => r'45f8ae3de1d99ad3da28391d853419e0e706c014';

/// Provider for checking if user is following a truck
///
/// Copied from [isFollowingTruck].
@ProviderFor(isFollowingTruck)
const isFollowingTruckProvider = IsFollowingTruckFamily();

/// Provider for checking if user is following a truck
///
/// Copied from [isFollowingTruck].
class IsFollowingTruckFamily extends Family<AsyncValue<bool>> {
  /// Provider for checking if user is following a truck
  ///
  /// Copied from [isFollowingTruck].
  const IsFollowingTruckFamily();

  /// Provider for checking if user is following a truck
  ///
  /// Copied from [isFollowingTruck].
  IsFollowingTruckProvider call({
    required String userId,
    required String truckId,
  }) {
    return IsFollowingTruckProvider(userId: userId, truckId: truckId);
  }

  @override
  IsFollowingTruckProvider getProviderOverride(
    covariant IsFollowingTruckProvider provider,
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
  String? get name => r'isFollowingTruckProvider';
}

/// Provider for checking if user is following a truck
///
/// Copied from [isFollowingTruck].
class IsFollowingTruckProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider for checking if user is following a truck
  ///
  /// Copied from [isFollowingTruck].
  IsFollowingTruckProvider({required String userId, required String truckId})
    : this._internal(
        (ref) => isFollowingTruck(
          ref as IsFollowingTruckRef,
          userId: userId,
          truckId: truckId,
        ),
        from: isFollowingTruckProvider,
        name: r'isFollowingTruckProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isFollowingTruckHash,
        dependencies: IsFollowingTruckFamily._dependencies,
        allTransitiveDependencies:
            IsFollowingTruckFamily._allTransitiveDependencies,
        userId: userId,
        truckId: truckId,
      );

  IsFollowingTruckProvider._internal(
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
    FutureOr<bool> Function(IsFollowingTruckRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFollowingTruckProvider._internal(
        (ref) => create(ref as IsFollowingTruckRef),
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
    return _IsFollowingTruckProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFollowingTruckProvider &&
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
mixin IsFollowingTruckRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _IsFollowingTruckProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with IsFollowingTruckRef {
  _IsFollowingTruckProviderElement(super.provider);

  @override
  String get userId => (origin as IsFollowingTruckProvider).userId;
  @override
  String get truckId => (origin as IsFollowingTruckProvider).truckId;
}

String _$truckFollowerCountHash() =>
    r'542ebd638ecd5fddc0d19905026944e4383fd09a';

/// Provider for truck follower count
///
/// Copied from [truckFollowerCount].
@ProviderFor(truckFollowerCount)
const truckFollowerCountProvider = TruckFollowerCountFamily();

/// Provider for truck follower count
///
/// Copied from [truckFollowerCount].
class TruckFollowerCountFamily extends Family<AsyncValue<int>> {
  /// Provider for truck follower count
  ///
  /// Copied from [truckFollowerCount].
  const TruckFollowerCountFamily();

  /// Provider for truck follower count
  ///
  /// Copied from [truckFollowerCount].
  TruckFollowerCountProvider call(String truckId) {
    return TruckFollowerCountProvider(truckId);
  }

  @override
  TruckFollowerCountProvider getProviderOverride(
    covariant TruckFollowerCountProvider provider,
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
  String? get name => r'truckFollowerCountProvider';
}

/// Provider for truck follower count
///
/// Copied from [truckFollowerCount].
class TruckFollowerCountProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for truck follower count
  ///
  /// Copied from [truckFollowerCount].
  TruckFollowerCountProvider(String truckId)
    : this._internal(
        (ref) => truckFollowerCount(ref as TruckFollowerCountRef, truckId),
        from: truckFollowerCountProvider,
        name: r'truckFollowerCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckFollowerCountHash,
        dependencies: TruckFollowerCountFamily._dependencies,
        allTransitiveDependencies:
            TruckFollowerCountFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckFollowerCountProvider._internal(
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
    FutureOr<int> Function(TruckFollowerCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckFollowerCountProvider._internal(
        (ref) => create(ref as TruckFollowerCountRef),
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
    return _TruckFollowerCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckFollowerCountProvider && other.truckId == truckId;
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
mixin TruckFollowerCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckFollowerCountProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with TruckFollowerCountRef {
  _TruckFollowerCountProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckFollowerCountProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
