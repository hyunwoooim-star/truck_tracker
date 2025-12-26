import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_repository.g.dart';

/// Analytics data model
class TruckAnalytics {
  final int clickCount;
  final int reviewCount;
  final int favoriteCount;
  final DateTime date;

  TruckAnalytics({
    required this.clickCount,
    required this.reviewCount,
    required this.favoriteCount,
    required this.date,
  });

  factory TruckAnalytics.fromFirestore(Map<String, dynamic> data) {
    return TruckAnalytics(
      clickCount: data['clickCount'] ?? 0,
      reviewCount: data['reviewCount'] ?? 0,
      favoriteCount: data['favoriteCount'] ?? 0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'clickCount': clickCount,
      'reviewCount': reviewCount,
      'favoriteCount': favoriteCount,
      'date': Timestamp.fromDate(date),
    };
  }
}

/// Daily analytics item for date range reports
class DailyAnalyticsItem {
  final DateTime date;
  final int clickCount;
  final int reviewCount;
  final int favoriteCount;

  DailyAnalyticsItem({
    required this.date,
    required this.clickCount,
    required this.reviewCount,
    required this.favoriteCount,
  });
}

/// Analytics data for a date range
class TruckAnalyticsRange {
  final DateTimeRange dateRange;
  final List<DailyAnalyticsItem> dailyData;

  TruckAnalyticsRange({
    required this.dateRange,
    required this.dailyData,
  });

  /// Total clicks across all days
  int get totalClicks =>
      dailyData.fold(0, (sum, item) => sum + item.clickCount);

  /// Total reviews across all days
  int get totalReviews =>
      dailyData.fold(0, (sum, item) => sum + item.reviewCount);

  /// Total favorites across all days
  int get totalFavorites =>
      dailyData.fold(0, (sum, item) => sum + item.favoriteCount);

  /// Average daily clicks
  double get avgDaily =>
      dailyData.isEmpty ? 0 : totalClicks / dailyData.length;

  /// Number of days in the range
  int get dayCount => dailyData.length;
}

/// Repository for truck analytics
class AnalyticsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Track truck click/view
  Future<void> trackTruckClick(String truckId) async {
    try {
      final today = DateTime.now();
      final dateKey = _getDateKey(today);
      
      await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('analytics')
          .doc(dateKey)
          .set({
        'clickCount': FieldValue.increment(1),
        'date': Timestamp.fromDate(today),
      }, SetOptions(merge: true));

      debugPrint('📊 Tracked click for truck $truckId');
    } catch (e) {
      debugPrint('❌ Error tracking click: $e');
    }
  }

  /// Get today's analytics for a truck
  Future<TruckAnalytics> getTodayAnalytics(String truckId) async {
    try {
      final today = DateTime.now();
      final dateKey = _getDateKey(today);
      
      final doc = await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('analytics')
          .doc(dateKey)
          .get();

      if (!doc.exists) {
        return TruckAnalytics(
          clickCount: 0,
          reviewCount: 0,
          favoriteCount: 0,
          date: today,
        );
      }

      final data = doc.data() ?? {};
      
      // Get review count
      final reviewCount = await _getReviewCount(truckId);
      
      // Get favorite count
      final favoriteCount = await _getFavoriteCount(truckId);

      return TruckAnalytics(
        clickCount: data['clickCount'] ?? 0,
        reviewCount: reviewCount,
        favoriteCount: favoriteCount,
        date: (data['date'] as Timestamp?)?.toDate() ?? today,
      );
    } catch (e) {
      debugPrint('❌ Error getting analytics: $e');
      return TruckAnalytics(
        clickCount: 0,
        reviewCount: 0,
        favoriteCount: 0,
        date: DateTime.now(),
      );
    }
  }

  /// Get review count for a truck
  Future<int> _getReviewCount(String truckId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('truckId', isEqualTo: truckId)
          .count()
          .get();
      
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get favorite count for a truck
  Future<int> _getFavoriteCount(String truckId) async {
    try {
      final snapshot = await _firestore
          .collection('favorites')
          .where('truckId', isEqualTo: truckId)
          .count()
          .get();
      
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get analytics for a date range
  Future<TruckAnalyticsRange> getAnalyticsRange(
    String truckId,
    DateTimeRange dateRange,
  ) async {
    try {
      debugPrint('📊 Getting analytics range for truck $truckId');
      debugPrint('   From: ${_getDateKey(dateRange.start)}');
      debugPrint('   To: ${_getDateKey(dateRange.end)}');

      final dailyData = <DailyAnalyticsItem>[];

      // Query Firestore for analytics in the date range
      final snapshot = await _firestore
          .collection('trucks')
          .doc(truckId)
          .collection('analytics')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end))
          .orderBy('date', descending: false)
          .get();

      debugPrint('📊 Found ${snapshot.docs.length} analytics documents');

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

        // Get review count for this specific date
        final reviewCount = await _getReviewCountForDate(truckId, date);

        dailyData.add(DailyAnalyticsItem(
          date: date,
          clickCount: data['clickCount'] ?? 0,
          reviewCount: reviewCount,
          favoriteCount: data['favoriteCount'] ?? 0,
        ));
      }

      debugPrint('✅ Analytics range retrieved successfully');
      return TruckAnalyticsRange(
        dateRange: dateRange,
        dailyData: dailyData,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error getting analytics range: $e');
      debugPrint('Stack trace: $stackTrace');
      return TruckAnalyticsRange(
        dateRange: dateRange,
        dailyData: [],
      );
    }
  }

  /// Get review count for a specific date
  Future<int> _getReviewCountForDate(String truckId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('reviews')
          .where('truckId', isEqualTo: truckId)
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting review count for date: $e');
      return 0;
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

@riverpod
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) {
  return AnalyticsRepository();
}

/// Provider for today's analytics
@riverpod
Future<TruckAnalytics> todayAnalytics(
  TodayAnalyticsRef ref,
  String truckId,
) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getTodayAnalytics(truckId);
}

/// Date range state notifier
@riverpod
class AnalyticsDateRangeNotifier extends AutoDisposeNotifier<DateTimeRange> {
  @override
  DateTimeRange build() {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 7)), // Default: Last 7 days
      end: now,
    );
  }

  void setDateRange(DateTimeRange range) {
    state = range;
  }

  void resetToDefault() {
    final now = DateTime.now();
    state = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }
}

/// Provider for analytics range
@riverpod
Future<TruckAnalyticsRange> analyticsRange(
  AnalyticsRangeRef ref,
  String truckId,
  DateTimeRange dateRange,
) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getAnalyticsRange(truckId, dateRange);
}
