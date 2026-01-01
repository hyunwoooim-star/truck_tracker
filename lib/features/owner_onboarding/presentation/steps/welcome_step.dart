import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';

/// Step 1: 환영 화면
class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // 트럭 아이콘 애니메이션
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.mustardYellow.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.local_shipping,
                  size: 80,
                  color: AppTheme.mustardYellow,
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // 축하 메시지
          const Text(
            '🎉 축하합니다!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.mustardYellow,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '사장님으로 승인되었습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 32),

          // 설명
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.store,
                  '트럭 정보를 입력하세요',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.restaurant_menu,
                  '메뉴를 등록하세요',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.schedule,
                  '영업 시간을 설정하세요',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.check_circle,
                  '5분이면 완료!',
                ),
              ],
            ),
          ),

          const Spacer(flex: 2),

          // 시작 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mustardYellow,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: const Text(
                '시작하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.mustardYellow, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
