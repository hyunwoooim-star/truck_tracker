import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'snackbar_helper.dart';

/// Centralized error handling utility
class ErrorHandler {
  /// Handle Firebase errors with user-friendly messages
  static String getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        // Network errors
        case 'unavailable':
        case 'deadline-exceeded':
          return '네트워크 연결을 확인해주세요';

        // Permission errors
        case 'permission-denied':
          return '권한이 없습니다';

        // Not found errors
        case 'not-found':
          return '데이터를 찾을 수 없습니다';

        // Already exists
        case 'already-exists':
          return '이미 존재하는 데이터입니다';

        // Resource exhausted
        case 'resource-exhausted':
          return '요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요';

        // Cancelled
        case 'cancelled':
          return '작업이 취소되었습니다';

        // Unknown
        case 'unknown':
          return '알 수 없는 오류가 발생했습니다';

        // Unauthenticated
        case 'unauthenticated':
          return '로그인이 필요합니다';

        // Invalid argument
        case 'invalid-argument':
          return '잘못된 입력입니다';

        default:
          return '오류가 발생했습니다: ${error.message ?? error.code}';
      }
    }

    return '알 수 없는 오류가 발생했습니다';
  }

  /// Show error with retry option
  static Future<bool> showErrorWithRetry({
    required BuildContext context,
    required String message,
    String? retryButtonText,
  }) async {
    final shouldRetry = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400]),
            const SizedBox(width: 12),
            const Text('오류'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(retryButtonText ?? '다시 시도'),
          ),
        ],
      ),
    );

    return shouldRetry ?? false;
  }

  /// Handle error and show appropriate message
  static void handleError({
    required BuildContext context,
    required dynamic error,
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    if (!context.mounted) return;

    final message = customMessage ?? getFirebaseErrorMessage(error);

    if (onRetry != null) {
      // Show error with retry option
      showErrorWithRetry(
        context: context,
        message: message,
      ).then((shouldRetry) {
        if (shouldRetry && context.mounted) {
          onRetry();
        }
      });
    } else {
      // Just show error
      SnackBarHelper.showError(context, message);
    }
  }

  /// Check if error is network-related
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseException) {
      return error.code == 'unavailable' ||
             error.code == 'deadline-exceeded';
    }
    return false;
  }

  /// Check if error is permission-related
  static bool isPermissionError(dynamic error) {
    if (error is FirebaseException) {
      return error.code == 'permission-denied' ||
             error.code == 'unauthenticated';
    }
    return false;
  }
}
