import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order.dart';

const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

/// Weekly Revenue Chart using fl_chart
class WeeklyRevenueChart extends ConsumerWidget {
  final String truckId;

  const WeeklyRevenueChart({
    super.key,
    required this.truckId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(truckOrdersProvider(truckId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Revenue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: ordersAsync.when(
              data: (orders) {
                final weeklyData = _calculateWeeklyRevenue(orders);
                return _buildChart(weeklyData);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: _mustard),
              ),
              error: (_, __) => const Center(
                child: Text(
                  'Error loading revenue data',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate revenue for each day of the current week
  Map<int, double> _calculateWeeklyRevenue(List<Order> orders) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1)); // Monday

    // Initialize all days to 0
    final weeklyRevenue = <int, double>{
      1: 0.0, // Monday
      2: 0.0, // Tuesday
      3: 0.0, // Wednesday
      4: 0.0, // Thursday
      5: 0.0, // Friday
      6: 0.0, // Saturday
      7: 0.0, // Sunday
    };

    // Sum revenue for completed orders in the current week
    for (final order in orders) {
      if (order.status == OrderStatus.completed && order.createdAt != null) {
        final orderDate = order.createdAt!;

        // Check if order is in current week
        if (orderDate.isAfter(weekStart.subtract(const Duration(days: 1)))) {
          final dayOfWeek = orderDate.weekday; // 1 = Monday, 7 = Sunday

          // Add to total (including both card and cash)
          weeklyRevenue[dayOfWeek] =
              (weeklyRevenue[dayOfWeek] ?? 0.0) + order.totalAmount;
        }
      }
    }

    return weeklyRevenue;
  }

  Widget _buildChart(Map<int, double> weeklyData) {
    final maxY = weeklyData.values.reduce((a, b) => a > b ? a : b);
    final chartMaxY = maxY > 0 ? maxY * 1.2 : 100000.0; // Add 20% padding

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: chartMaxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppTheme.mustardYellow90,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final day = _getDayName(group.x.toInt() + 1);
              final amount = NumberFormat('#,###').format(rod.toY.toInt());
              return BarTooltipItem(
                '$day\n₩$amount',
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final day = _getDayName(value.toInt() + 1);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    day.substring(0, 3), // Show first 3 letters
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  '${(value / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white12,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.white24, width: 1),
            left: BorderSide(color: Colors.white24, width: 1),
          ),
        ),
        barGroups: List.generate(7, (index) {
          final dayOfWeek = index + 1; // 1 = Monday
          final revenue = weeklyData[dayOfWeek] ?? 0.0;
          final isToday = DateTime.now().weekday == dayOfWeek;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: revenue,
                color: isToday ? _mustard : AppTheme.mustardYellow70,
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
