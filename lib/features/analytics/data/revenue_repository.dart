import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';

part 'revenue_repository.g.dart';

/// 일별 매출 데이터
class DailyRevenue {
  final DateTime date;
  final int orderCount;
  final int totalRevenue;
  final int completedOrders;
  final int cancelledOrders;

  DailyRevenue({
    required this.date,
    required this.orderCount,
    required this.totalRevenue,
    required this.completedOrders,
    required this.cancelledOrders,
  });

  double get avgOrderValue => orderCount > 0 ? totalRevenue / orderCount : 0;
  double get completionRate => orderCount > 0 ? completedOrders / orderCount * 100 : 0;
}

/// 매출 리포트 (기간별)
class RevenueReport {
  final DateTimeRange dateRange;
  final List<DailyRevenue> dailyData;
  final int totalRevenue;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double avgOrderValue;
  final Map<String, int> topMenuItems; // 인기 메뉴 TOP 5

  RevenueReport({
    required this.dateRange,
    required this.dailyData,
    required this.totalRevenue,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.avgOrderValue,
    required this.topMenuItems,
  });

  /// 전일 대비 매출 증감률
  double get revenueGrowthRate {
    if (dailyData.length < 2) return 0;
    final today = dailyData.last.totalRevenue;
    final yesterday = dailyData[dailyData.length - 2].totalRevenue;
    if (yesterday == 0) return today > 0 ? 100 : 0;
    return ((today - yesterday) / yesterday * 100);
  }

  /// 완료율
  double get completionRate => totalOrders > 0 ? completedOrders / totalOrders * 100 : 0;
}

/// 실시간 대시보드 데이터
class RealTimeDashboard {
  final int todayRevenue;
  final int todayOrders;
  final int pendingOrders;
  final int preparingOrders;
  final int readyOrders;
  final int activeVisitors; // 최근 10분 내 방문자
  final DateTime lastUpdated;

  RealTimeDashboard({
    required this.todayRevenue,
    required this.todayOrders,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.activeVisitors,
    required this.lastUpdated,
  });
}

