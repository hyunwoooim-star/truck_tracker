import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

/// Social feed post model
@freezed
abstract class Post with _$Post {
  const Post._();

  const factory Post({
    required String id,
    required String authorId,
    required String authorName,
    String? authorProfileUrl,
    String? truckId,
    String? truckName,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> hashtags,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(false) bool isLikedByMe,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  /// Create from Firestore document
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Post(
      id: doc.id,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      authorProfileUrl: data['authorProfileUrl'] as String?,
      truckId: data['truckId'] as String?,
      truckName: data['truckName'] as String?,
      content: data['content'] as String? ?? '',
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      hashtags: (data['hashtags'] as List<dynamic>?)?.cast<String>() ?? [],
      likeCount: data['likeCount'] as int? ?? 0,
      commentCount: data['commentCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorProfileUrl': authorProfileUrl,
      'truckId': truckId,
      'truckName': truckName,
      'content': content,
      'imageUrls': imageUrls,
      'hashtags': hashtags,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Extract hashtags from content
  static List<String> extractHashtags(String content) {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(content).map((m) => m.group(1)!.toLowerCase()).toList();
  }

  /// Time ago string for display
  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inDays > 7) {
      return '${createdAt!.month}/${createdAt!.day}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}일 전';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간 전';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}

/// Comment on a post
@freezed
abstract class Comment with _$Comment {
  const Comment._();

  const factory Comment({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    String? authorProfileUrl,
    required String content,
    @Default(0) int likeCount,
    @Default(false) bool isLikedByMe,
    DateTime? createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Comment(
      id: doc.id,
      postId: data['postId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      authorProfileUrl: data['authorProfileUrl'] as String?,
      content: data['content'] as String? ?? '',
      likeCount: data['likeCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorProfileUrl': authorProfileUrl,
      'content': content,
      'likeCount': likeCount,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inDays > 0) {
      return '${diff.inDays}일 전';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간 전';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}

/// Like reaction on a post or comment
@freezed
abstract class PostLike with _$PostLike {
  const factory PostLike({
    required String id,
    required String postId,
    required String userId,
    DateTime? createdAt,
  }) = _PostLike;

  factory PostLike.fromJson(Map<String, dynamic> json) => _$PostLikeFromJson(json);

  factory PostLike.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PostLike(
      id: doc.id,
      postId: data['postId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
