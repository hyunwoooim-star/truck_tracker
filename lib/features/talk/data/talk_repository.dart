import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
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
    AppLogger.debug('Sending message to truck ${message.truckId}', tag: 'TalkRepository');
    AppLogger.debug('User: ${message.userName}', tag: 'TalkRepository');
    AppLogger.debug('Message: ${message.message}', tag: 'TalkRepository');

    try {
      final docRef = await _getTalkCollection(message.truckId)
          .add(TalkMessage.toFirestore(message));

      AppLogger.success('Message sent: ${docRef.id}', tag: 'TalkRepository');
      return docRef.id;
    } catch (e, stackTrace) {
      AppLogger.error('Error sending message', error: e, stackTrace: stackTrace, tag: 'TalkRepository');
      rethrow;
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String truckId, String messageId) async {
    AppLogger.debug('Deleting message $messageId', tag: 'TalkRepository');

    try {
      await _getTalkCollection(truckId).doc(messageId).delete();
      AppLogger.success('Message deleted', tag: 'TalkRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting message', error: e, stackTrace: stackTrace, tag: 'TalkRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Watch talk messages for a truck (real-time stream)
  /// Returns the most recent messages (limit: 50)
  Stream<List<TalkMessage>> watchTruckTalk(String truckId) {
    AppLogger.debug('Watching talk for truck $truckId', tag: 'TalkRepository');

    return _getTalkCollection(truckId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs.map((doc) {
        try {
          return TalkMessage.fromFirestore(doc);
        } catch (e, stackTrace) {
          AppLogger.warning('Error parsing message ${doc.id}', tag: 'TalkRepository');
          return null;
        }
      }).whereType<TalkMessage>().toList();

      // Reverse to show oldest first
      final reversed = messages.reversed.toList();

      AppLogger.debug('Loaded ${reversed.length} talk messages for truck $truckId', tag: 'TalkRepository');
      return reversed;
    });
  }

  /// Get talk messages for a truck (one-time fetch)
  Future<List<TalkMessage>> getTruckTalk(String truckId, {int limit = 50}) async {
    AppLogger.debug('Fetching talk for truck $truckId', tag: 'TalkRepository');

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

      AppLogger.success('Fetched ${messages.length} messages', tag: 'TalkRepository');
      return messages;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching messages', error: e, stackTrace: stackTrace, tag: 'TalkRepository');
      return [];
    }
  }

  /// Clear all old messages (keep only recent N messages)
  Future<void> clearOldMessages(String truckId, {int keepRecent = 50}) async {
    AppLogger.debug('Clearing old messages for truck $truckId', tag: 'TalkRepository');

    try {
      final snapshot = await _getTalkCollection(truckId)
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.length <= keepRecent) {
        AppLogger.debug('No old messages to delete', tag: 'TalkRepository');
        return;
      }

      final toDelete = snapshot.docs.skip(keepRecent);

      for (final doc in toDelete) {
        await doc.reference.delete();
      }

      AppLogger.success('Deleted ${toDelete.length} old messages', tag: 'TalkRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing old messages', error: e, stackTrace: stackTrace, tag: 'TalkRepository');
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
