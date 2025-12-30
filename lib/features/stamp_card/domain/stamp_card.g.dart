// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamp_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StampCard _$StampCardFromJson(Map<String, dynamic> json) => _StampCard(
  id: json['id'] as String,
  visitorId: json['visitorId'] as String,
  visitorName: json['visitorName'] as String,
  truckId: json['truckId'] as String,
  truckName: json['truckName'] as String,
  stampCount: (json['stampCount'] as num?)?.toInt() ?? 0,
  completedCards: (json['completedCards'] as num?)?.toInt() ?? 0,
  stampDates:
      (json['stampDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StampCardToJson(
  _StampCard instance,
) => <String, dynamic>{
  'id': instance.id,
  'visitorId': instance.visitorId,
  'visitorName': instance.visitorName,
  'truckId': instance.truckId,
  'truckName': instance.truckName,
  'stampCount': instance.stampCount,
  'completedCards': instance.completedCards,
  'stampDates': instance.stampDates.map((e) => e.toIso8601String()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_Reward _$RewardFromJson(Map<String, dynamic> json) => _Reward(
  id: json['id'] as String,
  visitorId: json['visitorId'] as String,
  visitorName: json['visitorName'] as String,
  truckId: json['truckId'] as String,
  truckName: json['truckName'] as String,
  rewardType: $enumDecode(_$RewardTypeEnumMap, json['rewardType']),
  isUsed: json['isUsed'] as bool? ?? false,
  earnedAt: DateTime.parse(json['earnedAt'] as String),
  usedAt: json['usedAt'] == null
      ? null
      : DateTime.parse(json['usedAt'] as String),
  usedByOwnerId: json['usedByOwnerId'] as String?,
);

Map<String, dynamic> _$RewardToJson(_Reward instance) => <String, dynamic>{
  'id': instance.id,
  'visitorId': instance.visitorId,
  'visitorName': instance.visitorName,
  'truckId': instance.truckId,
  'truckName': instance.truckName,
  'rewardType': _$RewardTypeEnumMap[instance.rewardType]!,
  'isUsed': instance.isUsed,
  'earnedAt': instance.earnedAt.toIso8601String(),
  'usedAt': instance.usedAt?.toIso8601String(),
  'usedByOwnerId': instance.usedByOwnerId,
};

const _$RewardTypeEnumMap = {
  RewardType.freeItem: 'freeItem',
  RewardType.discount10: 'discount10',
  RewardType.discount20: 'discount20',
  RewardType.specialMenu: 'specialMenu',
};
