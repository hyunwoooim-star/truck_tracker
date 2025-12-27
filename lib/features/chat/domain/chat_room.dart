import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

/// Chat room model for 1:1 messaging
@freezed
class ChatRoom with _$ChatRoom {
  const ChatRoom._();

  const factory ChatRoom({
    required String id,
    required String userId,
    required String truckId,
    required DateTime lastMessageAt,
    required String lastMessage,
    @Default(0) int unreadCount,
    String? userName,
    String? truckName,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      userId: data['userId'] as String,
      truckId: data['truckId'] as String,
      lastMessageAt: (data['lastMessageAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] as String,
      unreadCount: data['unreadCount'] as int? ?? 0,
      userName: data['userName'] as String?,
      truckName: data['truckName'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'truckId': truckId,
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
      if (userName != null) 'userName': userName,
      if (truckName != null) 'truckName': truckName,
    };
  }
}
