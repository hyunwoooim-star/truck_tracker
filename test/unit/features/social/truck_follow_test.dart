import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/social/domain/truck_follow.dart';

void main() {
  group('TruckFollow Model', () {
    late TruckFollow truckFollow;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 12, 0, 0);
      truckFollow = TruckFollow(
        id: 'follow_123',
        userId: 'user_456',
        truckId: 'truck_789',
        followedAt: testDateTime,
        notificationsEnabled: true,
      );
    });

    test('should create TruckFollow with all fields', () {
      expect(truckFollow.id, 'follow_123');
      expect(truckFollow.userId, 'user_456');
      expect(truckFollow.truckId, 'truck_789');
      expect(truckFollow.followedAt, testDateTime);
      expect(truckFollow.notificationsEnabled, isTrue);
    });

    test('should create TruckFollow with required fields only', () {
      final minimal = TruckFollow(
        id: 'f1',
        userId: 'u1',
        truckId: 't1',
        followedAt: testDateTime,
      );

      expect(minimal.id, 'f1');
      expect(minimal.userId, 'u1');
      expect(minimal.truckId, 't1');
      expect(minimal.notificationsEnabled, isTrue); // default
    });

    group('notificationsEnabled', () {
      test('should default to true', () {
        final follow = TruckFollow(
          id: 'f1',
          userId: 'u1',
          truckId: 't1',
          followedAt: testDateTime,
        );
        expect(follow.notificationsEnabled, isTrue);
      });

      test('should toggle with copyWith', () {
        final disabled = truckFollow.copyWith(notificationsEnabled: false);
        expect(disabled.notificationsEnabled, isFalse);

        final enabled = disabled.copyWith(notificationsEnabled: true);
        expect(enabled.notificationsEnabled, isTrue);
      });
    });

    group('toFirestore', () {
      test('should convert TruckFollow to Map correctly', () {
        final firestoreMap = truckFollow.toFirestore();

        expect(firestoreMap['userId'], 'user_456');
        expect(firestoreMap['truckId'], 'truck_789');
        expect(firestoreMap['notificationsEnabled'], isTrue);
        expect(firestoreMap.containsKey('followedAt'), isTrue);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = truckFollow.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated notificationsEnabled', () {
        final updated = truckFollow.copyWith(notificationsEnabled: false);

        expect(updated.notificationsEnabled, isFalse);
        expect(updated.id, truckFollow.id); // unchanged
        expect(updated.userId, truckFollow.userId); // unchanged
      });

      test('should create copy with updated truckId', () {
        final updated = truckFollow.copyWith(truckId: 'new_truck');

        expect(updated.truckId, 'new_truck');
        expect(updated.userId, truckFollow.userId); // unchanged
      });
    });

    group('followedAt', () {
      test('should store exact datetime', () {
        expect(truckFollow.followedAt.year, 2025);
        expect(truckFollow.followedAt.month, 12);
        expect(truckFollow.followedAt.day, 31);
      });

      test('should update with copyWith', () {
        final newDate = DateTime(2026, 1, 1);
        final updated = truckFollow.copyWith(followedAt: newDate);

        expect(updated.followedAt.year, 2026);
      });
    });
  });
}
