// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckIn _$CheckInFromJson(Map<String, dynamic> json) => _CheckIn(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  truckId: json['truckId'] as String,
  truckName: json['truckName'] as String,
  checkedInAt: DateTime.parse(json['checkedInAt'] as String),
  loyaltyPoints: (json['loyaltyPoints'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CheckInToJson(_CheckIn instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'truckId': instance.truckId,
  'truckName': instance.truckName,
  'checkedInAt': instance.checkedInAt.toIso8601String(),
  'loyaltyPoints': instance.loyaltyPoints,
};
