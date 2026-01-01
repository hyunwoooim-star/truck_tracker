import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/themes/app_theme.dart';

/// 고객용 온보딩 튜토리얼 화면
/// 첫 앱 실행 시 4개의 슬라이드로 주요 기능을 소개합니다.
class CustomerOnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const CustomerOnboardingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<CustomerOnboardingScreen> createState() => _CustomerOnboardingScreenState();
}

class _CustomerOnboardingScreenState extends State<CustomerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.map_outlined,
      iconColor: Colors.blue,
      title: '주변 트럭 찾기',
      description: '지도에서 내 주변의\n푸드트럭을 한눈에\n찾아보세요!',
      backgroundColor: const Color(0xFF1A237E),
    ),
    OnboardingPage(
      icon: Icons.location_on,
      iconColor: Colors.green,
      title: '방문 인증하기',
      description: '트럭 50m 이내에서\n방문 인증 버튼을 눌러\n스탬프를 모으세요!',
      backgroundColor: const Color(0xFF1B5E20),
    ),
    OnboardingPage(
      icon: Icons.card_giftcard,
      iconColor: AppTheme.mustardYellow,
      title: '스탬프 모으기',
      description: '10개를 모으면\n무료 쿠폰을\n받을 수 있어요!',
      backgroundColor: const Color(0xFFE65100),
    ),
    OnboardingPage(
      icon: Icons.favorite,
      iconColor: Colors.red,
      title: '준비 완료!',
      description: '즐겨찾기와 리뷰로\n나만의 맛집을\n관리해보세요!',
      backgroundColor: const Color(0xFFC62828),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    // 건너뛰기 - 다음에 다시 표시될 수 있음
    widget.onComplete();
  }

  Future<void> _skipForToday() async {
    // 오늘 하루 보지 않기
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onboardingSkipUntil', DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch);
    widget.onComplete();
  }

  Future<void> _neverShowAgain() async {
    // 다시 보지 않기
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    widget.onComplete();
  }

  Future<void> _completeOnboarding() async {
    // 온보딩 완료 (시작하기 버튼)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 페이지 뷰
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // 상단 버튼들
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 하루동안 보지 않기
                TextButton(
                  onPressed: _skipForToday,
                  child: const Text(
                    '오늘 하루 안 보기',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),
                // 다시 보지 않기
                TextButton(
                  onPressed: _neverShowAgain,
                  child: const Text(
                    '다시 보지 않기',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 인디케이터 및 버튼
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // 페이지 인디케이터
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 다음/시작 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _pages[_currentPage].backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1 ? '다음' : '시작하기',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: page.backgroundColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // 아이콘 (일러스트 스타일)
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    page.icon,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // 제목
            Text(
              page.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // 설명
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

/// 온보딩 페이지 데이터 클래스
class OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Color backgroundColor;

  const OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });
}

/// 온보딩 완료 여부 확인 유틸리티
class OnboardingHelper {
  static const String _key = 'isFirstLaunch';
  static const String _skipUntilKey = 'onboardingSkipUntil';

  /// 온보딩을 표시해야 하는지 확인
  static Future<bool> shouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    // "다시 보지 않기"를 선택한 경우
    final isFirstLaunch = prefs.getBool(_key) ?? true;
    if (!isFirstLaunch) return false;

    // "오늘 하루 안 보기"를 선택한 경우
    final skipUntil = prefs.getInt(_skipUntilKey);
    if (skipUntil != null) {
      if (DateTime.now().millisecondsSinceEpoch < skipUntil) {
        return false; // 아직 스킵 기간 중
      }
    }

    return true;
  }

  /// 첫 실행 여부 확인 (레거시 호환)
  static Future<bool> isFirstLaunch() async {
    return shouldShowOnboarding();
  }

  /// 온보딩 완료 처리
  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
  }

  /// 온보딩 리셋 (테스트용)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_skipUntilKey);
  }
}
