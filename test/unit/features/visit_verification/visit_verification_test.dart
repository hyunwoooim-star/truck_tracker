import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/visit_verification/domain/visit_verification.dart';

void main() {
  group('VisitVerification Model', () {
    late VisitVerification verification;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 18, 30, 0);
      verification = VisitVerification(
        id: 'visit_123',
        visitorId: 'visitor_456',
        visitorName: 'TestVisitor',
        visitorPhotoUrl: 'https://example.com/avatar.jpg',
        truckId: 'truck_789',
        truckName: 'TestTruck',
        verifiedAt: testDateTime,
        distanceMeters: 25.5,
        latitude: 37.4979,
        longitude: 127.0276,
      );
    });

    test('should create VisitVerification with all fields', () {
      expect(verification.id, 'visit_123');
      expect(verification.visitorId, 'visitor_456');
      expect(verification.visitorName, 'TestVisitor');
      expect(verification.visitorPhotoUrl, 'https://example.com/avatar.jpg');
      expect(verification.truckId, 'truck_789');
      expect(verification.truckName, 'TestTruck');
      expect(verification.verifiedAt, testDateTime);
      expect(verification.distanceMeters, 25.5);
      expect(verification.latitude, 37.4979);
      expect(verification.longitude, 127.0276);
    });

    test('should create VisitVerification without optional photo', () {
      final noPhoto = VisitVerification(
        id: 'v1',
        visitorId: 'visitor1',
        visitorName: 'Visitor',
        truckId: 'truck1',
        truckName: 'Truck',
        verifiedAt: testDateTime,
        distanceMeters: 30.0,
        latitude: 37.5,
        longitude: 127.0,
      );
      expect(noPhoto.visitorPhotoUrl, isNull);
    });

    group('distanceMeters', () {
      test('should store distance in meters', () {
        expect(verification.distanceMeters, 25.5);
      });

      test('should handle very close distance', () {
        final veryClose = verification.copyWith(distanceMeters: 5.0);
        expect(veryClose.distanceMeters, 5.0);
      });

      test('should handle max verification distance (50m)', () {
        final maxDistance = verification.copyWith(distanceMeters: 50.0);
        expect(maxDistance.distanceMeters, 50.0);
      });
    });

    group('coordinates', () {
      test('should store latitude and longitude', () {
        expect(verification.latitude, 37.4979);
        expect(verification.longitude, 127.0276);
      });

      test('should handle Seoul area coordinates', () {
        expect(verification.latitude, greaterThan(37.0));
        expect(verification.latitude, lessThan(38.0));
        expect(verification.longitude, greaterThan(126.0));
        expect(verification.longitude, lessThan(128.0));
      });
    });

    group('toFirestore', () {
      test('should convert VisitVerification to Map correctly', () {
        final firestoreMap = verification.toFirestore();
        expect(firestoreMap['visitorId'], 'visitor_456');
        expect(firestoreMap['visitorName'], 'TestVisitor');
        expect(firestoreMap['truckId'], 'truck_789');
        expect(firestoreMap['distanceMeters'], 25.5);
        expect(firestoreMap['latitude'], 37.4979);
        expect(firestoreMap['longitude'], 127.0276);
      });

      test('should not include id in Firestore map', () {
        final firestoreMap = verification.toFirestore();
        expect(firestoreMap.containsKey('id'), isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated distance', () {
        final updated = verification.copyWith(distanceMeters: 40.0);
        expect(updated.distanceMeters, 40.0);
        expect(updated.id, verification.id);
      });

      test('should create copy with updated location', () {
        final updated = verification.copyWith(latitude: 37.5563, longitude: 126.9220);
        expect(updated.latitude, 37.5563);
        expect(updated.longitude, 126.9220);
      });
    });
  });

  group('TruckVisitStats Model', () {
    test('should create TruckVisitStats with defaults', () {
      const stats = TruckVisitStats(truckId: 'truck_123');
      expect(stats.truckId, 'truck_123');
      expect(stats.totalVisits, 0);
      expect(stats.uniqueVisitors, 0);
      expect(stats.recentVisitors, isEmpty);
    });

    test('should create TruckVisitStats with values', () {
      const stats = TruckVisitStats(
        truckId: 'truck_123',
        totalVisits: 100,
        uniqueVisitors: 50,
        recentVisitors: [],
      );
      expect(stats.totalVisits, 100);
      expect(stats.uniqueVisitors, 50);
    });
  });

  group('RecentVisitor Model', () {
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 12, 0, 0);
    });

    test('should create RecentVisitor with all fields', () {
      final visitor = RecentVisitor(
        visitorId: 'visitor_123',
        visitorName: 'Visitor',
        visitorPhotoUrl: 'https://example.com/photo.jpg',
        lastVisitAt: testDateTime,
        visitCount: 5,
      );
      expect(visitor.visitorId, 'visitor_123');
      expect(visitor.visitorName, 'Visitor');
      expect(visitor.visitCount, 5);
    });

    test('should create RecentVisitor with defaults', () {
      final visitor = RecentVisitor(
        visitorId: 'v1',
        visitorName: 'Visitor',
        lastVisitAt: testDateTime,
      );
      expect(visitor.visitorPhotoUrl, isNull);
      expect(visitor.visitCount, 1);
    });
  });
}
