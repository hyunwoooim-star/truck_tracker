import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/app_version_service.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/network_status_banner.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../favorite/presentation/favorites_screen.dart';
import '../../notifications/presentation/notification_settings_screen.dart';
import 'help_screen.dart';
import 'my_reviews_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'owner_request_dialog.dart';

/// General app settings screen
class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAdminAsync = ref.watch(isCurrentUserAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(
            child: ListView(
              children: [
                // ═══════════════════════════════════════════════════════
                // 관리자 메뉴 (관리자만 표시)
                // ═══════════════════════════════════════════════════════
                isAdminAsync.when(
                  data: (isAdmin) => isAdmin
                      ? Column(
                          children: [
                            _buildSectionHeader(context, '관리자'),
                            _buildSettingsTile(
                              icon: Icons.admin_panel_settings,
                              iconColor: Colors.purple,
                              title: '관리자 대시보드',
                              subtitle: '사용자 관리, 사장님 인증',
                              onTap: () => context.push('/admin'),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                // ═══════════════════════════════════════════════════════
                // 개인정보
                // ═══════════════════════════════════════════════════════
                _buildSectionHeader(context, '개인정보'),
                _buildPersonalInfoSection(context, ref),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════════════════
                // 내 활동
                // ═══════════════════════════════════════════════════════
                _buildSectionHeader(context, '내 활동'),
                _buildSettingsTile(
                  icon: Icons.favorite_outline,
                  title: '즐겨찾기',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.rate_review_outlined,
                  title: '내가 쓴 리뷰',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyReviewsScreen()),
                  ),
                ),

                // 사장님으로 전환 메뉴 (일반 사용자만 표시, 관리자 제외)
                isAdminAsync.when(
                  data: (isAdmin) => isAdmin
                      ? const SizedBox.shrink()
                      : _buildOwnerRequestTile(context, ref),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => _buildOwnerRequestTile(context, ref),
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════════════════
                // 앱 설정
                // ═══════════════════════════════════════════════════════
                _buildSectionHeader(context, '앱 설정'),
                _buildSettingsTile(
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  iconColor: isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark,
                  title: '테마',
                  subtitle: _getThemeModeLabel(themeMode),
                  onTap: () => _showThemeDialog(context, ref, themeMode),
                ),
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: '알림 설정',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
                  ),
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════════════════
                // 앱 정보 & 지원
                // ═══════════════════════════════════════════════════════
                _buildSectionHeader(context, '앱 정보 & 지원'),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('버전'),
                  subtitle: Text('v$kCurrentAppVersion'),
                  trailing: _buildVersionCheckButton(ref),
                ),
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: '도움말',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpScreen()),
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.feedback_outlined,
                  title: '피드백 보내기',
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => _launchUrl('mailto:support@truckajeossi.com'),
                ),
                _buildSettingsTile(
                  icon: Icons.policy_outlined,
                  title: '개인정보 처리방침',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: '서비스 이용약관',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
                  ),
                ),

                const SizedBox(height: 32),

                // App logo and copyright
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_shipping,
                        size: 48,
                        color: isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '트럭아저씨',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '© 2024-2025 트럭아저씨',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildProfileTile(BuildContext context, WidgetRef ref) {
    final nicknameAsync = ref.watch(currentUserNicknameProvider);
    final emailAsync = ref.watch(currentUserEmailProvider);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.mustardYellow,
        child: nicknameAsync.when(
          data: (nickname) => Text(
            nickname?.isNotEmpty == true ? nickname![0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          loading: () => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
          ),
          error: (_, __) => const Text('?', style: TextStyle(color: Colors.black)),
        ),
      ),
      title: nicknameAsync.when(
        data: (nickname) => Text(
          nickname ?? '닉네임 없음',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        loading: () => const Text('로딩 중...'),
        error: (_, __) => const Text('닉네임 없음'),
      ),
      subtitle: Text(emailAsync),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: 프로필 수정 화면으로 이동
        SnackBarHelper.showInfo(context, '프로필 수정 기능 준비 중');
      },
    );
  }

  /// 개인정보 섹션 (역할, 닉네임, 이메일)
  Widget _buildPersonalInfoSection(BuildContext context, WidgetRef ref) {
    final nicknameAsync = ref.watch(currentUserNicknameProvider);
    final emailAsync = ref.watch(currentUserEmailProvider);
    final roleAsync = ref.watch(currentUserRoleProvider);
    final nicknameChangeInfoAsync = ref.watch(nicknameChangeInfoProvider);

    return Column(
      children: [
        // 내 역할
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: const Text('내 역할'),
          trailing: roleAsync.when(
            data: (role) {
              String roleText;
              Color roleColor;
              IconData roleIcon;
              switch (role) {
                case 'admin':
                  roleText = '관리자';
                  roleColor = Colors.purple;
                  roleIcon = Icons.admin_panel_settings;
                  break;
                case 'owner':
                  roleText = '사장님';
                  roleColor = Colors.green;
                  roleIcon = Icons.store;
                  break;
                default:
                  roleText = '손님';
                  roleColor = AppTheme.mustardYellow;
                  roleIcon = Icons.person;
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(roleIcon, size: 16, color: roleColor),
                    const SizedBox(width: 4),
                    Text(
                      roleText,
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const Text('확인 불가'),
          ),
        ),

        // 닉네임 수정
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('닉네임'),
          subtitle: nicknameChangeInfoAsync.when(
            data: (info) {
              final remaining = info?['remainingChanges'] ?? 3;
              return Text('이번 달 수정 가능: $remaining회');
            },
            loading: () => null,
            error: (_, __) => null,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              nicknameAsync.when(
                data: (nickname) => Text(
                  nickname ?? '없음',
                  style: const TextStyle(color: Colors.grey),
                ),
                loading: () => const Text('...'),
                error: (_, __) => const Text('없음'),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () => _showNicknameEditDialog(context, ref),
        ),

        // 이메일 (표시만)
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('이메일'),
          trailing: Text(
            emailAsync,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  /// 닉네임 수정 다이얼로그
  void _showNicknameEditDialog(BuildContext context, WidgetRef ref) {
    final nicknameChangeInfoAsync = ref.read(nicknameChangeInfoProvider);

    nicknameChangeInfoAsync.when(
      data: (info) {
        final remaining = info?['remainingChanges'] ?? 3;

        if (remaining <= 0) {
          SnackBarHelper.showError(context, '이번 달 닉네임 수정 횟수를 모두 사용했습니다 (월 3회)');
          return;
        }

        final controller = TextEditingController();
        final currentNickname = ref.read(currentUserNicknameProvider).value;
        controller.text = currentNickname ?? '';

        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('닉네임 수정'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: '새 닉네임',
                    hintText: '2-10자 입력',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 10,
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                Text(
                  '이번 달 수정 가능 횟수: $remaining회',
                  style: TextStyle(
                    color: remaining <= 1 ? Colors.orange : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newNickname = controller.text.trim();
                  if (newNickname.length < 2) {
                    SnackBarHelper.showError(dialogContext, '닉네임은 2자 이상이어야 합니다');
                    return;
                  }
                  if (newNickname == currentNickname) {
                    Navigator.pop(dialogContext);
                    return;
                  }

                  Navigator.pop(dialogContext);

                  try {
                    final authService = ref.read(authServiceProvider);
                    final userId = ref.read(currentUserIdProvider);
                    if (userId == null) throw Exception('로그인 필요');

                    await authService.updateNicknameWithLimit(userId, newNickname);
                    ref.invalidate(currentUserNicknameProvider);
                    ref.invalidate(nicknameChangeInfoProvider);

                    if (context.mounted) {
                      SnackBarHelper.showSuccess(context, '닉네임이 변경되었습니다');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      SnackBarHelper.showError(context, '닉네임 변경 실패: $e');
                    }
                  }
                },
                child: const Text('변경'),
              ),
            ],
          ),
        );
      },
      loading: () => SnackBarHelper.showInfo(context, '로딩 중...'),
      error: (e, _) => SnackBarHelper.showError(context, '정보 로드 실패'),
    );
  }

  String _getThemeModeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return '다크 모드';
      case AppThemeMode.light:
        return '라이트 모드';
      case AppThemeMode.system:
        return '시스템 설정';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('테마 선택'),
        content: RadioGroup<AppThemeMode>(
          groupValue: currentMode,
          onChanged: (value) {
            if (value != null) {
              ref.read(appThemeModeProvider.notifier).setThemeMode(value);
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppThemeMode>(
                title: const Text('다크 모드'),
                subtitle: const Text('어두운 배경'),
                value: AppThemeMode.dark,
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('라이트 모드'),
                subtitle: const Text('밝은 배경'),
                value: AppThemeMode.light,
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('시스템 설정'),
                subtitle: const Text('시스템 설정을 따름'),
                value: AppThemeMode.system,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCheckButton(WidgetRef ref) {
    final versionCheckAsync = ref.watch(versionCheckProvider);

    return versionCheckAsync.when(
      data: (result) {
        if (result.needsUpdate) {
          return TextButton(
            onPressed: () {
              if (result.updateUrl != null) {
                _launchUrl(result.updateUrl!);
              }
            },
            child: Text(
              '업데이트 가능',
              style: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return Text(
          '최신 버전',
          style: TextStyle(
            color: Colors.green[600],
            fontSize: 14,
          ),
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stackTrace) => const Text(
        '확인 불가',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 사장님으로 전환 타일 (일반 사용자만 표시)
  Widget _buildOwnerRequestTile(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentUserRoleProvider);
    final requestStatusAsync = ref.watch(ownerRequestStatusProvider);

    return roleAsync.when(
      data: (role) {
        // 이미 사장님이거나 관리자이면 표시하지 않음
        if (role == 'owner' || role == 'admin') {
          return const SizedBox.shrink();
        }

        // 사장님 신청 상태 확인
        return requestStatusAsync.when(
          data: (requestStatus) {
            if (requestStatus != null) {
              final status = requestStatus['status'] as String?;
              if (status == 'pending') {
                // 대기 중인 신청이 있음
                return ListTile(
                  leading: const Icon(Icons.hourglass_top, color: Colors.orange),
                  title: const Text('사장님 인증 대기 중'),
                  subtitle: const Text('관리자 승인을 기다리고 있습니다'),
                  trailing: const Icon(Icons.info_outline, color: Colors.orange),
                  onTap: () => _showRequestStatusDialog(context, requestStatus),
                );
              } else if (status == 'rejected') {
                // 거절된 신청
                return ListTile(
                  leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                  title: const Text('사장님 인증 거절됨'),
                  subtitle: Text(requestStatus['rejectReason'] as String? ?? '다시 신청할 수 있습니다'),
                  trailing: const Icon(Icons.refresh),
                  onTap: () => _showOwnerRequestDialog(context, ref),
                );
              }
            }

            // 신청 전 상태
            return ListTile(
              leading: Icon(Icons.store_outlined, color: Colors.green[600]),
              title: const Text('사장님으로 전환'),
              subtitle: const Text('내 푸드트럭을 등록하고 관리하세요'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '신청',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => _showOwnerRequestDialog(context, ref),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// 사장님 신청 상태 다이얼로그
  void _showRequestStatusDialog(BuildContext context, Map<String, dynamic> status) {
    showDialog(
      context: context,
      builder: (context) => OwnerRequestStatusDialog(status: status),
    );
  }

  /// 사장님 신청 다이얼로그 (상호명, 파일 업로드 필수)
  void _showOwnerRequestDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const OwnerRequestDialog(),
    );
  }
}