import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/coupon_repository.dart';
import '../domain/coupon.dart';

part 'coupon_provider.g.dart';

/// Provider for coupon repository
@riverpod
CouponRepository couponRepository(Ref ref) {
  return CouponRepository();
}

/// Watch coupons for a specific truck
@riverpod
Stream<List<Coupon>> truckCoupons(Ref ref, String truckId) {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.watchTruckCoupons(truckId);
}

/// Get valid coupons for a truck (one-time fetch)
@riverpod
Future<List<Coupon>> validTruckCoupons(Ref ref, String truckId) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getValidCoupons(truckId);
}

/// Get coupon by code
@riverpod
Future<Coupon?> couponByCode(Ref ref, String code) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getCouponByCode(code);
}
