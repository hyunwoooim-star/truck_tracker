import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';

/// Screen showing payment result (success/failure)
class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({
    super.key,
    required this.success,
    required this.orderId,
    required this.amount,
    this.truckName,
    this.errorMessage,
  });

  final bool success;
  final String orderId;
  final int amount;
  final String? truckName;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Result Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: success
                      ? AppTheme.electricBlue.withValues(alpha: 0.15)
                      : Colors.red.withValues(alpha: 0.15),
                ),
                child: Icon(
                  success ? Icons.check_circle : Icons.error,
                  size: 64,
                  color: success ? AppTheme.electricBlue : Colors.red,
                ),
              ),
              const SizedBox(height: 32),

              // Result Title
              Text(
                success ? '결제 완료' : '결제 실패',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: success ? AppTheme.electricBlue : Colors.red,
                ),
              ),
              const SizedBox(height: 12),

              // Result Message
              Text(
                success
                    ? '주문이 성공적으로 접수되었습니다'
                    : (errorMessage ?? '결제 처리 중 문제가 발생했습니다'),
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Order Details (only on success)
              if (success) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('주문번호', '#${orderId.substring(0, 8).toUpperCase()}'),
                      if (truckName != null) ...[
                        const Divider(height: 24, color: AppTheme.charcoalLight),
                        _buildDetailRow('트럭', truckName!),
                      ],
                      const Divider(height: 24, color: AppTheme.charcoalLight),
                      _buildDetailRow(
                        '결제 금액',
                        '₩${formatter.format(amount)}',
                        valueStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pickup Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.mustardYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.mustardYellow.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.mustardYellow,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '음식이 준비되면 알림을 보내드립니다.\n트럭에서 직접 픽업해 주세요!',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (success) {
                      // Go back to home/truck list
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else {
                      // Go back to payment screen to retry
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: success ? AppTheme.electricBlue : AppTheme.charcoalLight,
                    foregroundColor: success ? Colors.black : AppTheme.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    success ? '홈으로 돌아가기' : '다시 시도',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              if (!success) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    '나중에 결제하기',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
