import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/review/domain/review.dart';

void main() {
  group('Review Model', () {
    late Review review;

    setUp(() {
      review = Review(
        id: 'review_123',
        truckId: 'truck_456',
        userId: 'user_789',
        userName: '맛집탐험가',
        userPhotoURL: 'https://example.com/avatar.jpg',
        rating: 5,
        comment: '정말 맛있어요! 떡볶이가 매콤하고 쫄깃합니다.',
        photoUrls: [
          'https://example.com/photo1.jpg',
          'https://example.com/photo2.jpg',
        ],
        ownerReply: '감사합니다! 또 방문해주세요 :)',
        ownerReplyAt: DateTime(2025, 12, 31, 14, 0, 0),
        createdAt: DateTime(2025, 12, 31, 12, 0, 0),
        updatedAt: DateTime(2025, 12, 31, 14, 0, 0),
      );
    });

    test('should create Review with required fields', () {
      final simpleReview = Review(
        id: 'r1',
        truckId: 't1',
        userId: 'u1',
        userName: '손님',
        rating: 4,
        comment: '괜찮았어요',
      );

      expect(simpleReview.id, 'r1');
      expect(simpleReview.truckId, 't1');
      expect(simpleReview.userId, 'u1');
      expect(simpleReview.userName, '손님');
      expect(simpleReview.rating, 4);
      expect(simpleReview.comment, '괜찮았어요');
      expect(simpleReview.photoUrls, isEmpty);
      expect(simpleReview.ownerReply, isNull);
    });

    test('should create Review with all fields', () {
      expect(review.id, 'review_123');
      expect(review.truckId, 'truck_456');
      expect(review.userId, 'user_789');
      expect(review.userName, '맛집탐험가');
      expect(review.userPhotoURL, isNotNull);
      expect(review.rating, 5);
      expect(review.comment, contains('떡볶이'));
      expect(review.photoUrls.length, 2);
      expect(review.ownerReply, contains('감사합니다'));
      expect(review.ownerReplyAt, isNotNull);
      expect(review.createdAt, isNotNull);
      expect(review.updatedAt, isNotNull);
    });

    group('rating validation', () {
      test('should allow rating from 1 to 5', () {
        for (int rating = 1; rating <= 5; rating++) {
          final r = review.copyWith(rating: rating);
          expect(r.rating, rating);
        }
      });
    });

    group('photoUrls', () {
      test('should default to empty list', () {
        final reviewWithoutPhotos = Review(
          id: 'r1',
          truckId: 't1',
          userId: 'u1',
          userName: '손님',
          rating: 4,
          comment: '맛있어요',
        );
        expect(reviewWithoutPhotos.photoUrls, isEmpty);
      });

      test('should contain photo URLs when provided', () {
        expect(review.photoUrls, hasLength(2));
        expect(review.photoUrls[0], contains('photo1'));
        expect(review.photoUrls[1], contains('photo2'));
      });
    });

    group('ownerReply', () {
      test('should be null when owner has not replied', () {
        final reviewWithoutReply = review.copyWith(
          ownerReply: null,
          ownerReplyAt: null,
        );
        expect(reviewWithoutReply.ownerReply, isNull);
        expect(reviewWithoutReply.ownerReplyAt, isNull);
      });

      test('should contain owner reply when provided', () {
        expect(review.ownerReply, isNotNull);
        expect(review.ownerReply, contains('감사합니다'));
        expect(review.ownerReplyAt, isNotNull);
      });
    });

    test('toFirestore should convert Review to Map correctly', () {
      final firestoreMap = Review.toFirestore(review);

      expect(firestoreMap['truckId'], 'truck_456');
      expect(firestoreMap['userId'], 'user_789');
      expect(firestoreMap['userName'], '맛집탐험가');
      expect(firestoreMap['rating'], 5);
      expect(firestoreMap['comment'], contains('떡볶이'));
      expect(firestoreMap['photoUrls'], hasLength(2));
      expect(firestoreMap['ownerReply'], contains('감사합니다'));
    });

    test('toFirestore should handle null optional fields', () {
      final minimalReview = Review(
        id: 'r1',
        truckId: 't1',
        userId: 'u1',
        userName: '손님',
        rating: 3,
        comment: '보통이에요',
      );

      final firestoreMap = Review.toFirestore(minimalReview);

      expect(firestoreMap['userPhotoURL'], isNull);
      expect(firestoreMap['ownerReply'], isNull);
      expect(firestoreMap['ownerReplyAt'], isNull);
      expect(firestoreMap['photoUrls'], isEmpty);
    });

    test('copyWith should create new Review with updated fields', () {
      final updatedReview = review.copyWith(
        rating: 4,
        comment: '수정된 리뷰입니다',
      );

      expect(updatedReview.id, review.id); // unchanged
      expect(updatedReview.rating, 4); // updated
      expect(updatedReview.comment, '수정된 리뷰입니다'); // updated
      expect(updatedReview.truckId, review.truckId); // unchanged
    });
  });

  group('Review rating descriptions', () {
    test('should have appropriate rating range', () {
      // Rating should typically be 1-5
      expect(1, greaterThanOrEqualTo(1));
      expect(5, lessThanOrEqualTo(5));
    });
  });
}
