import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/logger.dart';
import '../domain/chat_message.dart';
import '../domain/chat_room.dart';

part 'chat_repository.g.dart';

/// Repository for managing chat rooms and messages
class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _chatRoomsCollection =>
      _firestore.collection('chatRooms');

  // ═══════════════════════════════════════════════════════════
  // CHAT ROOM MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  /// Get or create a chat room between user and truck
  Future<ChatRoom?> getOrCreateChatRoom({
    required String userId,
    required String truckId,
    String? userName,
    String? truckName,
  }) async {
    try {
      // Check if chat room already exists
      final querySnapshot = await _chatRoomsCollection
          .where('userId', isEqualTo: userId)
          .where('truckId', isEqualTo: truckId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ChatRoom.fromFirestore(querySnapshot.docs.first);
      }

      // Create new chat room
      final newRoom = ChatRoom(
        id: '',
        userId: userId,
        truckId: truckId,
        lastMessageAt: DateTime.now(),
        lastMessage: '',
        unreadCount: 0,
        userName: userName,
        truckName: truckName,
      );

      final docRef = await _chatRoomsCollection.add(newRoom.toFirestore());
      return newRoom.copyWith(id: docRef.id);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting/creating chat room',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Watch chat rooms for a user (real-time)
  Stream<List<ChatRoom>> watchUserChatRooms(String userId) {
    return _chatRoomsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromFirestore(doc))
            .toList());
  }

  /// Watch chat rooms for a truck owner (real-time)
  Stream<List<ChatRoom>> watchTruckChatRooms(String truckId) {
    return _chatRoomsCollection
        .where('truckId', isEqualTo: truckId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromFirestore(doc))
            .toList());
  }

  /// Get a single chat room by ID
  Future<ChatRoom?> getChatRoom(String roomId) async {
    try {
      final doc = await _chatRoomsCollection.doc(roomId).get();
      if (!doc.exists) return null;
      return ChatRoom.fromFirestore(doc);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting chat room',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MESSAGE MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  /// Send a text message
  Future<bool> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String message,
  }) async {
    try {
      final newMessage = ChatMessage(
        id: '',
        chatRoomId: chatRoomId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Add message to subcollection
      await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toFirestore());

      // Update chat room's lastMessage and lastMessageAt
      await _chatRoomsCollection.doc(chatRoomId).update({
        'lastMessage': message,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount': FieldValue.increment(1),
      });

      AppLogger.info('Message sent successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error sending message', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Send a message with image
  Future<bool> sendImageMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String message,
    required File imageFile,
  }) async {
    try {
      // Upload image to Firebase Storage
      final imageUrl = await _uploadImage(chatRoomId, imageFile);
      if (imageUrl == null) return false;

      final newMessage = ChatMessage(
        id: '',
        chatRoomId: chatRoomId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        timestamp: DateTime.now(),
        isRead: false,
        imageUrl: imageUrl,
      );

      // Add message to subcollection
      await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toFirestore());

      // Update chat room's lastMessage and lastMessageAt
      await _chatRoomsCollection.doc(chatRoomId).update({
        'lastMessage': message.isNotEmpty ? message : '📷 사진',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount': FieldValue.increment(1),
      });

      AppLogger.info('Image message sent successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error sending image message',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Upload image to Firebase Storage
  Future<String?> _uploadImage(String chatRoomId, File imageFile) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('chat_images/$chatRoomId/$timestamp.jpg');

      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      AppLogger.info('Image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading image', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Watch messages in a chat room (real-time)
  Stream<List<ChatMessage>> watchMessages(String chatRoomId) {
    return _chatRoomsCollection
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  /// Mark all messages as read
  Future<void> markAllAsRead({
    required String chatRoomId,
    required String currentUserId,
  }) async {
    try {
      // Get all unread messages not sent by current user
      final unreadMessages = await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      // Batch update
      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      // Reset unread count
      batch.update(_chatRoomsCollection.doc(chatRoomId), {'unreadCount': 0});

      await batch.commit();
      AppLogger.info('Marked ${unreadMessages.docs.length} messages as read');
    } catch (e, stackTrace) {
      AppLogger.error('Error marking messages as read',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Delete a chat room and all its messages
  Future<bool> deleteChatRoom(String chatRoomId) async {
    try {
      // Delete all messages
      final messagesSnapshot = await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .get();

      final batch = _firestore.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete chat room
      batch.delete(_chatRoomsCollection.doc(chatRoomId));

      await batch.commit();
      AppLogger.info('Chat room deleted successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting chat room',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════

  /// Get total unread count for a user
  Future<int> getTotalUnreadCount(String userId) async {
    try {
      final snapshot = await _chatRoomsCollection
          .where('userId', isEqualTo: userId)
          .get();

      int totalUnread = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalUnread += (data['unreadCount'] as int? ?? 0);
      }

      return totalUnread;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting total unread count',
          error: e, stackTrace: stackTrace);
      return 0;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository();
}

@riverpod
Stream<List<ChatRoom>> userChatRooms(
  UserChatRoomsRef ref,
  String userId,
) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchUserChatRooms(userId);
}

@riverpod
Stream<List<ChatRoom>> truckChatRooms(
  TruckChatRoomsRef ref,
  String truckId,
) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchTruckChatRooms(truckId);
}

@riverpod
Stream<List<ChatMessage>> chatMessages(
  ChatMessagesRef ref,
  String chatRoomId,
) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(chatRoomId);
}

@riverpod
Future<int> totalUnreadCount(
  TotalUnreadCountRef ref,
  String userId,
) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getTotalUnreadCount(userId);
}
