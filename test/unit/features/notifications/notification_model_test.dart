import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/notifications/domain/notification.dart';

void main() {
  group('NotificationType', () {
    test('has all expected types', () {
      expect(NotificationType.values.length, 6);
      expect(NotificationType.values, contains(NotificationType.orderUpdate));
      expect(NotificationType.values, contains(NotificationType.truckOpen));
      expect(NotificationType.values, contains(NotificationType.promotion));
      expect(NotificationType.values, contains(NotificationType.chat));
      expect(NotificationType.values, contains(NotificationType.checkin));
      expect(NotificationType.values, contains(NotificationType.system));
    });
  });

  group('AppNotification', () {
    final testDate = DateTime(2024, 12, 30, 10, 30);

    test('can create notification with required fields', () {
      final notification = AppNotification(
        id: 'test-id-1',
        userId: 'user-123',
        title: 'Test Title',
        body: 'Test Body',
        type: NotificationType.system,
        createdAt: testDate,
      );

      expect(notification.id, 'test-id-1');
      expect(notification.userId, 'user-123');
      expect(notification.title, 'Test Title');
      expect(notification.body, 'Test Body');
      expect(notification.type, NotificationType.system);
      expect(notification.createdAt, testDate);
      expect(notification.isRead, false); // default
    });

    test('can create notification with optional fields', () {
      final notification = AppNotification(
        id: 'test-id-2',
        userId: 'user-123',
        title: 'Order Ready',
        body: 'Your order is ready!',
        type: NotificationType.orderUpdate,
        createdAt: testDate,
        isRead: true,
        truckId: 'truck-456',
        orderId: 'order-789',
        chatRoomId: null,
        data: {'extraInfo': 'value'},
      );

      expect(notification.isRead, true);
      expect(notification.truckId, 'truck-456');
      expect(notification.orderId, 'order-789');
      expect(notification.chatRoomId, null);
      expect(notification.data, {'extraInfo': 'value'});
    });

    group('typeLabel', () {
      test('orderUpdate returns 주문', () {
        final notification = AppNotification(
          id: '1',
          userId: 'u1',
          title: 't',
          body: 'b',
          type: NotificationType.orderUpdate,
          createdAt: testDate,
        );
        expect(notification.typeLabel, '주문');
      });

      test('truckOpen returns 영업 알림', () {
        final notification = AppNotification(
          id: '1',
          userId: 'u1',
          title: 't',
          body: 'b',
          type: NotificationType.truckOpen,
          createdAt: testDate,
        );
        expect(notification.typeLabel, '영업 알림');
      });

      test('promotion returns 프로모션', () {
        final notification = AppNotification(
          id: '1',
          userId: 'u1',
          title: 't',
          body: 'b',
          type: NotificationType.promotion,
          createdAt: testDate,
        );
        expect(notification.typeLabel, '프로모션');
      });

      test('chat returns 메시지', () {
        final notification = AppNotification(
          id: '1',
          userId: 'u1',
          title: 't',
          body: 'b',
          type: NotificationType.chat,
          createdAt: testDate,
        );
        expect(notification.typeLabel, '메시지');
      });

      test('checkin returns 체크인', () {
        final notification = AppNotification(
          id: '1',
          userId: 'u1',
          title: 't',
          body: 'b',
          type: NotificationType.checkin,
          createdAt: testDate,
        );
        expect(notification.typeLabel, '체크인');
      });

      test('system returns 시스템', () {
        final notification = AppNotification(
          id: '1',
          userId: 'u1',
          title: 't',
          body: 'b',
          type: NotificationType.system,
          createdAt: testDate,
        );
        expect(notification.typeLabel, '시스템');
      });
    });

    group('toFirestore', () {
      test('converts notification to firestore map', () {
        final notification = AppNotification(
          id: 'test-id',
          userId: 'user-123',
          title: 'Test Title',
          body: 'Test Body',
          type: NotificationType.orderUpdate,
          createdAt: testDate,
          isRead: true,
          truckId: 'truck-456',
          orderId: 'order-789',
        );

        final map = notification.toFirestore();

        expect(map['userId'], 'user-123');
        expect(map['title'], 'Test Title');
        expect(map['body'], 'Test Body');
        expect(map['type'], 'orderUpdate');
        expect(map['isRead'], true);
        expect(map['truckId'], 'truck-456');
        expect(map['orderId'], 'order-789');
        expect(map.containsKey('createdAt'), true);
      });

      test('excludes null optional fields', () {
        final notification = AppNotification(
          id: 'test-id',
          userId: 'user-123',
          title: 'Test Title',
          body: 'Test Body',
          type: NotificationType.system,
          createdAt: testDate,
        );

        final map = notification.toFirestore();

        expect(map.containsKey('truckId'), false);
        expect(map.containsKey('orderId'), false);
        expect(map.containsKey('chatRoomId'), false);
        expect(map.containsKey('data'), false);
      });
    });

    group('copyWith', () {
      test('can copy with new isRead value', () {
        final original = AppNotification(
          id: 'test-id',
          userId: 'user-123',
          title: 'Test Title',
          body: 'Test Body',
          type: NotificationType.system,
          createdAt: testDate,
          isRead: false,
        );

        final copy = original.copyWith(isRead: true);

        expect(copy.id, original.id);
        expect(copy.userId, original.userId);
        expect(copy.title, original.title);
        expect(copy.isRead, true);
      });
    });
  });
}
