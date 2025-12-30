import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/stamp_card.dart';

part 'stamp_card_repository.g.dart';

@riverpod
StampCardRepository stampCardRepository(Ref ref) {
  return StampCardRepository();
}

/// 사용자의 특정 트럭 스탬프 카드 Provider
@riverpod
Stream<StampCard?> userStampCard(
  Ref ref,
  String visitorId,
  String truckId,
) {
  final repository = ref.watch(stampCardRepositoryProvider);
  return repository.watchStampCard(visitorId, truckId);
}

/// 사용자의 모든 스탬프 카드 Provider
@riverpod
Stream<List<StampCard>> userStampCards(Ref ref, String visitorId) {
  final repository = ref.watch(stampCardRepositoryProvider);
  return repository.watchUserStampCards(visitorId);
}

/// 사용자의 사용 가능한 리워드 Provider
@riverpod
Stream<List<Reward>> userRewards(Ref ref, String visitorId) {
  final repository = ref.watch(stampCardRepositoryProvider);
  return repository.watchUserRewards(visitorId);
}

/// 트럭의 발급된 리워드 목록 (사장님용)
@riverpod
Stream<List<Reward>> truckRewards(Ref ref, String truckId) {
  final repository = ref.watch(stampCardRepositoryProvider);
  return repository.watchTruckRewards(truckId);
}

class StampCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 스탬프 추가 (방문 인증 시 호출)
  /// 10개 채우면 자동으로 리워드 발급
  Future<StampResult> addStamp({
    required String visitorId,
    required String visitorName,
    required String truckId,
    required String truckName,
  }) async {
    AppLogger.debug('Adding stamp for $visitorName at $truckName', tag: 'StampCard');

    try {
      // 기존 스탬프 카드 찾기
      final existingCard = await _getStampCard(visitorId, truckId);

      if (existingCard != null) {
        // 기존 카드에 스탬프 추가
        return await _addStampToExistingCard(existingCard, visitorName, truckName);
      } else {
        // 새 카드 생성
        return await _createNewStampCard(
          visitorId: visitorId,
          visitorName: visitorName,
          truckId: truckId,
          truckName: truckName,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error adding stamp', error: e, stackTrace: stackTrace, tag: 'StampCard');
      return StampResult.error('스탬프 추가 중 오류가 발생했습니다');
    }
  }

  Future<StampCard?> _getStampCard(String visitorId, String truckId) async {
    final snapshot = await _firestore
        .collection('stampCards')
        .where('visitorId', isEqualTo: visitorId)
        .where('truckId', isEqualTo: truckId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return StampCard.fromFirestore(snapshot.docs.first);
  }

  Future<StampResult> _addStampToExistingCard(
    StampCard card,
    String visitorName,
    String truckName,
  ) async {
    final newStampCount = card.stampCount + 1;
    final now = DateTime.now();
    final newStampDates = [...card.stampDates, now];

    // 10개 채웠으면 리워드 발급 & 카드 리셋
    if (newStampCount >= StampCard.maxStamps) {
      // 리워드 발급
      final reward = await _issueReward(
        visitorId: card.visitorId,
        visitorName: visitorName,
        truckId: card.truckId,
        truckName: truckName,
      );

      // 카드 리셋 (스탬프 0, completedCards +1)
      await _firestore.collection('stampCards').doc(card.id).update({
        'stampCount': 0,
        'completedCards': FieldValue.increment(1),
        'stampDates': [], // 리셋
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Stamp card completed! Reward issued: ${reward.id}', tag: 'StampCard');

      return StampResult.rewardEarned(
        stampCount: 0,
        completedCards: card.completedCards + 1,
        reward: reward,
      );
    } else {
      // 일반 스탬프 추가
      await _firestore.collection('stampCards').doc(card.id).update({
        'stampCount': newStampCount,
        'stampDates': newStampDates.map((e) => Timestamp.fromDate(e)).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.debug('Stamp added: $newStampCount/${StampCard.maxStamps}', tag: 'StampCard');

      return StampResult.stampAdded(
        stampCount: newStampCount,
        completedCards: card.completedCards,
      );
    }
  }

  Future<StampResult> _createNewStampCard({
    required String visitorId,
    required String visitorName,
    required String truckId,
    required String truckName,
  }) async {
    final now = DateTime.now();

    await _firestore.collection('stampCards').add({
      'visitorId': visitorId,
      'visitorName': visitorName,
      'truckId': truckId,
      'truckName': truckName,
      'stampCount': 1,
      'completedCards': 0,
      'stampDates': [Timestamp.fromDate(now)],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    AppLogger.debug('New stamp card created with 1 stamp', tag: 'StampCard');

    return StampResult.stampAdded(stampCount: 1, completedCards: 0);
  }

  Future<Reward> _issueReward({
    required String visitorId,
    required String visitorName,
    required String truckId,
    required String truckName,
  }) async {
    final docRef = await _firestore.collection('rewards').add({
      'visitorId': visitorId,
      'visitorName': visitorName,
      'truckId': truckId,
      'truckName': truckName,
      'rewardType': RewardType.freeItem.name, // 기본: 무료 메뉴
      'isUsed': false,
      'earnedAt': FieldValue.serverTimestamp(),
      'usedAt': null,
      'usedByOwnerId': null,
    });

    return Reward(
      id: docRef.id,
      visitorId: visitorId,
      visitorName: visitorName,
      truckId: truckId,
      truckName: truckName,
      rewardType: RewardType.freeItem,
      earnedAt: DateTime.now(),
    );
  }

  /// 리워드 사용 처리 (사장님이 확인)
  Future<bool> useReward(String rewardId, String ownerId) async {
    try {
      await _firestore.collection('rewards').doc(rewardId).update({
        'isUsed': true,
        'usedAt': FieldValue.serverTimestamp(),
        'usedByOwnerId': ownerId,
      });

      AppLogger.success('Reward used: $rewardId', tag: 'StampCard');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error using reward', error: e, stackTrace: stackTrace, tag: 'StampCard');
      return false;
    }
  }

  /// 보너스 스탬프 추가 (광고 시청 보상)
  Future<StampResult> addBonusStamp({
    required String userId,
    required String truckId,
    required String truckName,
  }) async {
    AppLogger.debug('Adding bonus stamp for user $userId at $truckName', tag: 'StampCard');

    try {
      // 기존 스탬프 카드 찾기
      final existingCard = await _getStampCard(userId, truckId);

      if (existingCard != null) {
        // 기존 카드에 보너스 스탬프 추가
        return await _addStampToExistingCard(existingCard, '', truckName);
      } else {
        // 새 카드 생성 (보너스 스탬프 1개)
        return await _createNewStampCard(
          visitorId: userId,
          visitorName: '', // 보너스 스탬프는 이름 불필요
          truckId: truckId,
          truckName: truckName,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error adding bonus stamp', error: e, stackTrace: stackTrace, tag: 'StampCard');
      return StampResult.error('보너스 스탬프 추가 중 오류가 발생했습니다');
    }
  }

  /// 스탬프 카드 스트림 (사용자별 트럭별)
  Stream<StampCard?> watchStampCard(String visitorId, String truckId) {
    return _firestore
        .collection('stampCards')
        .where('visitorId', isEqualTo: visitorId)
        .where('truckId', isEqualTo: truckId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return StampCard.fromFirestore(snapshot.docs.first);
    });
  }

  /// 사용자의 모든 스탬프 카드
  Stream<List<StampCard>> watchUserStampCards(String visitorId) {
    return _firestore
        .collection('stampCards')
        .where('visitorId', isEqualTo: visitorId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => StampCard.fromFirestore(doc)).toList());
  }

  /// 사용자의 리워드 목록 (미사용)
  Stream<List<Reward>> watchUserRewards(String visitorId) {
    return _firestore
        .collection('rewards')
        .where('visitorId', isEqualTo: visitorId)
        .where('isUsed', isEqualTo: false)
        .orderBy('earnedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reward.fromFirestore(doc)).toList());
  }

  /// 트럭의 발급된 리워드 목록 (사장님용)
  Stream<List<Reward>> watchTruckRewards(String truckId) {
    return _firestore
        .collection('rewards')
        .where('truckId', isEqualTo: truckId)
        .orderBy('earnedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reward.fromFirestore(doc)).toList());
  }

  /// 사용자의 미사용 리워드 개수
  Future<int> getUnusedRewardCount(String visitorId) async {
    try {
      final snapshot = await _firestore
          .collection('rewards')
          .where('visitorId', isEqualTo: visitorId)
          .where('isUsed', isEqualTo: false)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}

/// 스탬프 추가 결과
sealed class StampResult {
  const StampResult();

  factory StampResult.stampAdded({
    required int stampCount,
    required int completedCards,
  }) = StampAdded;

  factory StampResult.rewardEarned({
    required int stampCount,
    required int completedCards,
    required Reward reward,
  }) = RewardEarned;

  factory StampResult.error(String message) = StampError;
}

class StampAdded extends StampResult {
  final int stampCount;
  final int completedCards;

  const StampAdded({
    required this.stampCount,
    required this.completedCards,
  });
}

class RewardEarned extends StampResult {
  final int stampCount;
  final int completedCards;
  final Reward reward;

  const RewardEarned({
    required this.stampCount,
    required this.completedCards,
    required this.reward,
  });
}

class StampError extends StampResult {
  final String message;

  const StampError(this.message);
}
