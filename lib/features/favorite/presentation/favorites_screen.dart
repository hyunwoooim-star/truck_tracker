import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../shared/widgets/status_tag.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../data/favorite_repository.dart';

/// 즐겨찾기한 트럭 목록 화면
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('내 즐겨찾기')),
        body: const Center(
          child: Text('로그인이 필요합니다', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final favoriteTruckIdsAsync = ref.watch(userFavoritesProvider(userId));
    final allTrucksAsync = ref.watch(firestoreTruckStreamProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('내 즐겨찾기'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.electricBlue,
      ),
      body: favoriteTruckIdsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('오류: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (favoriteIds) {
          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    '아직 즐겨찾기한 트럭이 없습니다',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '트럭 목록에서 ♥를 눌러 추가하세요',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return allTrucksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('오류: $e', style: const TextStyle(color: Colors.red)),
            ),
            data: (allTrucks) {
              final favoriteTrucks = allTrucks
                  .where((truck) => favoriteIds.contains(truck.id))
                  .toList();

              if (favoriteTrucks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        '즐겨찾기한 트럭을 찾을 수 없습니다',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteTrucks.length,
                itemBuilder: (context, index) {
                  final truck = favoriteTrucks[index];
                  return _FavoriteTruckCard(truck: truck);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteTruckCard extends StatelessWidget {
  final Truck truck;

  const _FavoriteTruckCard({required this.truck});

  @override
  Widget build(BuildContext context) {
    final isClosed = truck.status == TruckStatus.maintenance;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.charcoalMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isClosed ? Colors.grey : AppTheme.electricBlue,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TruckDetailScreen(truck: truck)),
          );
        },
        child: Opacity(
          opacity: isClosed ? 0.6 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 트럭 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: truck.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: AppTheme.charcoalLight,
                      child: const Icon(Icons.local_shipping, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      color: AppTheme.charcoalLight,
                      child: const Icon(Icons.local_shipping, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 트럭 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              truck.truckNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StatusTag(status: truck.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        truck.foodType,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              truck.locationDescription,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 즐겨찾기 아이콘
                const Icon(Icons.favorite, color: Colors.red, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
