import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../data/ad_service.dart';

/// Button to watch rewarded ad for bonus rewards
class RewardedAdButton extends ConsumerStatefulWidget {
  const RewardedAdButton({
    super.key,
    required this.onRewardEarned,
    this.rewardDescription = '보너스 스탬프 1개',
    this.buttonText = '광고 보고 보상 받기',
    this.icon = Icons.play_circle_outline,
  });

  final void Function(int amount, String type) onRewardEarned;
  final String rewardDescription;
  final String buttonText;
  final IconData icon;

  @override
  ConsumerState<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends ConsumerState<RewardedAdButton> {
  bool _isLoading = false;

  Future<void> _showRewardedAd() async {
    if (kIsWeb) {
      SnackBarHelper.showInfo(context, '모바일 앱에서 이용 가능합니다');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final adService = ref.read(adServiceProvider);

    final shown = await adService.showRewardedAd(
      onRewardEarned: (amount, type) {
        widget.onRewardEarned(amount, type);
        if (mounted) {
          SnackBarHelper.showSuccess(context, '보상을 받았습니다! 🎉');
        }
      },
      onAdDismissed: () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );

    if (!shown && mounted) {
      setState(() {
        _isLoading = false;
      });
      SnackBarHelper.showInfo(context, '광고를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show on web
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.electricBlue.withValues(alpha: 0.15),
            AppTheme.mustardYellow.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.electricBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.card_giftcard,
                  color: AppTheme.electricBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '무료 보상',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.rewardDescription,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _showRewardedAd,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Icon(widget.icon, size: 20),
              label: Text(
                _isLoading ? '광고 로딩 중...' : widget.buttonText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact rewarded ad button (for inline use)
class CompactRewardedAdButton extends ConsumerWidget {
  const CompactRewardedAdButton({
    super.key,
    required this.onRewardEarned,
    this.label = '광고 보기',
  });

  final void Function(int amount, String type) onRewardEarned;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    return TextButton.icon(
      onPressed: () async {
        final adService = ref.read(adServiceProvider);
        final shown = await adService.showRewardedAd(
          onRewardEarned: onRewardEarned,
        );

        if (!shown && context.mounted) {
          SnackBarHelper.showInfo(context, '광고를 불러오는 중입니다');
        }
      },
      icon: const Icon(Icons.play_circle_outline, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.electricBlue,
      ),
    );
  }
}
