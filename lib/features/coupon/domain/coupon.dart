import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

/// Coupon type enum
enum CouponType {
  percentage,  // % 할인
  fixed,       // 고정 금액 할인
  freeItem,    // 무료 아이템
}

/// Coupon model for promotions and discounts
@freezed
sealed class Coupon with _$Coupon {
  const Coupon._();

  const factory Coupon({
    required String id,
    required String truckId,
    required String code,
    required CouponType type,
    int? discountPercent,      // % 할인 (type == percentage)
    int? discountAmount,        // 고정 금액 할인 (type == fixed)
    String? freeItemName,       // 무료 아이템 이름 (type == freeItem)
    required DateTime validFrom,
    required DateTime validUntil,
    required int maxUses,
    @Default(0) int currentUses,
    @Default([]) List<String> usedBy,  // userId 목록
    @Default(true) bool isActive,
    String? description,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) =>
      _$CouponFromJson(json);

  factory Coupon.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Coupon(
      id: doc.id,
      truckId: data['truckId'] as String,
      code: data['code'] as String,
      type: CouponType.values.byName(data['type'] as String),
      discountPercent: data['discountPercent'] as int?,
      discountAmount: data['discountAmount'] as int?,
      freeItemName: data['freeItemName'] as String?,
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validUntil: (data['validUntil'] as Timestamp).toDate(),
      maxUses: data['maxUses'] as int,
      currentUses: data['currentUses'] as int? ?? 0,
      usedBy: (data['usedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: data['isActive'] as bool? ?? true,
      description: data['description'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'truckId': truckId,
      'code': code,
      'type': type.name,
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (discountAmount != null) 'discountAmount': discountAmount,
      if (freeItemName != null) 'freeItemName': freeItemName,
      'validFrom': Timestamp.fromDate(validFrom),
      'validUntil': Timestamp.fromDate(validUntil),
      'maxUses': maxUses,
      'currentUses': currentUses,
      'usedBy': usedBy,
      'isActive': isActive,
      if (description != null) 'description': description,
    };
  }

  /// Check if coupon is currently valid
  bool get isValid {
    final now = DateTime.now();
    return isActive &&
        now.isAfter(validFrom) &&
        now.isBefore(validUntil) &&
        currentUses < maxUses;
  }

  /// Check if user has already used this coupon
  bool hasBeenUsedBy(String userId) {
    return usedBy.contains(userId);
  }

  /// Get display text for discount
  String get discountText {
    switch (type) {
      case CouponType.percentage:
        return '$discountPercent% OFF';
      case CouponType.fixed:
        return '₩${discountAmount?.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )} OFF';
      case CouponType.freeItem:
        return 'FREE $freeItemName';
    }
  }

  /// Calculate discount amount for a given order total
  int calculateDiscount(int orderTotal) {
    if (!isValid) return 0;

    switch (type) {
      case CouponType.percentage:
        return (orderTotal * (discountPercent ?? 0) / 100).round();
      case CouponType.fixed:
        return discountAmount ?? 0;
      case CouponType.freeItem:
        return 0; // Free item discount is handled separately
    }
  }

  /// Get remaining uses
  int get remainingUses => maxUses - currentUses;

  /// Get validity status text
  String get validityText {
    final now = DateTime.now();
    if (!isActive) return 'Inactive';
    if (now.isBefore(validFrom)) return 'Not yet valid';
    if (now.isAfter(validUntil)) return 'Expired';
    if (currentUses >= maxUses) return 'Sold out';
    return 'Valid';
  }
}
