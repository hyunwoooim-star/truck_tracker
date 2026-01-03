import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/bank_transfer_repository.dart';
import '../domain/bank_account.dart';

/// 사장님용 계좌번호 설정 화면
class BankAccountSetupScreen extends ConsumerStatefulWidget {
  final String truckId;

  const BankAccountSetupScreen({
    super.key,
    required this.truckId,
  });

  @override
  ConsumerState<BankAccountSetupScreen> createState() => _BankAccountSetupScreenState();
}

class _BankAccountSetupScreenState extends ConsumerState<BankAccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingAccount();
  }

  Future<void> _loadExistingAccount() async {
    setState(() => _isLoading = true);

    final repository = ref.read(bankTransferRepositoryProvider);
    final existingAccount = await repository.getBankAccount(widget.truckId);

    if (existingAccount != null && mounted) {
      _bankNameController.text = existingAccount.bankName;
      _accountNumberController.text = existingAccount.accountNumber;
      _accountHolderController.text = existingAccount.accountHolder;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final account = BankAccount(
        bankName: _bankNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        accountHolder: _accountHolderController.text.trim(),
      );

      final repository = ref.read(bankTransferRepositoryProvider);
      await repository.saveBankAccount(widget.truckId, account);

      if (mounted) {
        SnackBarHelper.showSuccess(context, '계좌 정보가 저장되었습니다');
        Navigator.pop(context, account);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '계좌 정보 저장에 실패했습니다');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('계좌번호 설정'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 안내 메시지
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.electricBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.electricBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.electricBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '손님들이 선결제 시 입금할 계좌번호를 등록해주세요',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 은행명
                    Text(
                      '은행명',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bankNameController,
                      style: TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: '예: 국민은행',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '은행명을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // 계좌번호
                    Text(
                      '계좌번호',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _accountNumberController,
                      style: TextStyle(color: AppTheme.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '숫자만 입력 (하이픈 제외)',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '계좌번호를 입력해주세요';
                        }
                        final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (digitsOnly.length < 10) {
                          return '유효한 계좌번호를 입력해주세요 (최소 10자리)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // 예금주
                    Text(
                      '예금주',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _accountHolderController,
                      style: TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: '예금주 이름',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '예금주를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // 저장 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.electricBlue,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: AppTheme.charcoalLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                '저장하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
