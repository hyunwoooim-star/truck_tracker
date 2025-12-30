import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/stamp_card/domain/stamp_card.dart';

void main() {
  group('StampCard Model', () {
    late StampCard stampCard;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 12, 0, 0);
      stampCard = StampCard(
        id: 'stamp_123',
        visitorId: 'visitor_456',
        visitorName: '홍길동',
        truckId: 'truck_789',
        truckName: '매운떡볶이',
        stampCount: 5,
        completedCards: 2,
        stampDates: [testDateTime],
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );
    });

    test('should create StampCard with all fields', () {
      expect(stampCard.id, 'stamp_123');
      expect(stampCard.visitorId, 'visitor_456');
      expect(stampCard.visitorName, '홍길동');
      expect(stampCard.truckId, 'truck_789');
      expect(stampCard.truckName, '매운떡볶이');
      expect(stampCard.stampCount, 5);
      expect(stampCard.completedCards, 2);
      expect(stampCard.stampDates.length, 1);
    });

    test('should create StampCard with defaults', () {
      final minimal = StampCard(
        id: 's1',
        visitorId: 'v1',
        visitorName: 'Visitor',
        truckId: 't1',
        truckName: 'Truck',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(minimal.stampCount, 0);
      expect(minimal.completedCards, 0);
      expect(minimal.stampDates, isEmpty);
    });

    group('maxStamps constant', () {
      test('should be 10', () {
        expect(StampCard.maxStamps, 10);
      });
    });

    group('isComplete', () {
      test('should return false when less than 10 stamps', () {
        expect(stampCard.isComplete, isFalse);
      });

      test('should return true when exactly 10 stamps', () {
        final complete = stampCard.copyWith(stampCount: 10);
        expect(complete.isComplete, isTrue);
      });

      test('should return true when more than 10 stamps', () {
        final overComplete = stampCard.copyWith(stampCount: 12);
        expect(overComplete.isComplete, isTrue);
      });
    });

    group('stampsUntilReward', () {
      test('should calculate remaining stamps correctly', () {
        expect(stampCard.stampsUntilReward, 5);
      });

      test('should return 0 when complete', () {
        final complete = stampCard.copyWith(stampCount: 10);
        expect(complete.stampsUntilReward, 0);
      });

      test('should return 10 for new card', () {
        final newCard = stampCard.copyWith(stampCount: 0);
        expect(newCard.stampsUntilReward, 10);
      });
    });

    group('progress', () {
      test('should calculate progress correctly', () {
        expect(stampCard.progress, 0.5);
      });

      test('should return 0 for new card', () {
        final newCard = stampCard.copyWith(stampCount: 0);
        expect(newCard.progress, 0.0);
      });

      test('should return 1.0 for complete card', () {
        final complete = stampCard.copyWith(stampCount: 10);
        expect(complete.progress, 1.0);
      });
    });

    group('toFirestore', () {
      test('should convert StampCard to Map correctly', () {
        final firestoreMap = stampCard.toFirestore();

        expect(firestoreMap['visitorId'], 'visitor_456');
        expect(firestoreMap['visitorName'], '홍길동');
        expect(firestoreMap['truckId'], 'truck_789');
        expect(firestoreMap['truckName'], '매운떡볶이');
        expect(firestoreMap['stampCount'], 5);
        expect(firestoreMap['completedCards'], 2);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = stampCard.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated stampCount', () {
        final updated = stampCard.copyWith(stampCount: 8);

        expect(updated.stampCount, 8);
        expect(updated.id, stampCard.id);
      });

      test('should create copy with updated completedCards', () {
        final updated = stampCard.copyWith(completedCards: 5);

        expect(updated.completedCards, 5);
      });
    });
  });

  group('Reward Model', () {
    late Reward reward;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 12, 0, 0);
      reward = Reward(
        id: 'reward_123',
        visitorId: 'visitor_456',
        visitorName: '홍길동',
        truckId: 'truck_789',
        truckName: '매운떡볶이',
        rewardType: RewardType.freeItem,
        isUsed: false,
        earnedAt: testDateTime,
      );
    });

    test('should create Reward with all fields', () {
      expect(reward.id, 'reward_123');
      expect(reward.visitorId, 'visitor_456');
      expect(reward.visitorName, '홍길동');
      expect(reward.truckId, 'truck_789');
      expect(reward.truckName, '매운떡볶이');
      expect(reward.rewardType, RewardType.freeItem);
      expect(reward.isUsed, isFalse);
      expect(reward.earnedAt, testDateTime);
    });

    test('should create Reward with defaults', () {
      final minimal = Reward(
        id: 'r1',
        visitorId: 'v1',
        visitorName: 'Visitor',
        truckId: 't1',
        truckName: 'Truck',
        rewardType: RewardType.discount10,
        earnedAt: testDateTime,
      );

      expect(minimal.isUsed, isFalse);
      expect(minimal.usedAt, isNull);
      expect(minimal.usedByOwnerId, isNull);
    });

    group('isUsed', () {
      test('should default to false', () {
        expect(reward.isUsed, isFalse);
      });

      test('should toggle with copyWith', () {
        final used = reward.copyWith(
          isUsed: true,
          usedAt: DateTime.now(),
          usedByOwnerId: 'owner_123',
        );
        expect(used.isUsed, isTrue);
        expect(used.usedAt, isNotNull);
        expect(used.usedByOwnerId, 'owner_123');
      });
    });

    group('toFirestore', () {
      test('should convert Reward to Map correctly', () {
        final firestoreMap = reward.toFirestore();

        expect(firestoreMap['visitorId'], 'visitor_456');
        expect(firestoreMap['visitorName'], '홍길동');
        expect(firestoreMap['truckId'], 'truck_789');
        expect(firestoreMap['truckName'], '매운떡볶이');
        expect(firestoreMap['rewardType'], 'freeItem');
        expect(firestoreMap['isUsed'], isFalse);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = reward.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });
    });
  });

  group('RewardType enum', () {
    test('should have all expected values', () {
      expect(RewardType.values.length, 4);
      expect(RewardType.values, contains(RewardType.freeItem));
      expect(RewardType.values, contains(RewardType.discount10));
      expect(RewardType.values, contains(RewardType.discount20));
      expect(RewardType.values, contains(RewardType.specialMenu));
    });

    group('displayName extension', () {
      test('freeItem should display correctly', () {
        expect(RewardType.freeItem.displayName, '무료 메뉴 1개');
      });

      test('discount10 should display correctly', () {
        expect(RewardType.discount10.displayName, '10% 할인');
      });

      test('discount20 should display correctly', () {
        expect(RewardType.discount20.displayName, '20% 할인');
      });

      test('specialMenu should display correctly', () {
        expect(RewardType.specialMenu.displayName, '특별 메뉴');
      });
    });

    group('emoji extension', () {
      test('freeItem should have gift emoji', () {
        expect(RewardType.freeItem.emoji, isNotEmpty);
      });

      test('discount10 should have tag emoji', () {
        expect(RewardType.discount10.emoji, isNotEmpty);
      });

      test('discount20 should have money emoji', () {
        expect(RewardType.discount20.emoji, isNotEmpty);
      });

      test('specialMenu should have star emoji', () {
        expect(RewardType.specialMenu.emoji, isNotEmpty);
      });
    });
  });
}
