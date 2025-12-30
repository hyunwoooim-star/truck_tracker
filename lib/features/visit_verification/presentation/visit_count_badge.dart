import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../data/visit_verification_repository.dart';

/// 트럭의 방문 인증 횟수를 표시하는 배지
/// 트럭 카드 또는 상세 화면에서 사용
class VisitCountBadge extends ConsumerWidget {
  final String truckId;
  final bool showLabel;
  final double iconSize;
  final double fontSize;

  const VisitCountBadge({
    super.key,
    required this.truckId,
    this.showLabel = true,
    this.iconSize = 16,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitCountAsync = ref.watch(truckVisitCountProvider(truckId));

    return visitCountAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
      data: (count) {
        if (count == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getBadgeColor(count).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBadgeColor(count).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getBadgeIcon(count),
                size: iconSize,
                color: _getBadgeColor(count),
              ),
              const SizedBox(width: 4),
              Text(
                showLabel ? '$count명 인증' : '$count',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: _getBadgeColor(count),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBadgeColor(int count) {
    if (count >= 100) return Colors.purple;
    if (count >= 50) return Colors.orange;
    if (count >= 20) return AppTheme.mustardYellow;
    if (count >= 10) return AppTheme.electricBlue;
    return Colors.grey[400]!;
  }

  IconData _getBadgeIcon(int count) {
    if (count >= 100) return Icons.local_fire_department;
    if (count >= 50) return Icons.verified;
    if (count >= 20) return Icons.thumb_up;
    if (count >= 10) return Icons.people;
    return Icons.person;
  }
}

/// 트럭 상세 화면용 확장 방문 정보 위젯
class VisitInfoSection extends ConsumerWidget {
  final String truckId;

  const VisitInfoSection({
    super.key,
    required this.truckId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitCountAsync = ref.watch(truckVisitCountProvider(truckId));
    final recentVisitsAsync = ref.watch(truckRecentVisitsProvider(truckId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            const Icon(
              Icons.verified_user,
              color: AppTheme.mustardYellow,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '방문 인증',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            visitCountAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
              data: (count) => Text(
                '총 $count회',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 최근 방문자
        recentVisitsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (e, s) => const SizedBox.shrink(),
          data: (visits) {
            if (visits.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 40,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '아직 방문 인증이 없어요',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '첫 번째 인증자가 되어보세요!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '최근 방문자',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 방문자 아바타 목록
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: visits.length > 10 ? 10 : visits.length,
                      itemBuilder: (context, index) {
                        final visit = visits[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < visits.length - 1 ? 8 : 0,
                          ),
                          child: Tooltip(
                            message: visit.visitorName,
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey[800],
                              backgroundImage: visit.visitorPhotoUrl != null
                                  ? NetworkImage(visit.visitorPhotoUrl!)
                                  : null,
                              child: visit.visitorPhotoUrl == null
                                  ? Text(
                                      visit.visitorName.isNotEmpty
                                          ? visit.visitorName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (visits.length > 10) ...[
                    const SizedBox(height: 8),
                    Text(
                      '+${visits.length - 10}명 더',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
