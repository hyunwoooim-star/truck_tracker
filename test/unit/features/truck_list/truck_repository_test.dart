import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_list/data/truck_repository.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';

/// Unit tests for TruckRepository
///
/// Tests Firestore CRUD operations, validation, and error handling.
void main() {
  group('TruckRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late TruckRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = TruckRepository(firestore: fakeFirestore);
    });

    // Helper to create a valid truck
    Truck createTruck(String id, {TruckStatus? status, double? latitude, double? longitude}) => Truck(
          id: id,
          truckNumber: 'TRUCK-$id',
          driverName: 'Driver $id',
          status: status ?? TruckStatus.onRoute,
          foodType: '닭꼬치',
          locationDescription: 'Test Location $id',
          latitude: latitude ?? 37.5665,
          longitude: longitude ?? 126.9780,
          imageUrl: null,
          menuItems: [],
          announcement: '',
          isOpen: true,
          avgRating: 4.5,
          totalReviews: 10,
          favoriteCount: 5,
        );

    group('CRUD Operations', () {
      test('addTruck creates new truck document', () async {
        final truck = createTruck('1');

        await repository.addTruck(truck);

        final doc = await fakeFirestore.collection('trucks').doc('1').get();
        expect(doc.exists, true);
        expect(doc.data()?['truckNumber'], 'TRUCK-1');
        expect(doc.data()?['driverName'], 'Driver 1');
      });

      test('getTruck returns truck by ID', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        final result = await repository.getTruck('1');

        expect(result, isNotNull);
        expect(result?.id, '1');
        expect(result?.truckNumber, 'TRUCK-1');
      });

      test('getTruck returns null for non-existent ID', () async {
        final result = await repository.getTruck('non-existent');

        expect(result, isNull);
      });

      test('updateTruck modifies existing truck', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        final updated = truck.copyWith(driverName: 'Updated Driver');
        await repository.updateTruck(updated);

        final result = await repository.getTruck('1');
        expect(result?.driverName, 'Updated Driver');
      });

      test('deleteTruck removes truck document', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        await repository.deleteTruck('1');

        final result = await repository.getTruck('1');
        expect(result, isNull);
      });
    });

    group('watchTrucks Stream', () {
      test('emits list of trucks in real-time', () async {
        // Add initial truck
        await repository.addTruck(createTruck('1'));

        final stream = repository.watchTrucks();

        expect(stream, emits(predicate<List<Truck>>((list) => list.length == 1)));
      });

      test('filters out trucks with maintenance status', () async {
        await repository.addTruck(createTruck('1', status: TruckStatus.onRoute));
        await repository.addTruck(createTruck('2', status: TruckStatus.maintenance));
        await repository.addTruck(createTruck('3', status: TruckStatus.resting));

        final stream = repository.watchTrucks();

        // Should only include onRoute and resting, NOT maintenance
        expect(
          stream,
          emits(predicate<List<Truck>>((list) =>
            list.length == 2 &&
            list.every((t) => t.status == TruckStatus.onRoute || t.status == TruckStatus.resting)
          ))
        );
      });

      test('filters out trucks with (0,0) coordinates', () async {
        await repository.addTruck(createTruck('1', latitude: 37.5665, longitude: 126.9780));
        await repository.addTruck(createTruck('2', latitude: 0.0, longitude: 0.0));

        final stream = repository.watchTrucks();

        // Should exclude truck with (0,0)
        expect(
          stream,
          emits(predicate<List<Truck>>((list) =>
            list.length == 1 &&
            list.first.id == '1'
          ))
        );
      });

      test('filters out trucks with invalid coordinates', () async {
        await repository.addTruck(createTruck('1', latitude: 37.5665, longitude: 126.9780)); // Valid
        await repository.addTruck(createTruck('2', latitude: 100.0, longitude: 200.0)); // Invalid (out of range)

        final stream = repository.watchTrucks();

        // Should exclude invalid coordinates
        expect(
          stream,
          emits(predicate<List<Truck>>((list) =>
            list.length == 1 &&
            list.first.id == '1'
          ))
        );
      });

      test('respects limit parameter', () async {
        // Add 10 trucks
        for (int i = 1; i <= 10; i++) {
          await repository.addTruck(createTruck('$i'));
        }

        final stream = repository.watchTrucks(limit: 5);

        expect(
          stream,
          emits(predicate<List<Truck>>((list) => list.length <= 5))
        );
      });
    });

    group('Location Updates', () {
      test('updateLocation modifies coordinates', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        await repository.updateLocation('1', 37.4979, 127.0276);

        final result = await repository.getTruck('1');
        expect(result?.latitude, 37.4979);
        expect(result?.longitude, 127.0276);
      });

      test('openForBusiness sets isOpen and updates location', () async {
        final truck = createTruck('1').copyWith(isOpen: false);
        await repository.addTruck(truck);

        await repository.openForBusiness('1', 37.4979, 127.0276);

        final result = await repository.getTruck('1');
        expect(result?.isOpen, true);
        expect(result?.latitude, 37.4979);
        expect(result?.longitude, 127.0276);
        expect(result?.status, TruckStatus.onRoute);
      });
    });

    group('Status Updates', () {
      test('updateStatus changes truck status', () async {
        final truck = createTruck('1', status: TruckStatus.onRoute);
        await repository.addTruck(truck);

        await repository.updateStatus('1', TruckStatus.resting);

        final result = await repository.getTruck('1');
        expect(result?.status, TruckStatus.resting);
      });
    });

    group('Menu & Announcement Updates', () {
      test('updateMenuItems modifies menu list', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        final menuItems = [
          {'name': '닭꼬치', 'price': 5000},
          {'name': '호떡', 'price': 2000},
        ];
        await repository.updateMenuItems('1', menuItems);

        final doc = await fakeFirestore.collection('trucks').doc('1').get();
        expect(doc.data()?['menuItems'], menuItems);
      });

      test('updateAnnouncement modifies announcement text', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        await repository.updateAnnouncement('1', '오늘 특가: 닭꼬치 30% 할인!');

        final result = await repository.getTruck('1');
        expect(result?.announcement, '오늘 특가: 닭꼬치 30% 할인!');
      });
    });

    group('Ratings & Favorites', () {
      test('updateRatings modifies avgRating and totalReviews', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        await repository.updateRatings('1', 4.8, 25);

        final result = await repository.getTruck('1');
        expect(result?.avgRating, 4.8);
        expect(result?.totalReviews, 25);
      });

      test('updateFavoriteCount modifies favorite count', () async {
        final truck = createTruck('1');
        await repository.addTruck(truck);

        await repository.updateFavoriteCount('1', 50);

        final result = await repository.getTruck('1');
        expect(result?.favoriteCount, 50);
      });
    });

    group('Batch Operations', () {
      test('addTrucksBatch creates multiple trucks atomically', () async {
        final trucks = [
          createTruck('1'),
          createTruck('2'),
          createTruck('3'),
        ];

        await repository.addTrucksBatch(trucks);

        final snapshot = await fakeFirestore.collection('trucks').get();
        expect(snapshot.docs.length, 3);
      });

      test('deleteAllTrucks removes all truck documents', () async {
        await repository.addTruck(createTruck('1'));
        await repository.addTruck(createTruck('2'));
        await repository.addTruck(createTruck('3'));

        await repository.deleteAllTrucks();

        final snapshot = await fakeFirestore.collection('trucks').get();
        expect(snapshot.docs.length, 0);
      });
    });

    group('getTrucks (one-time fetch)', () {
      test('returns all trucks once', () async {
        await repository.addTruck(createTruck('1'));
        await repository.addTruck(createTruck('2'));

        final result = await repository.getTrucks();

        expect(result.length, 2);
      });

      test('respects limit parameter', () async {
        for (int i = 1; i <= 10; i++) {
          await repository.addTruck(createTruck('$i'));
        }

        final result = await repository.getTrucks(limit: 5);

        expect(result.length, lessThanOrEqualTo(5));
      });
    });
  });
}
