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
    final pendingRequestsAsync = ref.watch(pendingOwnerRequestsProvider);

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
              ref.invalidate(pendingOwnerRequestsProvider);
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
          ref.invalidate(pendingOwnerRequestsProvider);
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

              // Pending Requests Section
              _buildSectionHeader('대기 중인 사장님 인증 요청'),
              const SizedBox(height: 12),
              pendingRequestsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: AppTheme.mustardYellow),
                  ),
                ),
                error: (error, _) => _buildErrorCard('요청 로드 실패: $error'),
                data: (requests) => _buildPendingRequestsSection(requests),
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
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: screenWidth > 800 ? 2.2 : 1.8,
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
        ),
        AdminStatsCard(
          icon: Icons.cancel,
          label: '거절됨',
          value: stats.totalRejectedOwners.toString(),
          color: Colors.red,
        ),
        AdminStatsCard(
          icon: Icons.percent,
          label: '승인률',
          value: stats.approvalRate.toStringAsFixed(1),
          suffix: '%',
          color: stats.approvalRate >= 50 ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildPendingRequestsSection(List<Map<String, dynamic>> requests) {
    if (requests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.charcoalLight),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.green,
            ),
            SizedBox(height: 12),
            Text(
              '대기 중인 요청이 없습니다',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Show first 3 requests
        ...requests.take(3).map((request) => _buildRequestPreviewCard(request)),

        if (requests.length > 3) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _navigateToOwnerRequests,
            icon: const Icon(Icons.visibility),
            label: Text('${requests.length - 3}개 더 보기'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.mustardYellow,
            ),
          ),
        ],

        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _navigateToOwnerRequests,
            icon: const Icon(Icons.manage_accounts),
            label: const Text('요청 관리하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mustardYellow,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestPreviewCard(Map<String, dynamic> request) {
    final email = request['email'] as String? ?? '';
    final displayName = request['displayName'] as String? ?? '이름 없음';
    final createdAt = request['createdAt'];
    String timeAgo = '';

    if (createdAt != null) {
      final date = (createdAt as dynamic).toDate() as DateTime;
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) {
        timeAgo = '${diff.inDays}일 전';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours}시간 전';
      } else {
        timeAgo = '${diff.inMinutes}분 전';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_add,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (timeAgo.isNotEmpty)
            Text(
              timeAgo,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
              ),
            ),
        ],
      ),
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
