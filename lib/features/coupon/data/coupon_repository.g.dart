// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$couponRepositoryHash() => r'd0f8ed70b2f95839d7412c051deef6e818cf2e3b';

/// See also [couponRepository].
@ProviderFor(couponRepository)
final couponRepositoryProvider = AutoDisposeProvider<CouponRepository>.internal(
  couponRepository,
  name: r'couponRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$couponRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CouponRepositoryRef = AutoDisposeProviderRef<CouponRepository>;
String _$truckCouponsHash() => r'bcc4e8a1fa636c9cee184e178445771e741d2d3e';

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

/// Provider for watching truck's coupons
///
/// Copied from [truckCoupons].
@ProviderFor(truckCoupons)
const truckCouponsProvider = TruckCouponsFamily();

/// Provider for watching truck's coupons
///
/// Copied from [truckCoupons].
class TruckCouponsFamily extends Family<AsyncValue<List<Coupon>>> {
  /// Provider for watching truck's coupons
  ///
  /// Copied from [truckCoupons].
  const TruckCouponsFamily();

  /// Provider for watching truck's coupons
  ///
  /// Copied from [truckCoupons].
  TruckCouponsProvider call(String truckId) {
    return TruckCouponsProvider(truckId);
  }

  @override
  TruckCouponsProvider getProviderOverride(
    covariant TruckCouponsProvider provider,
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
  String? get name => r'truckCouponsProvider';
}

/// Provider for watching truck's coupons
///
/// Copied from [truckCoupons].
class TruckCouponsProvider extends AutoDisposeStreamProvider<List<Coupon>> {
  /// Provider for watching truck's coupons
  ///
  /// Copied from [truckCoupons].
  TruckCouponsProvider(String truckId)
    : this._internal(
        (ref) => truckCoupons(ref as TruckCouponsRef, truckId),
        from: truckCouponsProvider,
        name: r'truckCouponsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckCouponsHash,
        dependencies: TruckCouponsFamily._dependencies,
        allTransitiveDependencies:
            TruckCouponsFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckCouponsProvider._internal(
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
    Stream<List<Coupon>> Function(TruckCouponsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckCouponsProvider._internal(
        (ref) => create(ref as TruckCouponsRef),
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
  AutoDisposeStreamProviderElement<List<Coupon>> createElement() {
    return _TruckCouponsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckCouponsProvider && other.truckId == truckId;
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
mixin TruckCouponsRef on AutoDisposeStreamProviderRef<List<Coupon>> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckCouponsProviderElement
    extends AutoDisposeStreamProviderElement<List<Coupon>>
    with TruckCouponsRef {
  _TruckCouponsProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckCouponsProvider).truckId;
}

String _$validTruckCouponsHash() => r'085b310aa072c2ddc40394cfcb1db585091bc46e';

/// Provider for getting valid coupons
///
/// Copied from [validTruckCoupons].
@ProviderFor(validTruckCoupons)
const validTruckCouponsProvider = ValidTruckCouponsFamily();

/// Provider for getting valid coupons
///
/// Copied from [validTruckCoupons].
class ValidTruckCouponsFamily extends Family<AsyncValue<List<Coupon>>> {
  /// Provider for getting valid coupons
  ///
  /// Copied from [validTruckCoupons].
  const ValidTruckCouponsFamily();

  /// Provider for getting valid coupons
  ///
  /// Copied from [validTruckCoupons].
  ValidTruckCouponsProvider call(String truckId) {
    return ValidTruckCouponsProvider(truckId);
  }

  @override
  ValidTruckCouponsProvider getProviderOverride(
    covariant ValidTruckCouponsProvider provider,
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
  String? get name => r'validTruckCouponsProvider';
}

/// Provider for getting valid coupons
///
/// Copied from [validTruckCoupons].
class ValidTruckCouponsProvider
    extends AutoDisposeFutureProvider<List<Coupon>> {
  /// Provider for getting valid coupons
  ///
  /// Copied from [validTruckCoupons].
  ValidTruckCouponsProvider(String truckId)
    : this._internal(
        (ref) => validTruckCoupons(ref as ValidTruckCouponsRef, truckId),
        from: validTruckCouponsProvider,
        name: r'validTruckCouponsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$validTruckCouponsHash,
        dependencies: ValidTruckCouponsFamily._dependencies,
        allTransitiveDependencies:
            ValidTruckCouponsFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  ValidTruckCouponsProvider._internal(
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
    FutureOr<List<Coupon>> Function(ValidTruckCouponsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ValidTruckCouponsProvider._internal(
        (ref) => create(ref as ValidTruckCouponsRef),
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
  AutoDisposeFutureProviderElement<List<Coupon>> createElement() {
    return _ValidTruckCouponsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidTruckCouponsProvider && other.truckId == truckId;
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
mixin ValidTruckCouponsRef on AutoDisposeFutureProviderRef<List<Coupon>> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _ValidTruckCouponsProviderElement
    extends AutoDisposeFutureProviderElement<List<Coupon>>
    with ValidTruckCouponsRef {
  _ValidTruckCouponsProviderElement(super.provider);

  @override
  String get truckId => (origin as ValidTruckCouponsProvider).truckId;
}

String _$userUsedCouponsHash() => r'a4f196101349ae3e36a6dc621611de513458b542';

/// Provider for getting user's used coupons
///
/// Copied from [userUsedCoupons].
@ProviderFor(userUsedCoupons)
const userUsedCouponsProvider = UserUsedCouponsFamily();

/// Provider for getting user's used coupons
///
/// Copied from [userUsedCoupons].
class UserUsedCouponsFamily extends Family<AsyncValue<List<Coupon>>> {
  /// Provider for getting user's used coupons
  ///
  /// Copied from [userUsedCoupons].
  const UserUsedCouponsFamily();

  /// Provider for getting user's used coupons
  ///
  /// Copied from [userUsedCoupons].
  UserUsedCouponsProvider call(String userId) {
    return UserUsedCouponsProvider(userId);
  }

  @override
  UserUsedCouponsProvider getProviderOverride(
    covariant UserUsedCouponsProvider provider,
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
  String? get name => r'userUsedCouponsProvider';
}

/// Provider for getting user's used coupons
///
/// Copied from [userUsedCoupons].
class UserUsedCouponsProvider extends AutoDisposeFutureProvider<List<Coupon>> {
  /// Provider for getting user's used coupons
  ///
  /// Copied from [userUsedCoupons].
  UserUsedCouponsProvider(String userId)
    : this._internal(
        (ref) => userUsedCoupons(ref as UserUsedCouponsRef, userId),
        from: userUsedCouponsProvider,
        name: r'userUsedCouponsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userUsedCouponsHash,
        dependencies: UserUsedCouponsFamily._dependencies,
        allTransitiveDependencies:
            UserUsedCouponsFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserUsedCouponsProvider._internal(
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
    FutureOr<List<Coupon>> Function(UserUsedCouponsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserUsedCouponsProvider._internal(
        (ref) => create(ref as UserUsedCouponsRef),
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
  AutoDisposeFutureProviderElement<List<Coupon>> createElement() {
    return _UserUsedCouponsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserUsedCouponsProvider && other.userId == userId;
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
mixin UserUsedCouponsRef on AutoDisposeFutureProviderRef<List<Coupon>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserUsedCouponsProviderElement
    extends AutoDisposeFutureProviderElement<List<Coupon>>
    with UserUsedCouponsRef {
  _UserUsedCouponsProviderElement(super.provider);

  @override
  String get userId => (origin as UserUsedCouponsProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
