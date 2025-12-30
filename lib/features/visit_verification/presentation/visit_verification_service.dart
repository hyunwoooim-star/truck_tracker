import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../../location/location_service.dart';
import '../../stamp_card/data/stamp_card_repository.dart';
import '../../truck_list/domain/truck.dart';
import '../data/visit_verification_repository.dart';
import '../domain/visit_verification.dart';

part 'visit_verification_service.g.dart';

/// 방문 인증 결과
sealed class VerificationResult {
  const VerificationResult();
}

class VerificationSuccess extends VerificationResult {
  final VisitVerification verification;
  final int userVisitCount; // 사용자의 해당 트럭 총 방문 횟수
  final StampResult? stampResult; // 스탬프 결과
  const VerificationSuccess(this.verification, this.userVisitCount, {this.stampResult});
}

class VerificationFailure extends VerificationResult {
  final VerificationError error;
  const VerificationFailure(this.error);
}

enum VerificationError {
  notLoggedIn,
  locationPermissionDenied,
  locationUnavailable,
  tooFarFromTruck,
  alreadyVerifiedToday,
  truckClosed,
  unknown,
}

extension VerificationErrorMessage on VerificationError {
  String get message {
    switch (this) {
      case VerificationError.notLoggedIn:
        return '로그인이 필요합니다';
      case VerificationError.locationPermissionDenied:
        return '위치 권한이 필요합니다';
      case VerificationError.locationUnavailable:
        return '현재 위치를 확인할 수 없습니다';
      case VerificationError.tooFarFromTruck:
        return '트럭과 너무 멀리 있습니다 (50m 이내에서 인증 가능)';
      case VerificationError.alreadyVerifiedToday:
        return '오늘 이미 방문 인증을 완료했습니다';
      case VerificationError.truckClosed:
        return '영업 중인 트럭에서만 인증할 수 있습니다';
      case VerificationError.unknown:
        return '알 수 없는 오류가 발생했습니다';
    }
  }
}

@riverpod
VisitVerificationService visitVerificationService(Ref ref) {
  return VisitVerificationService(
    repository: ref.watch(visitVerificationRepositoryProvider),
    stampCardRepository: ref.watch(stampCardRepositoryProvider),
    locationService: LocationService(),
  );
}

class VisitVerificationService {
  final VisitVerificationRepository repository;
  final StampCardRepository stampCardRepository;
  final LocationService locationService;

  VisitVerificationService({
    required this.repository,
    required this.stampCardRepository,
    required this.locationService,
  });

  /// 방문 인증 시도
  /// 위치 확인 → 거리 체크 → 중복 체크 → 기록
  Future<VerificationResult> verifyVisit({
    required String visitorId,
    required String visitorName,
    String? visitorPhotoUrl,
    required Truck truck,
  }) async {
    AppLogger.debug('Starting visit verification for truck: ${truck.foodType}', tag: 'VisitVerificationService');

    try {
      // 1. 트럭이 영업 중인지 확인
      if (!truck.isOpen) {
        AppLogger.warning('Truck is not open', tag: 'VisitVerificationService');
        return const VerificationFailure(VerificationError.truckClosed);
      }

      // 2. 오늘 이미 인증했는지 확인
      final hasVisited = await repository.hasVisitedToday(visitorId, truck.id);
      if (hasVisited) {
        AppLogger.warning('Already verified today', tag: 'VisitVerificationService');
        return const VerificationFailure(VerificationError.alreadyVerifiedToday);
      }

      // 3. 위치 권한 확인
      final hasPermission = await locationService.ensurePermission();
      if (!hasPermission) {
        AppLogger.warning('Location permission denied', tag: 'VisitVerificationService');
        return const VerificationFailure(VerificationError.locationPermissionDenied);
      }

      // 4. 현재 위치 가져오기
      final position = await locationService.getCurrentPosition();
      if (position == null) {
        AppLogger.warning('Could not get current position', tag: 'VisitVerificationService');
        return const VerificationFailure(VerificationError.locationUnavailable);
      }

      // 5. 트럭과의 거리 계산
      final distance = locationService.calculateDistance(
        position.latitude,
        position.longitude,
        truck.latitude,
        truck.longitude,
      );

      AppLogger.debug('Distance to truck: ${distance.toStringAsFixed(1)}m', tag: 'VisitVerificationService');

      // 6. 거리 확인 (50m 이내)
      if (distance > VisitVerificationRepository.verificationRadiusMeters) {
        AppLogger.warning('Too far from truck: ${distance.toStringAsFixed(1)}m', tag: 'VisitVerificationService');
        return const VerificationFailure(VerificationError.tooFarFromTruck);
      }

      // 7. 방문 기록 저장
      final verification = await repository.recordVisit(
        visitorId: visitorId,
        visitorName: visitorName,
        visitorPhotoUrl: visitorPhotoUrl,
        truckId: truck.id,
        truckName: truck.foodType,
        distanceMeters: distance,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (verification == null) {
        return const VerificationFailure(VerificationError.unknown);
      }

      // 8. 사용자의 해당 트럭 총 방문 횟수 가져오기
      final visitCount = await repository.getUserVisitCountForTruck(visitorId, truck.id);

      // 9. 스탬프 추가
      final stampResult = await stampCardRepository.addStamp(
        visitorId: visitorId,
        visitorName: visitorName,
        truckId: truck.id,
        truckName: truck.foodType,
      );

      AppLogger.success('Visit verification successful! Total visits: $visitCount', tag: 'VisitVerificationService');

      return VerificationSuccess(verification, visitCount, stampResult: stampResult);
    } catch (e, stackTrace) {
      AppLogger.error('Visit verification failed', error: e, stackTrace: stackTrace, tag: 'VisitVerificationService');
      return const VerificationFailure(VerificationError.unknown);
    }
  }

  /// 현재 위치에서 트럭까지의 거리 확인
  Future<double?> getDistanceToTruck(Truck truck) async {
    try {
      final hasPermission = await locationService.ensurePermission();
      if (!hasPermission) return null;

      final position = await locationService.getCurrentPosition();
      if (position == null) return null;

      return locationService.calculateDistance(
        position.latitude,
        position.longitude,
        truck.latitude,
        truck.longitude,
      );
    } catch (e) {
      AppLogger.error('Error getting distance to truck', error: e, tag: 'VisitVerificationService');
      return null;
    }
  }

  /// 인증 가능 여부 확인
  Future<bool> canVerify(String visitorId, Truck truck) async {
    // 트럭이 영업 중이 아니면 불가
    if (!truck.isOpen) return false;

    // 오늘 이미 인증했으면 불가
    final hasVisited = await repository.hasVisitedToday(visitorId, truck.id);
    if (hasVisited) return false;

    // 위치 권한 없으면 불가
    final hasPermission = await locationService.ensurePermission();
    if (!hasPermission) return false;

    // 거리 확인
    final distance = await getDistanceToTruck(truck);
    if (distance == null) return false;

    return distance <= VisitVerificationRepository.verificationRadiusMeters;
  }
}
