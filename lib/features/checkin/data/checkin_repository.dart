import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/checkin.dart';

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepository();
});

class CheckinRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Record a check-in
  Future<void> checkIn({
    required String userId,
    required String userName,
    required String truckId,
    required String truckName,
  }) async {
    AppLogger.debug('Recording check-in', tag: 'CheckinRepository');
    AppLogger.debug('User: $userName ($userId)', tag: 'CheckinRepository');
    AppLogger.debug('Truck: $truckName ($truckId)', tag: 'CheckinRepository');

    try {
      await _firestore.collection('checkins').add({
        'userId': userId,
        'userName': userName,
        'truckId': truckId,
        'truckName': truckName,
        'checkedInAt': FieldValue.serverTimestamp(),
        'loyaltyPoints': 10, // Award 10 points per check-in
      });

      AppLogger.success('Check-in recorded successfully', tag: 'CheckinRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error recording check-in', error: e, stackTrace: stackTrace, tag: 'CheckinRepository');
      rethrow;
    }
  }

  /// Get user's check-in history
  Stream<List<CheckIn>> watchUserCheckins(String userId) {
    AppLogger.debug('Watching check-ins for user: $userId', tag: 'CheckinRepository');

    return _firestore
        .collection('checkins')
        .where('userId', isEqualTo: userId)
        .orderBy('checkedInAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final checkins = snapshot.docs
          .map((doc) => CheckIn.fromFirestore(doc))
          .toList();

      AppLogger.debug('Received ${checkins.length} check-ins for user', tag: 'CheckinRepository');
      return checkins;
    });
  }

  /// Get truck's check-in history
  Stream<List<CheckIn>> watchTruckCheckins(String truckId) {
    AppLogger.debug('Watching check-ins for truck: $truckId', tag: 'CheckinRepository');

    return _firestore
        .collection('checkins')
        .where('truckId', isEqualTo: truckId)
        .orderBy('checkedInAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final checkins = snapshot.docs
          .map((doc) => CheckIn.fromFirestore(doc))
          .toList();

      AppLogger.debug('Received ${checkins.length} check-ins for truck', tag: 'CheckinRepository');
      return checkins;
    });
  }

  /// Get total loyalty points for a user
  Future<int> getTotalLoyaltyPoints(String userId) async {
    AppLogger.debug('Getting loyalty points for user: $userId', tag: 'CheckinRepository');

    try {
      final snapshot = await _firestore
          .collection('checkins')
          .where('userId', isEqualTo: userId)
          .get();

      final totalPoints = snapshot.docs.fold<int>(
        0,
        (sum, doc) => sum + ((doc.data()['loyaltyPoints'] ?? 0) as int),
      );

      AppLogger.success('Total loyalty points: $totalPoints', tag: 'CheckinRepository');
      return totalPoints;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting loyalty points', error: e, stackTrace: stackTrace, tag: 'CheckinRepository');
      return 0;
    }
  }

  /// Check if user has checked in to truck today
  Future<bool> hasCheckedInToday(String userId, String truckId) async {
    AppLogger.debug('Checking if user checked in today', tag: 'CheckinRepository');

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final snapshot = await _firestore
          .collection('checkins')
          .where('userId', isEqualTo: userId)
          .where('truckId', isEqualTo: truckId)
          .where('checkedInAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();

      final hasCheckedIn = snapshot.docs.isNotEmpty;
      AppLogger.debug(hasCheckedIn ? 'Already checked in today' : 'Not checked in today', tag: 'CheckinRepository');
      return hasCheckedIn;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking check-in status', error: e, stackTrace: stackTrace, tag: 'CheckinRepository');
      return false;
    }
  }
}
