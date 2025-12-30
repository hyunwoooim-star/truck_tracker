import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/walking_route.dart';

part 'directions_service.g.dart';

@riverpod
DirectionsService directionsService(Ref ref) {
  return DirectionsService();
}

/// 현재 위치 Provider
@riverpod
Future<Position?> currentPosition(Ref ref) async {
  try {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  } catch (e) {
    AppLogger.error('Failed to get current position', error: e, tag: 'Directions');
    return null;
  }
}

/// 도보 경로 Provider
@riverpod
Future<WalkingRoute?> walkingRoute(
  Ref ref, {
  required double destLat,
  required double destLng,
}) async {
  final position = await ref.watch(currentPositionProvider.future);
  if (position == null) return null;

  final service = ref.read(directionsServiceProvider);
  return service.getWalkingRoute(
    originLat: position.latitude,
    originLng: position.longitude,
    destLat: destLat,
    destLng: destLng,
  );
}

class DirectionsService {
  // Google Maps Directions API Key
  // Pass via --dart-define=GOOGLE_MAPS_API_KEY=xxx at build time
  // Falls back to estimated route calculation if key is not provided
  static const String _apiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '', // Empty = use estimated route fallback
  );

  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  /// 도보 경로 조회
  Future<WalkingRoute?> getWalkingRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String language = 'ko',
  }) async {
    // API 키가 없으면 바로 예상 경로 반환 (불필요한 API 호출 방지)
    if (_apiKey.isEmpty) {
      return _calculateEstimatedRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
      );
    }

    try {
      final url = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'origin': '$originLat,$originLng',
          'destination': '$destLat,$destLng',
          'mode': 'walking',
          'language': language,
          'key': _apiKey,
        },
      );

      AppLogger.debug('Fetching walking route: $originLat,$originLng → $destLat,$destLng', tag: 'Directions');

      final response = await http.get(url);

      if (response.statusCode != 200) {
        AppLogger.error('Directions API error: ${response.statusCode}', tag: 'Directions');
        return null;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String;

      if (status != 'OK') {
        AppLogger.warning('Directions API status: $status', tag: 'Directions');

        // API 키가 없거나 유효하지 않은 경우 예상 경로 반환
        if (status == 'REQUEST_DENIED' || _apiKey.isEmpty) {
          return _calculateEstimatedRoute(
            originLat: originLat,
            originLng: originLng,
            destLat: destLat,
            destLng: destLng,
          );
        }
        return null;
      }

      return WalkingRoute.fromDirectionsApi(data);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get walking route', error: e, stackTrace: stackTrace, tag: 'Directions');

      // 에러 시 예상 경로 반환
      return _calculateEstimatedRoute(
        originLat: originLat,
        originLng: originLng,
        destLat: destLat,
        destLng: destLng,
      );
    }
  }

  /// 예상 경로 계산 (API 없이 직선 거리 기반)
  WalkingRoute _calculateEstimatedRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    // 직선 거리 계산 (미터)
    final distanceMeters = Geolocator.distanceBetween(
      originLat,
      originLng,
      destLat,
      destLng,
    ).round();

    // 도보 속도: 약 5km/h = 83m/min
    // 실제 도보 경로는 직선보다 1.3배 정도 길다고 가정
    final adjustedDistance = (distanceMeters * 1.3).round();
    final durationSeconds = (adjustedDistance / 83 * 60).round();

    final distanceText = adjustedDistance >= 1000
        ? '${(adjustedDistance / 1000).toStringAsFixed(1)}km'
        : '${adjustedDistance}m';

    final durationMinutes = (durationSeconds / 60).ceil();
    final durationText = durationMinutes >= 60
        ? '${durationMinutes ~/ 60}시간 ${durationMinutes % 60}분'
        : '$durationMinutes분';

    return WalkingRoute(
      distanceMeters: adjustedDistance,
      distanceText: distanceText,
      durationSeconds: durationSeconds,
      durationText: durationText,
      startAddress: '현재 위치',
      endAddress: '트럭 위치',
      polylinePoints: [
        LatLngPoint(lat: originLat, lng: originLng),
        LatLngPoint(lat: destLat, lng: destLng),
      ],
      steps: [
        RouteStep(
          instruction: '트럭을 향해 이동하세요',
          distanceMeters: adjustedDistance,
          distanceText: distanceText,
          durationSeconds: durationSeconds,
          durationText: durationText,
          startLat: originLat,
          startLng: originLng,
          endLat: destLat,
          endLng: destLng,
        ),
      ],
    );
  }

  /// 현재 위치와 목적지 사이 거리 계산 (미터)
  double calculateDistance({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    return Geolocator.distanceBetween(originLat, originLng, destLat, destLng);
  }

  /// ETA 계산 (분)
  int calculateWalkingEta({
    required double distanceMeters,
    double walkingSpeedKmh = 5.0,
  }) {
    // 도보 속도 기본값: 5km/h
    final speedMps = walkingSpeedKmh * 1000 / 3600; // m/s
    final seconds = distanceMeters / speedMps;
    return (seconds / 60).ceil();
  }
}
