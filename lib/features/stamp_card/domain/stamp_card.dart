import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stamp_card.freezed.dart';
part 'stamp_card.g.dart';

/// 스탬프 카드 모델
/// 사용자별 트럭별 스탬프 카드
@freezed
sealed class StampCard with _$StampCard {
  const factory StampCard({
    required String id,
    required String visitorId,
    required String visitorName,
    required String truckId,
    required String truckName,
    @Default(0) int stampCount, // 현재 스탬프 수 (0-10)
    @Default(0) int completedCards, // 완료된 카드 수 (10개 채울 때마다 +1)
    @Default([]) List<DateTime> stampDates, // 스탬프 찍은 날짜들
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StampCard;

  const StampCard._();

  /// 스탬프 카드 최대 개수
  static const int maxStamps = 10;

  /// 카드가 완료되었는지 (10개 다 채움)
  bool get isComplete => stampCount >= maxStamps;

  /// 다음 리워드까지 남은 스탬프 수
  int get stampsUntilReward => maxStamps - stampCount;

  /// 진행률 (0.0 ~ 1.0)
  double get progress => stampCount / maxStamps;

  /// Firestore에서 변환
  factory StampCard.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StampCard(
      id: doc.id,
      visitorId: data['visitorId'] as String,
      visitorName: data['visitorName'] as String? ?? '',
      truckId: data['truckId'] as String,
      truckName: data['truckName'] as String? ?? '',
      stampCount: data['stampCount'] as int? ?? 0,
      completedCards: data['completedCards'] as int? ?? 0,
      stampDates: (data['stampDates'] as List<dynamic>?)
              ?.map((e) => (e as Timestamp).toDate())
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Firestore로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'visitorId': visitorId,
      'visitorName': visitorName,
      'truckId': truckId,
      'truckName': truckName,
      'stampCount': stampCount,
      'completedCards': completedCards,
      'stampDates': stampDates.map((e) => Timestamp.fromDate(e)).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory StampCard.fromJson(Map<String, dynamic> json) =>
      _$StampCardFromJson(json);
}

/// 리워드/쿠폰 모델
@freezed
sealed class Reward with _$Reward {
  const factory Reward({
    required String id,
    required String visitorId,
    required String visitorName,
    required String truckId,
    required String truckName,
    required RewardType rewardType,
    @Default(false) bool isUsed,
    required DateTime earnedAt,
    DateTime? usedAt,
    String? usedByOwnerId, // 사용 확인한 사장님 ID
  }) = _Reward;

  const Reward._();

  /// Firestore에서 변환
  factory Reward.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reward(
      id: doc.id,
      visitorId: data['visitorId'] as String,
      visitorName: data['visitorName'] as String? ?? '',
      truckId: data['truckId'] as String,
      truckName: data['truckName'] as String? ?? '',
      rewardType: RewardType.values.firstWhere(
        (e) => e.name == data['rewardType'],
        orElse: () => RewardType.freeItem,
      ),
      isUsed: data['isUsed'] as bool? ?? false,
      earnedAt: (data['earnedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      usedAt: (data['usedAt'] as Timestamp?)?.toDate(),
      usedByOwnerId: data['usedByOwnerId'] as String?,
    );
  }

  /// Firestore로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'visitorId': visitorId,
      'visitorName': visitorName,
      'truckId': truckId,
      'truckName': truckName,
      'rewardType': rewardType.name,
      'isUsed': isUsed,
      'earnedAt': Timestamp.fromDate(earnedAt),
      'usedAt': usedAt != null ? Timestamp.fromDate(usedAt!) : null,
      'usedByOwnerId': usedByOwnerId,
    };
  }

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);
}

/// 리워드 타입
enum RewardType {
  freeItem, // 무료 메뉴 1개
  discount10, // 10% 할인
  discount20, // 20% 할인
  specialMenu, // 특별 메뉴
}

extension RewardTypeExtension on RewardType {
  String get displayName {
    switch (this) {
      case RewardType.freeItem:
        return '무료 메뉴 1개';
      case RewardType.discount10:
        return '10% 할인';
      case RewardType.discount20:
        return '20% 할인';
      case RewardType.specialMenu:
        return '특별 메뉴';
    }
  }

  String get emoji {
    switch (this) {
      case RewardType.freeItem:
        return '🎁';
      case RewardType.discount10:
        return '🏷️';
      case RewardType.discount20:
        return '💰';
      case RewardType.specialMenu:
        return '⭐';
    }
  }
}

