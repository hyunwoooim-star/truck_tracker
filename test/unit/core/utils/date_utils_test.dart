import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/utils/date_utils.dart';

void main() {
  group('DateTimeExtensions', () {
    group('toDateKey', () {
      test('should format date correctly', () {
        final date = DateTime(2025, 12, 31);
        expect(date.toDateKey(), '2025-12-31');
      });

      test('should pad single digit month', () {
        final date = DateTime(2025, 1, 15);
        expect(date.toDateKey(), '2025-01-15');
      });

      test('should pad single digit day', () {
        final date = DateTime(2025, 12, 5);
        expect(date.toDateKey(), '2025-12-05');
      });

      test('should handle beginning of year', () {
        final date = DateTime(2025, 1, 1);
        expect(date.toDateKey(), '2025-01-01');
      });
    });

    group('dateOnly', () {
      test('should remove time component', () {
        final dateTime = DateTime(2025, 12, 31, 18, 30, 45);
        final dateOnly = dateTime.dateOnly;

        expect(dateOnly.year, 2025);
        expect(dateOnly.month, 12);
        expect(dateOnly.day, 31);
        expect(dateOnly.hour, 0);
        expect(dateOnly.minute, 0);
        expect(dateOnly.second, 0);
      });
    });

    group('startOfDay', () {
      test('should return start of day', () {
        final dateTime = DateTime(2025, 12, 31, 18, 30, 45);
        final start = dateTime.startOfDay;

        expect(start.hour, 0);
        expect(start.minute, 0);
        expect(start.second, 0);
      });
    });

    group('endOfDay', () {
      test('should return end of day', () {
        final dateTime = DateTime(2025, 12, 31, 10, 0, 0);
        final end = dateTime.endOfDay;

        expect(end.hour, 23);
        expect(end.minute, 59);
        expect(end.second, 59);
        expect(end.millisecond, 999);
      });
    });

    group('isSameDay', () {
      test('should return true for same date different time', () {
        final date1 = DateTime(2025, 12, 31, 10, 0);
        final date2 = DateTime(2025, 12, 31, 18, 30);

        expect(date1.isSameDay(date2), isTrue);
      });

      test('should return false for different dates', () {
        final date1 = DateTime(2025, 12, 31);
        final date2 = DateTime(2025, 12, 30);

        expect(date1.isSameDay(date2), isFalse);
      });

      test('should return false for different months', () {
        final date1 = DateTime(2025, 12, 15);
        final date2 = DateTime(2025, 11, 15);

        expect(date1.isSameDay(date2), isFalse);
      });

      test('should return false for different years', () {
        final date1 = DateTime(2025, 12, 31);
        final date2 = DateTime(2024, 12, 31);

        expect(date1.isSameDay(date2), isFalse);
      });
    });

    group('isToday', () {
      test('should return true for today', () {
        final today = DateTime.now();
        expect(today.isToday, isTrue);
      });

      test('should return false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isToday, isFalse);
      });

      test('should return false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isToday, isFalse);
      });
    });

    group('isYesterday', () {
      test('should return true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, isTrue);
      });

      test('should return false for today', () {
        final today = DateTime.now();
        expect(today.isYesterday, isFalse);
      });
    });

    group('isTomorrow', () {
      test('should return true for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isTomorrow, isTrue);
      });

      test('should return false for today', () {
        final today = DateTime.now();
        expect(today.isTomorrow, isFalse);
      });
    });

    group('koreanWeekday', () {
      test('should return correct Korean weekday for Monday', () {
        final monday = DateTime(2025, 12, 29); // Monday
        expect(monday.koreanWeekday, contains('월'));
      });

      test('should return correct Korean weekday for Sunday', () {
        final sunday = DateTime(2025, 12, 28); // Sunday
        expect(sunday.koreanWeekday, contains('일'));
      });

      test('should return correct Korean weekday for Wednesday', () {
        final wednesday = DateTime(2025, 12, 31); // Wednesday
        expect(wednesday.koreanWeekday, contains('수'));
      });
    });

    group('koreanWeekdayShort', () {
      test('should return short Korean weekday for Monday', () {
        final monday = DateTime(2025, 12, 29);
        expect(monday.koreanWeekdayShort, '월');
      });

      test('should return short Korean weekday for Sunday', () {
        final sunday = DateTime(2025, 12, 28);
        expect(sunday.koreanWeekdayShort, '일');
      });

      test('should return short Korean weekday for Friday', () {
        final friday = DateTime(2025, 12, 26);
        expect(friday.koreanWeekdayShort, '금');
      });
    });
  });
}
