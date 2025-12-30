import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../core/themes/app_theme.dart';
import '../../data/ad_service.dart';

/// Reusable banner ad widget
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (kIsWeb) return; // Web doesn't support AdMob

    _bannerAd = BannerAd(
      adUnitId: AdUnitIds.bannerId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner ad failed to load: ${error.message}');
        },
        onAdOpened: (ad) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('Banner ad closed');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show on web
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    // Show placeholder while loading
    if (!_isLoaded || _bannerAd == null) {
      return Container(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        color: AppTheme.charcoalMedium,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.textTertiary,
            ),
          ),
        ),
      );
    }

    return Container(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

/// Adaptive banner that fills the width of the screen
class AdaptiveBannerAdWidget extends StatefulWidget {
  const AdaptiveBannerAdWidget({super.key});

  @override
  State<AdaptiveBannerAdWidget> createState() => _AdaptiveBannerAdWidgetState();
}

class _AdaptiveBannerAdWidgetState extends State<AdaptiveBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    if (kIsWeb || _bannerAd != null) return;

    // Get the adaptive banner size
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      debugPrint('Unable to get adaptive banner size');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdUnitIds.bannerId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Adaptive banner ad failed to load: ${error.message}');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _bannerAd == null) {
      return Container(
        width: double.infinity,
        height: 50,
        color: AppTheme.charcoalMedium,
      );
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
