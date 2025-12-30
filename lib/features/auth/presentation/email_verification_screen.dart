import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'auth_provider.dart';

/// 이메일 인증 화면
/// 회원가입 후 이메일 인증을 안내하는 화면
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({
    super.key,
    this.isOwnerSignup = false,
    this.onVerified,
  });

  final bool isOwnerSignup;
  final VoidCallback? onVerified;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isCheckingVerification = false;
  bool _isResending = false;
  Timer? _autoCheckTimer;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    // Auto-check verification status every 3 seconds
    _autoCheckTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerification(silent: true),
    );
  }

  @override
  void dispose() {
    _autoCheckTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerification({bool silent = false}) async {
    if (_isCheckingVerification) return;

    setState(() => _isCheckingVerification = true);

    try {
      final authService = ref.read(authServiceProvider);
      final verified = await authService.checkEmailVerified();

      if (verified && mounted) {
        SnackBarHelper.showSuccess(context, '이메일 인증이 완료되었습니다!');

        if (widget.onVerified != null) {
          widget.onVerified!();
        } else {
          // Default: go back or navigate to main
          Navigator.of(context).pop(true);
        }
      } else if (!silent && mounted) {
        SnackBarHelper.showWarning(context, '아직 이메일이 인증되지 않았습니다');
      }
    } catch (e) {
      if (!silent && mounted) {
        SnackBarHelper.showError(context, '인증 확인 중 오류가 발생했습니다');
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingVerification = false);
      }
    }
  }

  Future<void> _resendVerification() async {
    if (_isResending || _resendCooldown > 0) return;

    setState(() => _isResending = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendEmailVerification();

      if (mounted) {
        SnackBarHelper.showSuccess(context, '인증 이메일을 재전송했습니다');

        // Start cooldown
        setState(() => _resendCooldown = 60);
        _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_resendCooldown > 0) {
            setState(() => _resendCooldown--);
          } else {
            timer.cancel();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        String message = '이메일 전송에 실패했습니다';
        if (e.toString().contains('too-many-requests')) {
          message = '잠시 후 다시 시도해주세요';
        }
        SnackBarHelper.showError(context, message);
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final userEmail = authService.currentUserEmail ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Email icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.mustardYellow.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 50,
                  color: AppTheme.mustardYellow,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                '이메일 인증',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                '인증 이메일을 발송했습니다.\n아래 이메일을 확인해주세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Email display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: AppTheme.mustardYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue[300], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '인증 방법',
                          style: TextStyle(
                            color: Colors.blue[300],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStep('1', '이메일 앱을 열어주세요'),
                    _buildStep('2', '트럭아저씨에서 온 인증 메일을 찾아주세요'),
                    _buildStep('3', '인증 링크를 클릭해주세요'),
                    _buildStep('4', '이 화면으로 돌아와 인증 확인을 눌러주세요'),
                  ],
                ),
              ),

              const Spacer(),

              // Check verification button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isCheckingVerification ? null : () => _checkVerification(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mustardYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isCheckingVerification
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : const Text(
                          '인증 완료 확인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Resend button
              TextButton(
                onPressed: (_isResending || _resendCooldown > 0)
                    ? null
                    : _resendVerification,
                child: Text(
                  _resendCooldown > 0
                      ? '재전송 가능 ($_resendCooldown초)'
                      : '인증 이메일 재전송',
                  style: TextStyle(
                    color: _resendCooldown > 0
                        ? Colors.grey
                        : AppTheme.mustardYellow,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip for now (if allowed)
              if (!widget.isOwnerSignup)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    '나중에 인증하기',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
