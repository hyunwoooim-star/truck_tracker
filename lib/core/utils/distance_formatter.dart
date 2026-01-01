/// 거리 포맷팅 유틸리티
///
/// 미터 단위 거리를 사용자 친화적인 문자열로 변환합니다.
/// 모든 거리 표시에서 일관된 포맷을 위해 사용합니다.
///
/// Example:
/// ```dart
/// DistanceFormatter.format(350);   // "350m"
/// DistanceFormatter.format(1200);  // "1.2km"
/// DistanceFormatter.format(15000); // "15.0km"
/// ```
class DistanceFormatter {
  const DistanceFormatter._();

  /// 미터 단위를 사용자 친화적인 문자열로 포맷팅
  ///
  /// - 1000m 미만: "350m" 형식
  /// - 1000m 이상: "1.2km" 형식
  static String format(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  /// 미터를 킬로미터로 변환
  static double toKilometers(double meters) => meters / 1000;

  /// 킬로미터를 미터로 변환
  static double toMeters(double kilometers) => kilometers * 1000;

  /// 도보 시간 계산 (5km/h 기준)
  ///
  /// Returns: Duration
  static Duration getWalkingTime(double distanceInMeters) {
    const walkingSpeedKmh = 5.0;
    const walkingSpeedMs = walkingSpeedKmh * 1000 / 3600; // m/s
    final timeInSeconds = distanceInMeters / walkingSpeedMs;
    return Duration(seconds: timeInSeconds.round());
  }

  /// 도보 시간을 문자열로 포맷팅
  ///
  /// Example:
  /// ```dart
  /// DistanceFormatter.formatWalkingTime(300);   // "도보 1분 이내"
  /// DistanceFormatter.formatWalkingTime(1000);  // "도보 약 12분"
  /// DistanceFormatter.formatWalkingTime(10000); // "도보 약 2시간 0분"
  /// ```
  static String formatWalkingTime(double distanceInMeters) {
    final duration = getWalkingTime(distanceInMeters);

    if (duration.inMinutes < 1) {
      return '도보 1분 이내';
    } else if (duration.inMinutes < 60) {
      return '도보 약 ${duration.inMinutes}분';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '도보 약 $hours시간 $minutes분';
    }
  }

  /// 거리에 따른 접근성 설명
  ///
  /// - 50m 이하: "아주 가까움"
  /// - 200m 이하: "가까움"
  /// - 500m 이하: "도보 거리"
  /// - 1km 이하: "걸어갈 만함"
  /// - 그 외: "다소 멀어요"
  static String getAccessibilityText(double distanceInMeters) {
    if (distanceInMeters <= 50) {
      return '아주 가까움';
    } else if (distanceInMeters <= 200) {
      return '가까움';
    } else if (distanceInMeters <= 500) {
      return '도보 거리';
    } else if (distanceInMeters <= 1000) {
      return '걸어갈 만함';
    } else {
      return '다소 멀어요';
    }
  }
}
