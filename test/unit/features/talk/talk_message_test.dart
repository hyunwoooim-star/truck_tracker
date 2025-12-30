import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/talk/domain/talk_message.dart';

void main() {
  group('TalkMessage Model', () {
    late TalkMessage talkMessage;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 18, 30, 0);
      talkMessage = TalkMessage(
        id: 'talk_123',
        truckId: 'truck_456',
        userId: 'user_789',
        userName: '홍길동',
        message: '떡볶이 맛있어요!',
        isOwner: false,
        createdAt: testDateTime,
      );
    });

    test('should create TalkMessage with all fields', () {
      expect(talkMessage.id, 'talk_123');
      expect(talkMessage.truckId, 'truck_456');
      expect(talkMessage.userId, 'user_789');
      expect(talkMessage.userName, '홍길동');
      expect(talkMessage.message, '떡볶이 맛있어요!');
      expect(talkMessage.isOwner, isFalse);
      expect(talkMessage.createdAt, testDateTime);
    });

    test('should create TalkMessage with required fields only', () {
      const minimal = TalkMessage(
        id: 't1',
        truckId: 'truck1',
        userId: 'user1',
        userName: 'User',
        message: 'Hello',
      );

      expect(minimal.id, 't1');
      expect(minimal.isOwner, isFalse); // default
      expect(minimal.createdAt, isNull);
    });

    group('isOwner', () {
      test('should default to false for customer messages', () {
        const customerMessage = TalkMessage(
          id: 't1',
          truckId: 'truck1',
          userId: 'user1',
          userName: 'Customer',
          message: 'Hello',
        );
        expect(customerMessage.isOwner, isFalse);
      });

      test('should be true for owner messages', () {
        const ownerMessage = TalkMessage(
          id: 't1',
          truckId: 'truck1',
          userId: 'owner1',
          userName: 'Owner',
          message: 'Welcome!',
          isOwner: true,
        );
        expect(ownerMessage.isOwner, isTrue);
      });

      test('should toggle with copyWith', () {
        final asOwner = talkMessage.copyWith(isOwner: true);
        expect(asOwner.isOwner, isTrue);
      });
    });

    group('toFirestore', () {
      test('should convert TalkMessage to Map correctly', () {
        final firestoreMap = TalkMessage.toFirestore(talkMessage);

        expect(firestoreMap['truckId'], 'truck_456');
        expect(firestoreMap['userId'], 'user_789');
        expect(firestoreMap['userName'], '홍길동');
        expect(firestoreMap['message'], '떡볶이 맛있어요!');
        expect(firestoreMap['isOwner'], isFalse);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = TalkMessage.toFirestore(talkMessage);
        expect(firestoreMap.containsKey('id'), isFalse);
      });

      test('should include createdAt timestamp', () {
        final firestoreMap = TalkMessage.toFirestore(talkMessage);
        expect(firestoreMap.containsKey('createdAt'), isTrue);
      });
    });

    group('copyWith', () {
      test('should create copy with updated message', () {
        final updated = talkMessage.copyWith(message: '순대도 맛있어요!');

        expect(updated.message, '순대도 맛있어요!');
        expect(updated.id, talkMessage.id); // unchanged
        expect(updated.userId, talkMessage.userId); // unchanged
      });

      test('should create copy with updated userName', () {
        final updated = talkMessage.copyWith(userName: '김철수');

        expect(updated.userName, '김철수');
        expect(updated.message, talkMessage.message); // unchanged
      });
    });

    group('message content', () {
      test('should store Korean text', () {
        expect(talkMessage.message, contains('떡볶이'));
      });

      test('should handle short messages', () {
        final short = talkMessage.copyWith(message: 'Hi');
        expect(short.message, 'Hi');
      });

      test('should handle longer messages', () {
        final long = talkMessage.copyWith(message: 'A' * 200);
        expect(long.message.length, 200);
      });
    });

    group('userName', () {
      test('should store display name', () {
        expect(talkMessage.userName, '홍길동');
      });

      test('should handle anonymous users', () {
        const anon = TalkMessage(
          id: 't1',
          truckId: 'truck1',
          userId: 'user1',
          userName: 'Anonymous',
          message: 'Hello',
        );
        expect(anon.userName, 'Anonymous');
      });
    });

    group('createdAt', () {
      test('should store datetime', () {
        expect(talkMessage.createdAt, testDateTime);
      });

      test('should be null when not provided', () {
        const noDate = TalkMessage(
          id: 't1',
          truckId: 'truck1',
          userId: 'user1',
          userName: 'User',
          message: 'Hello',
        );
        expect(noDate.createdAt, isNull);
      });
    });
  });
}
