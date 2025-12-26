import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkin.freezed.dart';
part 'checkin.g.dart';

@freezed
class CheckIn with _$CheckIn {
  const CheckIn._();

  const factory CheckIn({
    required String id,
    required String userId,
    required String userName,
    required String truckId,
    required String truckName,
    required DateTime checkedInAt,
    @Default(0) int loyaltyPoints,
  }) = _CheckIn;

  factory CheckIn.fromJson(Map<String, dynamic> json) => _$CheckInFromJson(json);

  /// Create from Firestore document
  factory CheckIn.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CheckIn(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      truckId: data['truckId'] ?? '',
      truckName: data['truckName'] ?? '',
      checkedInAt: (data['checkedInAt'] as Timestamp).toDate(),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'truckId': truckId,
      'truckName': truckName,
      'checkedInAt': Timestamp.fromDate(checkedInAt),
      'loyaltyPoints': loyaltyPoints,
    };
  }
}
