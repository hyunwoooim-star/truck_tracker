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
  late AnimationController _progressController;
  late AnimationController _bounceController;
  late Animation<double> _progressAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // 프로그레스 바 애니메이션 (3초 동안 채워짐)
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.95).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _progressController.forward();

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
    _progressController.dispose();
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
              ),
            ),

            const SizedBox(height: 16),

            // 프로그레스 바
            Container(
              width: 200,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                borderRadius: BorderRadius.circular(4),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.mustardYellow,
                            AppTheme.mustardYellow.withValues(alpha: 0.7),
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
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 안내 텍스트
            Text(
              '잠시만 기다려주세요',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 로그인 로딩 오버레이를 쉽게 표시하는 헬퍼 함수
void showLoginLoadingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => const LoginLoadingOverlay(),
  );
}

/// 로그인 로딩 오버레이 닫기
void hideLoginLoadingOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
