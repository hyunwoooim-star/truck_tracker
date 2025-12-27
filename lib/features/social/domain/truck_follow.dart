import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'truck_follow.freezed.dart';
part 'truck_follow.g.dart';

/// User following a truck (for notifications and updates)
@freezed
class TruckFollow with _$TruckFollow {
  const TruckFollow._();

  const factory TruckFollow({
    required String id,
    required String userId,
    required String truckId,
    required DateTime followedAt,
    @Default(true) bool notificationsEnabled,
  }) = _TruckFollow;

  factory TruckFollow.fromJson(Map<String, dynamic> json) =>
      _$TruckFollowFromJson(json);

  factory TruckFollow.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TruckFollow(
      id: doc.id,
      userId: data['userId'] as String,
      truckId: data['truckId'] as String,
      followedAt: (data['followedAt'] as Timestamp).toDate(),
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'truckId': truckId,
      'followedAt': Timestamp.fromDate(followedAt),
      'notificationsEnabled': notificationsEnabled,
    };
  }
}
