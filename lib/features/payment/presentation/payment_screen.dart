import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../order/domain/cart_item.dart';
import '../data/payment_repository.dart';
import '../domain/payment.dart';
import 'toss_payment_webview.dart';

/// Payment screen for selecting payment method and processing payment
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.orderName,
    required this.amount,
    required this.items,
    required this.truckName,
  });

  final String orderId;
  final String orderName;
  final int amount;
  final List<CartItem> items;
  final String truckName;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethodType _selectedMethod = PaymentMethodType.card;
  bool _isProcessing = false;

  final List<_PaymentMethodOption> _paymentMethods = [
    _PaymentMethodOption(
      type: PaymentMethodType.card,
      name: '신용/체크카드',
      icon: Icons.credit_card,
      description: '모든 카드 사용 가능',
    ),
    _PaymentMethodOption(
      type: PaymentMethodType.tossPay,
      name: '토스페이',
      icon: Icons.account_balance_wallet,
      description: '토스 간편결제',
      color: const Color(0xFF0064FF),
    ),
    _PaymentMethodOption(
      type: PaymentMethodType.kakaoPay,
      name: '카카오페이',
      icon: Icons.chat_bubble,
      description: '카카오 간편결제',
      color: const Color(0xFFFEE500),
      textColor: Colors.black,
    ),
    _PaymentMethodOption(
      type: PaymentMethodType.naverPay,
      name: '네이버페이',
      icon: Icons.payment,
      description: '네이버 간편결제',
      color: const Color(0xFF03C75A),
    ),
    _PaymentMethodOption(
      type: PaymentMethodType.transfer,
      name: '계좌이체',
      icon: Icons.account_balance,
      description: '실시간 계좌이체',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        backgroundColor: AppTheme.midnightCharcoal,
      ),
      body: Column(
        children: [
          // Order Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.charcoalMedium,
              border: Border(
                bottom: BorderSide(color: AppTheme.charcoalLight),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.truckName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.orderName,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '결제 금액',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '₩${formatter.format(widget.amount)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.electricBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment Method Selection
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  '결제 수단 선택',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ..._paymentMethods.map((method) => _buildPaymentMethodTile(method)),
              ],
            ),
          ),

          // Pay Button
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.charcoalMedium,
              border: Border(
                top: BorderSide(color: AppTheme.charcoalLight),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricBlue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.charcoalLight,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        '₩${formatter.format(widget.amount)} 결제하기',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(_PaymentMethodOption method) {
    final isSelected = _selectedMethod == method.type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method.type;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.electricBlue.withValues(alpha: 0.1) : AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.electricBlue : AppTheme.charcoalLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method.color ?? AppTheme.charcoalLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method.icon,
                color: method.textColor ?? Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.electricBlue : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Radio
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.electricBlue : AppTheme.charcoalLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarHelper.showWarning(context, '로그인이 필요합니다');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Create pending payment record
      final repository = ref.read(paymentRepositoryProvider);
      final payment = Payment(
        id: '',
        orderId: widget.orderId,
        userId: user.uid,
        amount: widget.amount,
        method: _selectedMethod,
        status: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

      await repository.createPayment(payment);

      // Navigate to TossPayments WebView
      if (mounted) {
        final result = await Navigator.push<PaymentResult>(
          context,
          MaterialPageRoute(
            builder: (_) => TossPaymentWebView(
              orderId: widget.orderId,
              orderName: widget.orderName,
              amount: widget.amount,
              customerName: user.displayName ?? user.email ?? 'Guest',
              customerEmail: user.email ?? '',
              method: _selectedMethod,
            ),
          ),
        );

        if (result != null && result.success) {
          // Payment successful
          if (mounted) {
            Navigator.pop(context, result);
          }
        } else if (result != null && !result.success) {
          // Payment failed
          if (mounted) {
            SnackBarHelper.showError(context, result.errorMessage ?? '결제에 실패했습니다');
          }
        }
        // If result is null, user cancelled - stay on page
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '결제 처리 중 오류가 발생했습니다');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

class _PaymentMethodOption {
  const _PaymentMethodOption({
    required this.type,
    required this.name,
    required this.icon,
    required this.description,
    this.color,
    this.textColor,
  });

  final PaymentMethodType type;
  final String name;
  final IconData icon;
  final String description;
  final Color? color;
  final Color? textColor;
}
