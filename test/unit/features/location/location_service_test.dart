import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/location/location_service.dart';

/// Unit tests for LocationService
///
/// Tests distance calculation and location formatting.
void main() {
  group('LocationService', () {
    late LocationService service;

    setUp(() {
      service = LocationService();
    });

    group('calculateDistance()', () {
      test('returns 0 for same location', () {
        final distance = service.calculateDistance(
          37.5665, // Seoul City Hall latitude
          126.9780, // Seoul City Hall longitude
          37.5665,
          126.9780,
        );
        expect(distance, 0);
      });

      test('calculates distance between Seoul and Gangnam (approximately 10km)', () {
        final distance = service.calculateDistance(
          37.5665, // Seoul City Hall
          126.9780,
          37.4979, // Gangnam Station
          127.0276,
        );
        // Distance should be around 10km (10,000 meters)
        expect(distance, greaterThan(9000));
        expect(distance, lessThan(11000));
      });

      test('distance is symmetric (A->B == B->A)', () {
        final distanceAB = service.calculateDistance(37.5665, 126.9780, 37.4979, 127.0276);
        final distanceBA = service.calculateDistance(37.4979, 127.0276, 37.5665, 126.9780);
        expect(distanceAB, closeTo(distanceBA, 1.0)); // Within 1 meter tolerance
      });

      test('handles negative coordinates (Southern/Western hemispheres)', () {
        final distance = service.calculateDistance(
          -33.8688, // Sydney
          151.2093,
          -37.8136, // Melbourne
          144.9631,
        );
        // Distance Sydney->Melbourne is about 700km
        expect(distance, greaterThan(600000));
        expect(distance, lessThan(800000));
      });
    });

    group('getDistanceText()', () {
      test('formats distance < 1km as meters', () {
        final text = service.getDistanceText(37.5665, 126.9780, 37.5670, 126.9780);
        expect(text, matches(r'^\d+m$')); // e.g. "555m"
      });

      test('formats distance >= 1km with 1 decimal', () {
        final text = service.getDistanceText(37.5665, 126.9780, 37.4979, 127.0276);
        expect(text, matches(r'^\d+\.\d{1}km$')); // e.g. "10.2km"
      });

      test('returns "0m" for same location', () {
        final text = service.getDistanceText(37.5665, 126.9780, 37.5665, 126.9780);
        expect(text, '0m');
      });
    });
  });
}
