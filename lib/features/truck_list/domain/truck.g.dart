// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TruckImpl _$$TruckImplFromJson(Map<String, dynamic> json) => _$TruckImpl(
  id: json['id'] as String,
  truckNumber: json['truckNumber'] as String,
  driverName: json['driverName'] as String,
  status: $enumDecode(_$TruckStatusEnumMap, json['status']),
  foodType: json['foodType'] as String,
  locationDescription: json['locationDescription'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  isFavorite: json['isFavorite'] as bool? ?? false,
  imageUrl: json['imageUrl'] as String,
  ownerEmail: json['ownerEmail'] as String? ?? '',
  bankAccount: json['bankAccount'] as String?,
  announcement: json['announcement'] as String? ?? '',
  favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
  avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  isOpen: json['isOpen'] as bool? ?? false,
);

Map<String, dynamic> _$$TruckImplToJson(_$TruckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'truckNumber': instance.truckNumber,
      'driverName': instance.driverName,
      'status': _$TruckStatusEnumMap[instance.status]!,
      'foodType': instance.foodType,
      'locationDescription': instance.locationDescription,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isFavorite': instance.isFavorite,
      'imageUrl': instance.imageUrl,
      'ownerEmail': instance.ownerEmail,
      'bankAccount': instance.bankAccount,
      'announcement': instance.announcement,
      'favoriteCount': instance.favoriteCount,
      'avgRating': instance.avgRating,
      'totalReviews': instance.totalReviews,
      'isOpen': instance.isOpen,
    };

const _$TruckStatusEnumMap = {
  TruckStatus.onRoute: 'onRoute',
  TruckStatus.resting: 'resting',
  TruckStatus.maintenance: 'maintenance',
};
