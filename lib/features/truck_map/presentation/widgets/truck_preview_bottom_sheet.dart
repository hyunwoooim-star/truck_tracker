import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/food_types.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/widgets/status_tag.dart';
import '../../../truck_detail/presentation/truck_detail_screen.dart';
import '../../../truck_list/domain/truck.dart';

/// 지도에서 트럭 마커/카드 클릭 시 표시되는 미리보기 바텀시트
class TruckPreviewBottomSheet extends StatelessWidget {
  const TruckPreviewBottomSheet({
    super.key,
    required this.truck,
    this.distanceText,
  });

  final Truck truck;
  final String? distanceText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 트럭 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: truck.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    memCacheHeight: 200,
                    memCacheWidth: 200,
                    placeholder: (context, url) => Container(
                      color: AppTheme.charcoalMedium,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.charcoalMedium,
                      child: const Icon(
                        Icons.local_shipping,
                        size: 40,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 트럭 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 음식 종류 (강조) + 상태
                      Row(
                        children: [
                          Text(
                            FoodTypes.getEmoji(truck.foodType),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              truck.foodType,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.mustardYellow,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // 트럭명
                      Text(
                        truck.truckNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 상태 + 거리
                      Row(
                        children: [
                          StatusTag(status: truck.status),
                          if (distanceText != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.electricBlue20,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.near_me,
                                    size: 14,
                                    color: AppTheme.electricBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    distanceText!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.electricBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 위치 설명
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              truck.locationDescription,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 상점 보기 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 바텀시트 닫기
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TruckDetailScreen(truck: truck),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.mustardYellow,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.storefront, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '상세보기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
