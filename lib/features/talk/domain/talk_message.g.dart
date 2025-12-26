// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TalkMessageImpl _$$TalkMessageImplFromJson(Map<String, dynamic> json) =>
    _$TalkMessageImpl(
      id: json['id'] as String,
      truckId: json['truckId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      message: json['message'] as String,
      isOwner: json['isOwner'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TalkMessageImplToJson(_$TalkMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'truckId': instance.truckId,
      'userId': instance.userId,
      'userName': instance.userName,
      'message': instance.message,
      'isOwner': instance.isOwner,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
