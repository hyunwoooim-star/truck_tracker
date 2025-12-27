import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Chat message model for 1:1 messaging between customer and owner
@freezed
class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    required String id,
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String message,
    required DateTime timestamp,
    @Default(false) bool isRead,
    String? imageUrl,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      chatRoomId: data['chatRoomId'] as String,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      message: data['message'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool? ?? false,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
