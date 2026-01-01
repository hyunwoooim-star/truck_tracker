import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';

part 'support_chat_repository.g.dart';

/// Support message model
class SupportMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromAdmin;
  final bool isRead;

  SupportMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isFromAdmin,
    this.isRead = false,
  });

  factory SupportMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SupportMessage(
      id: doc.id,
      chatId: data['chatId'] as String,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      message: data['message'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isFromAdmin: data['isFromAdmin'] as bool? ?? false,
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isFromAdmin': isFromAdmin,
      'isRead': isRead,
    };
  }
}

/// Support chat room model
class SupportChat {
  final String id;
  final String ownerId;
  final String ownerName;
  final String? truckId;
  final String? truckName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadByOwner;
  final int unreadByAdmin;
  final String status; // 'open', 'resolved', 'pending'

  SupportChat({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    this.truckId,
    this.truckName,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unreadByOwner = 0,
    this.unreadByAdmin = 0,
    this.status = 'open',
  });

  factory SupportChat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SupportChat(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      ownerName: data['ownerName'] as String,
      truckId: data['truckId'] as String?,
      truckName: data['truckName'] as String?,
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp).toDate(),
      unreadByOwner: data['unreadByOwner'] as int? ?? 0,
      unreadByAdmin: data['unreadByAdmin'] as int? ?? 0,
      status: data['status'] as String? ?? 'open',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      if (truckId != null) 'truckId': truckId,
      if (truckName != null) 'truckName': truckName,
      'lastMessage': lastMessage,
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'unreadByOwner': unreadByOwner,
      'unreadByAdmin': unreadByAdmin,
      'status': status,
    };
  }
}

/// Repository for owner-admin support chat
class SupportChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _supportChatsCollection =>
      _firestore.collection('supportChats');

  /// Get or create support chat for an owner
  Future<SupportChat?> getOrCreateSupportChat({
    required String ownerId,
    required String ownerName,
    String? truckId,
    String? truckName,
  }) async {
    try {
      // Check if chat already exists
      final querySnapshot = await _supportChatsCollection
          .where('ownerId', isEqualTo: ownerId)
          .where('status', whereIn: ['open', 'pending'])
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return SupportChat.fromFirestore(querySnapshot.docs.first);
      }

      // Create new support chat
      final newChat = SupportChat(
        id: '',
        ownerId: ownerId,
        ownerName: ownerName,
        truckId: truckId,
        truckName: truckName,
        lastMessage: '',
        lastMessageAt: DateTime.now(),
        status: 'open',
      );

      final docRef = await _supportChatsCollection.add(newChat.toFirestore());
      return SupportChat(
        id: docRef.id,
        ownerId: ownerId,
        ownerName: ownerName,
        truckId: truckId,
        truckName: truckName,
        lastMessage: '',
        lastMessageAt: DateTime.now(),
        status: 'open',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting/creating support chat',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Watch all support chats for admin
  Stream<List<SupportChat>> watchAllSupportChats() {
    return _supportChatsCollection
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SupportChat.fromFirestore(doc))
            .toList());
  }

  /// Watch support chat for a specific owner
  Stream<SupportChat?> watchOwnerSupportChat(String ownerId) {
    return _supportChatsCollection
        .where('ownerId', isEqualTo: ownerId)
        .where('status', whereIn: ['open', 'pending'])
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return SupportChat.fromFirestore(snapshot.docs.first);
    });
  }

  /// Send a message
  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String message,
    required bool isFromAdmin,
  }) async {
    try {
      final newMessage = SupportMessage(
        id: '',
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        timestamp: DateTime.now(),
        isFromAdmin: isFromAdmin,
      );

      // Add message
      await _supportChatsCollection
          .doc(chatId)
          .collection('messages')
          .add(newMessage.toFirestore());

      // Update chat metadata
      await _supportChatsCollection.doc(chatId).update({
        'lastMessage': message,
        'lastMessageAt': FieldValue.serverTimestamp(),
        if (isFromAdmin)
          'unreadByOwner': FieldValue.increment(1)
        else
          'unreadByAdmin': FieldValue.increment(1),
      });

      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error sending support message',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Watch messages in a support chat
  Stream<List<SupportMessage>> watchMessages(String chatId) {
    return _supportChatsCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SupportMessage.fromFirestore(doc))
            .toList());
  }

  /// Mark messages as read
  Future<void> markAsRead({
    required String chatId,
    required bool isAdmin,
  }) async {
    try {
      await _supportChatsCollection.doc(chatId).update({
        if (isAdmin) 'unreadByAdmin': 0 else 'unreadByOwner': 0,
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error marking as read', error: e, stackTrace: stackTrace);
    }
  }

  /// Resolve a support chat
  Future<bool> resolveChat(String chatId) async {
    try {
      await _supportChatsCollection.doc(chatId).update({
        'status': 'resolved',
      });
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error resolving chat', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
SupportChatRepository supportChatRepository(Ref ref) {
  return SupportChatRepository();
}

@riverpod
Stream<List<SupportChat>> allSupportChats(Ref ref) {
  final repository = ref.watch(supportChatRepositoryProvider);
  return repository.watchAllSupportChats();
}

@riverpod
Stream<SupportChat?> ownerSupportChat(Ref ref, String ownerId) {
  final repository = ref.watch(supportChatRepositoryProvider);
  return repository.watchOwnerSupportChat(ownerId);
}

@riverpod
Stream<List<SupportMessage>> supportMessages(Ref ref, String chatId) {
  final repository = ref.watch(supportChatRepositoryProvider);
  return repository.watchMessages(chatId);
}
