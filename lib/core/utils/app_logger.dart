import 'package:flutter/foundation.dart';

/// 앱 전역 로깅 유틸리티
///
/// Debug 모드에서만 로그를 출력하며, Release 모드에서는
/// 성능 영향을 최소화합니다.
///
/// Usage:
/// ```dart
/// AppLogger.debug('User logged in', tag: 'Auth');
/// AppLogger.error('Failed to load data', error: e, stackTrace: stack);
/// ```
class AppLogger {
  AppLogger._(); // Private constructor to prevent instantiation

  /// 일반 디버그 로그
  ///
  /// Debug 모드에서만 출력됩니다.
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix$message');
    }
  }

  /// 정보성 로그
  ///
  /// Debug 모드에서만 출력됩니다.
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️ $prefix$message');
    }
  }

  /// 경고 로그
  ///
  /// Debug 모드에서만 출력됩니다.
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️ $prefix$message');
    }
  }

  /// 에러 로그
  ///
  /// Debug 모드에서는 콘솔에 출력하고,
  /// Production에서는 크래시 리포팅 서비스로 전송합니다.
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('❌ $prefix$message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }

    // TODO: Production에서 Firebase Crashlytics로 전송
    // if (kReleaseMode) {
    //   FirebaseCrashlytics.instance.recordError(
    //     error ?? message,
    //     stackTrace,
    //     reason: message,
    //   );
    // }
  }

  /// 성공 로그 (시각적 피드백)
  ///
  /// Debug 모드에서만 출력됩니다.
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('✅ $prefix$message');
    }
  }
}
