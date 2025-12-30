import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';

part 'ad_service.g.dart';

/// AdMob Ad Unit IDs
class AdUnitIds {
  // 테스트 광고 ID (개발용)
  static const String testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';
  static const String testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';
  static const String testNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String testNativeIos = 'ca-app-pub-3940256099942544/3986624511';

  // 실제 광고 ID (프로덕션용 - AdMob 콘솔에서 발급)
  // TODO: 실제 광고 ID로 교체
  static const String liveBannerAndroid = '';
  static const String liveBannerIos = '';
  static const String liveInterstitialAndroid = '';
  static const String liveInterstitialIos = '';
  static const String liveRewardedAndroid = '';
  static const String liveRewardedIos = '';

  // 현재 환경
  static const bool isProduction = false;

  // Platform-specific banner ID
  static String get bannerId {
    if (kIsWeb) return ''; // Web doesn't support AdMob
    if (isProduction) {
      return Platform.isAndroid ? liveBannerAndroid : liveBannerIos;
    }
    return Platform.isAndroid ? testBannerAndroid : testBannerIos;
  }

  // Platform-specific interstitial ID
  static String get interstitialId {
    if (kIsWeb) return '';
    if (isProduction) {
      return Platform.isAndroid ? liveInterstitialAndroid : liveInterstitialIos;
    }
    return Platform.isAndroid ? testInterstitialAndroid : testInterstitialIos;
  }

  // Platform-specific rewarded ID
  static String get rewardedId {
    if (kIsWeb) return '';
    if (isProduction) {
      return Platform.isAndroid ? liveRewardedAndroid : liveRewardedIos;
    }
    return Platform.isAndroid ? testRewardedAndroid : testRewardedIos;
  }

  // Platform-specific native ID
  static String get nativeId {
    if (kIsWeb) return '';
    if (isProduction) {
      return Platform.isAndroid ? '' : ''; // TODO: Add native ad IDs
    }
    return Platform.isAndroid ? testNativeAndroid : testNativeIos;
  }
}

/// Service for managing ads
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _interstitialLoadAttempts = 0;
  int _rewardedLoadAttempts = 0;
  static const int _maxLoadAttempts = 3;

  /// Initialize Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      AppLogger.success('AdMob initialized', tag: 'AdService');

      // Pre-load interstitial and rewarded ads
      _loadInterstitialAd();
      _loadRewardedAd();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize AdMob', error: e, stackTrace: stackTrace, tag: 'AdService');
    }
  }

  /// Check if ads are available
  bool get isAvailable => _isInitialized && !kIsWeb;

  // ═══════════════════════════════════════════════════════════
  // INTERSTITIAL ADS (전면 광고)
  // ═══════════════════════════════════════════════════════════

  void _loadInterstitialAd() {
    if (!isAvailable) return;

    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          AppLogger.debug('Interstitial ad loaded', tag: 'AdService');
        },
        onAdFailedToLoad: (error) {
          _interstitialLoadAttempts++;
          _interstitialAd = null;
          AppLogger.warning('Interstitial ad failed to load: ${error.message}', tag: 'AdService');

          if (_interstitialLoadAttempts < _maxLoadAttempts) {
            _loadInterstitialAd();
          }
        },
      ),
    );
  }

  /// Show interstitial ad
  /// Returns true if ad was shown, false otherwise
  Future<bool> showInterstitialAd({
    VoidCallback? onAdDismissed,
  }) async {
    if (_interstitialAd == null) {
      AppLogger.debug('Interstitial ad not ready', tag: 'AdService');
      _loadInterstitialAd();
      return false;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd(); // Pre-load next ad
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        AppLogger.warning('Interstitial ad failed to show: ${error.message}', tag: 'AdService');
      },
    );

    await _interstitialAd!.show();
    return true;
  }

  /// Check if interstitial ad is ready
  bool get isInterstitialReady => _interstitialAd != null;

  // ═══════════════════════════════════════════════════════════
  // REWARDED ADS (보상형 광고)
  // ═══════════════════════════════════════════════════════════

  void _loadRewardedAd() {
    if (!isAvailable) return;

    RewardedAd.load(
      adUnitId: AdUnitIds.rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
          AppLogger.debug('Rewarded ad loaded', tag: 'AdService');
        },
        onAdFailedToLoad: (error) {
          _rewardedLoadAttempts++;
          _rewardedAd = null;
          AppLogger.warning('Rewarded ad failed to load: ${error.message}', tag: 'AdService');

          if (_rewardedLoadAttempts < _maxLoadAttempts) {
            _loadRewardedAd();
          }
        },
      ),
    );
  }

  /// Show rewarded ad
  /// [onRewardEarned] is called when user earns the reward
  /// Returns true if ad was shown, false otherwise
  Future<bool> showRewardedAd({
    required void Function(int amount, String type) onRewardEarned,
    VoidCallback? onAdDismissed,
  }) async {
    if (_rewardedAd == null) {
      AppLogger.debug('Rewarded ad not ready', tag: 'AdService');
      _loadRewardedAd();
      return false;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd(); // Pre-load next ad
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
        AppLogger.warning('Rewarded ad failed to show: ${error.message}', tag: 'AdService');
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        AppLogger.success('User earned reward: ${reward.amount} ${reward.type}', tag: 'AdService');
        onRewardEarned(reward.amount.toInt(), reward.type);
      },
    );
    return true;
  }

  /// Check if rewarded ad is ready
  bool get isRewardedReady => _rewardedAd != null;

  // ═══════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}

// ═══════════════════════════════════════════════════════════
// PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
AdService adService(Ref ref) {
  final service = AdService();
  ref.onDispose(() => service.dispose());
  return service;
}
