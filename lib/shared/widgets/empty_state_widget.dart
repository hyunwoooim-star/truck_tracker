import 'package:flutter/material.dart';

/// 공통 빈 상태 위젯
///
/// 데이터가 없을 때 표시되는 통일된 UI를 제공합니다.
/// 모든 화면에서 일관된 빈 상태 표시를 위해 사용합니다.
///
/// Example:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.favorite_border,
///   title: '즐겨찾기가 없습니다',
///   subtitle: '마음에 드는 트럭을 즐겨찾기에 추가해보세요',
///   action: () => Navigator.pushNamed(context, '/trucks'),
///   actionLabel: '트럭 찾아보기',
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
    this.iconSize = 64,
    this.iconColor,
  });

  /// 표시할 아이콘
  final IconData icon;

  /// 메인 제목 텍스트
  final String title;

  /// 부가 설명 텍스트 (선택)
  final String? subtitle;

  /// 액션 버튼 클릭 시 실행할 콜백 (선택)
  final VoidCallback? action;

  /// 액션 버튼 라벨 (선택)
  final String? actionLabel;

  /// 아이콘 크기 (기본값: 64)
  final double iconSize;

  /// 아이콘 색상 (기본값: grey[600])
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? (isDark ? Colors.grey[600] : Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: action,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
