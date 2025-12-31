import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'auth_provider.dart';

/// 사장님 승인 대기 화면
/// 사장님 가입 후 관리자 승인을 기다리는 동안 표시
class OwnerPendingScreen extends ConsumerStatefulWidget {
  const OwnerPendingScreen({
    super.key,
    this.status = 'pending',
    this.rejectionReason,
  });

  final String status; // 'pending' or 'rejected'
  final String? rejectionReason;

  @override
  ConsumerState<OwnerPendingScreen> createState() => _OwnerPendingScreenState();
}

class _OwnerPendingScreenState extends ConsumerState<OwnerPendingScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshStatus() async {
    setState(() => _isRefreshing = true);

    try {
      // Invalidate the provider to trigger a refresh
      ref.invalidate(ownerRequestStatusProvider);
      ref.invalidate(currentUserTruckIdProvider);

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        SnackBarHelper.showInfo(context, '상태를 확인했습니다');
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isPending = widget.status == 'pending';
    final isRejected = widget.status == 'rejected';

    return Scaffold(
      backgroundColor: AppTheme.charcoalDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPending ? Icons.hourglass_top : Icons.cancel_outlined,
                  size: 60,
                  color: isPending ? Colors.orange : Colors.red,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                isPending ? '승인 대기 중' : '승인 거절됨',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                isPending
                    ? '사장님 인증 요청이 접수되었습니다.\n관리자 검토 후 승인됩니다.'
                    : '사장님 인증이 거절되었습니다.',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              // Rejection reason
              if (isRejected && widget.rejectionReason != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '거절 사유',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.rejectionReason!,
                        style: TextStyle(
                          color: Colors.red[200],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 48),

              // Pending info box
              if (isPending)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.charcoalLight),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.check_circle_outline,
                        '사업자등록증 제출 완료',
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.pending_outlined,
                        '관리자 검토 중',
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.schedule,
                        '보통 1-2일 소요',
                        AppTheme.textTertiary,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Refresh button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isRefreshing ? null : _refreshStatus,
                  icon: _isRefreshing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(_isRefreshing ? '확인 중...' : '승인 상태 확인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mustardYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Re-submit button (for rejected)
              if (isRejected)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to re-submit screen
                      SnackBarHelper.showInfo(context, '재신청 기능 준비 중');
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('다시 신청하기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.mustardYellow,
                      side: const BorderSide(color: AppTheme.mustardYellow),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Logout button
              TextButton(
                onPressed: _logout,
                child: const Text(
                  '로그아웃',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