/// 매출 데이터 Repository
class RevenueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 실시간 대시보드 스트림
  Stream<RealTimeDashboard> watchRealTimeDashboard(String truckId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return _firestore
        .collection('orders')
        .where('truckId', isEqualTo: truckId)
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .snapshots()
        .map((snapshot) {
      int todayRevenue = 0;
      int todayOrders = 0;
      int pendingOrders = 0;
      int preparingOrders = 0;
      int readyOrders = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String?;
        final amount = (data['totalAmount'] as num?)?.toInt() ?? 0;

        todayOrders++;

        // 완료된 주문만 매출에 포함
        if (status == 'completed') {
          todayRevenue += amount;
        }

        switch (status) {
          case 'pending':
          case 'confirmed':
            pendingOrders++;
            break;
          case 'preparing':
            preparingOrders++;
            break;
          case 'ready':
            readyOrders++;
            break;
        }
      }

      return RealTimeDashboard(
        todayRevenue: todayRevenue,
        todayOrders: todayOrders,
        pendingOrders: pendingOrders,
        preparingOrders: preparingOrders,
        readyOrders: readyOrders,
        activeVisitors: 0, // TODO: 실제 구현 시 analytics에서 가져오기
        lastUpdated: DateTime.now(),
      );
    });
  }

  /// 기간별 매출 리포트 조회
  Future<RevenueReport> getRevenueReport(
    String truckId,
    DateTimeRange dateRange,
  ) async {
    try {
      AppLogger.debug('Getting revenue report for truck $truckId', tag: 'RevenueRepository');

      // 주문 데이터 조회
      final ordersSnapshot = await _firestore
          .collection('orders')
          .where('truckId', isEqualTo: truckId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(
            dateRange.end.add(const Duration(days: 1)),
          ))
          .get();

      AppLogger.debug('Found ${ordersSnapshot.docs.length} orders', tag: 'RevenueRepository');

      // 일별로 집계
      final dailyMap = <String, DailyRevenue>{};
      final menuCounts = <String, int>{};
      int totalRevenue = 0;
      int totalOrders = 0;
      int completedOrders = 0;
      int cancelledOrders = 0;

      for (final doc in ordersSnapshot.docs) {
        final data = doc.data();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt == null) continue;

        final dateKey = _getDateKey(createdAt);
        final status = data['status'] as String? ?? 'pending';
        final amount = (data['totalAmount'] as num?)?.toInt() ?? 0;

        totalOrders++;

        if (status == 'completed') {
          completedOrders++;
          totalRevenue += amount;
        } else if (status == 'cancelled') {
          cancelledOrders++;
        }

        // 일별 집계
        if (!dailyMap.containsKey(dateKey)) {
          dailyMap[dateKey] = DailyRevenue(
            date: DateTime.parse(dateKey),
            orderCount: 0,
            totalRevenue: 0,
            completedOrders: 0,
            cancelledOrders: 0,
          );
        }

        final existing = dailyMap[dateKey]!;
        dailyMap[dateKey] = DailyRevenue(
          date: existing.date,
          orderCount: existing.orderCount + 1,
          totalRevenue: status == 'completed' ? existing.totalRevenue + amount : existing.totalRevenue,
          completedOrders: status == 'completed' ? existing.completedOrders + 1 : existing.completedOrders,
          cancelledOrders: status == 'cancelled' ? existing.cancelledOrders + 1 : existing.cancelledOrders,
        );

        // 메뉴별 집계
        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final menuName = item['menuItemName'] as String? ?? 'Unknown';
          final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
          menuCounts[menuName] = (menuCounts[menuName] ?? 0) + quantity;
        }
      }

      // 날짜순 정렬
      final dailyData = dailyMap.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      // TOP 5 메뉴
      final sortedMenus = menuCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topMenuItems = Map.fromEntries(sortedMenus.take(5));

      return RevenueReport(
        dateRange: dateRange,
        dailyData: dailyData,
        totalRevenue: totalRevenue,
        totalOrders: totalOrders,
        completedOrders: completedOrders,
        cancelledOrders: cancelledOrders,
        avgOrderValue: totalOrders > 0 ? totalRevenue / completedOrders : 0,
        topMenuItems: topMenuItems,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting revenue report', error: e, stackTrace: stackTrace, tag: 'RevenueRepository');
      return RevenueReport(
        dateRange: dateRange,
        dailyData: [],
        totalRevenue: 0,
        totalOrders: 0,
        completedOrders: 0,
        cancelledOrders: 0,
        avgOrderValue: 0,
        topMenuItems: {},
      );
    }
  }

  /// 주간 매출 요약
  Future<Map<String, dynamic>> getWeeklySummary(String truckId) async {
    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    final thisWeek = await getRevenueReport(
      truckId,
      DateTimeRange(start: thisWeekStart, end: now),
    );

    final lastWeek = await getRevenueReport(
      truckId,
      DateTimeRange(
        start: lastWeekStart,
        end: thisWeekStart.subtract(const Duration(days: 1)),
      ),
    );

    double growthRate = 0;
    if (lastWeek.totalRevenue > 0) {
      growthRate = ((thisWeek.totalRevenue - lastWeek.totalRevenue) / lastWeek.totalRevenue * 100);
    } else if (thisWeek.totalRevenue > 0) {
      growthRate = 100;
    }

    return {
      'thisWeekRevenue': thisWeek.totalRevenue,
      'lastWeekRevenue': lastWeek.totalRevenue,
      'growthRate': growthRate,
      'thisWeekOrders': thisWeek.totalOrders,
      'avgOrderValue': thisWeek.avgOrderValue,
    };
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

@riverpod
RevenueRepository revenueRepository(Ref ref) {
  return RevenueRepository();
}

/// 실시간 대시보드 Provider
@riverpod
Stream<RealTimeDashboard> realTimeDashboard(Ref ref, String truckId) {
  final repository = ref.watch(revenueRepositoryProvider);
  return repository.watchRealTimeDashboard(truckId);
}

/// 매출 리포트 Provider
@riverpod
Future<RevenueReport> revenueReport(
  Ref ref,
  String truckId,
  DateTimeRange dateRange,
) {
  final repository = ref.watch(revenueRepositoryProvider);
  return repository.getRevenueReport(truckId, dateRange);
}

/// 주간 요약 Provider
@riverpod
Future<Map<String, dynamic>> weeklySummary(Ref ref, String truckId) {
  final repository = ref.watch(revenueRepositoryProvider);
  return repository.getWeeklySummary(truckId);
}

/// 리포트 기간 상태 Provider
@riverpod
class ReportDateRange extends _$ReportDateRange {
  @override
  DateTimeRange build() {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }

  void setRange(DateTimeRange range) => state = range;

  void setToday() {
    final now = DateTime.now();
    state = DateTimeRange(start: now, end: now);
  }

  void setThisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    state = DateTimeRange(start: start, end: now);
  }

  void setThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    state = DateTimeRange(start: start, end: now);
  }

  void setLast30Days() {
    final now = DateTime.now();
    state = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }
}
