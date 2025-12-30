import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order.dart';
import '../../truck_list/presentation/truck_provider.dart';
import 'pickup_navigation_screen.dart';

/// 픽업 준비 완료 알림을 듣고 화면을 표시하는 위젯
/// 앱의 상위에 배치하여 전역적으로 주문 상태를 모니터링
class PickupReadyListener extends ConsumerStatefulWidget {
  final Widget child;

  const PickupReadyListener({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<PickupReadyListener> createState() => _PickupReadyListenerState();
}

class _PickupReadyListenerState extends ConsumerState<PickupReadyListener> {
  final Set<String> _notifiedOrderIds = {};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return widget.child;

    // 사용자의 주문 스트림 감시
    final ordersAsync = ref.watch(userOrdersProvider(user.uid));

    ordersAsync.whenData((orders) {
      // 준비 완료된 주문 찾기
      final readyOrders = orders.where(
        (order) => order.status == OrderStatus.ready && !_notifiedOrderIds.contains(order.id),
      );

      for (final order in readyOrders) {
        _notifiedOrderIds.add(order.id);
        // 알림 표시
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showPickupReadyNotification(context, order);
        });
      }
    });

    return widget.child;
  }

  void _showPickupReadyNotification(BuildContext context, Order order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PickupReadyDialog(order: order),
    );
  }
}

/// 픽업 준비 완료 다이얼로그
class _PickupReadyDialog extends ConsumerWidget {
  final Order order;

  const _PickupReadyDialog({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: AppTheme.charcoalMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.mustardYellow.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppTheme.mustardYellow,
                    size: 64,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            '픽업 준비 완료! 🎉',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Order info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.charcoalLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      color: AppTheme.mustardYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.truckName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.items.map((e) => e.menuItemName).join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Message
          const Text(
            '주문하신 음식이 준비되었습니다.\n트럭으로 픽업하러 가세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        // 닫기 버튼
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            '나중에',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        // 길찾기 버튼
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            // 트럭 위치 조회 후 네비게이션 화면으로 이동
            await _navigateToPickup(context, ref);
          },
          icon: const Icon(Icons.navigation, color: Colors.black),
          label: const Text(
            '픽업 경로 안내',
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.electricBlue,
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToPickup(BuildContext context, WidgetRef ref) async {
    // 트럭 위치 조회
    final truckId = order.truckId;
    if (truckId.isEmpty) return;

    try {
      final truckRepo = ref.read(truckRepositoryProvider);
      final truck = await truckRepo.getTruck(truckId);

      if (truck != null && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PickupNavigationScreen(
              truckName: truck.foodType,
              truckAddress: truck.locationDescription,
              truckLat: truck.latitude,
              truckLng: truck.longitude,
              orderId: order.id,
            ),
          ),
        );
      }
    } catch (e) {
      // 에러 시 무시
    }
  }
}

/// 픽업 준비 완료 배너 (주문 목록용)
class PickupReadyBanner extends StatelessWidget {
  final Order order;
  final VoidCallback onNavigateTap;

  const PickupReadyBanner({
    super.key,
    required this.order,
    required this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context) {
    if (order.status != OrderStatus.ready) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.mustardYellow.withValues(alpha: 0.3),
            AppTheme.electricBlue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.mustardYellow.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.mustardYellow.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppTheme.mustardYellow,
                    size: 32,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '픽업 준비 완료!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mustardYellow,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.truckName}에서 주문이 준비되었어요',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Navigate button
          ElevatedButton(
            onPressed: onNavigateTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.electricBlue,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.navigation, size: 18),
                SizedBox(width: 4),
                Text(
                  '픽업',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
