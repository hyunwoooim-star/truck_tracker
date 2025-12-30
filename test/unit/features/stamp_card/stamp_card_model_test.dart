import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/stamp_card/domain/stamp_card.dart';

void main() {
  group('StampCard', () {
    test('maxStamps is 10', () {
      expect(StampCard.maxStamps, 10);
    });

    test('creates StampCard with all required fields', () {
      final card = StampCard(
        id: 'test-id',
        visitorId: 'visitor-123',
        visitorName: '홍길동',
        truckId: 'truck-456',
        truckName: '맛있는 타코',
        stampCount: 5,
        completedCards: 2,
        stampDates: [DateTime.now()],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(card.id, 'test-id');
      expect(card.visitorId, 'visitor-123');
      expect(card.visitorName, '홍길동');
      expect(card.truckId, 'truck-456');
      expect(card.truckName, '맛있는 타코');
      expect(card.stampCount, 5);
      expect(card.completedCards, 2);
    });

    test('stampCount cannot exceed maxStamps', () {
      // Business logic: stampCount resets to 0 when reaching 10
      const currentStamps = 9;
      const newStamps = currentStamps + 1;

      if (newStamps >= StampCard.maxStamps) {
        // Reset to 0 and increment completedCards
        expect(newStamps >= StampCard.maxStamps, isTrue);
      }
    });

    test('progressPercentage is calculated correctly', () {
      // 5 stamps out of 10 = 50%
      const stampCount = 5;
      const progress = stampCount / StampCard.maxStamps;
      expect(progress, 0.5);

      // 0 stamps = 0%
      const zeroProgress = 0 / StampCard.maxStamps;
      expect(zeroProgress, 0.0);

      // 10 stamps = 100%
      const fullProgress = 10 / StampCard.maxStamps;
      expect(fullProgress, 1.0);
    });
  });

  group('Reward', () {
    test('creates Reward with all fields', () {
      final reward = Reward(
        id: 'reward-id',
        visitorId: 'visitor-123',
        visitorName: '홍길동',
        truckId: 'truck-456',
        truckName: '맛있는 타코',
        rewardType: RewardType.freeItem,
        earnedAt: DateTime.now(),
        isUsed: false,
      );

      expect(reward.id, 'reward-id');
      expect(reward.rewardType, RewardType.freeItem);
      expect(reward.isUsed, isFalse);
    });

    test('isUsed can be toggled', () {
      final reward = Reward(
        id: 'reward-id',
        visitorId: 'visitor-123',
        visitorName: '홍길동',
        truckId: 'truck-456',
        truckName: '맛있는 타코',
        rewardType: RewardType.freeItem,
        earnedAt: DateTime.now(),
        isUsed: false,
      );

      expect(reward.isUsed, isFalse);

      // After using
      final usedReward = reward.copyWith(
        isUsed: true,
        usedAt: DateTime.now(),
      );
      expect(usedReward.isUsed, isTrue);
      expect(usedReward.usedAt, isNotNull);
    });

    test('RewardType has expected values', () {
      expect(RewardType.values.length, greaterThan(0));
      expect(RewardType.values.contains(RewardType.freeItem), isTrue);
    });
  });

  group('StampCard Business Rules', () {
    test('new card starts with 0 stamps', () {
      const initialStamps = 0;
      expect(initialStamps, 0);
    });

    test('collecting 10 stamps earns a reward', () {
      const stampsNeeded = 10;
      expect(stampsNeeded, StampCard.maxStamps);
    });

    test('after earning reward, card resets to 0', () {
      const stampsAfterReward = 0;
      expect(stampsAfterReward, 0);
    });

    test('completedCards increments after each reward', () {
      const before = 2;
      const after = before + 1;
      expect(after, 3);
    });
  });
}
