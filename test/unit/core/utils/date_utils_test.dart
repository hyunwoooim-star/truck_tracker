import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/utils/date_utils.dart';

/// Unit tests for DateTimeExtensions
///
/// Tests the utility methods added to DateTime via extension.
void main() {
  group('DateTimeExtensions', () {
    group('toDateKey()', () {
      test('formats date correctly as YYYY-MM-DD', () {
        final date = DateTime(2025, 12, 27);
        expect(date.toDateKey(), '2025-12-27');
      });

      test('pads single-digit month with zero', () {
        final date = DateTime(2025, 1, 15);
        expect(date.toDateKey(), '2025-01-15');
      });

      test('pads single-digit day with zero', () {
        final date = DateTime(2025, 12, 5);
        expect(date.toDateKey(), '2025-12-05');
      });

      test('handles new year date', () {
        final date = DateTime(2026, 1, 1);
        expect(date.toDateKey(), '2026-01-01');
      });
    });

    group('dateOnly', () {
      test('removes time component from datetime', () {
        final dateTime = DateTime(2025, 12, 27, 14, 30, 45, 123);
        final dateOnly = dateTime.dateOnly;

        expect(dateOnly.year, 2025);
        expect(dateOnly.month, 12);
        expect(dateOnly.day, 27);
        expect(dateOnly.hour, 0);
        expect(dateOnly.minute, 0);
        expect(dateOnly.second, 0);
        expect(dateOnly.millisecond, 0);
      });

      test('returns same date for already date-only datetime', () {
        final date = DateTime(2025, 12, 27);
        final dateOnly = date.dateOnly;

        expect(dateOnly, DateTime(2025, 12, 27));
      });
    });

    group('startOfDay / endOfDay', () {
      test('startOfDay returns midnight', () {
        final dateTime = DateTime(2025, 12, 27, 14, 30, 45);
        final start = dateTime.startOfDay;

        expect(start, DateTime(2025, 12, 27, 0, 0, 0));
      });

      test('endOfDay returns 23:59:59.999', () {
        final dateTime = DateTime(2025, 12, 27, 14, 30, 45);
        final end = dateTime.endOfDay;

        expect(end, DateTime(2025, 12, 27, 23, 59, 59, 999));
      });

      test('startOfDay and endOfDay span entire day', () {
        final date = DateTime(2025, 12, 27);
        final start = date.startOfDay;
        final end = date.endOfDay;

        expect(end.difference(start).inHours, 23);
        expect(end.difference(start).inMinutes, greaterThan(1439));
      });
    });

    group('isSameDay()', () {
      test('returns true for same date different times', () {
        final date1 = DateTime(2025, 12, 27, 9, 0);
        final date2 = DateTime(2025, 12, 27, 18, 30);

        expect(date1.isSameDay(date2), true);
      });

      test('returns false for different dates', () {
        final date1 = DateTime(2025, 12, 27);
        final date2 = DateTime(2025, 12, 28);

        expect(date1.isSameDay(date2), false);
      });

      test('returns false for same day different months', () {
        final date1 = DateTime(2025, 11, 27);
        final date2 = DateTime(2025, 12, 27);

        expect(date1.isSameDay(date2), false);
      });

      test('returns false for same day different years', () {
        final date1 = DateTime(2024, 12, 27);
        final date2 = DateTime(2025, 12, 27);

        expect(date1.isSameDay(date2), false);
      });
    });

    group('isToday / isYesterday / isTomorrow', () {
      test('isToday returns true for current date', () {
        final now = DateTime.now();
        expect(now.isToday, true);
      });

      test('isToday returns false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isToday, false);
      });

      test('isYesterday returns true for previous day', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, true);
      });

      test('isYesterday returns false for today', () {
        final today = DateTime.now();
        expect(today.isYesterday, false);
      });

      test('isTomorrow returns true for next day', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isTomorrow, true);
      });

      test('isTomorrow returns false for today', () {
        final today = DateTime.now();
        expect(today.isTomorrow, false);
      });
    });

    group('koreanWeekday', () {
      test('returns correct Korean weekday for Monday', () {
        final monday = DateTime(2025, 12, 29); // Known Monday
        expect(monday.koreanWeekday, '월요일');
      });

      test('returns correct Korean weekday for Sunday', () {
        final sunday = DateTime(2025, 12, 28); // Known Sunday
        expect(sunday.koreanWeekday, '일요일');
      });

      test('returns correct Korean weekday for Friday', () {
        final friday = DateTime(2025, 12, 26); // Known Friday
        expect(friday.koreanWeekday, '금요일');
      });
    });

    group('koreanWeekdayShort', () {
      test('returns short form for Monday', () {
        final monday = DateTime(2025, 12, 29);
        expect(monday.koreanWeekdayShort, '월');
      });

      test('returns short form for Sunday', () {
        final sunday = DateTime(2025, 12, 28);
        expect(sunday.koreanWeekdayShort, '일');
      });

      test('returns short form for Wednesday', () {
        final wednesday = DateTime(2025, 12, 31);
        expect(wednesday.koreanWeekdayShort, '수');
      });
    });
  });
}
