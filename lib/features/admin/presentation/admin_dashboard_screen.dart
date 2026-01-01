import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/admin_stats_repository.dart';
import 'admin_screen.dart';
import 'user_management_screen.dart';
import 'widgets/admin_stats_card.dart';

/// Main Admin Dashboard Screen
/// Shows statistics overview and quick access to admin functions
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool? _isAdmin;
  bool _isCheckingAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final authService = ref.read(authServiceProvider);
    final isAdmin = await authService.isCurrentUserAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
        _isCheckingAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking admin status
    if (_isCheckingAdmin) {
      return Scaffold(
        backgroundColor: AppTheme.charcoalDark,
        appBar: AppBar(
          title: const Text('관리자 대시보드'),
          backgroundColor: AppTheme.charcoalMedium,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.mustardYellow),
        ),
      );
    }

    // Access denied if not admin
    if (_isAdmin != true) {
      return Scaffold(
        backgroundColor: AppTheme.charcoalDark,
        appBar: AppBar(
          title: const Text('관리자 대시보드'),
          backgroundColor: AppTheme.charcoalMedium,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                '접근 권한이 없습니다',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '관리자만 접근할 수 있는 페이지입니다',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('돌아가기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.mustardYellow,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.charcoalDark,
      appBar: AppBar(
        title: const Text('관리자 대시보드'),
        backgroundColor: AppTheme.charcoalMedium,
        foregroundColor: AppTheme.mustardYellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: () {
              ref.invalidate(adminStatsProvider);
              SnackBarHelper.showInfo(context, '새로고침 중...');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.mustardYellow,
        backgroundColor: AppTheme.charcoalMedium,
        onRefresh: () async {
          ref.invalidate(adminStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Overview
              _buildSectionHeader('통계 개요'),
              const SizedBox(height: 12),
              statsAsync.when(
                loading: () => const _StatsLoadingGrid(),
                error: (error, _) => _buildErrorCard('통계 로드 실패: $error'),
                data: (stats) => _buildStatsGrid(stats),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              _buildSectionHeader('빠른 작업'),
              const SizedBox(height: 12),
              _buildQuickActions(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildStatsGrid(AdminStats stats) {
    // 화면 너비에 따라 열 수 조정
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 800 ? 3 : 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      // [FIX] 비율 낮춰서 카드 높이 증가 (라벨 잘림 방지)
      childAspectRatio: screenWidth > 800 ? 1.8 : 1.3,
      children: [
        AdminStatsCard(
          icon: Icons.pending_actions,
          label: '대기 중인 요청',
          value: stats.pendingOwnerRequests.toString(),
          color: stats.pendingOwnerRequests > 0 ? Colors.orange : AppTheme.mustardYellow,
          onTap: () => _navigateToOwnerRequests(),
        ),
        AdminStatsCard(
          icon: Icons.check_circle,
          label: '승인된 사장님',
          value: stats.totalApprovedOwners.toString(),
          color: Colors.green,
          onTap: () => _navigateToApprovedOwners(),
        ),
        AdminStatsCard(
          icon: Icons.people,
          label: '전체 사용자',
          value: stats.totalUsers.toString(),
          color: AppTheme.tossBlue,
          onTap: () => _navigateToUserManagement(),
        ),
        AdminStatsCard(
          icon: Icons.local_shipping,
          label: '전체 트럭',
          value: stats.totalTrucks.toString(),
          color: AppTheme.mustardYellow,
          onTap: () => _navigateToTruckList(),
        ),
        // 실용적인 통계로 변경
        AdminStatsCard(
          icon: Icons.touch_app,
          label: '오늘 체크인',
          value: stats.todayCheckins.toString(),
          color: Colors.cyan,
        ),
        AdminStatsCard(
          icon: Icons.storefront,
          label: '영업 중',
          value: stats.activeTrucks.toString(),
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionTile(
          icon: Icons.person_search,
          title: '사장님 인증 관리',
          subtitle: '대기 중인 인증 요청 승인/거절',
          color: Colors.orange,
          onTap: _navigateToOwnerRequests,
        ),
        const SizedBox(height: 8),
        _buildActionTile(
          icon: Icons.group,
          title: '사용자 관리',
          subtitle: '전체 사용자 조회 및 역할 관리',
          color: AppTheme.tossBlue,
          onTap: _navigateToUserManagement,
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.charcoalLight),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToOwnerRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminScreen()),
    );
  }

  void _navigateToUserManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserManagementScreen()),
    );
  }

  void _navigateToApprovedOwners() {
    // 사용자 관리 화면에서 사장님 필터 적용
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserManagementScreen()),
    );
    // TODO: 향후 사장님 필터가 적용된 화면으로 이동
  }

  void _navigateToTruckList() {
    // 트럭 리스트로 이동 (일단 사용자 관리로)
    SnackBarHelper.showInfo(context, '트럭 목록 화면은 준비 중입니다');
  }
}

/// Loading placeholder for stats grid
class _StatsLoadingGrid extends StatelessWidget {
  const _StatsLoadingGrid();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 800 ? 3 : 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: screenWidth > 800 ? 2.2 : 1.8,
      children: List.generate(6, (index) => _buildLoadingCard()),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.charcoalLight),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.mustardYellow,
          ),
        ),
      ),
    );
  }
}
