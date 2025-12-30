import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/coupon.dart';
import 'coupon_provider.dart';

/// Customer-facing screen to view available coupons for a truck
class CouponListScreen extends ConsumerWidget {
  const CouponListScreen({
    super.key,
    required this.truckId,
    required this.truckName,
  });

  final String truckId;
  final String truckName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(truckCouponsProvider(truckId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text('$truckName 쿠폰'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: couponsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (_, index) => const SkeletonCouponCard(),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
              const SizedBox(height: 16),
              Text(
                '쿠폰을 불러올 수 없습니다',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ],
          ),
        ),
        data: (coupons) {
          // Filter only valid coupons
          final validCoupons = coupons.where((c) => c.isValid).toList();

          if (validCoupons.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: validCoupons.length,
            itemBuilder: (context, index) {
              final coupon = validCoupons[index];
              final isUsed = currentUser != null && coupon.hasBeenUsedBy(currentUser.uid);
              return _CouponCard(
                coupon: coupon,
                isUsed: isUsed,
                onCopy: () => _copyCouponCode(context, coupon.code),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            '사용 가능한 쿠폰이 없습니다',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 쿠폰이 등록되면 알려드릴게요',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _copyCouponCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    SnackBarHelper.showSuccess(context, '쿠폰 코드가 복사되었습니다: $code');
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.isUsed,
    required this.onCopy,
  });

  final Coupon coupon;
  final bool isUsed;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUsed
              ? [Colors.grey[800]!, Colors.grey[900]!]
              : [AppTheme.mustardYellow20, AppTheme.mustardYellow05],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUsed ? Colors.grey[700]! : AppTheme.mustardYellow30,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with discount
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Discount badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUsed ? Colors.grey[700] : AppTheme.mustardYellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _getDiscountValue(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: isUsed ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                      Text(
                        _getDiscountLabel(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isUsed ? Colors.grey[500] : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Coupon info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (coupon.description != null)
                        Text(
                          coupon.description!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isUsed ? Colors.grey[500] : Colors.white,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dateFormat.format(coupon.validFrom)} ~ ${dateFormat.format(coupon.validUntil)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${coupon.remainingUses}/${coupon.maxUses}개 남음',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
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

          // Divider with dashed line effect
          Row(
            children: List.generate(
              30,
              (index) => Expanded(
                child: Container(
                  height: 1,
                  color: index.isEven
                      ? (isUsed ? Colors.grey[700] : AppTheme.mustardYellow30)
                      : Colors.transparent,
                ),
              ),
            ),
          ),

          // Footer with code and copy button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Coupon code
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '쿠폰 코드',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon.code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                          color: isUsed ? Colors.grey[600] : AppTheme.electricBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                // Copy or Used status
                if (isUsed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '사용 완료',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('복사'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.electricBlue,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDiscountValue() {
    switch (coupon.type) {
      case CouponType.percentage:
        return '${coupon.discountPercent}%';
      case CouponType.fixed:
        final amount = coupon.discountAmount ?? 0;
        if (amount >= 10000) {
          return '${amount ~/ 10000}만';
        }
        return '${amount ~/ 1000}천';
      case CouponType.freeItem:
        return 'FREE';
    }
  }

  String _getDiscountLabel() {
    switch (coupon.type) {
      case CouponType.percentage:
        return 'OFF';
      case CouponType.fixed:
        return '원 할인';
      case CouponType.freeItem:
        return coupon.freeItemName ?? '';
    }
  }
}
