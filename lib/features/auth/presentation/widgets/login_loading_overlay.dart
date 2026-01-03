import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';

/// 로그인 로딩 오버레이 - 심플한 애니메이션과 프로그레스 바
class LoginLoadingOverlay extends StatefulWidget {
  const LoginLoadingOverlay({super.key});

  @override
  State<LoginLoadingOverlay> createState() => _LoginLoadingOverlayState();
}

class _LoginLoadingOverlayState extends State<LoginLoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _bounceController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Shimmer 애니메이션 (무한 반복) - 왼쪽에서 오른쪽으로 이동
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _shimmerController.repeat(); // 무한 반복

    // 트럭 바운스 애니메이션
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 트럭 아이콘 애니메이션
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_bounceAnimation.value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.mustardYellow.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping,
                  size: 64,
                  color: AppTheme.mustardYellow,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 로딩 텍스트
            const Text(
              '접속 중...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none, // 밑줄 제거
              ),
            ),

            const SizedBox(height: 16),

            // 프로그레스 바 (Shimmer 효과 - 무한 반복)
            Container(
              width: 200,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.hardEdge,
              child: AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // 베이스 바
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.mustardYellow.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // Shimmer 효과
                      Positioned(
                        left: _shimmerAnimation.value * 200,
                        child: Container(
                          width: 80,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.mustardYellow.withValues(alpha: 0.0),
                                AppTheme.mustardYellow,
                                AppTheme.mustardYellow.withValues(alpha: 0.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.mustardYellow.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// 로딩 오버레이 상태 관리를 위한 GlobalKey
final GlobalKey<NavigatorState> _overlayNavigatorKey = GlobalKey<NavigatorState>();

/// 현재 오버레이가 표시 중인지 추적
bool _isOverlayShowing = false;

/// 오버레이가 표시 중인지 확인 (외부에서 접근 가능)
bool get isLoginOverlayShowing => _isOverlayShowing;

/// 로그인 로딩 오버레이를 쉽게 표시하는 헬퍼 함수
void showLoginLoadingOverlay(BuildContext context) {
  if (_isOverlayShowing) return; // 이미 표시 중이면 무시

  _isOverlayShowing = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    routeSettings: const RouteSettings(name: 'loginLoadingOverlay'),
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: const LoginLoadingOverlay(),
    ),
  ).then((_) {
    // 다이얼로그가 닫히면 상태 초기화
    _isOverlayShowing = false;
  });
}

/// 로그인 로딩 오버레이 닫기
void hideLoginLoadingOverlay(BuildContext context) {
  if (!_isOverlayShowing) return; // 표시 중이 아니면 무시

  _isOverlayShowing = false;

  // 여러 방법으로 시도
  try {
    // 1. rootNavigator로 pop 시도
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
  } catch (_) {}

  try {
    // 2. 일반 Navigator로 pop 시도
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
  } catch (_) {}

  try {
    // 3. popUntil로 시도
    Navigator.of(context, rootNavigator: true).popUntil((route) {
      if (route.settings.name == 'loginLoadingOverlay') {
        return false; // 이 route를 pop
      }
      return true; // 다른 route는 유지
    });
  } catch (_) {
    // 모든 방법 실패 - 무시
  }
}

/// 전역 NavigatorKey를 저장 (main.dart에서 설정)
GlobalKey<NavigatorState>? _globalNavigatorKey;

/// 전역 NavigatorKey 설정 (main.dart에서 호출)
void setGlobalNavigatorKey(GlobalKey<NavigatorState> key) {
  _globalNavigatorKey = key;
}

/// 로그인 오버레이 강제 닫기 (context 없이 사용 가능)
/// AuthWrapper에서 로그인 성공 시 호출
void forceHideLoginLoadingOverlay() {
  if (!_isOverlayShowing) return;

  _isOverlayShowing = false;

  try {
    final navigatorState = _globalNavigatorKey?.currentState;
    if (navigatorState != null && navigatorState.canPop()) {
      navigatorState.pop();
    }
  } catch (_) {
    // 실패해도 무시 - 이미 닫혔거나 없는 경우
  }
}
