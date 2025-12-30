import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'walking_route.freezed.dart';
part 'walking_route.g.dart';

/// 도보 경로 정보
@freezed
sealed class WalkingRoute with _$WalkingRoute {
  const WalkingRoute._();

  const factory WalkingRoute({
    /// 총 거리 (미터)
    required int distanceMeters,
    /// 총 거리 텍스트 (예: "1.2km")
    required String distanceText,
    /// 예상 소요 시간 (초)
    required int durationSeconds,
    /// 예상 소요 시간 텍스트 (예: "15분")
    required String durationText,
    /// 출발지 주소
    required String startAddress,
    /// 도착지 주소
    required String endAddress,
    /// 경로 폴리라인 포인트
    required List<LatLngPoint> polylinePoints,
    /// 상세 경로 단계
    required List<RouteStep> steps,
  }) = _WalkingRoute;

  factory WalkingRoute.fromJson(Map<String, dynamic> json) =>
      _$WalkingRouteFromJson(json);

  /// Google Maps Directions API 응답에서 생성
  factory WalkingRoute.fromDirectionsApi(Map<String, dynamic> response) {
    final routes = response['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) {
      throw Exception('No routes found');
    }

    final route = routes[0] as Map<String, dynamic>;
    final legs = route['legs'] as List<dynamic>;
    final leg = legs[0] as Map<String, dynamic>;

    final distance = leg['distance'] as Map<String, dynamic>;
    final duration = leg['duration'] as Map<String, dynamic>;

    // Decode polyline
    final overviewPolyline = route['overview_polyline'] as Map<String, dynamic>;
    final encodedPolyline = overviewPolyline['points'] as String;
    final polylinePoints = _decodePolyline(encodedPolyline);

    // Parse steps
    final stepsJson = leg['steps'] as List<dynamic>;
    final steps = stepsJson.map((step) {
      final stepMap = step as Map<String, dynamic>;
      final stepDistance = stepMap['distance'] as Map<String, dynamic>;
      final stepDuration = stepMap['duration'] as Map<String, dynamic>;
      final startLocation = stepMap['start_location'] as Map<String, dynamic>;
      final endLocation = stepMap['end_location'] as Map<String, dynamic>;

      return RouteStep(
        instruction: _stripHtmlTags(stepMap['html_instructions'] as String? ?? ''),
        distanceMeters: stepDistance['value'] as int,
        distanceText: stepDistance['text'] as String,
        durationSeconds: stepDuration['value'] as int,
        durationText: stepDuration['text'] as String,
        startLat: (startLocation['lat'] as num).toDouble(),
        startLng: (startLocation['lng'] as num).toDouble(),
        endLat: (endLocation['lat'] as num).toDouble(),
        endLng: (endLocation['lng'] as num).toDouble(),
        maneuver: stepMap['maneuver'] as String?,
      );
    }).toList();

    return WalkingRoute(
      distanceMeters: distance['value'] as int,
      distanceText: distance['text'] as String,
      durationSeconds: duration['value'] as int,
      durationText: duration['text'] as String,
      startAddress: leg['start_address'] as String? ?? '',
      endAddress: leg['end_address'] as String? ?? '',
      polylinePoints: polylinePoints,
      steps: steps,
    );
  }

  /// 분 단위 소요 시간
  int get durationMinutes => (durationSeconds / 60).ceil();

  /// km 단위 거리
  double get distanceKm => distanceMeters / 1000;

  /// Google Maps용 LatLng 리스트
  List<LatLng> get googleMapsPolyline =>
      polylinePoints.map((p) => LatLng(p.lat, p.lng)).toList();
}

/// 경로 단계
@freezed
sealed class RouteStep with _$RouteStep {
  const factory RouteStep({
    /// 안내 텍스트
    required String instruction,
    /// 거리 (미터)
    required int distanceMeters,
    /// 거리 텍스트
    required String distanceText,
    /// 소요 시간 (초)
    required int durationSeconds,
    /// 소요 시간 텍스트
    required String durationText,
    /// 시작 위도
    required double startLat,
    /// 시작 경도
    required double startLng,
    /// 종료 위도
    required double endLat,
    /// 종료 경도
    required double endLng,
    /// 방향 전환 유형 (turn-left, turn-right 등)
    String? maneuver,
  }) = _RouteStep;

  factory RouteStep.fromJson(Map<String, dynamic> json) =>
      _$RouteStepFromJson(json);
}

/// 위경도 포인트 (Freezed 직렬화용)
@freezed
sealed class LatLngPoint with _$LatLngPoint {
  const factory LatLngPoint({
    required double lat,
    required double lng,
  }) = _LatLngPoint;

  factory LatLngPoint.fromJson(Map<String, dynamic> json) =>
      _$LatLngPointFromJson(json);
}

/// HTML 태그 제거
String _stripHtmlTags(String htmlString) {
  return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
}

/// 구글 폴리라인 디코딩
List<LatLngPoint> _decodePolyline(String encoded) {
  final points = <LatLngPoint>[];
  int index = 0;
  int lat = 0;
  int lng = 0;

  while (index < encoded.length) {
    int result = 0;
    int shift = 0;
    int b;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    result = 0;
    shift = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLngPoint(
      lat: lat / 1e5,
      lng: lng / 1e5,
    ));
  }

  return points;
}
