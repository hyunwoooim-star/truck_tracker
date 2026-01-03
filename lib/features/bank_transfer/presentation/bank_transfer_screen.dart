import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../order/domain/cart_item.dart';
import '../data/bank_transfer_repository.dart';
import '../domain/bank_account.dart';

/// 손님용 계좌이체 화면
class BankTransferScreen extends ConsumerStatefulWidget {
  final String truckId;
  final String truckName;
  final int totalAmount;
  final List<CartItem> items;
  final String orderId;

  const BankTransferScreen({
    super.key,
    required this.truckId,
    required this.truckName,
    required this.totalAmount,
    required this.items,
    required this.orderId,
  });

  @override
  ConsumerState<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends ConsumerState<BankTransferScreen> {
  bool _isTransferConfirmed = false;
  final _depositorNameController = TextEditingController();

  @override
  void dispose() {
    _depositorNameController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      SnackBarHelper.showSuccess(context, '$label 복사되었습니다');
    }
  }

  Future<void> _openBankApp(BankAccount account) async {
    // 은행 앱 딥링크 시도
    final bankAppSchemes = {
      '국민': 'kbbank://',
      '신한': 'shinhan-sr-ansimclick://',
      '우리': 'wooribank://',
      '하나': 'hanabank://',
      '농협': 'nhb://',
      'NH': 'nhb://',
      '기업': 'ibkmb://',
      'IBK': 'ibkmb://',
      '카카오뱅크': 'kakaobank://',
      '케이뱅크': 'kbank://',
      '토스': 'supertoss://',
    };

    // 은행명에서 앱 스킴 찾기
    String? scheme;
    for (final entry in bankAppSchemes.entries) {
      if (account.bankName.contains(entry.key)) {
        scheme = entry.value;
        break;
      }
    }

    if (scheme != null) {
      final uri = Uri.parse(scheme);
      try {
        final canLaunch = await canLaunchUrl(uri);
        if (canLaunch) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (e) {
        // Scheme 실패 시 토스로 폴백
      }
    }

    // 토스 송금 페이지로 폴백
    await _openTossTransfer(account);
  }

  Future<void> _openTossTransfer(BankAccount account) async {
    // 토스 송금 페이지 (웹)
    final tossUrl = Uri.parse('https://toss.im/transfer-money');

    try {
      final canLaunch = await canLaunchUrl(tossUrl);
      if (canLaunch) {
        await launchUrl(tossUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          SnackBarHelper.showWarning(context, '은행앱을 열 수 없습니다. 계좌번호를 복사하여 직접 송금해주세요.');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '은행앱 열기에 실패했습니다');
      }
    }
  }

  void _confirmTransfer() {
    if (!_isTransferConfirmed) {
      SnackBarHelper.showWarning(context, '송금 완료 여부를 체크해주세요');
      return;
    }

    if (_depositorNameController.text.trim().isEmpty) {
      SnackBarHelper.showWarning(context, '입금자명을 입력해주세요');
      return;
    }

    // 주문 완료 처리
    Navigator.pop(context, {
      'confirmed': true,
      'depositorName': _depositorNameController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bankAccountAsync = ref.watch(bankAccountProvider(widget.truckId));
    final formatter = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('계좌이체'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: bankAccountAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '계좌 정보를 불러올 수 없습니다',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        data: (bankAccount) {
          if (bankAccount == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '사장님이 아직 계좌번호를\n등록하지 않았습니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.electricBlue,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('돌아가기'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주문 정보
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.charcoalLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: AppTheme.electricBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '주문 정보',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('가게', widget.truckName),
                      _buildInfoRow('주문번호', widget.orderId),
                      const Divider(
                        color: AppTheme.charcoalLight,
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '결제 금액',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₩${formatter.format(widget.totalAmount)}',
                            style: TextStyle(
                              color: AppTheme.electricBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 계좌 정보
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.mustardYellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.mustardYellow.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: AppTheme.mustardYellow,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '입금 계좌',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 은행명
                      Text(
                        '은행',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bankAccount.bankName,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 계좌번호
                      Text(
                        '계좌번호',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              bankAccount.accountNumber,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _copyToClipboard(
                              bankAccount.accountNumber,
                              '계좌번호가',
                            ),
                            icon: Icon(
                              Icons.copy,
                              color: AppTheme.electricBlue,
                            ),
                            tooltip: '계좌번호 복사',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 예금주
                      Text(
                        '예금주',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bankAccount.accountHolder,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 은행앱 열기 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _openBankApp(bankAccount),
                    icon: Icon(Icons.open_in_new),
                    label: Text(
                      '${bankAccount.bankName} 앱에서 송금하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.electricBlue,
                      side: BorderSide(
                        color: AppTheme.electricBlue,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 입금자명 입력
                Text(
                  '입금자명',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _depositorNameController,
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: '입금하실 때 사용한 이름',
                    hintStyle: TextStyle(color: AppTheme.textTertiary),
                    filled: true,
                    fillColor: AppTheme.charcoalMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.charcoalLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.electricBlue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 송금 완료 체크박스
                Material(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isTransferConfirmed = !_isTransferConfirmed;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            _isTransferConfirmed
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: _isTransferConfirmed
                                ? AppTheme.electricBlue
                                : AppTheme.textTertiary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '위 계좌로 송금을 완료했습니다',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 주문 완료 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _confirmTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTransferConfirmed
                          ? AppTheme.electricBlue
                          : AppTheme.charcoalLight,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      '주문 완료',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isTransferConfirmed ? Colors.black : AppTheme.textTertiary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 안내 문구
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '안내사항',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 입금 확인 후 사장님이 주문을 준비합니다\n'
                        '• 입금자명이 다를 경우 확인이 지연될 수 있습니다\n'
                        '• 입금 관련 문의는 트럭 사장님께 직접 연락해주세요',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
