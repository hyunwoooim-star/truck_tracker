import 'package:flutter/material.dart';

import '../../core/themes/app_theme.dart';

/// 토스 스타일 카드 위젯
/// - 탭 시 스케일 애니메이션 (0.98)
/// - 부드러운 그림자
/// - 둥근 모서리 (20px)
class TossCard extends StatefulWidget {
  const TossCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 20,
    this.backgroundColor,
    this.showShadow = true,
    this.border,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? backgroundColor;
  final bool showShadow;
  final Border? border;

  @override
  State<TossCard> createState() => _TossCardState();
}

class _TossCardState extends State<TossCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? AppTheme.tossGray900 : AppTheme.tossGray50);

    return Padding(
      padding: widget.margin,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.border,
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: AppTheme.tossShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: AppTheme.tossShadowMedium,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// 토스 스타일 리스트 아이템 카드
/// TossCard를 기반으로 리스트 아이템에 최적화
class TossListCard extends StatelessWidget {
  const TossListCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      padding: padding,
      margin: margin,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// 토스 스타일 트럭 카드
/// 메인 화면의 트럭 리스트에 사용
class TossTruckCard extends StatelessWidget {
  const TossTruckCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.foodType,
    required this.statusWidget,
    this.distance,
    this.location,
    this.onTap,
    this.imageBuilder,
  });

  final String imageUrl;
  final String name;
  final String foodType;
  final Widget statusWidget;
  final String? distance;
  final String? location;
  final VoidCallback? onTap;
  final Widget Function(String url)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TossCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // 트럭 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: imageBuilder?.call(imageUrl) ??
                Container(
                  width: 56,
                  height: 56,
                  color: isDark ? AppTheme.tossGray800 : AppTheme.tossGray200,
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    color: AppTheme.tossGray500,
                  ),
                ),
          ),
          const SizedBox(width: 14),
          // 트럭 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 이름 + 상태
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTheme.textPrimary
                              : AppTheme.tossGray900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    statusWidget,
                  ],
                ),
                const SizedBox(height: 4),
                // 음식 종류
                Text(
                  foodType,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.tossBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                // 거리 + 위치
                Row(
                  children: [
                    if (distance != null) ...[
                      Icon(
                        Icons.near_me,
                        size: 13,
                        color: AppTheme.tossBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.tossBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    if (location != null) ...[
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppTheme.tossGray500,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.tossGray500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 토스 스타일 상태 태그
/// 영업중/대기중/정비중 등 상태 표시
class TossStatusTag extends StatelessWidget {
  const TossStatusTag({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
  });

  final String label;
  final Color? color;
  final Color? backgroundColor;

  /// 영업중 상태 태그
  factory TossStatusTag.open({String label = '영업중'}) {
    return TossStatusTag(
      label: label,
      color: AppTheme.tossGreen,
      backgroundColor: const Color(0x1A00C48C), // tossGreen 10%
    );
  }

  /// 대기중 상태 태그
  factory TossStatusTag.resting({String label = '대기중'}) {
    return TossStatusTag(
      label: label,
      color: AppTheme.tossGray500,
      backgroundColor: const Color(0x1A8B95A1), // tossGray500 10%
    );
  }

  /// 점검중 상태 태그
  factory TossStatusTag.maintenance({String label = '점검중'}) {
    return TossStatusTag(
      label: label,
      color: AppTheme.tossOrange,
      backgroundColor: const Color(0x1AFF9F40), // tossOrange 10%
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagColor = color ?? AppTheme.tossBlue;
    final bgColor = backgroundColor ?? tagColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: tagColor,
        ),
      ),
    );
  }
}
