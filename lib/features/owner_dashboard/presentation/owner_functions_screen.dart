import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../core/themes/app_theme.dart';
import '../../truck_list/domain/truck.dart';
import '../../checkin/presentation/owner_qr_screen.dart';
import '../../analytics/presentation/revenue_dashboard_screen.dart';
import '../../notifications/presentation/push_notification_tool.dart';
import '../../truck_map/presentation/map_first_screen.dart';
import '../../bank_transfer/presentation/bank_account_setup_screen.dart';
import 'analytics_screen.dart';
import 'coupon_management_screen.dart';
import 'coupon_scanner_screen.dart';
import 'menu_management_screen.dart';
import 'review_management_screen.dart';
import 'schedule_management_screen.dart';
import 'widgets/widgets.dart';

/// 더보기 기능 화면 - 모든 관리 메뉴 모음
class OwnerFunctionsScreen extends ConsumerWidget {
  const OwnerFunctionsScreen({super.key, required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('기능 더보기'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 품절 토글 (자주 사용)
            OwnerSoldOutToggles(truckId: truck.id),
            const SizedBox(height: 24),

            // 트럭 운영 섹션
            _SectionTitle(title: '트럭 운영', icon: Icons.local_shipping),
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
                  icon: Icons.account_balance,
                  label: '계좌번호 설정',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BankAccountSetupScreen(truckId: truck.id)),
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

            // 마케팅 & 분석 섹션
            _SectionTitle(title: '마케팅 & 분석', icon: Icons.bar_chart),
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

            // 고객 대화
            OwnerTalkSection(truckId: truck.id),
            const SizedBox(height: 24),

            // 기타 섹션
            _SectionTitle(title: l10n.other, icon: Icons.more_horiz),
            const SizedBox(height: 12),
            _MenuList(
              items: [
                _MenuListItem(
                  icon: Icons.qr_code,
                  label: l10n.qrCheckInTooltip,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerQRScreen()),
                  ),
                ),
                _MenuListItem(
                  icon: Icons.storefront,
                  label: '손님 화면 보기',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapFirstScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
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
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
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
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.mustardYellow, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
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
