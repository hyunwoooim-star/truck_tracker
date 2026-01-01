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

/// 영업 상태 카드 - 현재 상태 표시 및 토글
class _OwnerStatusCard extends ConsumerWidget {
  const _OwnerStatusCard({required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isOpen = truck.isOpen;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOpen
              ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
              : [AppTheme.charcoalMedium, AppTheme.charcoalDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isOpen
                ? Colors.green.withAlpha(50)
                : Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOpen ? Colors.greenAccent : Colors.grey,
                  boxShadow: isOpen
                      ? [
                          BoxShadow(
                            color: Colors.greenAccent.withAlpha(128),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isOpen ? l10n.businessOpen : l10n.businessClosed,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
