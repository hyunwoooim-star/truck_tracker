import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../truck_list/domain/truck.dart';
import '../../../checkin/presentation/owner_qr_screen.dart';
import '../../../analytics/presentation/revenue_dashboard_screen.dart';
import '../../../notifications/presentation/push_notification_tool.dart';
import '../../../truck_map/presentation/map_first_screen.dart';
import '../analytics_screen.dart';
import '../coupon_management_screen.dart';
import '../coupon_scanner_screen.dart';
import '../menu_management_screen.dart';
import '../owner_management_screen.dart';
import '../review_management_screen.dart';
import '../schedule_management_screen.dart';
import '../owner_status_provider.dart';
import '../widgets/widgets.dart';

/// 더보기 탭 - 모든 관리 메뉴 모음
class OwnerMoreTab extends ConsumerWidget {
  const OwnerMoreTab({super.key, required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 트럭 관리 섹션
          _SectionTitle(title: l10n.truckManagement, icon: Icons.local_shipping),
          const SizedBox(height: 12),
          _MenuGrid(
            items: [
              _MenuItem(
                icon: Icons.restaurant_menu,
                label: l10n.menuManagement,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuManagementScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.calendar_today,
                label: '영업 일정',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScheduleManagementScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.dashboard_customize,
                label: '트럭 관리',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OwnerManagementScreen(truckId: truck.id)),
                ),
              ),
              _MenuItem(
                icon: Icons.qr_code,
                label: l10n.qrCheckInTooltip,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OwnerQRScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 쿠폰 & 리뷰 섹션
          _SectionTitle(title: l10n.couponAndReview, icon: Icons.local_offer),
          const SizedBox(height: 12),
          _MenuGrid(
            items: [
              _MenuItem(
                icon: Icons.local_offer,
                label: l10n.couponManagement,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CouponManagementScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.qr_code_scanner,
                label: '쿠폰 스캐너',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CouponScannerScreen(truckId: truck.id)),
                ),
              ),
              _MenuItem(
                icon: Icons.rate_review,
                label: l10n.reviewManagement,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReviewManagementScreen(truckId: truck.id)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 통계 & 분석 섹션
          _SectionTitle(title: l10n.statsAndAnalytics, icon: Icons.bar_chart),
          const SizedBox(height: 12),
          _MenuGrid(
            items: [
              _MenuItem(
                icon: Icons.attach_money,
                label: '매출 대시보드',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RevenueDashboardScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.analytics,
                label: '조회/리뷰 분석',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.notifications_active,
                label: '알림 발송',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PushNotificationTool()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 품절 토글
          OwnerSoldOutToggles(truckId: truck.id),
          const SizedBox(height: 24),

          // 고객 대화
          OwnerTalkSection(truckId: truck.id),
          const SizedBox(height: 24),

          // 기타 섹션
          _SectionTitle(title: l10n.other, icon: Icons.more_horiz),
          const SizedBox(height: 12),
          _MenuList(
            items: [
              _MenuListItem(
                icon: Icons.storefront,
                label: '손님 화면 보기',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapFirstScreen()),
                ),
              ),
              _MenuListItem(
                icon: Icons.logout,
                label: l10n.logout,
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => _showLogoutDialog(context, ref, l10n),
              ),
            ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.mustardYellow, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.charcoalLight.withAlpha(50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.mustardYellow.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.mustardYellow, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList({required this.items});

  final List<_MenuListItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.last == item;
          return Column(
            children: [
              item,
              if (!isLast)
                Divider(
                  height: 1,
                  color: Colors.grey[800],
                  indent: 56,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  const _MenuListItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor = Colors.white,
    this.iconColor = AppTheme.mustardYellow,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }
}
