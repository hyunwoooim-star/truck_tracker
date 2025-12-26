import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    debugPrint('📍 CheckinRepository: Recording check-in');
    debugPrint('   User: $userName ($userId)');
    debugPrint('   Truck: $truckName ($truckId)');

    try {
      await _firestore.collection('checkins').add({
        'userId': userId,
        'userName': userName,
        'truckId': truckId,
        'truckName': truckName,
        'checkedInAt': FieldValue.serverTimestamp(),
        'loyaltyPoints': 10, // Award 10 points per check-in
      });

      debugPrint('✅ Check-in recorded successfully');
    } catch (e) {
      debugPrint('❌ Error recording check-in: $e');
      rethrow;
    }
  }

  /// Get user's check-in history
  Stream<List<CheckIn>> watchUserCheckins(String userId) {
    debugPrint('📡 CheckinRepository: Watching check-ins for user: $userId');

    return _firestore
        .collection('checkins')
        .where('userId', isEqualTo: userId)
        .orderBy('checkedInAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final checkins = snapshot.docs
          .map((doc) => CheckIn.fromFirestore(doc))
          .toList();

      debugPrint('📍 Received ${checkins.length} check-ins for user');
      return checkins;
    });
  }

  /// Get truck's check-in history
  Stream<List<CheckIn>> watchTruckCheckins(String truckId) {
    debugPrint('📡 CheckinRepository: Watching check-ins for truck: $truckId');

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

      debugPrint('📍 Received ${checkins.length} check-ins for truck');
      return checkins;
    });
  }

  /// Get total loyalty points for a user
  Future<int> getTotalLoyaltyPoints(String userId) async {
    debugPrint('📊 CheckinRepository: Getting loyalty points for user: $userId');

    try {
      final snapshot = await _firestore
          .collection('checkins')
          .where('userId', isEqualTo: userId)
          .get();

      final totalPoints = snapshot.docs.fold<int>(
        0,
        (sum, doc) => sum + ((doc.data()['loyaltyPoints'] ?? 0) as int),
      );

      debugPrint('✅ Total loyalty points: $totalPoints');
      return totalPoints;
    } catch (e) {
      debugPrint('❌ Error getting loyalty points: $e');
      return 0;
    }
  }

  /// Check if user has checked in to truck today
  Future<bool> hasCheckedInToday(String userId, String truckId) async {
    debugPrint('🔍 CheckinRepository: Checking if user checked in today');

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
      debugPrint(hasCheckedIn ? '✅ Already checked in today' : '❌ Not checked in today');
      return hasCheckedIn;
    } catch (e) {
      debugPrint('❌ Error checking check-in status: $e');
      return false;
    }
  }
}
