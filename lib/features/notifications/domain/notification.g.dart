// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      truckId: json['truckId'] as String?,
      orderId: json['orderId'] as String?,
      chatRoomId: json['chatRoomId'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'truckId': instance.truckId,
      'orderId': instance.orderId,
      'chatRoomId': instance.chatRoomId,
      'data': instance.data,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.orderUpdate: 'orderUpdate',
  NotificationType.truckOpen: 'truckOpen',
  NotificationType.promotion: 'promotion',
  NotificationType.chat: 'chat',
  NotificationType.checkin: 'checkin',
  NotificationType.system: 'system',
};
