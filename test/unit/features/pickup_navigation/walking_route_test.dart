import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/pickup_navigation/domain/walking_route.dart';

void main() {
  group('WalkingRoute Model', () {
    late WalkingRoute route;
    late List<LatLngPoint> testPolyline;
    late List<RouteStep> testSteps;

    setUp(() {
      testPolyline = const [
        LatLngPoint(lat: 37.4979, lng: 127.0276),
        LatLngPoint(lat: 37.4985, lng: 127.0280),
        LatLngPoint(lat: 37.4990, lng: 127.0285),
      ];
      testSteps = const [
        RouteStep(
          instruction: 'Head north on Main Street',
          distanceMeters: 200,
          distanceText: '200m',
          durationSeconds: 180,
          durationText: '3 mins',
          startLat: 37.4979,
          startLng: 127.0276,
          endLat: 37.4985,
          endLng: 127.0280,
          maneuver: null,
        ),
        RouteStep(
          instruction: 'Turn right onto Oak Avenue',
          distanceMeters: 150,
          distanceText: '150m',
          durationSeconds: 120,
          durationText: '2 mins',
          startLat: 37.4985,
          startLng: 127.0280,
          endLat: 37.4990,
          endLng: 127.0285,
          maneuver: 'turn-right',
        ),
      ];
      route = WalkingRoute(
        distanceMeters: 1200,
        distanceText: '1.2 km',
        durationSeconds: 900,
        durationText: '15 mins',
        startAddress: 'Gangnam Station Exit 2',
        endAddress: 'Tteokbokki Truck Location',
        polylinePoints: testPolyline,
        steps: testSteps,
      );
    });

    test('should create WalkingRoute with all fields', () {
      expect(route.distanceMeters, 1200);
      expect(route.distanceText, '1.2 km');
      expect(route.durationSeconds, 900);
      expect(route.durationText, '15 mins');
      expect(route.startAddress, 'Gangnam Station Exit 2');
      expect(route.endAddress, 'Tteokbokki Truck Location');
      expect(route.polylinePoints.length, 3);
      expect(route.steps.length, 2);
    });

    group('durationMinutes', () {
      test('should calculate minutes from seconds', () {
        expect(route.durationMinutes, 15);
      });

      test('should ceil partial minutes', () {
        final shortRoute = route.copyWith(durationSeconds: 90);
        expect(shortRoute.durationMinutes, 2);
      });

      test('should handle exact minute', () {
        final exactRoute = route.copyWith(durationSeconds: 300);
        expect(exactRoute.durationMinutes, 5);
      });
    });

    group('distanceKm', () {
      test('should convert meters to kilometers', () {
        expect(route.distanceKm, 1.2);
      });

      test('should handle short distances', () {
        final shortRoute = route.copyWith(distanceMeters: 500);
        expect(shortRoute.distanceKm, 0.5);
      });

      test('should handle long distances', () {
        final longRoute = route.copyWith(distanceMeters: 5000);
        expect(longRoute.distanceKm, 5.0);
      });
    });

    group('googleMapsPolyline', () {
      test('should return list of LatLng', () {
        final polyline = route.googleMapsPolyline;
        expect(polyline.length, 3);
      });

      test('should preserve coordinates', () {
        final polyline = route.googleMapsPolyline;
        expect(polyline[0].latitude, 37.4979);
        expect(polyline[0].longitude, 127.0276);
      });
    });

    group('copyWith', () {
      test('should create copy with updated distance', () {
        final updated = route.copyWith(distanceMeters: 2000);
        expect(updated.distanceMeters, 2000);
        expect(updated.durationSeconds, route.durationSeconds);
      });

      test('should create copy with updated steps', () {
        final newSteps = [testSteps[0]];
        final updated = route.copyWith(steps: newSteps);
        expect(updated.steps.length, 1);
      });
    });
  });

  group('RouteStep Model', () {
    late RouteStep step;

    setUp(() {
      step = const RouteStep(
        instruction: 'Turn left onto Main Street',
        distanceMeters: 250,
        distanceText: '250m',
        durationSeconds: 200,
        durationText: '3 mins',
        startLat: 37.4979,
        startLng: 127.0276,
        endLat: 37.4985,
        endLng: 127.0280,
        maneuver: 'turn-left',
      );
    });

    test('should create RouteStep with all fields', () {
      expect(step.instruction, 'Turn left onto Main Street');
      expect(step.distanceMeters, 250);
      expect(step.distanceText, '250m');
      expect(step.durationSeconds, 200);
      expect(step.durationText, '3 mins');
      expect(step.startLat, 37.4979);
      expect(step.startLng, 127.0276);
      expect(step.endLat, 37.4985);
      expect(step.endLng, 127.0280);
      expect(step.maneuver, 'turn-left');
    });

    test('should create RouteStep without maneuver', () {
      const noManeuver = RouteStep(
        instruction: 'Continue straight',
        distanceMeters: 100,
        distanceText: '100m',
        durationSeconds: 60,
        durationText: '1 min',
        startLat: 37.5,
        startLng: 127.0,
        endLat: 37.51,
        endLng: 127.01,
      );
      expect(noManeuver.maneuver, isNull);
    });

    group('maneuver types', () {
      test('should handle turn-left', () {
        final leftTurn = step.copyWith(maneuver: 'turn-left');
        expect(leftTurn.maneuver, 'turn-left');
      });

      test('should handle turn-right', () {
        final rightTurn = step.copyWith(maneuver: 'turn-right');
        expect(rightTurn.maneuver, 'turn-right');
      });

      test('should handle straight', () {
        final straight = step.copyWith(maneuver: 'straight');
        expect(straight.maneuver, 'straight');
      });
    });
  });

  group('LatLngPoint Model', () {
    test('should create LatLngPoint with coordinates', () {
      const point = LatLngPoint(lat: 37.4979, lng: 127.0276);
      expect(point.lat, 37.4979);
      expect(point.lng, 127.0276);
    });

    test('should handle Seoul coordinates', () {
      const seoulPoint = LatLngPoint(lat: 37.5665, lng: 126.9780);
      expect(seoulPoint.lat, greaterThan(37.0));
      expect(seoulPoint.lat, lessThan(38.0));
      expect(seoulPoint.lng, greaterThan(126.0));
      expect(seoulPoint.lng, lessThan(128.0));
    });

    test('should handle decimal precision', () {
      const precisePoint = LatLngPoint(lat: 37.123456, lng: 127.654321);
      expect(precisePoint.lat, closeTo(37.123456, 0.000001));
      expect(precisePoint.lng, closeTo(127.654321, 0.000001));
    });
  });
}
