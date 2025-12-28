import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// Review model for truck reviews
@freezed
sealed class Review with _$Review {
  const factory Review({
    required String id,
    required String truckId,
    required String userId,
    required String userName,
    String? userPhotoURL,
    required int rating, // 1-5 stars
    required String comment,
    @Default([]) List<String> photoUrls,
    String? ownerReply, // Owner's reply to the review
    DateTime? ownerReplyAt, // When owner replied
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);

  /// Create from Firestore document
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Review(
      id: doc.id,
      truckId: data['truckId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      userPhotoURL: data['userPhotoURL'],
      rating: (data['rating'] as num?)?.toInt() ?? 5,
      comment: data['comment'] ?? '',
      photoUrls: (data['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      ownerReply: data['ownerReply'],
      ownerReplyAt: (data['ownerReplyAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  static Map<String, dynamic> toFirestore(Review review) {
    return {
      'truckId': review.truckId,
      'userId': review.userId,
      'userName': review.userName,
      'userPhotoURL': review.userPhotoURL,
      'rating': review.rating,
      'comment': review.comment,
      'photoUrls': review.photoUrls,
      'ownerReply': review.ownerReply,
      'ownerReplyAt': review.ownerReplyAt != null
          ? Timestamp.fromDate(review.ownerReplyAt!)
          : null,
      'createdAt': review.createdAt != null
          ? Timestamp.fromDate(review.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}





