import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../core/themes/app_theme.dart';

/// 앱 설정 화면 - 앱 사용 관련 설정만
class OwnerAppSettingsScreen extends ConsumerWidget {
  const OwnerAppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앱 설정 섹션
            _SettingsSection(
              title: '앱 설정',
              icon: Icons.app_settings_alt,
              items: [
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  label: '알림 설정',
                  subtitle: '푸시 알림 수신 여부',
                  onTap: () => _showNotificationSettings(context),
                ),
                _SettingsItem(
                  icon: Icons.language,
                  label: '언어 설정',
                  subtitle: '한국어',
                  onTap: () => _showLanguageSettings(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 정보 섹션
            _SettingsSection(
              title: '정보',
              icon: Icons.info_outline,
              items: [
                _SettingsItem(
                  icon: Icons.description_outlined,
                  label: '이용약관',
                  onTap: () => _showTermsDialog(context, l10n),
                ),
                _SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  label: l10n.privacyPolicy,
                  onTap: () => _showPrivacyDialog(context, l10n),
                ),
                _SettingsItem(
                  icon: Icons.info_outline,
                  label: '앱 정보',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAppInfoDialog(context, l10n),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text('알림 설정', style: TextStyle(color: Colors.white)),
        content: const Text(
          '알림 설정은 기기의 설정 앱에서 변경할 수 있습니다.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: AppTheme.mustardYellow)),
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text('언어 설정', style: TextStyle(color: Colors.white)),
        content: const Text(
          '현재 한국어만 지원합니다.\n추후 영어 지원 예정입니다.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: AppTheme.mustardYellow)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text('이용약관', style: TextStyle(color: Colors.white)),
        content: const SingleChildScrollView(
          child: Text(
            '트럭아저씨 서비스 이용약관\n\n'
            '제1조 (목적)\n'
            '본 약관은 트럭아저씨 앱 서비스 이용에 관한 조건 및 절차를 규정합니다.\n\n'
            '제2조 (서비스 이용)\n'
            '사용자는 본 서비스를 통해 푸드트럭 정보를 조회하고 관리할 수 있습니다.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok, style: const TextStyle(color: AppTheme.mustardYellow)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Text(l10n.privacyPolicyTitle, style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Text(
            l10n.privacyPolicyContent,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok, style: const TextStyle(color: AppTheme.mustardYellow)),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Text(l10n.truckUncle, style: const TextStyle(color: Colors.white)),
        content: const Text(
          'Version 1.0.0\n\n푸드트럭을 쉽게 찾고 관리할 수 있는 앱입니다.\n\n© 2026 트럭아저씨',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok, style: const TextStyle(color: AppTheme.mustardYellow)),
          ),
        ],
      ),
    );
  }
}

/// 설정 섹션
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 타이틀
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.mustardYellow, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        // 아이템 리스트
        Container(
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
        ),
      ],
    );
  }
}

/// 설정 아이템
class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.mustardYellow.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.mustardYellow, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }
}
