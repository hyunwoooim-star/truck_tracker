// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  authorProfileUrl: json['authorProfileUrl'] as String?,
  truckId: json['truckId'] as String?,
  truckName: json['truckName'] as String?,
  content: json['content'] as String,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  hashtags:
      (json['hashtags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  isLikedByMe: json['isLikedByMe'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'authorProfileUrl': instance.authorProfileUrl,
  'truckId': instance.truckId,
  'truckName': instance.truckName,
  'content': instance.content,
  'imageUrls': instance.imageUrls,
  'hashtags': instance.hashtags,
  'likeCount': instance.likeCount,
  'commentCount': instance.commentCount,
  'isLikedByMe': instance.isLikedByMe,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String,
  postId: json['postId'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  authorProfileUrl: json['authorProfileUrl'] as String?,
  content: json['content'] as String,
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
  isLikedByMe: json['isLikedByMe'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'authorProfileUrl': instance.authorProfileUrl,
  'content': instance.content,
  'likeCount': instance.likeCount,
  'isLikedByMe': instance.isLikedByMe,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_PostLike _$PostLikeFromJson(Map<String, dynamic> json) => _PostLike(
  id: json['id'] as String,
  postId: json['postId'] as String,
  userId: json['userId'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PostLikeToJson(_PostLike instance) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'userId': instance.userId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
