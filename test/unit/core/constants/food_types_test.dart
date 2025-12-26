import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/constants/food_types.dart';

/// Unit tests for FoodTypes constants
///
/// Verifies filter tag lists and utility functions.
void main() {
  group('FoodTypes', () {
    group('filterTags', () {
      test('contains "전체" as first item', () {
        expect(FoodTypes.filterTags.first, '전체');
      });

      test('contains all expected food types', () {
        expect(FoodTypes.filterTags, contains('닭꼬치'));
        expect(FoodTypes.filterTags, contains('호떡'));
        expect(FoodTypes.filterTags, contains('어묵'));
        expect(FoodTypes.filterTags, contains('붕어빵'));
        expect(FoodTypes.filterTags, contains('심야라멘'));
        expect(FoodTypes.filterTags, contains('불막창'));
        expect(FoodTypes.filterTags, contains('크레페퀸'));
        expect(FoodTypes.filterTags, contains('옛날통닭'));
      });

      test('has exactly 9 items (including "전체")', () {
        expect(FoodTypes.filterTags.length, 9);
      });

      test('has no duplicates', () {
        final uniqueTags = FoodTypes.filterTags.toSet();
        expect(uniqueTags.length, FoodTypes.filterTags.length);
      });
    });

    group('defaultFilter', () {
      test('is "전체"', () {
        expect(FoodTypes.defaultFilter, '전체');
      });
    });

    group('isAllFilter()', () {
      test('returns true for "전체"', () {
        expect(FoodTypes.isAllFilter('전체'), true);
      });

      test('returns false for specific food types', () {
        expect(FoodTypes.isAllFilter('닭꼬치'), false);
        expect(FoodTypes.isAllFilter('호떡'), false);
        expect(FoodTypes.isAllFilter('어묵'), false);
      });

      test('returns false for invalid filter', () {
        expect(FoodTypes.isAllFilter('존재하지않음'), false);
      });

      test('is case-sensitive', () {
        expect(FoodTypes.isAllFilter('전 체'), false);
        expect(FoodTypes.isAllFilter('JEONCHE'), false);
      });
    });

    group('actualFoodTypes', () {
      test('excludes "전체"', () {
        expect(FoodTypes.actualFoodTypes, isNot(contains('전체')));
      });

      test('contains only actual food types', () {
        expect(FoodTypes.actualFoodTypes.length, 8);
        expect(FoodTypes.actualFoodTypes, contains('닭꼬치'));
        expect(FoodTypes.actualFoodTypes, contains('옛날통닭'));
      });

      test('is same as filterTags without first element', () {
        final expected = FoodTypes.filterTags.skip(1).toList();
        expect(FoodTypes.actualFoodTypes, expected);
      });
    });
  });
}
