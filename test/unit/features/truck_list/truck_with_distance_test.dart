import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';
import 'package:truck_tracker/features/truck_list/domain/truck_with_distance.dart';

/// Unit tests for TruckWithDistance domain model
///
/// Tests distance formatting and sorting logic.
void main() {
  group('TruckWithDistance', () {
    // Helper to create a mock truck
    Truck createMockTruck(String id) => Truck(
          id: id,
          truckNumber: 'TEST-$id',
          driverName: 'Driver $id',
          status: TruckStatus.onRoute,
          foodType: '닭꼬치',
          locationDescription: 'Test Location',
          latitude: 37.5665,
          longitude: 126.9780,
          imageUrl: 'https://example.com/truck-$id.jpg',
        );

    group('distanceText', () {
      test('formats distance < 1000m as meters (no decimal)', () {
        final truck = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 150.7,
        );
        expect(truck.distanceText, '151m');
      });

      test('formats distance exactly 999m as meters', () {
        final truck = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 999,
        );
        expect(truck.distanceText, '999m');
      });

      test('formats distance >= 1000m as kilometers (1 decimal)', () {
        final truck = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 1500,
        );
        expect(truck.distanceText, '1.5km');
      });

      test('formats large distance correctly', () {
        final truck = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 10234.5,
        );
        expect(truck.distanceText, '10.2km');
      });

      test('handles zero distance', () {
        final truck = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 0,
        );
        expect(truck.distanceText, '0m');
      });

      test('rounds kilometers to 1 decimal place', () {
        final truck = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 1234.567,
        );
        expect(truck.distanceText, '1.2km'); // 1.234567 rounded to 1.2
      });
    });

    group('compareByDistance()', () {
      test('returns negative when this is closer', () {
        final closer = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 100,
        );
        final farther = TruckWithDistance(
          truck: createMockTruck('2'),
          distanceInMeters: 500,
        );
        expect(closer.compareByDistance(farther), lessThan(0));
      });

      test('returns positive when this is farther', () {
        final closer = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 100,
        );
        final farther = TruckWithDistance(
          truck: createMockTruck('2'),
          distanceInMeters: 500,
        );
        expect(farther.compareByDistance(closer), greaterThan(0));
      });

      test('returns zero when distances are equal', () {
        final truck1 = TruckWithDistance(
          truck: createMockTruck('1'),
          distanceInMeters: 250,
        );
        final truck2 = TruckWithDistance(
          truck: createMockTruck('2'),
          distanceInMeters: 250,
        );
        expect(truck1.compareByDistance(truck2), 0);
      });

      test('sorts list of trucks by distance correctly', () {
        final trucks = [
          TruckWithDistance(truck: createMockTruck('3'), distanceInMeters: 1000),
          TruckWithDistance(truck: createMockTruck('1'), distanceInMeters: 100),
          TruckWithDistance(truck: createMockTruck('2'), distanceInMeters: 500),
        ];

        trucks.sort((a, b) => a.compareByDistance(b));

        expect(trucks[0].truck.id, '1'); // 100m
        expect(trucks[1].truck.id, '2'); // 500m
        expect(trucks[2].truck.id, '3'); // 1000m
      });
    });
  });
}
