// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomImpl _$$ChatRoomImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      truckId: json['truckId'] as String,
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      lastMessage: json['lastMessage'] as String,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      userName: json['userName'] as String?,
      truckName: json['truckName'] as String?,
    );

Map<String, dynamic> _$$ChatRoomImplToJson(_$ChatRoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'truckId': instance.truckId,
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'userName': instance.userName,
      'truckName': instance.truckName,
    };
