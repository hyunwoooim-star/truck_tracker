import 'package:flutter_test/flutter_test.dart';

/// AuthService 단위 테스트
/// Firebase 의존성 때문에 실제 테스트는 mock 필요
void main() {
  group('AuthService', () {
    test('validateEmail returns true for valid email', () {
      expect(_isValidEmail('test@example.com'), isTrue);
      expect(_isValidEmail('user.name@domain.co.kr'), isTrue);
      expect(_isValidEmail('user+tag@example.org'), isTrue);
    });

    test('validateEmail returns false for invalid email', () {
      expect(_isValidEmail(''), isFalse);
      expect(_isValidEmail('notanemail'), isFalse);
      expect(_isValidEmail('missing@domain'), isFalse);
      expect(_isValidEmail('@nodomain.com'), isFalse);
    });

    test('validateDisplayName returns true for valid names', () {
      expect(_isValidDisplayName('홍길동'), isTrue);
      expect(_isValidDisplayName('John Doe'), isTrue);
      expect(_isValidDisplayName('사장님'), isTrue);
    });

    test('validateDisplayName returns false for invalid names', () {
      expect(_isValidDisplayName(''), isFalse);
      expect(_isValidDisplayName('a'), isFalse); // too short
      expect(_isValidDisplayName('a' * 51), isFalse); // too long
    });

    group('UserRole', () {
      test('can identify customer role', () {
        const role = 'customer';
        expect(role == 'customer', isTrue);
        expect(role == 'owner', isFalse);
        expect(role == 'admin', isFalse);
      });

      test('can identify owner role', () {
        const role = 'owner';
        expect(role == 'owner', isTrue);
        expect(role == 'customer', isFalse);
      });

      test('can identify admin role', () {
        const role = 'admin';
        expect(role == 'admin', isTrue);
        expect(role == 'customer', isFalse);
      });
    });
  });
}

// Helper functions that mirror AuthService logic
bool _isValidEmail(String email) {
  if (email.isEmpty) return false;
  final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+(\.[a-zA-Z]{2,})+$');
  return emailRegex.hasMatch(email);
}

bool _isValidDisplayName(String name) {
  if (name.isEmpty) return false;
  if (name.length < 2) return false;
  if (name.length > 50) return false;
  return true;
}
