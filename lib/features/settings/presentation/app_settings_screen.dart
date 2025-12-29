import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/app_version_service.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/widgets/network_status_banner.dart';
import '../../notifications/presentation/notification_settings_screen.dart';

/// General app settings screen
class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                // Theme Section
                _buildSectionHeader(context, '화면'),
                ListTile(
                  leading: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark,
                  ),
                  title: const Text('테마'),
                  subtitle: Text(_getThemeModeLabel(themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context, ref, themeMode),
                ),

                const Divider(),

                // Notifications Section
                _buildSectionHeader(context, '알림'),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('알림 설정'),
                  subtitle: const Text('알림 유형별 설정'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                // App Info Section
                _buildSectionHeader(context, '앱 정보'),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('버전'),
                  subtitle: Text('v$kCurrentAppVersion'),
                  trailing: _buildVersionCheckButton(ref),
                ),
                ListTile(
                  leading: const Icon(Icons.policy_outlined),
                  title: const Text('개인정보 처리방침'),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => _launchUrl('https://example.com/privacy'),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('서비스 이용약관'),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => _launchUrl('https://example.com/terms'),
                ),

                const Divider(),

                // Support Section
                _buildSectionHeader(context, '지원'),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('도움말'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open help screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: const Text('피드백 보내기'),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => _launchUrl('mailto:support@example.com'),
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
                        '© 2024 Truck Tracker',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
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
}
