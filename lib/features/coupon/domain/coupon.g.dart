// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Coupon _$CouponFromJson(Map<String, dynamic> json) => _Coupon(
  id: json['id'] as String,
  truckId: json['truckId'] as String,
  code: json['code'] as String,
  type: $enumDecode(_$CouponTypeEnumMap, json['type']),
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
  discountAmount: (json['discountAmount'] as num?)?.toInt(),
  freeItemName: json['freeItemName'] as String?,
  validFrom: DateTime.parse(json['validFrom'] as String),
  validUntil: DateTime.parse(json['validUntil'] as String),
  maxUses: (json['maxUses'] as num).toInt(),
  currentUses: (json['currentUses'] as num?)?.toInt() ?? 0,
  usedBy:
      (json['usedBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isActive: json['isActive'] as bool? ?? true,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CouponToJson(_Coupon instance) => <String, dynamic>{
  'id': instance.id,
  'truckId': instance.truckId,
  'code': instance.code,
  'type': _$CouponTypeEnumMap[instance.type]!,
  'discountPercent': instance.discountPercent,
  'discountAmount': instance.discountAmount,
  'freeItemName': instance.freeItemName,
  'validFrom': instance.validFrom.toIso8601String(),
  'validUntil': instance.validUntil.toIso8601String(),
  'maxUses': instance.maxUses,
  'currentUses': instance.currentUses,
  'usedBy': instance.usedBy,
  'isActive': instance.isActive,
  'description': instance.description,
};

const _$CouponTypeEnumMap = {
  CouponType.percentage: 'percentage',
  CouponType.fixed: 'fixed',
  CouponType.freeItem: 'freeItem',
};
