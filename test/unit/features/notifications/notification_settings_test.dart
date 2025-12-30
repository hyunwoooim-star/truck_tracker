import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/notifications/domain/notification_settings.dart';

void main() {
  group('NotificationSettings Model', () {
    late NotificationSettings settings;

    setUp(() {
      settings = const NotificationSettings(
        userId: 'user_123',
        truckOpenings: true,
        orderUpdates: true,
        newCoupons: true,
        reviews: true,
        promotions: true,
        nearbyTrucks: false,
        nearbyRadius: 1000,
        followedTrucks: true,
        chatMessages: true,
      );
    });

    test('should create NotificationSettings with all fields', () {
      expect(settings.userId, 'user_123');
      expect(settings.truckOpenings, isTrue);
      expect(settings.orderUpdates, isTrue);
      expect(settings.newCoupons, isTrue);
      expect(settings.reviews, isTrue);
      expect(settings.promotions, isTrue);
      expect(settings.nearbyTrucks, isFalse);
      expect(settings.nearbyRadius, 1000);
      expect(settings.followedTrucks, isTrue);
      expect(settings.chatMessages, isTrue);
    });

    group('default values', () {
      test('should have correct defaults', () {
        const defaultSettings = NotificationSettings(userId: 'u1');

        expect(defaultSettings.truckOpenings, isTrue);
        expect(defaultSettings.orderUpdates, isTrue);
        expect(defaultSettings.newCoupons, isTrue);
        expect(defaultSettings.reviews, isTrue);
        expect(defaultSettings.promotions, isTrue);
        expect(defaultSettings.nearbyTrucks, isFalse);
        expect(defaultSettings.nearbyRadius, 1000);
        expect(defaultSettings.followedTrucks, isTrue);
        expect(defaultSettings.chatMessages, isTrue);
        expect(defaultSettings.lastUpdated, isNull);
      });
    });

    group('defaultSettings factory', () {
      test('should create settings with default values', () {
        final defaults = NotificationSettings.defaultSettings('user_new');

        expect(defaults.userId, 'user_new');
        expect(defaults.truckOpenings, isTrue);
        expect(defaults.orderUpdates, isTrue);
        expect(defaults.newCoupons, isTrue);
        expect(defaults.reviews, isTrue);
        expect(defaults.promotions, isTrue);
        expect(defaults.nearbyTrucks, isFalse);
        expect(defaults.nearbyRadius, 1000);
        expect(defaults.followedTrucks, isTrue);
        expect(defaults.chatMessages, isTrue);
        expect(defaults.lastUpdated, isNotNull);
      });
    });

    group('hasAnyEnabled', () {
      test('should return true when any notification is enabled', () {
        expect(settings.hasAnyEnabled, isTrue);
      });

      test('should return false when all notifications are disabled', () {
        const disabledSettings = NotificationSettings(
          userId: 'u1',
          truckOpenings: false,
          orderUpdates: false,
          newCoupons: false,
          reviews: false,
          promotions: false,
          nearbyTrucks: false,
          followedTrucks: false,
          chatMessages: false,
        );

        expect(disabledSettings.hasAnyEnabled, isFalse);
      });

      test('should return true with only one enabled', () {
        const singleEnabled = NotificationSettings(
          userId: 'u1',
          truckOpenings: true,
          orderUpdates: false,
          newCoupons: false,
          reviews: false,
          promotions: false,
          nearbyTrucks: false,
          followedTrucks: false,
          chatMessages: false,
        );

        expect(singleEnabled.hasAnyEnabled, isTrue);
      });
    });

    group('enabledCount', () {
      test('should count all enabled notifications', () {
        // settings has 7 enabled (all except nearbyTrucks)
        expect(settings.enabledCount, 7);
      });

      test('should return 0 when all disabled', () {
        const disabled = NotificationSettings(
          userId: 'u1',
          truckOpenings: false,
          orderUpdates: false,
          newCoupons: false,
          reviews: false,
          promotions: false,
          nearbyTrucks: false,
          followedTrucks: false,
          chatMessages: false,
        );

        expect(disabled.enabledCount, 0);
      });

      test('should return 8 when all enabled', () {
        const allEnabled = NotificationSettings(
          userId: 'u1',
          truckOpenings: true,
          orderUpdates: true,
          newCoupons: true,
          reviews: true,
          promotions: true,
          nearbyTrucks: true,
          followedTrucks: true,
          chatMessages: true,
        );

        expect(allEnabled.enabledCount, 8);
      });
    });

    group('nearbyRadiusKm', () {
      test('should convert meters to kilometers', () {
        expect(settings.nearbyRadiusKm, 1.0);
      });

      test('should handle 500 meters', () {
        final halfKm = settings.copyWith(nearbyRadius: 500);
        expect(halfKm.nearbyRadiusKm, 0.5);
      });

      test('should handle 2000 meters', () {
        final twoKm = settings.copyWith(nearbyRadius: 2000);
        expect(twoKm.nearbyRadiusKm, 2.0);
      });

      test('should handle 1500 meters', () {
        final oneAndHalfKm = settings.copyWith(nearbyRadius: 1500);
        expect(oneAndHalfKm.nearbyRadiusKm, 1.5);
      });
    });

    group('copyWith', () {
      test('should create copy with updated truckOpenings', () {
        final updated = settings.copyWith(truckOpenings: false);

        expect(updated.truckOpenings, isFalse);
        expect(updated.userId, settings.userId);
        expect(updated.orderUpdates, settings.orderUpdates);
      });

      test('should create copy with updated nearbyRadius', () {
        final updated = settings.copyWith(nearbyRadius: 2000);

        expect(updated.nearbyRadius, 2000);
        expect(updated.nearbyTrucks, settings.nearbyTrucks);
      });

      test('should enable nearbyTrucks', () {
        final updated = settings.copyWith(nearbyTrucks: true);

        expect(updated.nearbyTrucks, isTrue);
      });
    });

    group('notification types', () {
      test('truckOpenings controls truck opening notifications', () {
        final disabled = settings.copyWith(truckOpenings: false);
        expect(disabled.truckOpenings, isFalse);
      });

      test('orderUpdates controls order status notifications', () {
        final disabled = settings.copyWith(orderUpdates: false);
        expect(disabled.orderUpdates, isFalse);
      });

      test('newCoupons controls coupon notifications', () {
        final disabled = settings.copyWith(newCoupons: false);
        expect(disabled.newCoupons, isFalse);
      });

      test('reviews controls review reply notifications', () {
        final disabled = settings.copyWith(reviews: false);
        expect(disabled.reviews, isFalse);
      });

      test('promotions controls promotion notifications', () {
        final disabled = settings.copyWith(promotions: false);
        expect(disabled.promotions, isFalse);
      });

      test('nearbyTrucks controls location-based notifications', () {
        final enabled = settings.copyWith(nearbyTrucks: true);
        expect(enabled.nearbyTrucks, isTrue);
      });

      test('followedTrucks controls followed truck notifications', () {
        final disabled = settings.copyWith(followedTrucks: false);
        expect(disabled.followedTrucks, isFalse);
      });

      test('chatMessages controls chat notifications', () {
        final disabled = settings.copyWith(chatMessages: false);
        expect(disabled.chatMessages, isFalse);
      });
    });
  });
}
