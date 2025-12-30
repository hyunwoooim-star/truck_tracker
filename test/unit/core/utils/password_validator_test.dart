import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/utils/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    group('constants', () {
      test('minLengthSignUp should be 8', () {
        expect(PasswordValidator.minLengthSignUp, 8);
      });

      test('minLengthLogin should be 6', () {
        expect(PasswordValidator.minLengthLogin, 6);
      });
    });

    group('validate - login mode', () {
      test('should return error for empty password', () {
        final result = PasswordValidator.validate('', isSignUp: false);
        expect(result, isNotNull);
      });

      test('should return error for password less than 6 characters', () {
        final result = PasswordValidator.validate('12345', isSignUp: false);
        expect(result, isNotNull);
      });

      test('should return null for password with exactly 6 characters', () {
        final result = PasswordValidator.validate('123456', isSignUp: false);
        expect(result, isNull);
      });

      test('should return null for password with more than 6 characters', () {
        final result = PasswordValidator.validate('password', isSignUp: false);
        expect(result, isNull);
      });

      test('should not require uppercase for login', () {
        final result = PasswordValidator.validate('simplepassword', isSignUp: false);
        expect(result, isNull);
      });
    });

    group('validate - sign up mode', () {
      test('should return error for empty password', () {
        final result = PasswordValidator.validate('', isSignUp: true);
        expect(result, isNotNull);
      });

      test('should return error for password less than 8 characters', () {
        final result = PasswordValidator.validate('Abc123!', isSignUp: true);
        expect(result, isNotNull);
      });

      test('should return error for password without uppercase', () {
        final result = PasswordValidator.validate('abcdefgh1!', isSignUp: true);
        expect(result, isNotNull);
      });

      test('should return error for password without lowercase', () {
        final result = PasswordValidator.validate('ABCDEFGH1!', isSignUp: true);
        expect(result, isNotNull);
      });

      test('should return error for password without digit', () {
        final result = PasswordValidator.validate('Abcdefgh!', isSignUp: true);
        expect(result, isNotNull);
      });

      test('should return error for password without special character', () {
        final result = PasswordValidator.validate('Abcdefgh1', isSignUp: true);
        expect(result, isNotNull);
      });

      test('should return null for valid strong password', () {
        final result = PasswordValidator.validate('Abcdefg1!', isSignUp: true);
        expect(result, isNull);
      });
    });

    group('getStrength', () {
      test('should return 0 for empty password', () {
        expect(PasswordValidator.getStrength(''), 0);
      });

      test('should return 1 for password with only length requirement', () {
        expect(PasswordValidator.getStrength('12345678'), 1);
      });

      test('should return 2 for password with length and lowercase', () {
        expect(PasswordValidator.getStrength('abcdefgh'), 2);
      });

      test('should return 3 for password with length, lowercase, uppercase', () {
        expect(PasswordValidator.getStrength('Abcdefgh'), 3);
      });

      test('should return 4 for password with length, lowercase, uppercase, digit', () {
        expect(PasswordValidator.getStrength('Abcdefg1'), 4);
      });

      test('should return 5 for password meeting all criteria', () {
        expect(PasswordValidator.getStrength('Abcdefg1!'), 5);
      });
    });

    group('getStrengthLabel', () {
      test('should return correct label for strength 0', () {
        expect(PasswordValidator.getStrengthLabel(0), contains('약'));
      });

      test('should return correct label for strength 2', () {
        expect(PasswordValidator.getStrengthLabel(2), contains('약'));
      });

      test('should return correct label for strength 3', () {
        expect(PasswordValidator.getStrengthLabel(3), contains('보통'));
      });

      test('should return correct label for strength 4', () {
        expect(PasswordValidator.getStrengthLabel(4), contains('강'));
      });

      test('should return correct label for strength 5', () {
        expect(PasswordValidator.getStrengthLabel(5), contains('강'));
      });
    });
  });
}
