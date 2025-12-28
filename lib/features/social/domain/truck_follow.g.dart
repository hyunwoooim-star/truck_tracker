// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TruckFollow _$TruckFollowFromJson(Map<String, dynamic> json) => _TruckFollow(
  id: json['id'] as String,
  userId: json['userId'] as String,
  truckId: json['truckId'] as String,
  followedAt: DateTime.parse(json['followedAt'] as String),
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$TruckFollowToJson(_TruckFollow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'truckId': instance.truckId,
      'followedAt': instance.followedAt.toIso8601String(),
      'notificationsEnabled': instance.notificationsEnabled,
    };
