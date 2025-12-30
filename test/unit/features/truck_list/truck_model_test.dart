import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';

void main() {
  group('Truck Model', () {
    late Truck truck;

    setUp(() {
      truck = const Truck(
        id: 'truck_123',
        truckNumber: 'A-1234',
        driverName: '김철수',
        status: TruckStatus.onRoute,
        foodType: '떡볶이',
        locationDescription: '강남역 2번 출구',
        latitude: 37.4979,
        longitude: 127.0276,
        imageUrl: 'https://example.com/truck.jpg',
        ownerEmail: 'owner@example.com',
        contactPhone: '010-1234-5678',
        bankAccount: '123-456-789',
        announcement: '오늘 떡볶이 할인!',
        favoriteCount: 50,
        avgRating: 4.5,
        totalReviews: 100,
        isOpen: true,
        weeklySchedule: {'monday': {'isOpen': true, 'location': '강남'}},
      );
    });

    test('should create Truck with all fields', () {
      expect(truck.id, 'truck_123');
      expect(truck.truckNumber, 'A-1234');
      expect(truck.driverName, '김철수');
      expect(truck.status, TruckStatus.onRoute);
      expect(truck.foodType, '떡볶이');
      expect(truck.locationDescription, '강남역 2번 출구');
      expect(truck.latitude, 37.4979);
      expect(truck.longitude, 127.0276);
      expect(truck.imageUrl, 'https://example.com/truck.jpg');
      expect(truck.ownerEmail, 'owner@example.com');
      expect(truck.contactPhone, '010-1234-5678');
      expect(truck.bankAccount, '123-456-789');
      expect(truck.announcement, '오늘 떡볶이 할인!');
      expect(truck.favoriteCount, 50);
      expect(truck.avgRating, 4.5);
      expect(truck.totalReviews, 100);
      expect(truck.isOpen, isTrue);
      expect(truck.weeklySchedule, isNotNull);
    });

    test('should create Truck with required fields and defaults', () {
      const minimalTruck = Truck(
        id: 't1',
        truckNumber: 'B-9999',
        driverName: '박영희',
        status: TruckStatus.resting,
        foodType: '타코야끼',
        locationDescription: '홍대입구',
        latitude: 37.5563,
        longitude: 126.9220,
        imageUrl: '',
      );

      expect(minimalTruck.id, 't1');
      expect(minimalTruck.isFavorite, isFalse); // default
      expect(minimalTruck.ownerEmail, ''); // default
      expect(minimalTruck.contactPhone, ''); // default
      expect(minimalTruck.bankAccount, isNull); // optional
      expect(minimalTruck.announcement, ''); // default
      expect(minimalTruck.favoriteCount, 0); // default
      expect(minimalTruck.avgRating, 0.0); // default
      expect(minimalTruck.totalReviews, 0); // default
      expect(minimalTruck.isOpen, isFalse); // default
      expect(minimalTruck.weeklySchedule, isNull); // optional
    });

    group('TruckStatus enum', () {
      test('should have all expected values', () {
        expect(TruckStatus.values.length, 3);
        expect(TruckStatus.values, contains(TruckStatus.onRoute));
        expect(TruckStatus.values, contains(TruckStatus.resting));
        expect(TruckStatus.values, contains(TruckStatus.maintenance));
      });

      test('should create truck with onRoute status', () {
        const onRouteTruck = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.onRoute,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );
        expect(onRouteTruck.status, TruckStatus.onRoute);
      });

      test('should create truck with resting status', () {
        const restingTruck = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );
        expect(restingTruck.status, TruckStatus.resting);
      });

      test('should create truck with maintenance status', () {
        const maintenanceTruck = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.maintenance,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );
        expect(maintenanceTruck.status, TruckStatus.maintenance);
      });
    });

    group('toFirestore', () {
      test('should convert Truck to Map correctly', () {
        final firestoreMap = truck.toFirestore();

        expect(firestoreMap['truckNumber'], 'A-1234');
        expect(firestoreMap['driverName'], '김철수');
        expect(firestoreMap['status'], 'onRoute');
        expect(firestoreMap['foodType'], '떡볶이');
        expect(firestoreMap['locationDescription'], '강남역 2번 출구');
        expect(firestoreMap['latitude'], 37.4979);
        expect(firestoreMap['longitude'], 127.0276);
        expect(firestoreMap['imageUrl'], 'https://example.com/truck.jpg');
        expect(firestoreMap['ownerEmail'], 'owner@example.com');
        expect(firestoreMap['contactPhone'], '010-1234-5678');
        expect(firestoreMap['bankAccount'], '123-456-789');
        expect(firestoreMap['announcement'], '오늘 떡볶이 할인!');
        expect(firestoreMap['favoriteCount'], 50);
        expect(firestoreMap['avgRating'], 4.5);
        expect(firestoreMap['totalReviews'], 100);
        expect(firestoreMap['isOpen'], isTrue);
        expect(firestoreMap['weeklySchedule'], isNotNull);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = truck.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });

      test('should include null bankAccount', () {
        const truckWithoutBank = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );

        final firestoreMap = truckWithoutBank.toFirestore();
        expect(firestoreMap['bankAccount'], isNull);
      });
    });

    group('rankingScore', () {
      test('should calculate ranking score correctly', () {
        // rankingScore = (favoriteCount * 0.4) + (avgRating * 0.6)
        // = (50 * 0.4) + (4.5 * 0.6)
        // = 20 + 2.7
        // = 22.7
        expect(truck.rankingScore, closeTo(22.7, 0.01));
      });

      test('should return 0 for zero favorites and rating', () {
        const zeroTruck = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
          favoriteCount: 0,
          avgRating: 0.0,
        );

        expect(zeroTruck.rankingScore, 0.0);
      });

      test('should weight favorites at 40%', () {
        const truck100Fav = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
          favoriteCount: 100,
          avgRating: 0.0,
        );

        // 100 * 0.4 = 40
        expect(truck100Fav.rankingScore, 40.0);
      });

      test('should weight rating at 60%', () {
        const truckPerfectRating = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
          favoriteCount: 0,
          avgRating: 5.0,
        );

        // 5.0 * 0.6 = 3.0
        expect(truckPerfectRating.rankingScore, 3.0);
      });
    });

    group('copyWith', () {
      test('should create copy with updated status', () {
        final updatedTruck = truck.copyWith(status: TruckStatus.maintenance);

        expect(updatedTruck.id, truck.id); // unchanged
        expect(updatedTruck.truckNumber, truck.truckNumber); // unchanged
        expect(updatedTruck.status, TruckStatus.maintenance); // updated
      });

      test('should create copy with updated location', () {
        final updatedTruck = truck.copyWith(
          locationDescription: '신촌역 앞',
          latitude: 37.5598,
          longitude: 126.9426,
        );

        expect(updatedTruck.locationDescription, '신촌역 앞');
        expect(updatedTruck.latitude, 37.5598);
        expect(updatedTruck.longitude, 126.9426);
        expect(updatedTruck.foodType, truck.foodType); // unchanged
      });

      test('should create copy with updated isOpen', () {
        final closedTruck = truck.copyWith(isOpen: false);
        expect(closedTruck.isOpen, isFalse);

        final openTruck = closedTruck.copyWith(isOpen: true);
        expect(openTruck.isOpen, isTrue);
      });

      test('should create copy with updated favorites and rating', () {
        final updatedTruck = truck.copyWith(
          favoriteCount: 100,
          avgRating: 4.8,
          totalReviews: 150,
        );

        expect(updatedTruck.favoriteCount, 100);
        expect(updatedTruck.avgRating, 4.8);
        expect(updatedTruck.totalReviews, 150);
      });
    });

    group('isFavorite', () {
      test('should default to false', () {
        const newTruck = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );
        expect(newTruck.isFavorite, isFalse);
      });

      test('should be true when set', () {
        const favoriteTruck = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
          isFavorite: true,
        );
        expect(favoriteTruck.isFavorite, isTrue);
      });

      test('should toggle with copyWith', () {
        // truck.isFavorite defaults to false, so toggling makes it true
        final toggled = truck.copyWith(isFavorite: !truck.isFavorite);
        expect(toggled.isFavorite, isTrue);

        // toggle again makes it false
        final toggledBack = toggled.copyWith(isFavorite: !toggled.isFavorite);
        expect(toggledBack.isFavorite, isFalse);
      });
    });

    group('announcement', () {
      test('should default to empty string', () {
        const truckWithoutAnnouncement = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );
        expect(truckWithoutAnnouncement.announcement, isEmpty);
      });

      test('should store announcement text', () {
        expect(truck.announcement, '오늘 떡볶이 할인!');
      });
    });

    group('weeklySchedule', () {
      test('should be null by default', () {
        const truckWithoutSchedule = Truck(
          id: 't1',
          truckNumber: 'A-1',
          driverName: 'Driver',
          status: TruckStatus.resting,
          foodType: '푸드',
          locationDescription: '위치',
          latitude: 37.0,
          longitude: 127.0,
          imageUrl: '',
        );
        expect(truckWithoutSchedule.weeklySchedule, isNull);
      });

      test('should contain schedule data when provided', () {
        expect(truck.weeklySchedule, isNotNull);
        expect(truck.weeklySchedule!['monday'], isNotNull);
      });
    });

    group('coordinates', () {
      test('should store latitude and longitude', () {
        expect(truck.latitude, 37.4979);
        expect(truck.longitude, 127.0276);
      });

      test('should handle Seoul area coordinates', () {
        // Seoul typical range: 37.4 ~ 37.7 lat, 126.8 ~ 127.2 long
        expect(truck.latitude, greaterThan(37.0));
        expect(truck.latitude, lessThan(38.0));
        expect(truck.longitude, greaterThan(126.0));
        expect(truck.longitude, lessThan(128.0));
      });
    });
  });
}
