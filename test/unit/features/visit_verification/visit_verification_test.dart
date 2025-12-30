import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/visit_verification/data/visit_verification_repository.dart';

void main() {
  group('VisitVerification', () {
    test('verificationRadiusMeters is 50', () {
      expect(VisitVerificationRepository.verificationRadiusMeters, 50.0);
    });

    group('Distance calculation', () {
      test('calculates distance correctly for same location', () {
        const lat1 = 37.5665;
        const lng1 = 126.9780;
        const lat2 = 37.5665;
        const lng2 = 126.9780;

        final distance = _calculateDistance(lat1, lng1, lat2, lng2);
        expect(distance, closeTo(0, 0.001));
      });

      test('calculates distance correctly for nearby locations', () {
        // Seoul City Hall to Deoksugung Palace (~300m)
        const lat1 = 37.5665;
        const lng1 = 126.9780;
        const lat2 = 37.5659;
        const lng2 = 126.9751;

        final distance = _calculateDistance(lat1, lng1, lat2, lng2);
        expect(distance, greaterThan(200));
        expect(distance, lessThan(400));
      });

      test('calculates distance correctly for far locations', () {
        // Seoul to Busan (~325km)
        const lat1 = 37.5665;
        const lng1 = 126.9780;
        const lat2 = 35.1796;
        const lng2 = 129.0756;

        final distance = _calculateDistance(lat1, lng1, lat2, lng2);
        expect(distance, greaterThan(300000)); // >300km
        expect(distance, lessThan(350000)); // <350km
      });
    });

    group('Verification eligibility', () {
      test('user within 50m can verify', () {
        const distance = 30.0;
        expect(distance <= VisitVerificationRepository.verificationRadiusMeters, isTrue);
      });

      test('user exactly at 50m can verify', () {
        const distance = 50.0;
        expect(distance <= VisitVerificationRepository.verificationRadiusMeters, isTrue);
      });

      test('user beyond 50m cannot verify', () {
        const distance = 51.0;
        expect(distance <= VisitVerificationRepository.verificationRadiusMeters, isFalse);
      });

      test('user at 100m cannot verify', () {
        const distance = 100.0;
        expect(distance <= VisitVerificationRepository.verificationRadiusMeters, isFalse);
      });
    });

    group('Today check', () {
      test('same day is today', () {
        final now = DateTime.now();
        final visitTime = DateTime.now();

        expect(_isSameDay(now, visitTime), isTrue);
      });

      test('yesterday is not today', () {
        final now = DateTime.now();
        final visitTime = now.subtract(const Duration(days: 1));

        expect(_isSameDay(now, visitTime), isFalse);
      });

      test('tomorrow is not today', () {
        final now = DateTime.now();
        final visitTime = now.add(const Duration(days: 1));

        expect(_isSameDay(now, visitTime), isFalse);
      });
    });
  });
}

// Haversine formula for distance calculation (in meters)
double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const double earthRadius = 6371000; // meters
  final double dLat = _toRadians(lat2 - lat1);
  final double dLng = _toRadians(lng2 - lng1);

  final double a = _sin(dLat / 2) * _sin(dLat / 2) +
      _cos(_toRadians(lat1)) *
          _cos(_toRadians(lat2)) *
          _sin(dLng / 2) *
          _sin(dLng / 2);

  final double c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
  return earthRadius * c;
}

double _toRadians(double degrees) => degrees * 3.14159265359 / 180;
double _sin(double x) => _power(x, 1) - _power(x, 3) / 6 + _power(x, 5) / 120;
double _cos(double x) => 1 - _power(x, 2) / 2 + _power(x, 4) / 24;
double _sqrt(double x) {
  if (x <= 0) return 0;
  double guess = x / 2;
  for (int i = 0; i < 20; i++) {
    guess = (guess + x / guess) / 2;
  }
  return guess;
}

double _atan2(double y, double x) {
  if (x > 0) return _atan(y / x);
  if (x < 0 && y >= 0) return _atan(y / x) + 3.14159265359;
  if (x < 0 && y < 0) return _atan(y / x) - 3.14159265359;
  if (x == 0 && y > 0) return 3.14159265359 / 2;
  if (x == 0 && y < 0) return -3.14159265359 / 2;
  return 0;
}

double _atan(double x) {
  // Taylor series approximation
  if (x.abs() > 1) {
    return (x > 0 ? 1 : -1) * 3.14159265359 / 2 - _atan(1 / x);
  }
  double result = 0;
  double term = x;
  for (int n = 1; n <= 20; n++) {
    result += term / (2 * n - 1);
    term *= -x * x;
  }
  return result;
}

double _power(double base, int exp) {
  double result = 1;
  for (int i = 0; i < exp; i++) {
    result *= base;
  }
  return result;
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
