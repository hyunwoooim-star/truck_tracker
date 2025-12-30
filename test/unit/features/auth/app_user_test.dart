import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/auth/domain/app_user.dart';

void main() {
  group('AppUser Model', () {
    late AppUser user;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 12, 0, 0);
      user = AppUser(
        uid: 'user_123',
        email: 'test@example.com',
        displayName: '홍길동',
        photoURL: 'https://example.com/avatar.jpg',
        loginMethod: 'google',
        role: 'customer',
        ownedTruckId: null,
        fcmToken: 'fcm_token_123',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );
    });

    test('should create AppUser with all fields', () {
      expect(user.uid, 'user_123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, '홍길동');
      expect(user.photoURL, 'https://example.com/avatar.jpg');
      expect(user.loginMethod, 'google');
      expect(user.role, 'customer');
      expect(user.ownedTruckId, isNull);
      expect(user.fcmToken, 'fcm_token_123');
      expect(user.createdAt, testDateTime);
      expect(user.updatedAt, testDateTime);
    });

    test('should create AppUser with required fields only', () {
      const minimalUser = AppUser(
        uid: 'u1',
        email: 'minimal@example.com',
        displayName: 'Minimal User',
      );

      expect(minimalUser.uid, 'u1');
      expect(minimalUser.email, 'minimal@example.com');
      expect(minimalUser.displayName, 'Minimal User');
      expect(minimalUser.photoURL, isNull);
      expect(minimalUser.loginMethod, 'email'); // default
      expect(minimalUser.role, 'customer'); // default
      expect(minimalUser.ownedTruckId, isNull);
      expect(minimalUser.fcmToken, isNull);
      expect(minimalUser.createdAt, isNull);
      expect(minimalUser.updatedAt, isNull);
    });

    group('loginMethod', () {
      test('should default to email', () {
        const emailUser = AppUser(
          uid: 'u1',
          email: 'email@example.com',
          displayName: 'Email User',
        );
        expect(emailUser.loginMethod, 'email');
      });

      test('should allow google login method', () {
        final googleUser = user.copyWith(loginMethod: 'google');
        expect(googleUser.loginMethod, 'google');
      });

      test('should allow kakao login method', () {
        final kakaoUser = user.copyWith(loginMethod: 'kakao');
        expect(kakaoUser.loginMethod, 'kakao');
      });

      test('should allow naver login method', () {
        final naverUser = user.copyWith(loginMethod: 'naver');
        expect(naverUser.loginMethod, 'naver');
      });
    });

    group('role', () {
      test('should default to customer', () {
        const customerUser = AppUser(
          uid: 'u1',
          email: 'customer@example.com',
          displayName: 'Customer',
        );
        expect(customerUser.role, 'customer');
      });

      test('should allow owner role', () {
        final ownerUser = user.copyWith(
          role: 'owner',
          ownedTruckId: 42,
        );
        expect(ownerUser.role, 'owner');
        expect(ownerUser.ownedTruckId, 42);
      });
    });

    group('ownedTruckId', () {
      test('should be null for customer', () {
        expect(user.ownedTruckId, isNull);
      });

      test('should have value for owner', () {
        final owner = AppUser(
          uid: 'owner_1',
          email: 'owner@example.com',
          displayName: '사장님',
          role: 'owner',
          ownedTruckId: 1,
        );
        expect(owner.ownedTruckId, 1);
      });

      test('should allow truck IDs from 1 to 100', () {
        final owner1 = user.copyWith(role: 'owner', ownedTruckId: 1);
        expect(owner1.ownedTruckId, 1);

        final owner100 = user.copyWith(role: 'owner', ownedTruckId: 100);
        expect(owner100.ownedTruckId, 100);
      });
    });

    group('toFirestore', () {
      test('should convert AppUser to Map correctly', () {
        final firestoreMap = AppUser.toFirestore(user);

        expect(firestoreMap['uid'], 'user_123');
        expect(firestoreMap['email'], 'test@example.com');
        expect(firestoreMap['displayName'], '홍길동');
        expect(firestoreMap['photoURL'], 'https://example.com/avatar.jpg');
        expect(firestoreMap['loginMethod'], 'google');
        expect(firestoreMap['role'], 'customer');
        expect(firestoreMap['ownedTruckId'], isNull);
        expect(firestoreMap['fcmToken'], 'fcm_token_123');
      });

      test('should include createdAt timestamp', () {
        final firestoreMap = AppUser.toFirestore(user);
        expect(firestoreMap.containsKey('createdAt'), isTrue);
      });

      test('should include updatedAt timestamp', () {
        final firestoreMap = AppUser.toFirestore(user);
        expect(firestoreMap.containsKey('updatedAt'), isTrue);
      });
    });

    group('copyWith', () {
      test('should create copy with updated displayName', () {
        final updated = user.copyWith(displayName: '새이름');

        expect(updated.displayName, '새이름');
        expect(updated.uid, user.uid); // unchanged
        expect(updated.email, user.email); // unchanged
      });

      test('should create copy with updated role', () {
        final updated = user.copyWith(role: 'owner', ownedTruckId: 5);

        expect(updated.role, 'owner');
        expect(updated.ownedTruckId, 5);
        expect(updated.uid, user.uid); // unchanged
      });

      test('should create copy with updated fcmToken', () {
        final updated = user.copyWith(fcmToken: 'new_fcm_token');

        expect(updated.fcmToken, 'new_fcm_token');
      });

      test('should create copy with null fcmToken', () {
        final updated = user.copyWith(fcmToken: null);

        expect(updated.fcmToken, isNull);
      });
    });

    group('photoURL', () {
      test('should be null when not provided', () {
        const noPhotoUser = AppUser(
          uid: 'u1',
          email: 'nophoto@example.com',
          displayName: 'No Photo',
        );
        expect(noPhotoUser.photoURL, isNull);
      });

      test('should contain URL when provided', () {
        expect(user.photoURL, 'https://example.com/avatar.jpg');
      });
    });

    group('fcmToken', () {
      test('should be null when not provided', () {
        const noTokenUser = AppUser(
          uid: 'u1',
          email: 'notoken@example.com',
          displayName: 'No Token',
        );
        expect(noTokenUser.fcmToken, isNull);
      });

      test('should contain token when provided', () {
        expect(user.fcmToken, 'fcm_token_123');
      });
    });

    group('timestamps', () {
      test('should store createdAt datetime', () {
        expect(user.createdAt, testDateTime);
      });

      test('should store updatedAt datetime', () {
        expect(user.updatedAt, testDateTime);
      });

      test('should be null when not provided', () {
        const noTimestampUser = AppUser(
          uid: 'u1',
          email: 'notimestamp@example.com',
          displayName: 'No Timestamp',
        );
        expect(noTimestampUser.createdAt, isNull);
        expect(noTimestampUser.updatedAt, isNull);
      });
    });
  });
}
