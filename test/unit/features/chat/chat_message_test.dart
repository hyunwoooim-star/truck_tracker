import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/chat/domain/chat_message.dart';

void main() {
  group('ChatMessage', () {
    final testDate = DateTime(2024, 12, 30, 14, 30);

    test('can create message with required fields', () {
      final message = ChatMessage(
        id: 'msg-1',
        chatRoomId: 'room-1',
        senderId: 'user-1',
        senderName: 'John',
        message: 'Hello!',
        timestamp: testDate,
        isRead: false,
      );

      expect(message.id, 'msg-1');
      expect(message.chatRoomId, 'room-1');
      expect(message.senderId, 'user-1');
      expect(message.senderName, 'John');
      expect(message.message, 'Hello!');
      expect(message.timestamp, testDate);
      expect(message.isRead, false);
      expect(message.imageUrl, null);
      expect(message.isEdited, false);
    });

    test('can create message with image', () {
      final message = ChatMessage(
        id: 'msg-2',
        chatRoomId: 'room-1',
        senderId: 'user-1',
        senderName: 'John',
        message: 'Check this out!',
        timestamp: testDate,
        isRead: false,
        imageUrl: 'https://example.com/image.jpg',
      );

      expect(message.imageUrl, 'https://example.com/image.jpg');
    });

    test('can create edited message', () {
      final message = ChatMessage(
        id: 'msg-3',
        chatRoomId: 'room-1',
        senderId: 'user-1',
        senderName: 'John',
        message: 'Edited message',
        timestamp: testDate,
        isRead: true,
        isEdited: true,
      );

      expect(message.isEdited, true);
      expect(message.isRead, true);
    });

    group('toFirestore', () {
      test('converts message to firestore map', () {
        final message = ChatMessage(
          id: 'msg-1',
          chatRoomId: 'room-1',
          senderId: 'user-1',
          senderName: 'John',
          message: 'Hello!',
          timestamp: testDate,
          isRead: false,
        );

        final map = message.toFirestore();

        expect(map['chatRoomId'], 'room-1');
        expect(map['senderId'], 'user-1');
        expect(map['senderName'], 'John');
        expect(map['message'], 'Hello!');
        expect(map['isRead'], false);
        expect(map['isEdited'], false);
        expect(map.containsKey('timestamp'), true);
      });

      test('includes imageUrl when present', () {
        final message = ChatMessage(
          id: 'msg-1',
          chatRoomId: 'room-1',
          senderId: 'user-1',
          senderName: 'John',
          message: 'Photo',
          timestamp: testDate,
          isRead: false,
          imageUrl: 'https://example.com/image.jpg',
        );

        final map = message.toFirestore();

        expect(map['imageUrl'], 'https://example.com/image.jpg');
      });

      test('excludes imageUrl when null', () {
        final message = ChatMessage(
          id: 'msg-1',
          chatRoomId: 'room-1',
          senderId: 'user-1',
          senderName: 'John',
          message: 'Text only',
          timestamp: testDate,
          isRead: false,
        );

        final map = message.toFirestore();

        expect(map.containsKey('imageUrl'), false);
      });
    });

    group('copyWith', () {
      test('can copy with new message content', () {
        final original = ChatMessage(
          id: 'msg-1',
          chatRoomId: 'room-1',
          senderId: 'user-1',
          senderName: 'John',
          message: 'Original message',
          timestamp: testDate,
          isRead: false,
        );

        final edited = original.copyWith(
          message: 'Edited message',
          isEdited: true,
        );

        expect(edited.id, original.id);
        expect(edited.message, 'Edited message');
        expect(edited.isEdited, true);
        expect(edited.senderId, original.senderId);
      });

      test('can mark as read', () {
        final unread = ChatMessage(
          id: 'msg-1',
          chatRoomId: 'room-1',
          senderId: 'user-1',
          senderName: 'John',
          message: 'Message',
          timestamp: testDate,
          isRead: false,
        );

        final read = unread.copyWith(isRead: true);

        expect(read.isRead, true);
      });
    });
  });
}
