import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/checkin/domain/checkin.dart';

void main() {
  group('CheckIn Model', () {
    late CheckIn checkIn;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 18, 30, 0);
      checkIn = CheckIn(
        id: 'checkin_123',
        userId: 'user_456',
        userName: '홍길동',
        truckId: 'truck_789',
        truckName: '매운떡볶이',
        checkedInAt: testDateTime,
        loyaltyPoints: 10,
      );
    });

    test('should create CheckIn with all fields', () {
      expect(checkIn.id, 'checkin_123');
      expect(checkIn.userId, 'user_456');
      expect(checkIn.userName, '홍길동');
      expect(checkIn.truckId, 'truck_789');
      expect(checkIn.truckName, '매운떡볶이');
      expect(checkIn.checkedInAt, testDateTime);
      expect(checkIn.loyaltyPoints, 10);
    });

    test('should have default loyaltyPoints of 0', () {
      final checkInWithoutPoints = CheckIn(
        id: 'c1',
        userId: 'u1',
        userName: '김철수',
        truckId: 't1',
        truckName: '타코야끼',
        checkedInAt: testDateTime,
      );

      expect(checkInWithoutPoints.loyaltyPoints, 0);
    });

    test('should create CheckIn with required fields only', () {
      final minimalCheckIn = CheckIn(
        id: 'c1',
        userId: 'u1',
        userName: '손님',
        truckId: 't1',
        truckName: '푸드트럭',
        checkedInAt: DateTime.now(),
      );

      expect(minimalCheckIn.id, 'c1');
      expect(minimalCheckIn.userId, 'u1');
      expect(minimalCheckIn.loyaltyPoints, 0);
    });

    group('toFirestore', () {
      test('should convert CheckIn to Map correctly', () {
        final firestoreMap = checkIn.toFirestore();

        expect(firestoreMap['userId'], 'user_456');
        expect(firestoreMap['userName'], '홍길동');
        expect(firestoreMap['truckId'], 'truck_789');
        expect(firestoreMap['truckName'], '매운떡볶이');
        expect(firestoreMap['loyaltyPoints'], 10);
        expect(firestoreMap.containsKey('checkedInAt'), isTrue);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = checkIn.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });
    });

    test('copyWith should create new CheckIn with updated fields', () {
      final updatedCheckIn = checkIn.copyWith(
        loyaltyPoints: 20,
        userName: '새이름',
      );

      expect(updatedCheckIn.id, checkIn.id); // unchanged
      expect(updatedCheckIn.loyaltyPoints, 20); // updated
      expect(updatedCheckIn.userName, '새이름'); // updated
      expect(updatedCheckIn.truckId, checkIn.truckId); // unchanged
    });

    group('loyaltyPoints', () {
      test('should allow zero loyalty points', () {
        final noPoints = checkIn.copyWith(loyaltyPoints: 0);
        expect(noPoints.loyaltyPoints, 0);
      });

      test('should allow positive loyalty points', () {
        final withPoints = checkIn.copyWith(loyaltyPoints: 100);
        expect(withPoints.loyaltyPoints, 100);
      });
    });

    group('checkedInAt', () {
      test('should store exact datetime', () {
        final specificTime = DateTime(2025, 6, 15, 12, 30, 45);
        final checkInWithTime = checkIn.copyWith(checkedInAt: specificTime);

        expect(checkInWithTime.checkedInAt.year, 2025);
        expect(checkInWithTime.checkedInAt.month, 6);
        expect(checkInWithTime.checkedInAt.day, 15);
        expect(checkInWithTime.checkedInAt.hour, 12);
        expect(checkInWithTime.checkedInAt.minute, 30);
        expect(checkInWithTime.checkedInAt.second, 45);
      });
    });

    test('equality should work correctly', () {
      final checkIn1 = CheckIn(
        id: 'c1',
        userId: 'u1',
        userName: '테스터',
        truckId: 't1',
        truckName: '트럭',
        checkedInAt: testDateTime,
        loyaltyPoints: 5,
      );

      final checkIn2 = CheckIn(
        id: 'c1',
        userId: 'u1',
        userName: '테스터',
        truckId: 't1',
        truckName: '트럭',
        checkedInAt: testDateTime,
        loyaltyPoints: 5,
      );

      final checkIn3 = CheckIn(
        id: 'c2', // different id
        userId: 'u1',
        userName: '테스터',
        truckId: 't1',
        truckName: '트럭',
        checkedInAt: testDateTime,
        loyaltyPoints: 5,
      );

      expect(checkIn1, equals(checkIn2));
      expect(checkIn1, isNot(equals(checkIn3)));
    });
  });
}
