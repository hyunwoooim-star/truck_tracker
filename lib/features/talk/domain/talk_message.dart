import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'talk_message.freezed.dart';
part 'talk_message.g.dart';

/// Talk message model for real-time one-line communication
@freezed
sealed class TalkMessage with _$TalkMessage {
  const factory TalkMessage({
    required String id,
    required String truckId,
    required String userId,
    required String userName,
    required String message,
    @Default(false) bool isOwner, // true if message is from truck owner
    DateTime? createdAt,
  }) = _TalkMessage;

  factory TalkMessage.fromJson(Map<String, dynamic> json) =>
      _$TalkMessageFromJson(json);

  /// Create from Firestore document
  factory TalkMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TalkMessage(
      id: doc.id,
      truckId: data['truckId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      message: data['message'] ?? '',
      isOwner: data['isOwner'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  static Map<String, dynamic> toFirestore(TalkMessage message) {
    return {
      'truckId': message.truckId,
      'userId': message.userId,
      'userName': message.userName,
      'message': message.message,
      'isOwner': message.isOwner,
      'createdAt': message.createdAt != null
          ? Timestamp.fromDate(message.createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
