import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/coupon.dart';

part 'coupon_repository.g.dart';

/// Repository for managing coupons
class CouponRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _couponsCollection =>
      _firestore.collection('coupons');

  // ═══════════════════════════════════════════════════════════
  // CREATE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Create a new coupon (Owner only)
  Future<String> createCoupon(Coupon coupon) async {
    AppLogger.debug('Creating coupon', tag: 'CouponRepository');

    try {
      final docRef = await _couponsCollection.add(coupon.toFirestore());

      AppLogger.success('Coupon created: ${docRef.id}', tag: 'CouponRepository');
      return docRef.id;
    } catch (e, stackTrace) {
      AppLogger.error('Error creating coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Get a single coupon by ID
  Future<Coupon?> getCoupon(String couponId) async {
    try {
      final doc = await _couponsCollection.doc(couponId).get();

      if (!doc.exists) return null;

      return Coupon.fromFirestore(doc);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      return null;
    }
  }

  /// Get coupon by code
  Future<Coupon?> getCouponByCode(String code) async {
    AppLogger.debug('Getting coupon by code: $code', tag: 'CouponRepository');

    try {
      final snapshot = await _couponsCollection
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        AppLogger.warning('Coupon not found: $code', tag: 'CouponRepository');
        return null;
      }

      return Coupon.fromFirestore(snapshot.docs.first);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting coupon by code',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      return null;
    }
  }

  /// Watch all coupons for a truck (real-time stream)
  Stream<List<Coupon>> watchTruckCoupons(String truckId) {
    AppLogger.debug('Watching coupons for truck $truckId',
        tag: 'CouponRepository');

    return _couponsCollection
        .where('truckId', isEqualTo: truckId)
        .orderBy('validFrom', descending: true)
        .snapshots()
        .map((snapshot) {
      final coupons = snapshot.docs
          .map((doc) => Coupon.fromFirestore(doc))
          .toList();

      AppLogger.debug('Truck has ${coupons.length} coupons',
          tag: 'CouponRepository');
      return coupons;
    });
  }

  /// Get valid coupons for a truck
  Future<List<Coupon>> getValidCoupons(String truckId) async {
    AppLogger.debug('Getting valid coupons for truck $truckId',
        tag: 'CouponRepository');

    try {
      final now = Timestamp.now();

      final snapshot = await _couponsCollection
          .where('truckId', isEqualTo: truckId)
          .where('isActive', isEqualTo: true)
          .where('validUntil', isGreaterThan: now)
          .get();

      final coupons = snapshot.docs
          .map((doc) => Coupon.fromFirestore(doc))
          .where((coupon) =>
              coupon.currentUses < coupon.maxUses &&
              coupon.validFrom.isBefore(DateTime.now()))
          .toList();

      AppLogger.success('Found ${coupons.length} valid coupons',
          tag: 'CouponRepository');
      return coupons;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting valid coupons',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      return [];
    }
  }

  /// Get all coupons used by a user
  Future<List<Coupon>> getUserUsedCoupons(String userId) async {
    try {
      final snapshot = await _couponsCollection
          .where('usedBy', arrayContains: userId)
          .orderBy('validUntil', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Coupon.fromFirestore(doc))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user coupons',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════
  // UPDATE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Update a coupon
  Future<void> updateCoupon(String couponId, Coupon coupon) async {
    AppLogger.debug('Updating coupon $couponId', tag: 'CouponRepository');

    try {
      await _couponsCollection.doc(couponId).update(coupon.toFirestore());

      AppLogger.success('Coupon updated', tag: 'CouponRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      rethrow;
    }
  }

  /// Use a coupon (increment currentUses, add user to usedBy)
  Future<bool> useCoupon(String couponId, String userId) async {
    AppLogger.debug('Using coupon $couponId by user $userId',
        tag: 'CouponRepository');

    try {
      final docRef = _couponsCollection.doc(couponId);

      // Use transaction to prevent race conditions
      return await _firestore.runTransaction<bool>((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          AppLogger.warning('Coupon not found', tag: 'CouponRepository');
          return false;
        }

        final coupon = Coupon.fromFirestore(snapshot);

        // Validate coupon
        if (!coupon.isValid) {
          AppLogger.warning('Coupon is not valid', tag: 'CouponRepository');
          return false;
        }

        // Check if user already used
        if (coupon.hasBeenUsedBy(userId)) {
          AppLogger.warning('User already used this coupon',
              tag: 'CouponRepository');
          return false;
        }

        // Update coupon
        transaction.update(docRef, {
          'currentUses': FieldValue.increment(1),
          'usedBy': FieldValue.arrayUnion([userId]),
        });

        AppLogger.success('Coupon used successfully', tag: 'CouponRepository');
        return true;
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error using coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      return false;
    }
  }

  /// Deactivate a coupon
  Future<void> deactivateCoupon(String couponId) async {
    AppLogger.debug('Deactivating coupon $couponId', tag: 'CouponRepository');

    try {
      await _couponsCollection.doc(couponId).update({'isActive': false});

      AppLogger.success('Coupon deactivated', tag: 'CouponRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deactivating coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // DELETE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Delete a coupon
  Future<void> deleteCoupon(String couponId) async {
    AppLogger.debug('Deleting coupon $couponId', tag: 'CouponRepository');

    try {
      await _couponsCollection.doc(couponId).delete();

      AppLogger.success('Coupon deleted', tag: 'CouponRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════

  /// Validate coupon code and return coupon if valid
  Future<Coupon?> validateCouponCode({
    required String code,
    required String userId,
    String? truckId,
  }) async {
    AppLogger.debug('Validating coupon code: $code', tag: 'CouponRepository');

    try {
      final coupon = await getCouponByCode(code);

      if (coupon == null) {
        AppLogger.warning('Coupon not found', tag: 'CouponRepository');
        return null;
      }

      // Check truck ID if provided
      if (truckId != null && coupon.truckId != truckId) {
        AppLogger.warning('Coupon is for different truck',
            tag: 'CouponRepository');
        return null;
      }

      // Check if valid
      if (!coupon.isValid) {
        AppLogger.warning('Coupon is not valid', tag: 'CouponRepository');
        return null;
      }

      // Check if user already used
      if (coupon.hasBeenUsedBy(userId)) {
        AppLogger.warning('User already used this coupon',
            tag: 'CouponRepository');
        return null;
      }

      AppLogger.success('Coupon is valid', tag: 'CouponRepository');
      return coupon;
    } catch (e, stackTrace) {
      AppLogger.error('Error validating coupon',
          error: e, stackTrace: stackTrace, tag: 'CouponRepository');
      return null;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
CouponRepository couponRepository(Ref ref) {
  return CouponRepository();
}

/// Provider for watching truck's coupons
@riverpod
Stream<List<Coupon>> truckCoupons(Ref ref, String truckId) {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.watchTruckCoupons(truckId);
}

/// Provider for getting valid coupons
@riverpod
Future<List<Coupon>> validTruckCoupons(
    Ref ref, String truckId) {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getValidCoupons(truckId);
}

/// Provider for getting user's used coupons
@riverpod
Future<List<Coupon>> userUsedCoupons(Ref ref, String userId) {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getUserUsedCoupons(userId);
}
