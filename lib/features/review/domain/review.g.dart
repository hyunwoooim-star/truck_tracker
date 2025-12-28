// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  truckId: json['truckId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userPhotoURL: json['userPhotoURL'] as String?,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  ownerReply: json['ownerReply'] as String?,
  ownerReplyAt: json['ownerReplyAt'] == null
      ? null
      : DateTime.parse(json['ownerReplyAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'truckId': instance.truckId,
  'userId': instance.userId,
  'userName': instance.userName,
  'userPhotoURL': instance.userPhotoURL,
  'rating': instance.rating,
  'comment': instance.comment,
  'photoUrls': instance.photoUrls,
  'ownerReply': instance.ownerReply,
  'ownerReplyAt': instance.ownerReplyAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
