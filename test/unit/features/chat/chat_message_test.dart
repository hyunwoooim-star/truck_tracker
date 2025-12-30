import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/chat/domain/chat_message.dart';

void main() {
  group('ChatMessage Model', () {
    late ChatMessage message;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 18, 30, 0);
      message = ChatMessage(
        id: 'msg_123',
        chatRoomId: 'room_456',
        senderId: 'user_789',
        senderName: '홍길동',
        message: '안녕하세요! 떡볶이 2인분 주문 가능한가요?',
        timestamp: testDateTime,
        isRead: false,
        isEdited: false,
        imageUrl: 'https://example.com/image.jpg',
      );
    });

    test('should create ChatMessage with all fields', () {
      expect(message.id, 'msg_123');
      expect(message.chatRoomId, 'room_456');
      expect(message.senderId, 'user_789');
      expect(message.senderName, '홍길동');
      expect(message.message, contains('떡볶이'));
      expect(message.timestamp, testDateTime);
      expect(message.isRead, isFalse);
      expect(message.isEdited, isFalse);
      expect(message.imageUrl, 'https://example.com/image.jpg');
    });

    test('should create ChatMessage with required fields only', () {
      final minimalMessage = ChatMessage(
        id: 'm1',
        chatRoomId: 'r1',
        senderId: 's1',
        senderName: 'Sender',
        message: 'Hello',
        timestamp: DateTime.now(),
      );

      expect(minimalMessage.id, 'm1');
      expect(minimalMessage.isRead, isFalse);
      expect(minimalMessage.isEdited, isFalse);
      expect(minimalMessage.imageUrl, isNull);
    });

    group('isRead', () {
      test('should default to false', () {
        final unread = ChatMessage(
          id: 'm1',
          chatRoomId: 'r1',
          senderId: 's1',
          senderName: 'Sender',
          message: 'Test',
          timestamp: DateTime.now(),
        );
        expect(unread.isRead, isFalse);
      });

      test('should toggle with copyWith', () {
        final read = message.copyWith(isRead: true);
        expect(read.isRead, isTrue);
      });
    });

    group('isEdited', () {
      test('should default to false', () {
        final notEdited = ChatMessage(
          id: 'm1',
          chatRoomId: 'r1',
          senderId: 's1',
          senderName: 'Sender',
          message: 'Test',
          timestamp: DateTime.now(),
        );
        expect(notEdited.isEdited, isFalse);
      });

      test('should be true when message is edited', () {
        final edited = message.copyWith(
          message: '수정된 메시지',
          isEdited: true,
        );
        expect(edited.isEdited, isTrue);
        expect(edited.message, '수정된 메시지');
      });
    });

    group('imageUrl', () {
      test('should be null when no image attached', () {
        final noImage = ChatMessage(
          id: 'm1',
          chatRoomId: 'r1',
          senderId: 's1',
          senderName: 'Sender',
          message: 'Text only',
          timestamp: DateTime.now(),
        );
        expect(noImage.imageUrl, isNull);
      });

      test('should contain URL when image attached', () {
        expect(message.imageUrl, 'https://example.com/image.jpg');
      });
    });

    group('toFirestore', () {
      test('should convert ChatMessage to Map correctly', () {
        final firestoreMap = message.toFirestore();

        expect(firestoreMap['chatRoomId'], 'room_456');
        expect(firestoreMap['senderId'], 'user_789');
        expect(firestoreMap['senderName'], '홍길동');
        expect(firestoreMap['message'], contains('떡볶이'));
        expect(firestoreMap['isRead'], isFalse);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = message.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });

      test('should include imageUrl when present', () {
        final firestoreMap = message.toFirestore();
        expect(firestoreMap['imageUrl'], 'https://example.com/image.jpg');
      });

      test('should not include imageUrl when null', () {
        final noImage = ChatMessage(
          id: 'm1',
          chatRoomId: 'r1',
          senderId: 's1',
          senderName: 'Sender',
          message: 'No image',
          timestamp: DateTime.now(),
        );

        final firestoreMap = noImage.toFirestore();
        expect(firestoreMap.containsKey('imageUrl'), isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated message', () {
        final updated = message.copyWith(message: '새 메시지');

        expect(updated.message, '새 메시지');
        expect(updated.id, message.id);
        expect(updated.senderId, message.senderId);
      });

      test('should create copy with updated isRead', () {
        final updated = message.copyWith(isRead: true);

        expect(updated.isRead, isTrue);
        expect(updated.message, message.message);
      });
    });

    group('message content', () {
      test('should store Korean text', () {
        expect(message.message, contains('안녕하세요'));
        expect(message.message, contains('주문'));
      });

      test('should handle long messages', () {
        final longMessage = message.copyWith(message: '테스트 ' * 100);
        expect(longMessage.message.length, 400);
      });
    });

    group('timestamp', () {
      test('should store exact datetime', () {
        expect(message.timestamp.year, 2025);
        expect(message.timestamp.month, 12);
        expect(message.timestamp.day, 31);
        expect(message.timestamp.hour, 18);
        expect(message.timestamp.minute, 30);
      });
    });
  });
}
