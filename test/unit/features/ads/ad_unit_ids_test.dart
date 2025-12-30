import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/ads/data/ad_service.dart';

void main() {
  group('AdUnitIds', () {
    group('Test Ad IDs', () {
      test('should have valid Android test banner ID', () {
        expect(AdUnitIds.testBannerAndroid, isNotEmpty);
        expect(AdUnitIds.testBannerAndroid, startsWith('ca-app-pub-'));
      });

      test('should have valid iOS test banner ID', () {
        expect(AdUnitIds.testBannerIos, isNotEmpty);
        expect(AdUnitIds.testBannerIos, startsWith('ca-app-pub-'));
      });

      test('should have valid Android test interstitial ID', () {
        expect(AdUnitIds.testInterstitialAndroid, isNotEmpty);
        expect(AdUnitIds.testInterstitialAndroid, startsWith('ca-app-pub-'));
      });

      test('should have valid iOS test interstitial ID', () {
        expect(AdUnitIds.testInterstitialIos, isNotEmpty);
        expect(AdUnitIds.testInterstitialIos, startsWith('ca-app-pub-'));
      });

      test('should have valid Android test rewarded ID', () {
        expect(AdUnitIds.testRewardedAndroid, isNotEmpty);
        expect(AdUnitIds.testRewardedAndroid, startsWith('ca-app-pub-'));
      });

      test('should have valid iOS test rewarded ID', () {
        expect(AdUnitIds.testRewardedIos, isNotEmpty);
        expect(AdUnitIds.testRewardedIos, startsWith('ca-app-pub-'));
      });

      test('should have valid Android test native ID', () {
        expect(AdUnitIds.testNativeAndroid, isNotEmpty);
        expect(AdUnitIds.testNativeAndroid, startsWith('ca-app-pub-'));
      });

      test('should have valid iOS test native ID', () {
        expect(AdUnitIds.testNativeIos, isNotEmpty);
        expect(AdUnitIds.testNativeIos, startsWith('ca-app-pub-'));
      });
    });

    group('Production flag', () {
      test('should be false by default (development mode)', () {
        expect(AdUnitIds.isProduction, isFalse);
      });
    });

    group('Live Ad IDs (placeholder)', () {
      test('live banner IDs should be empty until production setup', () {
        expect(AdUnitIds.liveBannerAndroid, isEmpty);
        expect(AdUnitIds.liveBannerIos, isEmpty);
      });

      test('live interstitial IDs should be empty until production setup', () {
        expect(AdUnitIds.liveInterstitialAndroid, isEmpty);
        expect(AdUnitIds.liveInterstitialIos, isEmpty);
      });

      test('live rewarded IDs should be empty until production setup', () {
        expect(AdUnitIds.liveRewardedAndroid, isEmpty);
        expect(AdUnitIds.liveRewardedIos, isEmpty);
      });
    });

    group('Test ID Format', () {
      test('all test IDs should use Google test publisher ID', () {
        const testPublisherId = 'ca-app-pub-3940256099942544';

        expect(AdUnitIds.testBannerAndroid, startsWith(testPublisherId));
        expect(AdUnitIds.testBannerIos, startsWith(testPublisherId));
        expect(AdUnitIds.testInterstitialAndroid, startsWith(testPublisherId));
        expect(AdUnitIds.testInterstitialIos, startsWith(testPublisherId));
        expect(AdUnitIds.testRewardedAndroid, startsWith(testPublisherId));
        expect(AdUnitIds.testRewardedIos, startsWith(testPublisherId));
        expect(AdUnitIds.testNativeAndroid, startsWith(testPublisherId));
        expect(AdUnitIds.testNativeIos, startsWith(testPublisherId));
      });
    });
  });
}
