import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/coupon/domain/coupon.dart';

void main() {
  group('Coupon Model', () {
    final now = DateTime.now();
    late Coupon percentageCoupon;
    late Coupon fixedCoupon;
    late Coupon freeItemCoupon;

    setUp(() {
      percentageCoupon = Coupon(
        id: 'coupon_1',
        truckId: 'truck_123',
        code: 'SAVE20',
        type: CouponType.percentage,
        discountPercent: 20,
        validFrom: now.subtract(const Duration(days: 1)),
        validUntil: now.add(const Duration(days: 30)),
        maxUses: 100,
        currentUses: 50,
        description: '20% 할인 쿠폰',
      );

      fixedCoupon = Coupon(
        id: 'coupon_2',
        truckId: 'truck_123',
        code: 'DISCOUNT3000',
        type: CouponType.fixed,
        discountAmount: 3000,
        validFrom: now.subtract(const Duration(days: 1)),
        validUntil: now.add(const Duration(days: 30)),
        maxUses: 50,
        currentUses: 10,
        description: '3,000원 할인 쿠폰',
      );

      freeItemCoupon = Coupon(
        id: 'coupon_3',
        truckId: 'truck_123',
        code: 'FREEDRINK',
        type: CouponType.freeItem,
        freeItemName: '콜라',
        validFrom: now.subtract(const Duration(days: 1)),
        validUntil: now.add(const Duration(days: 30)),
        maxUses: 20,
        currentUses: 5,
        description: '음료 무료 쿠폰',
      );
    });

    test('should create percentage coupon correctly', () {
      expect(percentageCoupon.id, 'coupon_1');
      expect(percentageCoupon.code, 'SAVE20');
      expect(percentageCoupon.type, CouponType.percentage);
      expect(percentageCoupon.discountPercent, 20);
      expect(percentageCoupon.maxUses, 100);
      expect(percentageCoupon.currentUses, 50);
    });

    test('should create fixed coupon correctly', () {
      expect(fixedCoupon.type, CouponType.fixed);
      expect(fixedCoupon.discountAmount, 3000);
    });

    test('should create free item coupon correctly', () {
      expect(freeItemCoupon.type, CouponType.freeItem);
      expect(freeItemCoupon.freeItemName, '콜라');
    });

    group('isValid', () {
      test('should return true for valid coupon', () {
        expect(percentageCoupon.isValid, isTrue);
        expect(fixedCoupon.isValid, isTrue);
        expect(freeItemCoupon.isValid, isTrue);
      });

      test('should return false for inactive coupon', () {
        final inactiveCoupon = percentageCoupon.copyWith(isActive: false);
        expect(inactiveCoupon.isValid, isFalse);
      });

      test('should return false for expired coupon', () {
        final expiredCoupon = percentageCoupon.copyWith(
          validUntil: now.subtract(const Duration(days: 1)),
        );
        expect(expiredCoupon.isValid, isFalse);
      });

      test('should return false for not yet valid coupon', () {
        final futureValidCoupon = percentageCoupon.copyWith(
          validFrom: now.add(const Duration(days: 1)),
        );
        expect(futureValidCoupon.isValid, isFalse);
      });

      test('should return false for sold out coupon', () {
        final soldOutCoupon = percentageCoupon.copyWith(
          currentUses: 100,
          maxUses: 100,
        );
        expect(soldOutCoupon.isValid, isFalse);
      });
    });

    group('hasBeenUsedBy', () {
      test('should return false for unused user', () {
        expect(percentageCoupon.hasBeenUsedBy('new_user'), isFalse);
      });

      test('should return true for user who used the coupon', () {
        final usedCoupon = percentageCoupon.copyWith(
          usedBy: ['user_1', 'user_2'],
        );
        expect(usedCoupon.hasBeenUsedBy('user_1'), isTrue);
        expect(usedCoupon.hasBeenUsedBy('user_2'), isTrue);
        expect(usedCoupon.hasBeenUsedBy('user_3'), isFalse);
      });
    });

    group('discountText', () {
      test('should return correct text for percentage coupon', () {
        expect(percentageCoupon.discountText, '20% OFF');
      });

      test('should return correct text for fixed coupon', () {
        expect(fixedCoupon.discountText, contains('3,000'));
        expect(fixedCoupon.discountText, contains('OFF'));
      });

      test('should return correct text for free item coupon', () {
        expect(freeItemCoupon.discountText, 'FREE 콜라');
      });
    });

    group('calculateDiscount', () {
      test('should calculate percentage discount correctly', () {
        expect(percentageCoupon.calculateDiscount(10000), 2000); // 20% of 10000
        expect(percentageCoupon.calculateDiscount(15000), 3000); // 20% of 15000
        expect(percentageCoupon.calculateDiscount(8500), 1700); // 20% of 8500
      });

      test('should calculate fixed discount correctly', () {
        expect(fixedCoupon.calculateDiscount(10000), 3000);
        expect(fixedCoupon.calculateDiscount(5000), 3000); // Always 3000
      });

      test('should return 0 for free item coupon', () {
        expect(freeItemCoupon.calculateDiscount(10000), 0);
      });

      test('should return 0 for invalid coupon', () {
        final expiredCoupon = percentageCoupon.copyWith(
          validUntil: now.subtract(const Duration(days: 1)),
        );
        expect(expiredCoupon.calculateDiscount(10000), 0);
      });
    });

    group('remainingUses', () {
      test('should calculate remaining uses correctly', () {
        expect(percentageCoupon.remainingUses, 50); // 100 - 50
        expect(fixedCoupon.remainingUses, 40); // 50 - 10
        expect(freeItemCoupon.remainingUses, 15); // 20 - 5
      });

      test('should return 0 when sold out', () {
        final soldOutCoupon = percentageCoupon.copyWith(currentUses: 100);
        expect(soldOutCoupon.remainingUses, 0);
      });
    });

    group('validityText', () {
      test('should return "Valid" for valid coupon', () {
        expect(percentageCoupon.validityText, 'Valid');
      });

      test('should return "Inactive" for inactive coupon', () {
        final inactiveCoupon = percentageCoupon.copyWith(isActive: false);
        expect(inactiveCoupon.validityText, 'Inactive');
      });

      test('should return "Not yet valid" for future coupon', () {
        final futureCoupon = percentageCoupon.copyWith(
          validFrom: now.add(const Duration(days: 1)),
        );
        expect(futureCoupon.validityText, 'Not yet valid');
      });

      test('should return "Expired" for expired coupon', () {
        final expiredCoupon = percentageCoupon.copyWith(
          validUntil: now.subtract(const Duration(days: 1)),
        );
        expect(expiredCoupon.validityText, 'Expired');
      });

      test('should return "Sold out" for sold out coupon', () {
        final soldOutCoupon = percentageCoupon.copyWith(
          currentUses: 100,
          maxUses: 100,
        );
        expect(soldOutCoupon.validityText, 'Sold out');
      });
    });

    test('toFirestore should convert Coupon to Map correctly', () {
      final firestoreMap = percentageCoupon.toFirestore();

      expect(firestoreMap['truckId'], 'truck_123');
      expect(firestoreMap['code'], 'SAVE20');
      expect(firestoreMap['type'], 'percentage');
      expect(firestoreMap['discountPercent'], 20);
      expect(firestoreMap['maxUses'], 100);
      expect(firestoreMap['currentUses'], 50);
      expect(firestoreMap['isActive'], isTrue);
    });

    test('toFirestore should not include null optional fields', () {
      final firestoreMap = percentageCoupon.toFirestore();

      expect(firestoreMap.containsKey('discountAmount'), isFalse);
      expect(firestoreMap.containsKey('freeItemName'), isFalse);
    });
  });

  group('CouponType enum', () {
    test('should have all expected values', () {
      expect(CouponType.values.length, 3);
      expect(CouponType.values, contains(CouponType.percentage));
      expect(CouponType.values, contains(CouponType.fixed));
      expect(CouponType.values, contains(CouponType.freeItem));
    });
  });
}
