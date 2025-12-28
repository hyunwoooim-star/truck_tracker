// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationSettingsImpl(
  userId: json['userId'] as String,
  truckOpenings: json['truckOpenings'] as bool? ?? true,
  orderUpdates: json['orderUpdates'] as bool? ?? true,
  newCoupons: json['newCoupons'] as bool? ?? true,
  reviews: json['reviews'] as bool? ?? true,
  promotions: json['promotions'] as bool? ?? true,
  nearbyTrucks: json['nearbyTrucks'] as bool? ?? false,
  nearbyRadius: (json['nearbyRadius'] as num?)?.toInt() ?? 1000,
  followedTrucks: json['followedTrucks'] as bool? ?? true,
  chatMessages: json['chatMessages'] as bool? ?? true,
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$NotificationSettingsImplToJson(
  _$NotificationSettingsImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'truckOpenings': instance.truckOpenings,
  'orderUpdates': instance.orderUpdates,
  'newCoupons': instance.newCoupons,
  'reviews': instance.reviews,
  'promotions': instance.promotions,
  'nearbyTrucks': instance.nearbyTrucks,
  'nearbyRadius': instance.nearbyRadius,
  'followedTrucks': instance.followedTrucks,
  'chatMessages': instance.chatMessages,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
};
