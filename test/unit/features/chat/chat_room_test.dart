import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/chat/domain/chat_room.dart';

void main() {
  group('ChatRoom Model', () {
    late ChatRoom chatRoom;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 18, 30, 0);
      chatRoom = ChatRoom(
        id: 'room_123',
        userId: 'user_456',
        truckId: 'truck_789',
        lastMessageAt: testDateTime,
        lastMessage: '안녕하세요! 주문 가능한가요?',
        unreadCount: 3,
        userName: '홍길동',
        truckName: '매운떡볶이',
      );
    });

    test('should create ChatRoom with all fields', () {
      expect(chatRoom.id, 'room_123');
      expect(chatRoom.userId, 'user_456');
      expect(chatRoom.truckId, 'truck_789');
      expect(chatRoom.lastMessageAt, testDateTime);
      expect(chatRoom.lastMessage, '안녕하세요! 주문 가능한가요?');
      expect(chatRoom.unreadCount, 3);
      expect(chatRoom.userName, '홍길동');
      expect(chatRoom.truckName, '매운떡볶이');
    });

    test('should create ChatRoom with required fields only', () {
      final minimalRoom = ChatRoom(
        id: 'r1',
        userId: 'u1',
        truckId: 't1',
        lastMessageAt: DateTime.now(),
        lastMessage: 'Hello',
      );

      expect(minimalRoom.id, 'r1');
      expect(minimalRoom.userId, 'u1');
      expect(minimalRoom.truckId, 't1');
      expect(minimalRoom.unreadCount, 0); // default
      expect(minimalRoom.userName, isNull);
      expect(minimalRoom.truckName, isNull);
    });

    group('unreadCount', () {
      test('should default to 0', () {
        final noUnread = ChatRoom(
          id: 'r1',
          userId: 'u1',
          truckId: 't1',
          lastMessageAt: DateTime.now(),
          lastMessage: 'Test',
        );
        expect(noUnread.unreadCount, 0);
      });

      test('should store positive unread count', () {
        expect(chatRoom.unreadCount, 3);
      });

      test('should update with copyWith', () {
        final updated = chatRoom.copyWith(unreadCount: 5);
        expect(updated.unreadCount, 5);
      });

      test('should reset to 0 when read', () {
        final read = chatRoom.copyWith(unreadCount: 0);
        expect(read.unreadCount, 0);
      });
    });

    group('toFirestore', () {
      test('should convert ChatRoom to Map correctly', () {
        final firestoreMap = chatRoom.toFirestore();

        expect(firestoreMap['userId'], 'user_456');
        expect(firestoreMap['truckId'], 'truck_789');
        expect(firestoreMap['lastMessage'], '안녕하세요! 주문 가능한가요?');
        expect(firestoreMap['unreadCount'], 3);
        expect(firestoreMap['userName'], '홍길동');
        expect(firestoreMap['truckName'], '매운떡볶이');
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = chatRoom.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });

      test('should not include null userName', () {
        final noUserName = ChatRoom(
          id: 'r1',
          userId: 'u1',
          truckId: 't1',
          lastMessageAt: DateTime.now(),
          lastMessage: 'Test',
        );

        final firestoreMap = noUserName.toFirestore();
        expect(firestoreMap.containsKey('userName'), isFalse);
      });

      test('should not include null truckName', () {
        final noTruckName = ChatRoom(
          id: 'r1',
          userId: 'u1',
          truckId: 't1',
          lastMessageAt: DateTime.now(),
          lastMessage: 'Test',
        );

        final firestoreMap = noTruckName.toFirestore();
        expect(firestoreMap.containsKey('truckName'), isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated lastMessage', () {
        final updated = chatRoom.copyWith(
          lastMessage: '새로운 메시지',
          lastMessageAt: DateTime.now(),
        );

        expect(updated.lastMessage, '새로운 메시지');
        expect(updated.id, chatRoom.id); // unchanged
      });

      test('should create copy with updated unreadCount', () {
        final updated = chatRoom.copyWith(unreadCount: 10);

        expect(updated.unreadCount, 10);
        expect(updated.userId, chatRoom.userId); // unchanged
      });
    });

    group('lastMessage', () {
      test('should store message text', () {
        expect(chatRoom.lastMessage, contains('주문'));
      });

      test('should handle empty message', () {
        final emptyMessage = chatRoom.copyWith(lastMessage: '');
        expect(emptyMessage.lastMessage, isEmpty);
      });

      test('should handle long message', () {
        final longMessage = chatRoom.copyWith(
          lastMessage: '아' * 1000,
        );
        expect(longMessage.lastMessage.length, 1000);
      });
    });

    group('optional names', () {
      test('should store userName when provided', () {
        expect(chatRoom.userName, '홍길동');
      });

      test('should store truckName when provided', () {
        expect(chatRoom.truckName, '매운떡볶이');
      });

      test('should allow null userName', () {
        final noName = chatRoom.copyWith(userName: null);
        expect(noName.userName, isNull);
      });

      test('should allow null truckName', () {
        final noName = chatRoom.copyWith(truckName: null);
        expect(noName.truckName, isNull);
      });
    });
  });
}
