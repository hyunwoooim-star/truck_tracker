import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';

/// 로그인 로딩 오버레이 - 재밌는 애니메이션과 프로그레스 바
class LoginLoadingOverlay extends StatefulWidget {
  final String provider; // 'kakao', 'naver', 'google', 'email'

  const LoginLoadingOverlay({
    super.key,
    required this.provider,
  });

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

  String get _providerName {
    switch (widget.provider) {
      case 'kakao':
        return '카카오';
      case 'naver':
        return '네이버';
      case 'google':
        return '구글';
      case 'email':
        return '이메일';
      default:
        return '';
    }
  }

  Color get _providerColor {
    switch (widget.provider) {
      case 'kakao':
        return const Color(0xFFFEE500);
      case 'naver':
        return const Color(0xFF03C75A);
      case 'google':
        return Colors.white;
      case 'email':
        return AppTheme.mustardYellow;
      default:
        return AppTheme.mustardYellow;
    }
  }

  IconData get _providerIcon {
    switch (widget.provider) {
      case 'kakao':
        return Icons.chat_bubble;
      case 'naver':
        return Icons.north_east;
      case 'google':
        return Icons.g_mobiledata;
      case 'email':
        return Icons.email;
      default:
        return Icons.login;
    }
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
                      color: _providerColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 트럭 아이콘
                    const Icon(
                      Icons.local_shipping,
                      size: 64,
                      color: AppTheme.mustardYellow,
                    ),
                    const SizedBox(height: 8),
                    // 로그인 제공자 아이콘
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_providerIcon, size: 20, color: _providerColor),
                        const SizedBox(width: 4),
                        Text(
                          _providerName,
                          style: TextStyle(
                            color: _providerColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 로딩 텍스트
            Text(
              '로그인 중...',
              style: const TextStyle(
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
                            _providerColor,
                            _providerColor.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: _providerColor.withValues(alpha: 0.5),
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
void showLoginLoadingOverlay(BuildContext context, String provider) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => LoginLoadingOverlay(provider: provider),
  );
}

/// 로그인 로딩 오버레이 닫기
void hideLoginLoadingOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
