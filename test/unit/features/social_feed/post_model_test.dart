import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/social_feed/domain/post.dart';

void main() {
  group('Post Model', () {
    late Post post;

    setUp(() {
      post = Post(
        id: 'post_123',
        authorId: 'user_456',
        authorName: '떡볶이왕',
        authorProfileUrl: 'https://example.com/profile.jpg',
        truckId: 'truck_789',
        truckName: '매운떡볶이',
        content: '오늘 신메뉴 출시! #떡볶이 #신메뉴 #푸드트럭',
        imageUrls: ['https://example.com/img1.jpg', 'https://example.com/img2.jpg'],
        hashtags: ['떡볶이', '신메뉴', '푸드트럭'],
        likeCount: 42,
        commentCount: 7,
        isLikedByMe: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      );
    });

    test('should create Post with required fields', () {
      final simplePost = Post(
        id: 'p1',
        authorId: 'u1',
        authorName: '테스터',
        content: '안녕하세요!',
      );

      expect(simplePost.id, 'p1');
      expect(simplePost.authorId, 'u1');
      expect(simplePost.authorName, '테스터');
      expect(simplePost.content, '안녕하세요!');
      expect(simplePost.imageUrls, isEmpty);
      expect(simplePost.hashtags, isEmpty);
      expect(simplePost.likeCount, 0);
      expect(simplePost.commentCount, 0);
      expect(simplePost.isLikedByMe, isFalse);
    });

    test('should create Post with all fields', () {
      expect(post.id, 'post_123');
      expect(post.authorId, 'user_456');
      expect(post.authorName, '떡볶이왕');
      expect(post.truckId, 'truck_789');
      expect(post.truckName, '매운떡볶이');
      expect(post.imageUrls.length, 2);
      expect(post.hashtags.length, 3);
      expect(post.likeCount, 42);
      expect(post.commentCount, 7);
      expect(post.isLikedByMe, isTrue);
    });

    group('extractHashtags', () {
      test('should extract hashtags from content', () {
        final hashtags = Post.extractHashtags('오늘 #푸드트럭 에서 #타코 먹었어요!');
        expect(hashtags, ['푸드트럭', '타코']);
      });

      test('should return empty list when no hashtags', () {
        final hashtags = Post.extractHashtags('오늘 맛있는 음식 먹었어요');
        expect(hashtags, isEmpty);
      });

      test('should convert hashtags to lowercase', () {
        final hashtags = Post.extractHashtags('#FoodTruck #TACO');
        expect(hashtags, ['foodtruck', 'taco']);
      });

      test('should handle multiple hashtags in sequence', () {
        final hashtags = Post.extractHashtags('#맛집 #추천 #푸드트럭 #타코야끼');
        expect(hashtags.length, 4);
        expect(hashtags, contains('맛집'));
        expect(hashtags, contains('추천'));
      });
    });

    group('timeAgo', () {
      test('should return "방금 전" for posts created less than a minute ago', () {
        final recentPost = post.copyWith(
          createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
        );
        expect(recentPost.timeAgo, '방금 전');
      });

      test('should return "X분 전" for posts created minutes ago', () {
        final minutesAgoPost = post.copyWith(
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        );
        expect(minutesAgoPost.timeAgo, '15분 전');
      });

      test('should return "X시간 전" for posts created hours ago', () {
        final hoursAgoPost = post.copyWith(
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        );
        expect(hoursAgoPost.timeAgo, '5시간 전');
      });

      test('should return "X일 전" for posts created days ago (within a week)', () {
        final daysAgoPost = post.copyWith(
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        );
        expect(daysAgoPost.timeAgo, '3일 전');
      });

      test('should return date format for posts older than a week', () {
        final oldPost = post.copyWith(
          createdAt: DateTime(2025, 12, 20),
        );
        expect(oldPost.timeAgo, '12/20');
      });

      test('should return empty string when createdAt is null', () {
        final nullDatePost = post.copyWith(createdAt: null);
        expect(nullDatePost.timeAgo, '');
      });
    });

    test('toFirestore should convert Post to Map correctly', () {
      final firestoreMap = post.toFirestore();

      expect(firestoreMap['authorId'], 'user_456');
      expect(firestoreMap['authorName'], '떡볶이왕');
      expect(firestoreMap['truckId'], 'truck_789');
      expect(firestoreMap['truckName'], '매운떡볶이');
      expect(firestoreMap['content'], contains('#떡볶이'));
      expect(firestoreMap['imageUrls'], hasLength(2));
      expect(firestoreMap['hashtags'], hasLength(3));
      expect(firestoreMap['likeCount'], 42);
      expect(firestoreMap['commentCount'], 7);
    });
  });

  group('Comment Model', () {
    late Comment comment;

    setUp(() {
      comment = Comment(
        id: 'comment_123',
        postId: 'post_456',
        authorId: 'user_789',
        authorName: '맛집탐험가',
        authorProfileUrl: 'https://example.com/avatar.jpg',
        content: '맛있어 보여요! 다음에 가봐야겠어요',
        likeCount: 5,
        isLikedByMe: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      );
    });

    test('should create Comment with required fields', () {
      final simpleComment = Comment(
        id: 'c1',
        postId: 'p1',
        authorId: 'u1',
        authorName: '댓글러',
        content: '좋아요!',
      );

      expect(simpleComment.id, 'c1');
      expect(simpleComment.postId, 'p1');
      expect(simpleComment.authorId, 'u1');
      expect(simpleComment.authorName, '댓글러');
      expect(simpleComment.content, '좋아요!');
      expect(simpleComment.likeCount, 0);
      expect(simpleComment.isLikedByMe, isFalse);
    });

    group('timeAgo', () {
      test('should return correct time ago string', () {
        expect(comment.timeAgo, '30분 전');

        final hourAgoComment = comment.copyWith(
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        );
        expect(hourAgoComment.timeAgo, '2시간 전');
      });

      test('should return empty string when createdAt is null', () {
        final nullDateComment = comment.copyWith(createdAt: null);
        expect(nullDateComment.timeAgo, '');
      });
    });

    test('toFirestore should convert Comment to Map correctly', () {
      final firestoreMap = comment.toFirestore();

      expect(firestoreMap['postId'], 'post_456');
      expect(firestoreMap['authorId'], 'user_789');
      expect(firestoreMap['authorName'], '맛집탐험가');
      expect(firestoreMap['content'], contains('맛있어'));
      expect(firestoreMap['likeCount'], 5);
    });
  });

  group('PostLike Model', () {
    test('should create PostLike with required fields', () {
      final like = PostLike(
        id: 'like_123',
        postId: 'post_456',
        userId: 'user_789',
        createdAt: DateTime.now(),
      );

      expect(like.id, 'like_123');
      expect(like.postId, 'post_456');
      expect(like.userId, 'user_789');
      expect(like.createdAt, isNotNull);
    });

    test('should create PostLike without createdAt', () {
      final like = PostLike(
        id: 'like_123',
        postId: 'post_456',
        userId: 'user_789',
      );

      expect(like.createdAt, isNull);
    });
  });
}
