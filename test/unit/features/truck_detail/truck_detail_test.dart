import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_detail/domain/truck_detail.dart';
import 'package:truck_tracker/features/truck_detail/domain/menu_item.dart';
import 'package:truck_tracker/features/review/domain/review.dart';

void main() {
  group('TruckDetail Model', () {
    late TruckDetail truckDetail;
    late List<MenuItem> testMenuItems;
    late List<Review> testReviews;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2025, 12, 31, 12, 0, 0);
      testMenuItems = [
        const MenuItem(
          id: 'menu_1',
          name: 'Tteokbokki',
          price: 5000,
          description: 'Spicy rice cake',
        ),
        const MenuItem(
          id: 'menu_2',
          name: 'Sundae',
          price: 4000,
          description: 'Korean sausage',
        ),
      ];
      testReviews = [
        Review(
          id: 'review_1',
          truckId: 'truck_123',
          userId: 'user_1',
          userName: 'User1',
          rating: 5,
          content: 'Great food!',
          createdAt: testDateTime,
        ),
      ];
      truckDetail = TruckDetail(
        truckId: 'truck_123',
        operatingHours: '10:00 - 22:00',
        menuItems: testMenuItems,
        reviews: testReviews,
        averageRating: 4.8,
        description: 'Best food truck in town',
      );
    });

    test('should create TruckDetail with all fields', () {
      expect(truckDetail.truckId, 'truck_123');
      expect(truckDetail.operatingHours, '10:00 - 22:00');
      expect(truckDetail.menuItems.length, 2);
      expect(truckDetail.reviews.length, 1);
      expect(truckDetail.averageRating, 4.8);
      expect(truckDetail.description, 'Best food truck in town');
    });

    test('should create TruckDetail with default values', () {
      final minimal = TruckDetail(
        truckId: 't1',
        operatingHours: '09:00 - 18:00',
        menuItems: const [],
        reviews: const [],
      );

      expect(minimal.averageRating, 4.5); // default
      expect(minimal.description, ''); // default
    });

    group('menuItems', () {
      test('should contain correct menu items', () {
        expect(truckDetail.menuItems[0].name, 'Tteokbokki');
        expect(truckDetail.menuItems[1].name, 'Sundae');
      });

      test('should handle empty menu list', () {
        final noMenu = truckDetail.copyWith(menuItems: const []);
        expect(noMenu.menuItems, isEmpty);
      });

      test('should update menu items with copyWith', () {
        final newMenu = [
          const MenuItem(
            id: 'menu_3',
            name: 'Ramen',
            price: 6000,
          ),
        ];
        final updated = truckDetail.copyWith(menuItems: newMenu);
        expect(updated.menuItems.length, 1);
        expect(updated.menuItems[0].name, 'Ramen');
      });
    });

    group('reviews', () {
      test('should contain correct reviews', () {
        expect(truckDetail.reviews[0].rating, 5);
        expect(truckDetail.reviews[0].content, 'Great food!');
      });

      test('should handle empty reviews list', () {
        final noReviews = truckDetail.copyWith(reviews: const []);
        expect(noReviews.reviews, isEmpty);
      });
    });

    group('averageRating', () {
      test('should default to 4.5', () {
        final noRating = TruckDetail(
          truckId: 't1',
          operatingHours: '09:00 - 18:00',
          menuItems: const [],
          reviews: const [],
        );
        expect(noRating.averageRating, 4.5);
      });

      test('should update with copyWith', () {
        final updated = truckDetail.copyWith(averageRating: 3.5);
        expect(updated.averageRating, 3.5);
      });

      test('should handle perfect rating', () {
        final perfect = truckDetail.copyWith(averageRating: 5.0);
        expect(perfect.averageRating, 5.0);
      });

      test('should handle low rating', () {
        final low = truckDetail.copyWith(averageRating: 1.0);
        expect(low.averageRating, 1.0);
      });
    });

    group('operatingHours', () {
      test('should store operating hours string', () {
        expect(truckDetail.operatingHours, '10:00 - 22:00');
      });

      test('should update with copyWith', () {
        final updated = truckDetail.copyWith(operatingHours: '11:00 - 21:00');
        expect(updated.operatingHours, '11:00 - 21:00');
      });

      test('should handle 24 hour format', () {
        final late = truckDetail.copyWith(operatingHours: '18:00 - 02:00');
        expect(late.operatingHours, '18:00 - 02:00');
      });
    });

    group('description', () {
      test('should default to empty string', () {
        final noDesc = TruckDetail(
          truckId: 't1',
          operatingHours: '09:00 - 18:00',
          menuItems: const [],
          reviews: const [],
        );
        expect(noDesc.description, '');
      });

      test('should store description', () {
        expect(truckDetail.description, 'Best food truck in town');
      });

      test('should update with copyWith', () {
        final updated = truckDetail.copyWith(description: 'New description');
        expect(updated.description, 'New description');
      });
    });

    group('toFirestore', () {
      test('should convert TruckDetail to Map correctly', () {
        final firestoreMap = truckDetail.toFirestore();

        expect(firestoreMap['operatingHours'], '10:00 - 22:00');
        expect(firestoreMap['averageRating'], 4.8);
        expect(firestoreMap['description'], 'Best food truck in town');
        expect(firestoreMap['menuItems'], isA<List>());
        expect(firestoreMap['reviews'], isA<List>());
      });

      test('should not include truckId in Firestore map', () {
        final firestoreMap = truckDetail.toFirestore();
        expect(firestoreMap.containsKey('truckId'), isFalse);
      });

      test('should serialize menuItems correctly', () {
        final firestoreMap = truckDetail.toFirestore();
        final menuList = firestoreMap['menuItems'] as List;
        expect(menuList.length, 2);
      });

      test('should serialize reviews correctly', () {
        final firestoreMap = truckDetail.toFirestore();
        final reviewList = firestoreMap['reviews'] as List;
        expect(reviewList.length, 1);
      });
    });

    group('copyWith', () {
      test('should create copy with updated truckId', () {
        final updated = truckDetail.copyWith(truckId: 'new_truck');
        expect(updated.truckId, 'new_truck');
        expect(updated.operatingHours, truckDetail.operatingHours);
      });

      test('should create copy with all fields unchanged when no args', () {
        final copy = truckDetail.copyWith();
        expect(copy.truckId, truckDetail.truckId);
        expect(copy.operatingHours, truckDetail.operatingHours);
        expect(copy.averageRating, truckDetail.averageRating);
      });
    });

    group('fromJson', () {
      test('should create TruckDetail from JSON', () {
        final json = {
          'truckId': 'truck_456',
          'operatingHours': '08:00 - 20:00',
          'menuItems': <Map<String, dynamic>>[],
          'reviews': <Map<String, dynamic>>[],
          'averageRating': 4.2,
          'description': 'Test truck',
        };

        final fromJson = TruckDetail.fromJson(json);
        expect(fromJson.truckId, 'truck_456');
        expect(fromJson.operatingHours, '08:00 - 20:00');
        expect(fromJson.averageRating, 4.2);
      });
    });
  });
}
