import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../location/location_service.dart';
import '../../../order/data/order_repository.dart';
import '../../../order/domain/order.dart';
import '../../../truck_list/domain/truck.dart';
import '../../../truck_list/presentation/truck_provider.dart';
import '../owner_status_provider.dart';

/// GPS 영업 시작 버튼
class OwnerGpsButton extends ConsumerWidget {
  final Truck truck;

  const OwnerGpsButton({super.key, required this.truck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOperating = ref.watch(ownerOperatingStatusProvider);
    final locationService = LocationService();

    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          if (isOperating) {
            _showCloseBusinessDialog(context, ref);
            return;
          }

          try {
            final position = await locationService.getCurrentPosition();
            if (position == null) {
              throw Exception('GPS 위치를 가져올 수 없습니다');
            }

            final repository = ref.read(truckRepositoryProvider);
            await repository.openForBusiness(
              truck.id,
              position.latitude,
              position.longitude,
            );

            await ref.read(ownerOperatingStatusProvider.notifier).setStatus(true);

            if (context.mounted) {
              SnackBarHelper.showSuccess(context, '영업을 시작했습니다! 고객에게 알림이 전송되었습니다.');
            }
          } catch (e) {
            if (context.mounted) {
              SnackBarHelper.showError(context, '오류: $e');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.mustardYellow,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 20),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.my_location, size: 28, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              isOperating ? '영업 중' : '영업 시작',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCloseBusinessDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text('영업 종료', style: TextStyle(color: Colors.white)),
        content: const Text('영업을 종료하시겠습니까?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final repository = ref.read(truckRepositoryProvider);
                await repository.updateStatus(truck.id, TruckStatus.maintenance);
                await ref
                    .read(ownerOperatingStatusProvider.notifier)
                    .setStatus(false);
                if (context.mounted) {
                  SnackBarHelper.showInfo(context, '영업이 종료되었습니다');
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '오류: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('영업 종료'),
          ),
        ],
      ),
    );
  }
}

/// 현금 매출 입력 버튼
class OwnerCashSaleButton extends ConsumerWidget {
  final Truck truck;

  const OwnerCashSaleButton({super.key, required this.truck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () => _showCashSaleDialog(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '현금 매출 입력',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showCashSaleDialog(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();
    final itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        title: const Text('현금 매출 입력',
            style: TextStyle(color: AppTheme.mustardYellow)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: const InputDecoration(
                labelText: '메뉴명',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '금액',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.mustardYellow),
            onPressed: () async {
              final amount = int.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                SnackBarHelper.showWarning(context, '올바른 금액을 입력하세요');
                return;
              }

              final currentUser = ref.read(currentUserProvider);
              final order = Order(
                id: '',
                userId: currentUser?.uid ?? 'unknown',
                userName: currentUser?.displayName ??
                    currentUser?.email ??
                    'Cash Customer',
                truckId: truck.id,
                truckName: truck.foodType,
                items: [],
                totalAmount: amount,
                status: OrderStatus.completed,
                paymentMethod: 'cash',
                source: 'manual',
                itemName: itemController.text.trim().isEmpty
                    ? null
                    : itemController.text.trim(),
              );

              try {
                final orderRepo = ref.read(orderRepositoryProvider);
                await orderRepo.placeOrder(order);

                if (context.mounted) {
                  Navigator.pop(context);
                  SnackBarHelper.showSuccess(context,
                      '₩${NumberFormat('#,###').format(amount)} 현금 매출이 기록되었습니다');
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '오류: $e');
                }
              }
            },
            child: const Text('저장', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
