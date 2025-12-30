import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/themes/app_theme.dart';
import '../../data/directions_service.dart';

/// 트럭까지 예상 도착 시간 카드
class EtaCard extends ConsumerWidget {
  final double truckLat;
  final double truckLng;
  final String truckName;
  final VoidCallback? onNavigateTap;

  const EtaCard({
    super.key,
    required this.truckLat,
    required this.truckLng,
    required this.truckName,
    this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionAsync = ref.watch(currentPositionProvider);

    return positionAsync.when(
      loading: () => _buildLoadingCard(),
      error: (_, __) => _buildErrorCard(context),
      data: (position) {
        if (position == null) {
          return _buildLocationDisabledCard(context);
        }

        // 거리 계산
        final distanceMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          truckLat,
          truckLng,
        );

        // ETA 계산 (도보 5km/h 기준)
        final etaMinutes = (distanceMeters / 83).ceil(); // 83m/min

        return _buildEtaCard(context, distanceMeters, etaMinutes);
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.charcoalLight),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.electricBlue,
            ),
          ),
          SizedBox(width: 12),
          Text(
            '위치 확인 중...',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '위치를 확인할 수 없습니다',
              style: TextStyle(color: Colors.red),
            ),
          ),
          if (onNavigateTap != null)
            TextButton(
              onPressed: onNavigateTap,
              child: const Text('지도 앱 열기'),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationDisabledCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.charcoalLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '위치 권한을 허용해주세요',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text('설정'),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaCard(BuildContext context, double distanceMeters, int etaMinutes) {
    final distanceText = distanceMeters >= 1000
        ? '${(distanceMeters / 1000).toStringAsFixed(1)}km'
        : '${distanceMeters.round()}m';

    final etaText = etaMinutes >= 60
        ? '${etaMinutes ~/ 60}시간 ${etaMinutes % 60}분'
        : '$etaMinutes분';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.electricBlue.withValues(alpha: 0.2),
            AppTheme.electricBlue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Walking icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.electricBlue.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_walk,
              color: AppTheme.electricBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // ETA and distance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '도보 $etaText',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.electricBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.charcoalLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        distanceText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  truckName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Navigate button
          if (onNavigateTap != null)
            IconButton(
              onPressed: onNavigateTap,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 컴팩트 ETA 배지 (트럭 카드용)
class CompactEtaBadge extends ConsumerWidget {
  final double truckLat;
  final double truckLng;

  const CompactEtaBadge({
    super.key,
    required this.truckLat,
    required this.truckLng,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionAsync = ref.watch(currentPositionProvider);

    return positionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (position) {
        if (position == null) return const SizedBox.shrink();

        final distanceMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          truckLat,
          truckLng,
        );

        final etaMinutes = (distanceMeters / 83).ceil();
        final etaText = etaMinutes >= 60
            ? '${etaMinutes ~/ 60}h ${etaMinutes % 60}m'
            : '${etaMinutes}분';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.electricBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.electricBlue.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_walk,
                size: 14,
                color: AppTheme.electricBlue,
              ),
              const SizedBox(width: 4),
              Text(
                etaText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.electricBlue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
