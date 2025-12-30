import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../truck_detail/domain/menu_item.dart';
import '../../../truck_detail/presentation/truck_detail_provider.dart';

/// 품절 토글 위젯
class OwnerSoldOutToggles extends ConsumerWidget {
  final String truckId;

  const OwnerSoldOutToggles({super.key, required this.truckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(truckDetailStreamProvider(truckId));

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '메뉴 관리',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          detailAsync.when(
            data: (detail) {
              if (detail == null || detail.menuItems.isEmpty) {
                return const Text(
                  '등록된 메뉴가 없습니다',
                  style: TextStyle(color: Colors.white70),
                );
              }

              return Column(
                children: detail.menuItems.map((item) {
                  return _MenuItemTile(
                    item: item,
                    truckId: truckId,
                  );
                }).toList(),
              );
            },
            loading: () =>
                const CircularProgressIndicator(color: AppTheme.mustardYellow),
            error: (error, stackTrace) => const Text(
              '메뉴 로딩 실패',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends ConsumerWidget {
  final MenuItem item;
  final String truckId;

  const _MenuItemTile({
    required this.item,
    required this.truckId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isSoldOut ? AppTheme.red50 : AppTheme.mustardYellow30,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: item.isSoldOut ? Colors.grey[600] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration:
                        item.isSoldOut ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${item.price}',
                  style: TextStyle(
                    color:
                        item.isSoldOut ? Colors.grey[700] : AppTheme.mustardYellow,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: !item.isSoldOut,
            onChanged: (value) => _toggleSoldOut(ref),
            activeTrackColor: AppTheme.mustardYellow.withAlpha(128),
            inactiveThumbColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSoldOut(WidgetRef ref) async {
    final detailProvider = ref.read(truckDetailProvider(truckId).notifier);
    await detailProvider.toggleMenuItemSoldOut(item.id);
  }
}
