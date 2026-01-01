import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// 앱 전역 로깅 유틸리티
///
/// Debug 모드에서만 로그를 출력하며, Release 모드에서는
/// 성능 영향을 최소화합니다.
/// Production에서는 에러를 Firebase Crashlytics + Sentry로 전송합니다.
/// - 모바일: Crashlytics + Sentry
/// - 웹: Sentry only (Crashlytics 미지원)
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
  /// Debug/Profile 모드에서 출력됩니다.
  static void debug(String message, {String? tag}) {
    if (kDebugMode || kProfileMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      // ignore: avoid_print
      print('🔍 $prefix$message');
    }
  }

  /// 정보성 로그
  ///
  /// Debug/Profile 모드에서 출력됩니다.
  static void info(String message, {String? tag}) {
    if (kDebugMode || kProfileMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      // ignore: avoid_print
      print('ℹ️ $prefix$message');
    }
  }

  /// 경고 로그
  ///
  /// Debug 모드에서만 출력됩니다.
  /// Production에서는 Crashlytics + Sentry에 로그로 기록됩니다.
  static void warning(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';

    if (kDebugMode) {
      debugPrint('⚠️ $prefix$message');
    } else {
      // Production: Log to Sentry (web + mobile)
      Sentry.addBreadcrumb(Breadcrumb(
        message: '$prefix$message',
        level: SentryLevel.warning,
        category: tag ?? 'app',
      ));
      // Also log to Crashlytics (mobile only)
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.log('WARNING: $prefix$message');
      }
    }
  }

  /// 에러 로그
  ///
  /// Debug 모드에서는 콘솔에 출력하고,
  /// Production에서는 Firebase Crashlytics + Sentry로 전송합니다.
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

    // Production: Send to Sentry (web + mobile)
    if (!kDebugMode) {
      Sentry.captureException(
        error ?? Exception(message),
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('category', tag ?? 'app');
          scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
        },
      );
    }

    // Production: Also send to Firebase Crashlytics (mobile only)
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

  /// Crashlytics + Sentry에 사용자 정보 설정
  ///
  /// 사용자 식별을 위해 로그인 시 호출합니다.
  static Future<void> setUserId(String userId, {String? email}) async {
    // Sentry (web + mobile)
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: userId, email: email));
    });

    // Crashlytics (mobile only)
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
  }

  /// Crashlytics + Sentry에 커스텀 키-값 설정
  static Future<void> setCustomKey(String key, dynamic value) async {
    // Sentry (web + mobile)
    Sentry.configureScope((scope) {
      scope.setTag(key, value.toString());
    });

    // Crashlytics (mobile only)
    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
    }
  }
}
