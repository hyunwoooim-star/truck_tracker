import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../truck_list/domain/truck.dart';
import '../owner_management_screen.dart';
import '../owner_functions_screen.dart';
import '../owner_settings_screen.dart';
import '../owner_status_provider.dart';

/// 더보기 탭 - 3개 메뉴만 (사장님 대시보드 설정, 더보기, 로그아웃)
class OwnerMoreTab extends ConsumerWidget {
  const OwnerMoreTab({super.key, required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // 사장님용 대시보드 설정
          _BigMenuCard(
            icon: Icons.local_shipping,
            title: '사장님 대시보드 설정',
            subtitle: '트럭 프로필, 위치, 음식 종류 수정',
            color: AppTheme.mustardYellow,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OwnerManagementScreen(truckId: truck.id),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 기능 더보기
          _BigMenuCard(
            icon: Icons.apps,
            title: '기능 더보기',
            subtitle: '메뉴관리, 쿠폰, 리뷰, 통계 등',
            color: AppTheme.electricBlue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OwnerFunctionsScreen(truck: truck),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 앱 설정
          _BigMenuCard(
            icon: Icons.settings,
            title: l10n.settings,
            subtitle: '알림, 언어, 앱 정보',
            color: Colors.grey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OwnerAppSettingsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 로그아웃 버튼
          _LogoutButton(
            onTap: () => _showLogoutDialog(context, ref, l10n),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Text(l10n.logout, style: const TextStyle(color: Colors.white)),
        content: Text(l10n.confirmLogout, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).signOut();
              ref.invalidate(currentUserTruckIdProvider);
              ref.invalidate(currentUserProvider);
              ref.invalidate(currentUserIdProvider);
              ref.invalidate(currentUserEmailProvider);
              ref.invalidate(ownerTruckProvider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}

/// 큰 메뉴 카드
class _BigMenuCard extends StatelessWidget {
  const _BigMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withAlpha(50)),
          ),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // 화살표
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// 로그아웃 버튼
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.withAlpha(100)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.logout,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
