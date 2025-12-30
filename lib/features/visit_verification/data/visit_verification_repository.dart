import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/visit_verification.dart';

part 'visit_verification_repository.g.dart';

@riverpod
VisitVerificationRepository visitVerificationRepository(Ref ref) {
  return VisitVerificationRepository();
}

/// 트럭별 방문 인증 횟수 Provider
@riverpod
Stream<int> truckVisitCount(Ref ref, String truckId) {
  final repository = ref.watch(visitVerificationRepositoryProvider);
  return repository.watchVisitCount(truckId);
}

/// 트럭별 최근 방문자 목록 Provider
@riverpod
Stream<List<VisitVerification>> truckRecentVisits(Ref ref, String truckId) {
  final repository = ref.watch(visitVerificationRepositoryProvider);
  return repository.watchRecentVisits(truckId);
}

/// 사용자의 특정 트럭 방문 여부 (오늘) Provider
@riverpod
Future<bool> hasVisitedToday(Ref ref, String visitorId, String truckId) {
  final repository = ref.watch(visitVerificationRepositoryProvider);
  return repository.hasVisitedToday(visitorId, truckId);
}

class VisitVerificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 방문 인증 반경 (미터)
  static const double verificationRadiusMeters = 50.0;

  /// 방문 인증 기록
  Future<VisitVerification?> recordVisit({
    required String visitorId,
    required String visitorName,
    String? visitorPhotoUrl,
    required String truckId,
    required String truckName,
    required double distanceMeters,
    required double latitude,
    required double longitude,
  }) async {
    AppLogger.debug('Recording visit verification', tag: 'VisitVerification');
    AppLogger.debug('Visitor: $visitorName ($visitorId)', tag: 'VisitVerification');
    AppLogger.debug('Truck: $truckName ($truckId)', tag: 'VisitVerification');
    AppLogger.debug('Distance: ${distanceMeters.toStringAsFixed(1)}m', tag: 'VisitVerification');

    try {
      final docRef = await _firestore.collection('visitVerifications').add({
        'visitorId': visitorId,
        'visitorName': visitorName,
        'visitorPhotoUrl': visitorPhotoUrl,
        'truckId': truckId,
        'truckName': truckName,
        'verifiedAt': FieldValue.serverTimestamp(),
        'distanceMeters': distanceMeters,
        'latitude': latitude,
        'longitude': longitude,
      });

      // 트럭의 방문 카운터 업데이트
      await _updateTruckVisitCount(truckId, 1);

      AppLogger.success('Visit verification recorded: ${docRef.id}', tag: 'VisitVerification');

      return VisitVerification(
        id: docRef.id,
        visitorId: visitorId,
        visitorName: visitorName,
        visitorPhotoUrl: visitorPhotoUrl,
        truckId: truckId,
        truckName: truckName,
        verifiedAt: DateTime.now(),
        distanceMeters: distanceMeters,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error recording visit', error: e, stackTrace: stackTrace, tag: 'VisitVerification');
      rethrow;
    }
  }

  /// 트럭의 방문 카운터 업데이트
  Future<void> _updateTruckVisitCount(String truckId, int increment) async {
    try {
      await _firestore.collection('trucks').doc(truckId).update({
        'visitCount': FieldValue.increment(increment),
      });
    } catch (e) {
      // 필드가 없으면 생성
      AppLogger.debug('Creating visitCount field for truck', tag: 'VisitVerification');
      await _firestore.collection('trucks').doc(truckId).set({
        'visitCount': increment,
      }, SetOptions(merge: true));
    }
  }

  /// 트럭의 총 방문 인증 수 스트림
  Stream<int> watchVisitCount(String truckId) {
    return _firestore
        .collection('visitVerifications')
        .where('truckId', isEqualTo: truckId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// 트럭의 최근 방문 기록
  Stream<List<VisitVerification>> watchRecentVisits(String truckId, {int limit = 20}) {
    return _firestore
        .collection('visitVerifications')
        .where('truckId', isEqualTo: truckId)
        .orderBy('verifiedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VisitVerification.fromFirestore(doc))
            .toList());
  }

  /// 사용자의 방문 기록
  Stream<List<VisitVerification>> watchUserVisits(String visitorId) {
    return _firestore
        .collection('visitVerifications')
        .where('visitorId', isEqualTo: visitorId)
        .orderBy('verifiedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VisitVerification.fromFirestore(doc))
            .toList());
  }

  /// 오늘 이미 방문 인증 했는지 확인
  Future<bool> hasVisitedToday(String visitorId, String truckId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final snapshot = await _firestore
          .collection('visitVerifications')
          .where('visitorId', isEqualTo: visitorId)
          .where('truckId', isEqualTo: truckId)
          .where('verifiedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking visit status', error: e, stackTrace: stackTrace, tag: 'VisitVerification');
      return false;
    }
  }

  /// 특정 트럭에 대한 사용자의 총 방문 횟수
  Future<int> getUserVisitCountForTruck(String visitorId, String truckId) async {
    try {
      final snapshot = await _firestore
          .collection('visitVerifications')
          .where('visitorId', isEqualTo: visitorId)
          .where('truckId', isEqualTo: truckId)
          .get();

      return snapshot.docs.length;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user visit count', error: e, stackTrace: stackTrace, tag: 'VisitVerification');
      return 0;
    }
  }

  /// 고유 방문자 수 (트럭별)
  Future<int> getUniqueVisitorCount(String truckId) async {
    try {
      final snapshot = await _firestore
          .collection('visitVerifications')
          .where('truckId', isEqualTo: truckId)
          .get();

      final uniqueVisitors = snapshot.docs
          .map((doc) => doc.data()['visitorId'] as String)
          .toSet();

      return uniqueVisitors.length;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting unique visitor count', error: e, stackTrace: stackTrace, tag: 'VisitVerification');
      return 0;
    }
  }
}
