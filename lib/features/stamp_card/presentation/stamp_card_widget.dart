import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../ads/data/ad_service.dart';
import '../data/stamp_card_repository.dart';
import '../domain/stamp_card.dart';

/// 스탬프 카드 위젯 (트럭 상세 화면용)
class StampCardWidget extends ConsumerWidget {
  final String truckId;
  final String truckName;

  const StampCardWidget({
    super.key,
    required this.truckId,
    required this.truckName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildLoginPrompt();
    }

    final stampCardAsync = ref.watch(userStampCardProvider(user.uid, truckId));

    return stampCardAsync.when(
      loading: () => _buildLoadingCard(),
      error: (e, s) => const SizedBox.shrink(),
      data: (stampCard) => _buildStampCard(context, stampCard),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: Colors.grey[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '로그인하고 스탬프를 모아보세요!',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildStampCard(BuildContext context, StampCard? stampCard) {
    final stampCount = stampCard?.stampCount ?? 0;
    final completedCards = stampCard?.completedCards ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900]!,
            Colors.grey[850] ?? Colors.grey[800]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.mustardYellow.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.mustardYellow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.mustardYellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: AppTheme.mustardYellow,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '스탬프 카드',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (completedCards > 0)
                      Text(
                        '완료 $completedCards장',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.mustardYellow,
                        ),
                      ),
                  ],
                ),
              ),
              // 진행률 텍스트
              Text(
                '$stampCount / ${StampCard.maxStamps}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mustardYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 스탬프 그리드
          _buildStampGrid(stampCount),

          const SizedBox(height: 12),

          // 진행 바
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stampCount / StampCard.maxStamps,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation(AppTheme.mustardYellow),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 12),

          // 안내 텍스트
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  stampCount >= StampCard.maxStamps
                      ? '축하해요! 쿠폰을 획득했어요! 🎉'
                      : '${StampCard.maxStamps - stampCount}개 더 모으면 무료 쿠폰!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),

          // 보상형 광고로 보너스 스탬프 받기
          if (!kIsWeb && stampCount < StampCard.maxStamps) ...[
            const SizedBox(height: 12),
            _BonusStampAdButton(truckId: truckId, truckName: truckName),
          ],
        ],
      ),
    );
  }

  Widget _buildStampGrid(int stampCount) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(StampCard.maxStamps, (index) {
        final isStamped = index < stampCount;
        return _buildStampSlot(index + 1, isStamped);
      }),
    );
  }

  Widget _buildStampSlot(int number, bool isStamped) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isStamped
            ? AppTheme.mustardYellow
            : Colors.grey[800],
        shape: BoxShape.circle,
        border: Border.all(
          color: isStamped
              ? AppTheme.mustardYellow
              : Colors.grey[700]!,
          width: 2,
        ),
        boxShadow: isStamped
            ? [
                BoxShadow(
                  color: AppTheme.mustardYellow.withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isStamped
            ? const Icon(
                Icons.check,
                color: Colors.black,
                size: 18,
              )
            : Text(
                '$number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
      ),
    );
  }
}

/// 미니 스탬프 배지 (트럭 카드용)
class StampBadge extends ConsumerWidget {
  final String truckId;

  const StampBadge({
    super.key,
    required this.truckId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final stampCardAsync = ref.watch(userStampCardProvider(user.uid, truckId));

    return stampCardAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
      data: (stampCard) {
        if (stampCard == null || stampCard.stampCount == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.mustardYellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.mustardYellow.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.card_giftcard,
                size: 14,
                color: AppTheme.mustardYellow,
              ),
              const SizedBox(width: 4),
              Text(
                '${stampCard.stampCount}/${StampCard.maxStamps}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.mustardYellow,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 보상형 광고로 보너스 스탬프 받기 버튼
class _BonusStampAdButton extends ConsumerStatefulWidget {
  final String truckId;
  final String truckName;

  const _BonusStampAdButton({
    required this.truckId,
    required this.truckName,
  });

  @override
  ConsumerState<_BonusStampAdButton> createState() => _BonusStampAdButtonState();
}

class _BonusStampAdButtonState extends ConsumerState<_BonusStampAdButton> {
  bool _isLoading = false;

  Future<void> _watchAdForBonusStamp() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    final adService = ref.read(adServiceProvider);

    final shown = await adService.showRewardedAd(
      onRewardEarned: (amount, type) async {
        // 광고 시청 완료 - 보너스 스탬프 지급
        try {
          final repository = ref.read(stampCardRepositoryProvider);
          await repository.addBonusStamp(
            userId: user.uid,
            truckId: widget.truckId,
            truckName: widget.truckName,
          );

          if (mounted) {
            SnackBarHelper.showSuccess(context, '보너스 스탬프 1개를 받았어요! 🎉');
          }
        } catch (e) {
          if (mounted) {
            SnackBarHelper.showError(context, '스탬프 지급에 실패했습니다');
          }
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
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _watchAdForBonusStamp,
        icon: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.electricBlue,
                ),
              )
            : const Icon(Icons.play_circle_outline, size: 18),
        label: Text(
          _isLoading ? '광고 로딩 중...' : '광고 보고 보너스 스탬프 받기',
          style: const TextStyle(fontSize: 12),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.electricBlue,
          side: BorderSide(
            color: AppTheme.electricBlue.withValues(alpha: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
