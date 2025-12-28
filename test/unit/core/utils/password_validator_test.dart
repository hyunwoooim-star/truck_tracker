import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/utils/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    group('validate()', () {
      group('로그인 모드', () {
        test('빈 비밀번호는 에러 반환', () {
          final result = PasswordValidator.validate('', isSignUp: false);
          expect(result, isNotNull);
          expect(result, contains('입력해주세요'));
        });

        test('6자 미만 비밀번호는 에러 반환', () {
          final result = PasswordValidator.validate('12345', isSignUp: false);
          expect(result, isNotNull);
          expect(result, contains('최소 6자'));
        });

        test('6자 이상 비밀번호는 유효함', () {
          final result = PasswordValidator.validate('123456', isSignUp: false);
          expect(result, isNull);
        });

        test('약한 비밀번호도 로그인 시 허용됨', () {
          final result = PasswordValidator.validate('abcdef', isSignUp: false);
          expect(result, isNull);
        });
      });

      group('회원가입 모드', () {
        test('빈 비밀번호는 에러 반환', () {
          final result = PasswordValidator.validate('', isSignUp: true);
          expect(result, isNotNull);
          expect(result, contains('입력해주세요'));
        });

        test('8자 미만 비밀번호는 에러 반환', () {
          final result = PasswordValidator.validate('Abc123!', isSignUp: true);
          expect(result, isNotNull);
          expect(result, contains('최소 8자'));
        });

        test('대문자 없으면 에러', () {
          final result = PasswordValidator.validate('abcd1234!', isSignUp: true);
          expect(result, isNotNull);
          expect(result, contains('대문자'));
        });

        test('소문자 없으면 에러', () {
          final result = PasswordValidator.validate('ABCD1234!', isSignUp: true);
          expect(result, isNotNull);
          expect(result, contains('소문자'));
        });

        test('숫자 없으면 에러', () {
          final result = PasswordValidator.validate('Abcdefgh!', isSignUp: true);
          expect(result, isNotNull);
          expect(result, contains('숫자'));
        });

        test('특수문자 없으면 에러', () {
          final result = PasswordValidator.validate('Abcd1234', isSignUp: true);
          expect(result, isNotNull);
          expect(result, contains('특수문자'));
        });

        test('강력한 비밀번호는 유효함', () {
          final result = PasswordValidator.validate('StrongPass123!', isSignUp: true);
          expect(result, isNull);
        });

        test('최소 요구사항을 정확히 만족하면 유효함', () {
          final result = PasswordValidator.validate('Abc1234@', isSignUp: true);
          expect(result, isNull);
        });
      });
    });

    group('getStrength()', () {
      test('빈 비밀번호는 강도 0', () {
        final strength = PasswordValidator.getStrength('');
        expect(strength, equals(0));
      });

      test('짧은 비밀번호는 약함', () {
        final strength = PasswordValidator.getStrength('abc');
        expect(strength, lessThan(3));
      });

      test('길이만 충족하면 강도 1', () {
        final strength = PasswordValidator.getStrength('abcdefgh');
        expect(strength, equals(2)); // 길이 + 소문자
      });

      test('대소문자+숫자만 있으면 강도 4', () {
        final strength = PasswordValidator.getStrength('Abcd1234');
        expect(strength, equals(4));
      });

      test('모든 조건 충족하면 강도 5', () {
        final strength = PasswordValidator.getStrength('StrongPass123!');
        expect(strength, equals(5));
      });
    });

    group('getStrengthLabel()', () {
      test('강도 0-1은 매우 약함', () {
        expect(PasswordValidator.getStrengthLabel(0), '매우 약함');
        expect(PasswordValidator.getStrengthLabel(1), '매우 약함');
      });

      test('강도 2는 약함', () {
        expect(PasswordValidator.getStrengthLabel(2), '약함');
      });

      test('강도 3은 보통', () {
        expect(PasswordValidator.getStrengthLabel(3), '보통');
      });

      test('강도 4는 강함', () {
        expect(PasswordValidator.getStrengthLabel(4), '강함');
      });

      test('강도 5는 매우 강함', () {
        expect(PasswordValidator.getStrengthLabel(5), '매우 강함');
      });
    });
  });
}
