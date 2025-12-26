/// Base exception class for app-wide error handling
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message ${code != null ? '(code: $code)' : ''}';
}

/// Network-related errors
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noInternet() {
    return const NetworkException(
      message: '인터넷 연결을 확인해주세요',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: '요청 시간이 초과되었습니다',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError([String? details]) {
    return NetworkException(
      message: details ?? '서버 오류가 발생했습니다',
      code: 'SERVER_ERROR',
    );
  }
}

/// Firestore errors
class FirestoreException extends AppException {
  const FirestoreException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory FirestoreException.permissionDenied() {
    return const FirestoreException(
      message: '데이터 접근 권한이 없습니다',
      code: 'PERMISSION_DENIED',
    );
  }

  factory FirestoreException.notFound() {
    return const FirestoreException(
      message: '데이터를 찾을 수 없습니다',
      code: 'NOT_FOUND',
    );
  }

  factory FirestoreException.fromFirebase(dynamic error) {
    return FirestoreException(
      message: '데이터베이스 오류가 발생했습니다',
      code: 'FIRESTORE_ERROR',
      originalError: error,
    );
  }
}

/// Authentication errors
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.userNotFound() {
    return const AuthException(
      message: '사용자를 찾을 수 없습니다',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.wrongPassword() {
    return const AuthException(
      message: '비밀번호가 올바르지 않습니다',
      code: 'WRONG_PASSWORD',
    );
  }

  factory AuthException.emailInUse() {
    return const AuthException(
      message: '이미 사용 중인 이메일입니다',
      code: 'EMAIL_IN_USE',
    );
  }

  factory AuthException.weakPassword() {
    return const AuthException(
      message: '비밀번호가 너무 약합니다 (최소 6자)',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthException.notLoggedIn() {
    return const AuthException(
      message: '로그인이 필요합니다',
      code: 'NOT_LOGGED_IN',
    );
  }
}

/// Validation errors
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.invalidInput(String field) {
    return ValidationException(
      message: '$field이(가) 올바르지 않습니다',
      code: 'INVALID_INPUT',
    );
  }

  factory ValidationException.requiredField(String field) {
    return ValidationException(
      message: '$field은(는) 필수 항목입니다',
      code: 'REQUIRED_FIELD',
    );
  }
}

/// Location errors
class LocationException extends AppException {
  const LocationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory LocationException.permissionDenied() {
    return const LocationException(
      message: '위치 권한이 필요합니다',
      code: 'PERMISSION_DENIED',
    );
  }

  factory LocationException.serviceDisabled() {
    return const LocationException(
      message: 'GPS를 활성화해주세요',
      code: 'SERVICE_DISABLED',
    );
  }
}
