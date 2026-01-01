import 'package:flutter/material.dart';

/// 공통 에러 상태 위젯
///
/// 에러 발생 시 표시되는 통일된 UI를 제공합니다.
/// 재시도 기능을 포함할 수 있습니다.
///
/// Example:
/// ```dart
/// ErrorStateWidget(
///   error: error,
///   onRetry: () => ref.invalidate(someProvider),
/// )
/// ```
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.retryLabel = '다시 시도',
    this.showDetails = false,
  });

  /// 발생한 에러 객체
  final Object error;

  /// 재시도 버튼 클릭 시 실행할 콜백 (선택)
  final VoidCallback? onRetry;

  /// 표시할 아이콘 (기본값: error_outline)
  final IconData icon;

  /// 재시도 버튼 라벨 (기본값: '다시 시도')
  final String retryLabel;

  /// 상세 에러 메시지 표시 여부 (디버그용)
  final bool showDetails;

  String _getErrorMessage() {
    final errorString = error.toString();

    // Firebase 에러 처리
    if (errorString.contains('permission-denied')) {
      return '접근 권한이 없습니다';
    }
    if (errorString.contains('network-request-failed') ||
        errorString.contains('unavailable')) {
      return '네트워크 연결을 확인해주세요';
    }
    if (errorString.contains('not-found')) {
      return '데이터를 찾을 수 없습니다';
    }
    if (errorString.contains('unauthenticated')) {
      return '로그인이 필요합니다';
    }

    // 일반 에러
    if (errorString.contains('SocketException') ||
        errorString.contains('Connection')) {
      return '인터넷 연결을 확인해주세요';
    }
    if (errorString.contains('TimeoutException')) {
      return '요청 시간이 초과되었습니다';
    }

    return '오류가 발생했습니다';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorMessage(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (showDetails) ...[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
