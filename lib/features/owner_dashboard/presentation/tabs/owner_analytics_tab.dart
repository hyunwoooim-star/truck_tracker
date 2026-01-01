import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../order/data/order_repository.dart';
import '../../../order/domain/order.dart' as app_order;
import '../../../truck_list/domain/truck.dart';
import '../owner_status_provider.dart';

/// 통계 탭 - 매출, 방문, 리뷰 차트
class OwnerAnalyticsTab extends ConsumerWidget {
  const OwnerAnalyticsTab({super.key, required this.truckId});

  final String truckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ordersAsync = ref.watch(truckOrdersProvider(truckId));
    final truckAsync = ref.watch(ownerTruckProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              const Icon(Icons.bar_chart, color: AppTheme.mustardYellow, size: 24),
              const SizedBox(width: 12),
              Text(
                l10n.todayStats,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 통계 카드 그리드
          ordersAsync.when(
            data: (orders) {
              final completedOrders = orders.where(
                (o) => o.status == app_order.OrderStatus.completed,
              ).toList();
              final totalRevenue = completedOrders.fold<int>(
                0,
                (sum, o) => sum + o.totalAmount,
              );

              return Column(
                children: [
                  // 매출 & 주문 row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                          title: l10n.revenue,
                          value: '₩${_formatNumber(totalRevenue)}',
                          subtitle: '완료된 주문 기준',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.receipt,
                          iconColor: Colors.blue,
                          title: l10n.orderCount,
                          value: orders.length.toString(),
                          subtitle: '${completedOrders.length}건 완료',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 방문 & 리뷰 row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people,
                          iconColor: Colors.orange,
                          title: l10n.visits,
                          value: orders.length.toString(),
                          subtitle: '오늘 주문 수',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: truckAsync.when(
                          data: (truck) => _StatCard(
                            icon: Icons.star,
                            iconColor: AppTheme.mustardYellow,
                            title: l10n.reviews,
                            value: truck?.avgRating.toStringAsFixed(1) ?? '0.0',
                            subtitle: '${truck?.totalReviews ?? 0}개 리뷰',
                          ),
                          loading: () => const _StatCard(
                            icon: Icons.star,
                            iconColor: AppTheme.mustardYellow,
                            title: '리뷰',
                            value: '-',
                            subtitle: '로딩 중...',
                          ),
                          error: (_, __) => const _StatCard(
                            icon: Icons.star,
                            iconColor: AppTheme.mustardYellow,
                            title: '리뷰',
                            value: '0.0',
                            subtitle: '0개 리뷰',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.mustardYellow),
            ),
            error: (_, __) => const Center(
              child: Text(
                '데이터를 불러올 수 없습니다',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 주문 현황 차트 (간단한 바 차트)
          ordersAsync.when(
            data: (orders) => _OrderStatusChart(orders: orders),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // 품절 현황 섹션
          truckAsync.when(
            data: (truck) => truck != null ? _SoldOutSection(truck: truck) : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}만';
    }
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

/// 통계 카드 위젯
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.charcoalLight.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// 주문 상태 차트
class _OrderStatusChart extends StatelessWidget {
  const _OrderStatusChart({required this.orders});

  final List<app_order.Order> orders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = orders.where((o) => o.status == app_order.OrderStatus.pending).length;
    final preparing = orders.where((o) => o.status == app_order.OrderStatus.preparing).length;
    final completed = orders.where((o) => o.status == app_order.OrderStatus.completed).length;
    final cancelled = orders.where((o) => o.status == app_order.OrderStatus.cancelled).length;

    final total = orders.length;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // 스택 바
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                if (pending > 0)
                  Expanded(
                    flex: pending,
                    child: Container(height: 24, color: Colors.orange),
                  ),
                if (preparing > 0)
                  Expanded(
                    flex: preparing,
                    child: Container(height: 24, color: Colors.blue),
                  ),
                if (completed > 0)
                  Expanded(
                    flex: completed,
                    child: Container(height: 24, color: Colors.green),
                  ),
                if (cancelled > 0)
                  Expanded(
                    flex: cancelled,
                    child: Container(height: 24, color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 범례
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _Legend(color: Colors.orange, label: '대기 $pending'),
              _Legend(color: Colors.blue, label: '준비중 $preparing'),
              _Legend(color: Colors.green, label: '완료 $completed'),
              _Legend(color: Colors.red, label: '취소 $cancelled'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

/// 품절 현황 섹션
class _SoldOutSection extends StatelessWidget {
  const _SoldOutSection({required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: AppTheme.mustardYellow, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.soldOutStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '품절 관리는 "더보기" 탭에서 할 수 있습니다.',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
