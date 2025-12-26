import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../analytics/data/analytics_repository.dart';
import '../../auth/presentation/auth_provider.dart';

/// Analytics Dashboard Screen with Date Range Support
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final truckIdAsync = ref.watch(currentUserTruckIdProvider);
    final l10n = AppLocalizations.of(context)!;

    // Watch the date range state
    final dateRange = ref.watch(analyticsDateRangeNotifierProvider);

    // Fetch analytics for the date range - wait for truckId to load first
    final analyticsAsync = truckIdAsync.when(
      data: (truckId) => truckId != null
          ? ref.watch(analyticsRangeProvider(truckId.toString(), dateRange))
          : const AsyncValue<TruckAnalyticsRange>.loading(),
      loading: () => const AsyncValue<TruckAnalyticsRange>.loading(),
      error: (_, __) => const AsyncValue<TruckAnalyticsRange>.loading(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('통계 대시보드'),
        actions: [
          // Date Range Picker Button
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: l10n.selectDateRangeTooltip,
            onPressed: () => _showDateRangePicker(context, ref),
          ),
          // CSV Download Button
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: l10n.downloadCSVTooltip,
            onPressed: analyticsAsync.hasValue
                ? () => _downloadRangeCsv(context, analyticsAsync.value!, l10n)
                : null,
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('오류: $e', textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (analytics) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Range Display
                _buildDateRangeCard(analytics.dateRange, analytics.dayCount),
                const SizedBox(height: 24),

                // Summary Statistics
                _buildSummaryStats(analytics),
                const SizedBox(height: 24),

                // Daily Data Table
                if (analytics.dailyData.isNotEmpty)
                  _buildDailyTable(context, analytics.dailyData),

                if (analytics.dailyData.isEmpty)
                  _buildNoDataMessage(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Date range display card
  Widget _buildDateRangeCard(DateTimeRange dateRange, int dayCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.mustardYellow10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.electricBlue,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat('yyyy.MM.dd').format(dateRange.start)} ~ '
                '${DateFormat('yyyy.MM.dd').format(dateRange.end)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.electricBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '총 $dayCount일의 데이터',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Summary statistics cards
  Widget _buildSummaryStats(TruckAnalyticsRange analytics) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.touch_app,
                title: '총 조회 수',
                value: analytics.totalClicks,
                color: AppTheme.electricBlue,
                description: '${analytics.avgDaily.toStringAsFixed(1)}/day',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                icon: Icons.star,
                title: '총 리뷰',
                value: analytics.totalReviews,
                color: Colors.amber,
                description: '기간 내 전체',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _StatCard(
          icon: Icons.favorite,
          title: '즐겨찾기',
          value: analytics.totalFavorites,
          color: Colors.pink,
          description: '현재 총 즐겨찾기 수',
        ),
      ],
    );
  }

  /// Daily data table
  Widget _buildDailyTable(BuildContext context, List<DailyAnalyticsItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '일별 상세 데이터',
          style: TextStyle(
            fontSize: 20,
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
            children: [
              // Table Header
              _buildTableHeader(context),
              const Divider(height: 24),
              // Table Rows
              ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        DateFormat('MM.dd (EEE)').format(item.date),
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${item.clickCount}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: AppTheme.electricBlue),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${item.reviewCount}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${item.favoriteCount}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  /// Table header
  Widget _buildTableHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            l10n.date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            l10n.clicks,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: Text(
            l10n.reviews,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: Text(
            l10n.favorites,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  /// No data message
  Widget _buildNoDataMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 64,
              color: AppTheme.textSecondary50,
            ),
            const SizedBox(height: 16),
            const Text(
              '선택한 기간에 데이터가 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show date range picker
  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final currentRange = ref.read(analyticsDateRangeNotifierProvider);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: currentRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.electricBlue,
              onPrimary: Colors.white,
              surface: AppTheme.charcoalMedium,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(analyticsDateRangeNotifierProvider.notifier).setDateRange(picked);
    }
  }

  /// Download range CSV
  void _downloadRangeCsv(BuildContext context, TruckAnalyticsRange analytics, AppLocalizations l10n) {
    try {
      // Prepare CSV data with multiple rows
      List<List<dynamic>> csvData = [
        [l10n.date, l10n.clickCount, l10n.reviewCount, l10n.favoriteCount],
        ...analytics.dailyData.map((item) => [
          DateFormat('yyyy-MM-dd').format(item.date),
          item.clickCount,
          item.reviewCount,
          item.favoriteCount,
        ]),
        // Add summary rows
        [''],
        [l10n.total, analytics.totalClicks, analytics.totalReviews, analytics.totalFavorites],
        [
          l10n.average,
          (analytics.avgDaily).toStringAsFixed(1),
          analytics.dailyData.isEmpty
              ? '0.0'
              : (analytics.totalReviews / analytics.dailyData.length).toStringAsFixed(1),
          analytics.dailyData.isEmpty
              ? '0.0'
              : (analytics.totalFavorites / analytics.dailyData.length).toStringAsFixed(1),
        ],
      ];

      String csv = const ListToCsvConverter().convert(csvData);

      // Download for Web
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute(
          'download',
          'revenue_${DateFormat('yyyy-MM-dd').format(analytics.dateRange.start)}_'
          '${DateFormat('yyyy-MM-dd').format(analytics.dateRange.end)}.csv',
        )
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.csvDownloadSuccess),
          backgroundColor: AppTheme.electricBlue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.csvDownloadError('$e')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.description,
  });

  final IconData icon;
  final String title;
  final int value;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberFormat('#,###').format(value),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
