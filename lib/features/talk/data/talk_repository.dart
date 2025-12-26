import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/talk_message.dart';

part 'talk_repository.g.dart';

/// Repository for managing truck talk messages
class TalkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get talk messages sub-collection for a truck
  CollectionReference<Map<String, dynamic>> _getTalkCollection(String truckId) {
    return _firestore.collection('trucks').doc(truckId).collection('talks');
  }

  // ═══════════════════════════════════════════════════════════
  // WRITE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Send a talk message
  Future<String> sendMessage(TalkMessage message) async {
    debugPrint('💬 TalkRepository: Sending message to truck ${message.truckId}');
    debugPrint('   User: ${message.userName}');
    debugPrint('   Message: ${message.message}');

    try {
      final docRef = await _getTalkCollection(message.truckId)
          .add(TalkMessage.toFirestore(message));

      debugPrint('✅ Message sent: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String truckId, String messageId) async {
    debugPrint('💬 TalkRepository: Deleting message $messageId');

    try {
      await _getTalkCollection(truckId).doc(messageId).delete();
      debugPrint('✅ Message deleted');
    } catch (e) {
      debugPrint('❌ Error deleting message: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Watch talk messages for a truck (real-time stream)
  /// Returns the most recent messages (limit: 50)
  Stream<List<TalkMessage>> watchTruckTalk(String truckId) {
    debugPrint('📡 TalkRepository: Watching talk for truck $truckId');

    return _getTalkCollection(truckId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs.map((doc) {
        try {
          return TalkMessage.fromFirestore(doc);
        } catch (e) {
          debugPrint('⚠️ Error parsing message ${doc.id}: $e');
          return null;
        }
      }).whereType<TalkMessage>().toList();

      // Reverse to show oldest first
      final reversed = messages.reversed.toList();

      debugPrint('📡 Loaded ${reversed.length} talk messages for truck $truckId');
      return reversed;
    });
  }

  /// Get talk messages for a truck (one-time fetch)
  Future<List<TalkMessage>> getTruckTalk(String truckId, {int limit = 50}) async {
    debugPrint('💬 TalkRepository: Fetching talk for truck $truckId');

    try {
      final snapshot = await _getTalkCollection(truckId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final messages = snapshot.docs
          .map((doc) => TalkMessage.fromFirestore(doc))
          .toList()
          .reversed
          .toList();

      debugPrint('✅ Fetched ${messages.length} messages');
      return messages;
    } catch (e) {
      debugPrint('❌ Error fetching messages: $e');
      return [];
    }
  }

  /// Clear all old messages (keep only recent N messages)
  Future<void> clearOldMessages(String truckId, {int keepRecent = 50}) async {
    debugPrint('🧹 TalkRepository: Clearing old messages for truck $truckId');

    try {
      final snapshot = await _getTalkCollection(truckId)
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.length <= keepRecent) {
        debugPrint('   No old messages to delete');
        return;
      }

      final toDelete = snapshot.docs.skip(keepRecent);

      for (final doc in toDelete) {
        await doc.reference.delete();
      }

      debugPrint('✅ Deleted ${toDelete.length} old messages');
    } catch (e) {
      debugPrint('❌ Error clearing old messages: $e');
    }
  }
}

@riverpod
TalkRepository talkRepository(TalkRepositoryRef ref) {
  return TalkRepository();
}

/// Provider for watching talk messages of a specific truck
@riverpod
Stream<List<TalkMessage>> truckTalk(TruckTalkRef ref, String truckId) {
  final repository = ref.watch(talkRepositoryProvider);
  return repository.watchTruckTalk(truckId);
}
