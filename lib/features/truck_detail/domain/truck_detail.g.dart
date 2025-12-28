// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TruckDetail _$TruckDetailFromJson(Map<String, dynamic> json) => _TruckDetail(
  truckId: json['truckId'] as String,
  operatingHours: json['operatingHours'] as String,
  menuItems: (json['menuItems'] as List<dynamic>)
      .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  reviews: (json['reviews'] as List<dynamic>)
      .map((e) => Review.fromJson(e as Map<String, dynamic>))
      .toList(),
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 4.5,
  description: json['description'] as String? ?? '',
);

Map<String, dynamic> _$TruckDetailToJson(_TruckDetail instance) =>
    <String, dynamic>{
      'truckId': instance.truckId,
      'operatingHours': instance.operatingHours,
      'menuItems': instance.menuItems,
      'reviews': instance.reviews,
      'averageRating': instance.averageRating,
      'description': instance.description,
    };
