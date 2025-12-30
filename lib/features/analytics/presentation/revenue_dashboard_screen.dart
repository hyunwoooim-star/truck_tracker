import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/revenue_repository.dart';

/// 매출 대시보드 화면
class RevenueDashboardScreen extends ConsumerWidget {
  const RevenueDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final truckIdAsync = ref.watch(currentUserTruckIdProvider);

    return truckIdAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('오류: $e')),
      ),
      data: (truckId) {
        if (truckId == null) {
          return const Scaffold(
            body: Center(child: Text('트럭 정보를 찾을 수 없습니다')),
          );
        }
        return _RevenueDashboardContent(truckId: truckId.toString());
      },
    );
  }
}

class _RevenueDashboardContent extends ConsumerWidget {
  final String truckId;

  const _RevenueDashboardContent({required this.truckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(reportDateRangeProvider);
    final realtimeAsync = ref.watch(realTimeDashboardProvider(truckId));
    final reportAsync = ref.watch(revenueReportProvider(truckId, dateRange));

    return Scaffold(
      appBar: AppBar(
        title: const Text('매출 대시보드'),
        actions: [
          // 기간 선택
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              final notifier = ref.read(reportDateRangeProvider.notifier);
              switch (value) {
                case 'today':
                  notifier.setToday();
                  break;
                case 'week':
                  notifier.setThisWeek();
                  break;
                case 'month':
                  notifier.setThisMonth();
                  break;
                case '30days':
                  notifier.setLast30Days();
                  break;
                case 'custom':
                  _showDateRangePicker(context, ref);
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'today', child: Text('오늘')),
              const PopupMenuItem(value: 'week', child: Text('이번 주')),
              const PopupMenuItem(value: 'month', child: Text('이번 달')),
              const PopupMenuItem(value: '30days', child: Text('최근 30일')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'custom', child: Text('기간 선택...')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(realTimeDashboardProvider(truckId));
          ref.invalidate(revenueReportProvider(truckId, dateRange));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 실시간 현황
              _buildRealTimeSection(realtimeAsync),
              const SizedBox(height: 24),

              // 매출 리포트
              _buildRevenueReport(reportAsync, dateRange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRealTimeSection(AsyncValue<RealTimeDashboard> realtimeAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, color: AppTheme.mustardYellow, size: 20),
            const SizedBox(width: 8),
            const Text(
              '실시간 현황',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            realtimeAsync.when(
              loading: () => const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const Icon(Icons.error, size: 16, color: Colors.red),
              data: (data) => Text(
                '${DateFormat('HH:mm').format(data.lastUpdated)} 업데이트',
                style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        realtimeAsync.when(
          loading: () => const _RealTimeCardsLoading(),
          error: (e, _) => Center(child: Text('오류: $e')),
          data: (data) => _RealTimeCards(data: data),
        ),
      ],
    );
  }

  Widget _buildRevenueReport(
    AsyncValue<RevenueReport> reportAsync,
    DateTimeRange dateRange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics, color: AppTheme.electricBlue, size: 20),
            const SizedBox(width: 8),
            const Text(
              '매출 리포트',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${DateFormat('MM.dd').format(dateRange.start)} ~ ${DateFormat('MM.dd').format(dateRange.end)}',
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        reportAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Center(child: Text('오류: $e')),
          data: (report) => _RevenueReportContent(report: report),
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final currentRange = ref.read(reportDateRangeProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: currentRange,
    );

    if (picked != null) {
      ref.read(reportDateRangeProvider.notifier).setRange(picked);
    }
  }
}

/// 실시간 카드들
class _RealTimeCards extends StatelessWidget {
  final RealTimeDashboard data;

  const _RealTimeCards({required this.data});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Column(
      children: [
        // 오늘 매출 (큰 카드)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.mustardYellow.withValues(alpha: 0.3),
                AppTheme.mustardYellow.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.mustardYellow.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '오늘 매출',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₩${formatter.format(data.todayRevenue)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mustardYellow,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '주문 ${data.todayOrders}건 완료',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 주문 상태 카드들
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: '대기중',
                count: data.pendingOrders,
                color: Colors.orange,
                icon: Icons.hourglass_empty,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatusCard(
                title: '준비중',
                count: data.preparingOrders,
                color: AppTheme.electricBlue,
                icon: Icons.restaurant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatusCard(
                title: '픽업대기',
                count: data.readyOrders,
                color: Colors.green,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RealTimeCardsLoading extends StatelessWidget {
  const _RealTimeCardsLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: AppTheme.charcoalMedium,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                height: 80,
                margin: EdgeInsets.only(left: index > 0 ? 12 : 0),
                decoration: BoxDecoration(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
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

/// 매출 리포트 내용
class _RevenueReportContent extends StatelessWidget {
  final RevenueReport report;

  const _RevenueReportContent({required this.report});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Column(
      children: [
        // 요약 카드
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: '총 매출',
                value: '₩${formatter.format(report.totalRevenue)}',
                color: AppTheme.electricBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: '평균 주문',
                value: '₩${formatter.format(report.avgOrderValue.round())}',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: '완료 주문',
                value: '${report.completedOrders}건',
                subtitle: '${report.completionRate.toStringAsFixed(1)}% 완료율',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: '취소 주문',
                value: '${report.cancelledOrders}건',
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 일별 매출 차트
        if (report.dailyData.isNotEmpty) ...[
          _buildRevenueChart(report),
          const SizedBox(height: 24),
        ],

        // 인기 메뉴 TOP 5
        if (report.topMenuItems.isNotEmpty) ...[
          _buildTopMenus(report.topMenuItems),
        ],
      ],
    );
  }

  Widget _buildRevenueChart(RevenueReport report) {
    if (report.dailyData.isEmpty) return const SizedBox.shrink();

    final maxRevenue = report.dailyData
        .map((e) => e.totalRevenue)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    final spots = report.dailyData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.totalRevenue.toDouble());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '일별 매출 추이',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.charcoalMedium,
            borderRadius: BorderRadius.circular(12),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxRevenue > 0 ? maxRevenue / 4 : 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppTheme.charcoalLight,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, _) {
                      if (value >= 10000) {
                        return Text(
                          '${(value / 10000).toStringAsFixed(0)}만',
                          style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
                        );
                      }
                      return Text(
                        '${value.toInt()}',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= report.dailyData.length) return const Text('');
                      final date = report.dailyData[index].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MM/dd').format(date),
                          style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (report.dailyData.length - 1).toDouble(),
              minY: 0,
              maxY: maxRevenue * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppTheme.electricBlue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppTheme.electricBlue.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopMenus(Map<String, int> topMenuItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '인기 메뉴 TOP 5',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.charcoalMedium,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: topMenuItems.entries.toList().asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final menuName = entry.value.key;
              final count = entry.value.value;

              return Padding(
                padding: EdgeInsets.only(top: entry.key > 0 ? 12 : 0),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: rank <= 3
                            ? AppTheme.mustardYellow.withValues(alpha: 0.2)
                            : AppTheme.charcoalLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$rank',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rank <= 3 ? AppTheme.mustardYellow : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        menuName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '$count개',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.electricBlue,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
