import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../order/data/order_repository.dart';
import '../../../truck_list/domain/truck.dart';
import '../widgets/widgets.dart';

/// 홈 탭 - 영업 상태, 오늘 통계, 빠른 실행, 공지사항
class OwnerHomeTab extends ConsumerWidget {
  const OwnerHomeTab({super.key, required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(truckOrdersProvider(truck.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 영업 상태 카드
          _OwnerStatusCard(truck: truck),
          const SizedBox(height: 16),

          // GPS 영업 시작 버튼
          OwnerGpsButton(truck: truck),

          // 현금 매출 입력 버튼
          OwnerCashSaleButton(truck: truck),
          const SizedBox(height: 16),

          // 오늘의 통계
          ordersAsync.when(
            data: (orders) => OwnerStatsCard(orders: orders),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // 오늘의 공지사항
          OwnerAnnouncementSection(truck: truck),
        ],
      ),
    );
  }
}

/// 영업 상태 카드 - 현재 상태 표시 (onRoute/resting/maintenance 구분)
class _OwnerStatusCard extends ConsumerWidget {
  const _OwnerStatusCard({required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = truck.status;

    // 상태별 색상 및 텍스트 설정
    final (List<Color> gradientColors, Color dotColor, Color shadowColor, String statusText, String statusDesc, IconData statusIcon) = switch (status) {
      TruckStatus.onRoute => (
        [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        Colors.greenAccent,
        Colors.green,
        '영업 중',
        '고객들에게 내 위치가 표시되고 있어요',
        Icons.storefront,
      ),
      TruckStatus.resting => (
        [const Color(0xFFE65100), const Color(0xFFF57C00)],
        Colors.orangeAccent,
        Colors.orange,
        '휴식 중',
        '잠시 쉬는 중이에요. 곧 돌아올게요!',
        Icons.pause_circle_filled,
      ),
      TruckStatus.maintenance => (
        [const Color(0xFF424242), const Color(0xFF616161)],
        Colors.grey,
        Colors.black,
        '영업 종료',
        '오늘 영업이 종료되었어요',
        Icons.nightlight_round,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상태 표시 (아이콘 + 점 + 텍스트)
          Row(
            children: [
              Icon(statusIcon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  boxShadow: status == TruckStatus.onRoute
                      ? [
                          BoxShadow(
                            color: dotColor.withAlpha(128),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 상태 설명
          Text(
            statusDesc,
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          // 위치 정보
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  truck.locationDescription.isEmpty ? '위치 미설정' : truck.locationDescription,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (truck.announcement.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.campaign, color: AppTheme.mustardYellow, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    truck.announcement,
                    style: const TextStyle(
                      color: AppTheme.mustardYellow,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
