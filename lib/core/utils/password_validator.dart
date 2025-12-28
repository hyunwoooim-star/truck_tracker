/// Password validation utility for enhanced security
///
/// Provides validation logic for both login and sign-up modes:
/// - Login: Minimum 6 characters (backwards compatibility)
/// - Sign-up: Strong password requirements (8+ chars, uppercase, lowercase, digits, special chars)
class PasswordValidator {
  static const int minLengthSignUp = 8;
  static const int minLengthLogin = 6;

  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp _digitRegex = RegExp(r'\d');
  static final RegExp _specialCharRegex = RegExp(r'[@$!%*?&]');

  /// Validates password based on mode
  ///
  /// [password] - The password string to validate
  /// [isSignUp] - If true, applies strong validation; if false, basic validation
  ///
  /// Returns null if valid, otherwise returns error message
  static String? validate(String password, {bool isSignUp = false}) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    // Login mode: only check minimum length for backwards compatibility
    if (!isSignUp) {
      if (password.length < minLengthLogin) {
        return '비밀번호는 최소 $minLengthLogin자 이상이어야 합니다';
      }
      return null;
    }

    // Sign-up mode: enforce strong password requirements
    if (password.length < minLengthSignUp) {
      return '비밀번호는 최소 $minLengthSignUp자 이상이어야 합니다';
    }

    if (!_uppercaseRegex.hasMatch(password)) {
      return '비밀번호에 대문자가 포함되어야 합니다';
    }

    if (!_lowercaseRegex.hasMatch(password)) {
      return '비밀번호에 소문자가 포함되어야 합니다';
    }

    if (!_digitRegex.hasMatch(password)) {
      return '비밀번호에 숫자가 포함되어야 합니다';
    }

    if (!_specialCharRegex.hasMatch(password)) {
      return '비밀번호에 특수문자 (@\$!%*?&)가 포함되어야 합니다';
    }

    return null;
  }

  /// Evaluates password strength on a scale of 0-5
  ///
  /// Returns:
  /// - 0: Empty or very weak
  /// - 1-2: Weak (missing multiple criteria)
  /// - 3: Medium (missing 1-2 criteria)
  /// - 4: Strong (meets most criteria)
  /// - 5: Very strong (meets all criteria)
  static int getStrength(String password) {
    int strength = 0;

    if (password.length >= minLengthSignUp) strength++;
    if (_uppercaseRegex.hasMatch(password)) strength++;
    if (_lowercaseRegex.hasMatch(password)) strength++;
    if (_digitRegex.hasMatch(password)) strength++;
    if (_specialCharRegex.hasMatch(password)) strength++;

    return strength;
  }

  /// Gets human-readable strength label
  static String getStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return '매우 약함';
      case 2:
        return '약함';
      case 3:
        return '보통';
      case 4:
        return '강함';
      case 5:
        return '매우 강함';
      default:
        return '알 수 없음';
    }
  }
}
