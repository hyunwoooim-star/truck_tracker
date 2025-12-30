import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/notifications/domain/notification.dart';

void main() {
  group('AppNotification Model', () {
    late AppNotification notification;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 18, 30, 0);
      notification = AppNotification(
        id: 'notif_123',
        userId: 'user_456',
        title: '주문이 준비되었습니다!',
        body: '떡볶이 트럭에서 주문하신 음식이 준비되었습니다.',
        type: NotificationType.orderUpdate,
        createdAt: testDateTime,
        isRead: false,
        truckId: 'truck_789',
        orderId: 'order_111',
        data: {'status': 'ready'},
      );
    });

    test('should create AppNotification with all fields', () {
      expect(notification.id, 'notif_123');
      expect(notification.userId, 'user_456');
      expect(notification.title, '주문이 준비되었습니다!');
      expect(notification.body, contains('떡볶이'));
      expect(notification.type, NotificationType.orderUpdate);
      expect(notification.createdAt, testDateTime);
      expect(notification.isRead, isFalse);
      expect(notification.truckId, 'truck_789');
      expect(notification.orderId, 'order_111');
      expect(notification.data, isNotNull);
    });

    test('should create AppNotification with required fields only', () {
      final minimalNotification = AppNotification(
        id: 'n1',
        userId: 'u1',
        title: '알림 제목',
        body: '알림 내용',
        type: NotificationType.system,
        createdAt: DateTime.now(),
      );

      expect(minimalNotification.id, 'n1');
      expect(minimalNotification.isRead, isFalse);
      expect(minimalNotification.truckId, isNull);
      expect(minimalNotification.orderId, isNull);
      expect(minimalNotification.chatRoomId, isNull);
      expect(minimalNotification.data, isNull);
    });

    group('NotificationType enum', () {
      test('should have all expected values', () {
        expect(NotificationType.values.length, 6);
        expect(NotificationType.values, contains(NotificationType.orderUpdate));
        expect(NotificationType.values, contains(NotificationType.truckOpen));
        expect(NotificationType.values, contains(NotificationType.promotion));
        expect(NotificationType.values, contains(NotificationType.chat));
        expect(NotificationType.values, contains(NotificationType.checkin));
        expect(NotificationType.values, contains(NotificationType.system));
      });
    });

    group('typeLabel', () {
      test('should return correct label for orderUpdate', () {
        final n = notification.copyWith(type: NotificationType.orderUpdate);
        expect(n.typeLabel, '주문');
      });

      test('should return correct label for truckOpen', () {
        final n = notification.copyWith(type: NotificationType.truckOpen);
        expect(n.typeLabel, '영업 알림');
      });

      test('should return correct label for promotion', () {
        final n = notification.copyWith(type: NotificationType.promotion);
        expect(n.typeLabel, '프로모션');
      });

      test('should return correct label for chat', () {
        final n = notification.copyWith(type: NotificationType.chat);
        expect(n.typeLabel, '메시지');
      });

      test('should return correct label for checkin', () {
        final n = notification.copyWith(type: NotificationType.checkin);
        expect(n.typeLabel, '체크인');
      });

      test('should return correct label for system', () {
        final n = notification.copyWith(type: NotificationType.system);
        expect(n.typeLabel, '시스템');
      });
    });

    group('isRead', () {
      test('should default to false', () {
        final unreadNotification = AppNotification(
          id: 'n1',
          userId: 'u1',
          title: '제목',
          body: '내용',
          type: NotificationType.system,
          createdAt: DateTime.now(),
        );
        expect(unreadNotification.isRead, isFalse);
      });

      test('should toggle with copyWith', () {
        final readNotification = notification.copyWith(isRead: true);
        expect(readNotification.isRead, isTrue);
      });
    });

    group('copyWith', () {
      test('should create copy with updated title', () {
        final updated = notification.copyWith(title: '새 제목');

        expect(updated.title, '새 제목');
        expect(updated.id, notification.id);
        expect(updated.type, notification.type);
      });

      test('should create copy with updated type', () {
        final updated = notification.copyWith(type: NotificationType.chat);

        expect(updated.type, NotificationType.chat);
        expect(updated.title, notification.title);
      });
    });

    group('optional fields', () {
      test('should handle notification with truckId', () {
        expect(notification.truckId, 'truck_789');
      });

      test('should handle notification with orderId', () {
        expect(notification.orderId, 'order_111');
      });

      test('should handle notification with chatRoomId', () {
        final chatNotification = notification.copyWith(
          type: NotificationType.chat,
          chatRoomId: 'chat_123',
        );
        expect(chatNotification.chatRoomId, 'chat_123');
      });

      test('should handle notification with additional data', () {
        expect(notification.data, isNotNull);
        expect(notification.data!['status'], 'ready');
      });
    });
  });
}
