// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(followRepository)
final followRepositoryProvider = FollowRepositoryProvider._();

final class FollowRepositoryProvider
    extends
        $FunctionalProvider<
          FollowRepository,
          FollowRepository,
          FollowRepository
        >
    with $Provider<FollowRepository> {
  FollowRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$followRepositoryHash();

  @$internal
  @override
  $ProviderElement<FollowRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FollowRepository create(Ref ref) {
    return followRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FollowRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FollowRepository>(value),
    );
  }
}

String _$followRepositoryHash() => r'1534e9ed4d6c553f39db200bfac98591376072e2';

/// Provider for watching user's followed trucks

@ProviderFor(userFollows)
final userFollowsProvider = UserFollowsFamily._();

/// Provider for watching user's followed trucks

final class UserFollowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TruckFollow>>,
          List<TruckFollow>,
          Stream<List<TruckFollow>>
        >
    with
        $FutureModifier<List<TruckFollow>>,
        $StreamProvider<List<TruckFollow>> {
  /// Provider for watching user's followed trucks
  UserFollowsProvider._({
    required UserFollowsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userFollowsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userFollowsHash();

  @override
  String toString() {
    return r'userFollowsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TruckFollow>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TruckFollow>> create(Ref ref) {
    final argument = this.argument as String;
    return userFollows(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserFollowsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userFollowsHash() => r'98d2d9feb4518b2807a9a753accd1cf96597e52d';

/// Provider for watching user's followed trucks

final class UserFollowsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TruckFollow>>, String> {
  UserFollowsFamily._()
    : super(
        retry: null,
        name: r'userFollowsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching user's followed trucks

  UserFollowsProvider call(String userId) =>
      UserFollowsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userFollowsProvider';
}

/// Provider for checking if user is following a truck

@ProviderFor(isFollowingTruck)
final isFollowingTruckProvider = IsFollowingTruckFamily._();

/// Provider for checking if user is following a truck

final class IsFollowingTruckProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking if user is following a truck
  IsFollowingTruckProvider._({
    required IsFollowingTruckFamily super.from,
    required ({String userId, String truckId}) super.argument,
  }) : super(
         retry: null,
         name: r'isFollowingTruckProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isFollowingTruckHash();

  @override
  String toString() {
    return r'isFollowingTruckProvider'
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
    return isFollowingTruck(
      ref,
      userId: argument.userId,
      truckId: argument.truckId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsFollowingTruckProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isFollowingTruckHash() => r'45f8ae3de1d99ad3da28391d853419e0e706c014';

/// Provider for checking if user is following a truck

final class IsFollowingTruckFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String userId, String truckId})
        > {
  IsFollowingTruckFamily._()
    : super(
        retry: null,
        name: r'isFollowingTruckProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for checking if user is following a truck

  IsFollowingTruckProvider call({
    required String userId,
    required String truckId,
  }) => IsFollowingTruckProvider._(
    argument: (userId: userId, truckId: truckId),
    from: this,
  );

  @override
  String toString() => r'isFollowingTruckProvider';
}

/// Provider for truck follower count

@ProviderFor(truckFollowerCount)
final truckFollowerCountProvider = TruckFollowerCountFamily._();

/// Provider for truck follower count

final class TruckFollowerCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Provider for truck follower count
  TruckFollowerCountProvider._({
    required TruckFollowerCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckFollowerCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckFollowerCountHash();

  @override
  String toString() {
    return r'truckFollowerCountProvider'
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
    return truckFollowerCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckFollowerCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckFollowerCountHash() =>
    r'542ebd638ecd5fddc0d19905026944e4383fd09a';

/// Provider for truck follower count

final class TruckFollowerCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  TruckFollowerCountFamily._()
    : super(
        retry: null,
        name: r'truckFollowerCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for truck follower count

  TruckFollowerCountProvider call(String truckId) =>
      TruckFollowerCountProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckFollowerCountProvider';
}
