import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../order/domain/order.dart';

/// 오늘의 주문 통계 카드
class OwnerStatsCard extends StatelessWidget {
  final List<Order> orders;

  const OwnerStatsCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final today = DateTime.now();

    final todayOrders = orders.where((order) {
      if (order.createdAt == null) return false;
      final orderDate = order.createdAt!;
      return orderDate.year == today.year &&
          orderDate.month == today.month &&
          orderDate.day == today.day;
    }).toList();

    final totalOrders = todayOrders.length;
    final completedOrders =
        todayOrders.where((o) => o.status == OrderStatus.completed).length;
    final pendingOrders = todayOrders
        .where((o) =>
            o.status == OrderStatus.pending ||
            o.status == OrderStatus.confirmed)
        .length;
    final totalRevenue = todayOrders
        .where((o) => o.status == OrderStatus.completed)
        .fold<int>(0, (sum, order) => sum + order.totalAmount);

    final cashOrders = todayOrders.where(
        (o) => o.paymentMethod == 'cash' && o.status == OrderStatus.completed);
    final onlineOrders = todayOrders.where(
        (o) => o.paymentMethod != 'cash' && o.status == OrderStatus.completed);
    final cashRevenue =
        cashOrders.fold<int>(0, (sum, o) => sum + o.totalAmount);
    final onlineRevenue =
        onlineOrders.fold<int>(0, (sum, o) => sum + o.totalAmount);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.mustardYellow15,
            AppTheme.mustardYellow10,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.mustardYellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.today, color: AppTheme.mustardYellow, size: 28),
              SizedBox(width: 12),
              Text(
                '오늘의 주문 현황',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mustardYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.receipt_long,
                  label: '총 주문',
                  value: '$totalOrders',
                  color: AppTheme.electricBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.check_circle,
                  label: '완료',
                  value: '$completedOrders',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.pending,
                  label: '대기 중',
                  value: '$pendingOrders',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.attach_money,
                  label: '매출',
                  value: '₩${numberFormat.format(totalRevenue)}',
                  color: AppTheme.mustardYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.payments,
                  label: '현금',
                  value: '₩${numberFormat.format(cashRevenue)}',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.credit_card,
                  label: '온라인',
                  value: '₩${numberFormat.format(onlineRevenue)}',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
