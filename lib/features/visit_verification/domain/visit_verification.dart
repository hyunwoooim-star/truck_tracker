import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_verification.freezed.dart';
part 'visit_verification.g.dart';

/// 방문 인증 기록
/// 사용자가 트럭 근처(50m)에서 "방문 인증" 버튼을 눌렀을 때 기록
@freezed
sealed class VisitVerification with _$VisitVerification {
  const VisitVerification._();

  const factory VisitVerification({
    required String id,
    required String visitorId,
    required String visitorName,
    String? visitorPhotoUrl,
    required String truckId,
    required String truckName,
    required DateTime verifiedAt,
    required double distanceMeters, // 인증 시점의 거리
    required double latitude, // 인증 시점의 사용자 위치
    required double longitude,
  }) = _VisitVerification;

  factory VisitVerification.fromJson(Map<String, dynamic> json) =>
      _$VisitVerificationFromJson(json);

  /// Create from Firestore document
  factory VisitVerification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VisitVerification(
      id: doc.id,
      visitorId: data['visitorId'] ?? '',
      visitorName: data['visitorName'] ?? '',
      visitorPhotoUrl: data['visitorPhotoUrl'],
      truckId: data['truckId'] ?? '',
      truckName: data['truckName'] ?? '',
      verifiedAt: (data['verifiedAt'] as Timestamp).toDate(),
      distanceMeters: (data['distanceMeters'] ?? 0).toDouble(),
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'visitorId': visitorId,
      'visitorName': visitorName,
      'visitorPhotoUrl': visitorPhotoUrl,
      'truckId': truckId,
      'truckName': truckName,
      'verifiedAt': Timestamp.fromDate(verifiedAt),
      'distanceMeters': distanceMeters,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// 트럭별 방문 통계
@freezed
sealed class TruckVisitStats with _$TruckVisitStats {
  const factory TruckVisitStats({
    required String truckId,
    @Default(0) int totalVisits,
    @Default(0) int uniqueVisitors,
    @Default([]) List<RecentVisitor> recentVisitors,
  }) = _TruckVisitStats;
}

/// 최근 방문자 정보 (UI 표시용)
@freezed
sealed class RecentVisitor with _$RecentVisitor {
  const factory RecentVisitor({
    required String visitorId,
    required String visitorName,
    String? visitorPhotoUrl,
    required DateTime lastVisitAt,
    @Default(1) int visitCount,
  }) = _RecentVisitor;
}
