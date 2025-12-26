/// DateTime 확장 메서드
///
/// 날짜 관련 유틸리티 기능을 제공합니다.
extension DateTimeExtensions on DateTime {
  /// Firestore용 날짜 키 생성 (YYYY-MM-DD 형식)
  ///
  /// Firestore 문서 ID나 필드 값으로 사용하기 적합한 형식입니다.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 12, 26);
  /// print(date.toDateKey()); // "2025-12-26"
  /// ```
  String toDateKey() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// 시간 제거 (날짜만 반환)
  ///
  /// 시간, 분, 초를 0으로 설정하여 날짜만 비교할 수 있게 합니다.
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now();
  /// final dateOnly = now.dateOnly;
  /// print(dateOnly); // 2025-12-26 00:00:00.000
  /// ```
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  /// 하루의 시작 시간 (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// 하루의 끝 시간 (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// 같은 날짜인지 확인
  ///
  /// 시간을 무시하고 날짜만 비교합니다.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// 오늘인지 확인
  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  /// 어제인지 확인
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// 내일인지 확인
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  /// 한국어 요일 반환
  ///
  /// Example:
  /// ```dart
  /// final monday = DateTime(2025, 12, 29); // Monday
  /// print(monday.koreanWeekday); // "월요일"
  /// ```
  String get koreanWeekday {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[weekday - 1];
  }

  /// 짧은 한국어 요일 반환 (요일 제외)
  ///
  /// Example:
  /// ```dart
  /// final monday = DateTime(2025, 12, 29);
  /// print(monday.koreanWeekdayShort); // "월"
  /// ```
  String get koreanWeekdayShort {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }
}
