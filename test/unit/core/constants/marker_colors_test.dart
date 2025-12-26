import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:truck_tracker/core/constants/marker_colors.dart';

/// Unit tests for MarkerColors
///
/// Verifies food type to marker hue mappings for Google Maps.
void main() {
  group('MarkerColors', () {
    group('foodTypeHues', () {
      test('contains all expected food types', () {
        expect(MarkerColors.foodTypeHues, containsPair('닭꼬치', anything));
        expect(MarkerColors.foodTypeHues, containsPair('호떡', anything));
        expect(MarkerColors.foodTypeHues, containsPair('어묵', anything));
        expect(MarkerColors.foodTypeHues, containsPair('붕어빵', anything));
        expect(MarkerColors.foodTypeHues, containsPair('심야라멘', anything));
        expect(MarkerColors.foodTypeHues, containsPair('불막창', anything));
        expect(MarkerColors.foodTypeHues, containsPair('크레페퀸', anything));
        expect(MarkerColors.foodTypeHues, containsPair('옛날통닭', anything));
      });

      test('has exactly 8 mappings', () {
        expect(MarkerColors.foodTypeHues.length, 8);
      });

      test('maps 닭꼬치 to red', () {
        expect(MarkerColors.foodTypeHues['닭꼬치'], BitmapDescriptor.hueRed);
      });

      test('maps 호떡 to orange', () {
        expect(MarkerColors.foodTypeHues['호떡'], BitmapDescriptor.hueOrange);
      });

      test('maps 어묵 and 붕어빵 to yellow', () {
        expect(MarkerColors.foodTypeHues['어묵'], BitmapDescriptor.hueYellow);
        expect(MarkerColors.foodTypeHues['붕어빵'], BitmapDescriptor.hueYellow);
      });

      test('maps 심야라멘 to violet', () {
        expect(MarkerColors.foodTypeHues['심야라멘'], BitmapDescriptor.hueViolet);
      });

      test('maps 크레페퀸 to magenta', () {
        expect(MarkerColors.foodTypeHues['크레페퀸'], BitmapDescriptor.hueMagenta);
      });

      test('maps 불막창 to rose', () {
        expect(MarkerColors.foodTypeHues['불막창'], BitmapDescriptor.hueRose);
      });

      test('maps 옛날통닭 to green', () {
        expect(MarkerColors.foodTypeHues['옛날통닭'], BitmapDescriptor.hueGreen);
      });

      test('all hues are valid (0-360)', () {
        for (final hue in MarkerColors.foodTypeHues.values) {
          expect(hue, greaterThanOrEqualTo(0.0));
          expect(hue, lessThanOrEqualTo(360.0));
        }
      });
    });

    group('defaultHue', () {
      test('is cyan (175.0)', () {
        expect(MarkerColors.defaultHue, 175.0);
      });

      test('is within valid hue range', () {
        expect(MarkerColors.defaultHue, greaterThanOrEqualTo(0.0));
        expect(MarkerColors.defaultHue, lessThanOrEqualTo(360.0));
      });
    });

    group('getHue()', () {
      test('returns correct hue for registered food type', () {
        expect(
          MarkerColors.getHue('닭꼬치'),
          BitmapDescriptor.hueRed,
        );
        expect(
          MarkerColors.getHue('호떡'),
          BitmapDescriptor.hueOrange,
        );
        expect(
          MarkerColors.getHue('심야라멘'),
          BitmapDescriptor.hueViolet,
        );
      });

      test('returns defaultHue for unregistered food type', () {
        expect(MarkerColors.getHue('피자'), MarkerColors.defaultHue);
        expect(MarkerColors.getHue('햄버거'), MarkerColors.defaultHue);
        expect(MarkerColors.getHue('Unknown'), MarkerColors.defaultHue);
      });

      test('returns defaultHue for empty string', () {
        expect(MarkerColors.getHue(''), MarkerColors.defaultHue);
      });

      test('is case-sensitive', () {
        // '닭꼬치' (correct case) should return red
        expect(MarkerColors.getHue('닭꼬치'), BitmapDescriptor.hueRed);

        // '닭 꼬치' (space) should return default
        expect(MarkerColors.getHue('닭 꼬치'), MarkerColors.defaultHue);
      });

      test('returns consistent hue for same input', () {
        final hue1 = MarkerColors.getHue('닭꼬치');
        final hue2 = MarkerColors.getHue('닭꼬치');
        expect(hue1, hue2);
      });
    });
  });
}
