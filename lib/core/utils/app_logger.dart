import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// 앱 전역 로깅 유틸리티
///
/// Debug 모드에서만 로그를 출력하며, Release 모드에서는
/// 성능 영향을 최소화합니다.
/// Production에서는 에러를 Firebase Crashlytics로 전송합니다.
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
  /// Production에서는 Crashlytics에 로그로 기록됩니다.
  static void warning(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';

    if (kDebugMode) {
      debugPrint('⚠️ $prefix$message');
    } else if (!kIsWeb) {
      // Production: Log to Crashlytics
      FirebaseCrashlytics.instance.log('WARNING: $prefix$message');
    }
  }

  /// 에러 로그
  ///
  /// Debug 모드에서는 콘솔에 출력하고,
  /// Production에서는 Firebase Crashlytics로 전송합니다.
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
    bool fatal = false,
  }) {
    final prefix = tag != null ? '[$tag] ' : '';

    if (kDebugMode) {
      debugPrint('❌ $prefix$message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }

    // Production: Send to Firebase Crashlytics (not available on web)
    if (!kDebugMode && !kIsWeb) {
      FirebaseCrashlytics.instance.recordError(
        error ?? Exception(message),
        stackTrace,
        reason: '$prefix$message',
        fatal: fatal,
      );
    }
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

  /// Crashlytics에 사용자 정보 설정
  ///
  /// 사용자 식별을 위해 로그인 시 호출합니다.
  static Future<void> setUserId(String userId) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
  }

  /// Crashlytics에 커스텀 키-값 설정
  static Future<void> setCustomKey(String key, dynamic value) async {
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
    }
  }
}
