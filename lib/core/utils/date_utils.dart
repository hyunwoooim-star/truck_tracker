import 'package:intl/intl.dart';

/// 날짜/시간 포맷팅 유틸리티
///
/// 앱 전체에서 일관된 날짜 포맷을 위해 사용합니다.
///
/// Example:
/// ```dart
/// DateTimeFormatter.formatDate(DateTime.now());     // "2026.01.01"
/// DateTimeFormatter.formatTime(DateTime.now());     // "14:30"
/// DateTimeFormatter.formatRelative(DateTime.now()); // "방금 전"
/// ```
class DateTimeFormatter {
  const DateTimeFormatter._();

  static final _dateFormat = DateFormat('yyyy.MM.dd');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dateTimeFormat = DateFormat('yyyy.MM.dd HH:mm');
  static final _shortDateFormat = DateFormat('M/d');

  /// 날짜 포맷팅 (yyyy.MM.dd)
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// 시간 포맷팅 (HH:mm)
  static String formatTime(DateTime time) => _timeFormat.format(time);

  /// 날짜+시간 포맷팅 (yyyy.MM.dd HH:mm)
  static String formatDateTime(DateTime dateTime) =>
      _dateTimeFormat.format(dateTime);

  /// 짧은 날짜 포맷팅 (M/d)
  static String formatShortDate(DateTime date) => _shortDateFormat.format(date);

  /// 상대적 시간 표시 (몇 분 전, 몇 시간 전 등)
  ///
  /// - 1분 미만: "방금 전"
  /// - 1시간 미만: "N분 전"
  /// - 24시간 미만: "N시간 전"
  /// - 7일 미만: "N일 전"
  /// - 그 외: "M/d" 형식
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      return formatShortDate(dateTime);
    }
  }

  /// 채팅용 날짜 그룹 라벨
  ///
  /// - 오늘: "오늘"
  /// - 어제: "어제"
  /// - 올해: "M월 d일"
  /// - 그 외: "yyyy년 M월 d일"
  static String formatChatDateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return '오늘';
    } else if (dateOnly == yesterday) {
      return '어제';
    } else if (date.year == now.year) {
      return DateFormat('M월 d일').format(date);
    } else {
      return DateFormat('yyyy년 M월 d일').format(date);
    }
  }

  /// 쿠폰 유효기간 표시용
  static String formatCouponValidity(DateTime validFrom, DateTime validUntil) {
    return '${formatDate(validFrom)} ~ ${formatDate(validUntil)}';
  }
}

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
