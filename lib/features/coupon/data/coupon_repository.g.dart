// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(couponRepository)
final couponRepositoryProvider = CouponRepositoryProvider._();

final class CouponRepositoryProvider
    extends
        $FunctionalProvider<
          CouponRepository,
          CouponRepository,
          CouponRepository
        >
    with $Provider<CouponRepository> {
  CouponRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'couponRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$couponRepositoryHash();

  @$internal
  @override
  $ProviderElement<CouponRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CouponRepository create(Ref ref) {
    return couponRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CouponRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CouponRepository>(value),
    );
  }
}

String _$couponRepositoryHash() => r'd0f8ed70b2f95839d7412c051deef6e818cf2e3b';

/// Provider for watching truck's coupons

@ProviderFor(truckCoupons)
final truckCouponsProvider = TruckCouponsFamily._();

/// Provider for watching truck's coupons

final class TruckCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Coupon>>,
          List<Coupon>,
          Stream<List<Coupon>>
        >
    with $FutureModifier<List<Coupon>>, $StreamProvider<List<Coupon>> {
  /// Provider for watching truck's coupons
  TruckCouponsProvider._({
    required TruckCouponsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckCouponsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckCouponsHash();

  @override
  String toString() {
    return r'truckCouponsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Coupon>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Coupon>> create(Ref ref) {
    final argument = this.argument as String;
    return truckCoupons(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckCouponsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckCouponsHash() => r'bcc4e8a1fa636c9cee184e178445771e741d2d3e';

/// Provider for watching truck's coupons

final class TruckCouponsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Coupon>>, String> {
  TruckCouponsFamily._()
    : super(
        retry: null,
        name: r'truckCouponsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching truck's coupons

  TruckCouponsProvider call(String truckId) =>
      TruckCouponsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckCouponsProvider';
}

/// Provider for getting valid coupons

@ProviderFor(validTruckCoupons)
final validTruckCouponsProvider = ValidTruckCouponsFamily._();

/// Provider for getting valid coupons

final class ValidTruckCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Coupon>>,
          List<Coupon>,
          FutureOr<List<Coupon>>
        >
    with $FutureModifier<List<Coupon>>, $FutureProvider<List<Coupon>> {
  /// Provider for getting valid coupons
  ValidTruckCouponsProvider._({
    required ValidTruckCouponsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'validTruckCouponsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$validTruckCouponsHash();

  @override
  String toString() {
    return r'validTruckCouponsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Coupon>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Coupon>> create(Ref ref) {
    final argument = this.argument as String;
    return validTruckCoupons(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidTruckCouponsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$validTruckCouponsHash() => r'085b310aa072c2ddc40394cfcb1db585091bc46e';

/// Provider for getting valid coupons

final class ValidTruckCouponsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Coupon>>, String> {
  ValidTruckCouponsFamily._()
    : super(
        retry: null,
        name: r'validTruckCouponsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting valid coupons

  ValidTruckCouponsProvider call(String truckId) =>
      ValidTruckCouponsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'validTruckCouponsProvider';
}

/// Provider for getting user's used coupons

@ProviderFor(userUsedCoupons)
final userUsedCouponsProvider = UserUsedCouponsFamily._();

/// Provider for getting user's used coupons

final class UserUsedCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Coupon>>,
          List<Coupon>,
          FutureOr<List<Coupon>>
        >
    with $FutureModifier<List<Coupon>>, $FutureProvider<List<Coupon>> {
  /// Provider for getting user's used coupons
  UserUsedCouponsProvider._({
    required UserUsedCouponsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userUsedCouponsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userUsedCouponsHash();

  @override
  String toString() {
    return r'userUsedCouponsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Coupon>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Coupon>> create(Ref ref) {
    final argument = this.argument as String;
    return userUsedCoupons(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserUsedCouponsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userUsedCouponsHash() => r'a4f196101349ae3e36a6dc621611de513458b542';

/// Provider for getting user's used coupons

final class UserUsedCouponsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Coupon>>, String> {
  UserUsedCouponsFamily._()
    : super(
        retry: null,
        name: r'userUsedCouponsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting user's used coupons

  UserUsedCouponsProvider call(String userId) =>
      UserUsedCouponsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userUsedCouponsProvider';
}
