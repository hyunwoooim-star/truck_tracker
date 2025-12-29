// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for coupon repository

@ProviderFor(couponRepository)
final couponRepositoryProvider = CouponRepositoryProvider._();

/// Provider for coupon repository

final class CouponRepositoryProvider
    extends
        $FunctionalProvider<
          CouponRepository,
          CouponRepository,
          CouponRepository
        >
    with $Provider<CouponRepository> {
  /// Provider for coupon repository
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

String _$couponRepositoryHash() => r'0bcf95632f01b3d49dc9c2aa4bf65f395fcb4afb';

/// Watch coupons for a specific truck

@ProviderFor(truckCoupons)
final truckCouponsProvider = TruckCouponsFamily._();

/// Watch coupons for a specific truck

final class TruckCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Coupon>>,
          List<Coupon>,
          Stream<List<Coupon>>
        >
    with $FutureModifier<List<Coupon>>, $StreamProvider<List<Coupon>> {
  /// Watch coupons for a specific truck
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

String _$truckCouponsHash() => r'2b3aa897389e19e114f7d00c71040e7049cb3994';

/// Watch coupons for a specific truck

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

  /// Watch coupons for a specific truck

  TruckCouponsProvider call(String truckId) =>
      TruckCouponsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckCouponsProvider';
}

/// Get valid coupons for a truck (one-time fetch)

@ProviderFor(validTruckCoupons)
final validTruckCouponsProvider = ValidTruckCouponsFamily._();

/// Get valid coupons for a truck (one-time fetch)

final class ValidTruckCouponsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Coupon>>,
          List<Coupon>,
          FutureOr<List<Coupon>>
        >
    with $FutureModifier<List<Coupon>>, $FutureProvider<List<Coupon>> {
  /// Get valid coupons for a truck (one-time fetch)
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

String _$validTruckCouponsHash() => r'f6e2b08edd20583603f4bc2fb04257947f9d63e7';

/// Get valid coupons for a truck (one-time fetch)

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

  /// Get valid coupons for a truck (one-time fetch)

  ValidTruckCouponsProvider call(String truckId) =>
      ValidTruckCouponsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'validTruckCouponsProvider';
}

/// Get coupon by code

@ProviderFor(couponByCode)
final couponByCodeProvider = CouponByCodeFamily._();

/// Get coupon by code

final class CouponByCodeProvider
    extends $FunctionalProvider<AsyncValue<Coupon?>, Coupon?, FutureOr<Coupon?>>
    with $FutureModifier<Coupon?>, $FutureProvider<Coupon?> {
  /// Get coupon by code
  CouponByCodeProvider._({
    required CouponByCodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'couponByCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$couponByCodeHash();

  @override
  String toString() {
    return r'couponByCodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Coupon?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Coupon?> create(Ref ref) {
    final argument = this.argument as String;
    return couponByCode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CouponByCodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$couponByCodeHash() => r'b1f2806d9583294b908826b84d70fb24128df991';

/// Get coupon by code

final class CouponByCodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Coupon?>, String> {
  CouponByCodeFamily._()
    : super(
        retry: null,
        name: r'couponByCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get coupon by code

  CouponByCodeProvider call(String code) =>
      CouponByCodeProvider._(argument: code, from: this);

  @override
  String toString() => r'couponByCodeProvider';
}
