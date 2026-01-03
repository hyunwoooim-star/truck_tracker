import 'package:flutter/material.dart';

/// 반응형 컨테이너 위젯
/// PC 웹에서는 최대 너비를 제한하고 중앙 정렬
/// 모바일에서는 전체 너비 사용
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.backgroundColor,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// 반응형 Scaffold - body에 자동으로 반응형 적용
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.backgroundColor,
    this.maxWidth = 600,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Color? backgroundColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > maxWidth;

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      backgroundColor: backgroundColor ?? (isWideScreen ? Colors.grey[100] : null),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: isWideScreen
              ? BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                )
              : null,
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: bottomNavigationBar,
              ),
            )
          : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// 반응형 유틸리티 함수들
class ResponsiveUtils {
  /// 화면 너비에 따른 반응형 브레이크포인트
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  /// 화면 크기에 따른 그리드 열 수
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    return 4;
  }

  /// 화면 크기에 따른 패딩
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 24);
  }
}
