import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

/// Help screen with app usage guide
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    size: 48,
                    color: isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '트럭아저씨 사용 가이드',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '맛있는 푸드트럭을 찾아보세요!',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // For Customers Section
          _HelpSection(
            icon: Icons.person,
            title: '고객님을 위한 기능',
            items: [
              _HelpItem(
                icon: Icons.map,
                title: '지도에서 트럭 찾기',
                description: '지도에서 현재 영업 중인 푸드트럭의 위치를 실시간으로 확인할 수 있어요. '
                    '마커를 탭하면 트럭 정보를 볼 수 있습니다.',
              ),
              _HelpItem(
                icon: Icons.search,
                title: '검색 & 필터',
                description: '음식 종류, 거리, 평점으로 원하는 트럭을 빠르게 찾아보세요. '
                    '고급 필터로 더 세밀하게 검색할 수 있어요.',
              ),
              _HelpItem(
                icon: Icons.favorite,
                title: '즐겨찾기',
                description: '좋아하는 트럭을 즐겨찾기에 추가하면 영업 시작 알림을 받을 수 있어요.',
              ),
              _HelpItem(
                icon: Icons.qr_code_scanner,
                title: 'QR 체크인',
                description: '트럭 방문 시 QR 코드를 스캔하면 포인트가 적립됩니다. '
                    '10회 방문 시 특별 혜택을 받을 수 있어요!',
              ),
              _HelpItem(
                icon: Icons.star,
                title: '리뷰 작성',
                description: '방문 후 리뷰를 남겨주세요. 다른 고객들에게 도움이 되고, '
                    '사장님께 소중한 피드백이 됩니다.',
              ),
              _HelpItem(
                icon: Icons.chat,
                title: '채팅',
                description: '트럭 사장님과 직접 대화할 수 있어요. 메뉴 문의, 예약 등 '
                    '궁금한 점을 물어보세요.',
              ),
              _HelpItem(
                icon: Icons.local_offer,
                title: '쿠폰',
                description: '트럭별 발행된 쿠폰을 확인하고 사용하세요. '
                    '할인 혜택을 놓치지 마세요!',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // For Owners Section
          _HelpSection(
            icon: Icons.store,
            title: '사장님을 위한 기능',
            items: [
              _HelpItem(
                icon: Icons.dashboard,
                title: '대시보드',
                description: '오늘의 매출, 방문객 수, 리뷰 등을 한눈에 확인할 수 있어요.',
              ),
              _HelpItem(
                icon: Icons.location_on,
                title: '위치 업데이트',
                description: '현재 위치를 업데이트하면 고객들이 트럭을 쉽게 찾을 수 있어요.',
              ),
              _HelpItem(
                icon: Icons.restaurant_menu,
                title: '메뉴 관리',
                description: '메뉴를 추가, 수정, 삭제하고 가격을 설정하세요. '
                    '사진을 첨부하면 더 매력적으로 보여요.',
              ),
              _HelpItem(
                icon: Icons.qr_code,
                title: 'QR 코드',
                description: '고객 체크인용 QR 코드를 생성하고 표시하세요.',
              ),
              _HelpItem(
                icon: Icons.analytics,
                title: '통계',
                description: '일별, 주별 방문 통계와 매출 현황을 분석해보세요.',
              ),
              _HelpItem(
                icon: Icons.local_offer,
                title: '쿠폰 발행',
                description: '할인 쿠폰을 발행하여 더 많은 고객을 유치하세요.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Notifications Section
          _HelpSection(
            icon: Icons.notifications,
            title: '알림 설정',
            items: [
              _HelpItem(
                icon: Icons.location_searching,
                title: '근처 트럭 알림',
                description: '설정한 반경 내에 트럭이 나타나면 알림을 받을 수 있어요. '
                    '설정에서 반경을 조절하세요.',
              ),
              _HelpItem(
                icon: Icons.favorite_border,
                title: '즐겨찾기 트럭 알림',
                description: '즐겨찾기한 트럭이 영업을 시작하면 알림을 받습니다.',
              ),
              _HelpItem(
                icon: Icons.message,
                title: '채팅 알림',
                description: '새 메시지가 오면 푸시 알림을 받습니다.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tips Section
          _HelpSection(
            icon: Icons.lightbulb,
            title: '꿀팁',
            items: [
              _HelpItem(
                icon: Icons.star_half,
                title: '평점 필터 활용',
                description: '평점 4.0 이상만 보기 등 필터를 활용하면 '
                    '인기 있는 트럭을 빠르게 찾을 수 있어요.',
              ),
              _HelpItem(
                icon: Icons.schedule,
                title: '영업 시간 확인',
                description: '트럭마다 영업 시간이 달라요. 방문 전 확인하세요.',
              ),
              _HelpItem(
                icon: Icons.directions,
                title: '길찾기',
                description: '트럭 상세 화면에서 네이버/카카오/구글 지도로 '
                    '바로 길찾기를 할 수 있어요.',
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Contact Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.help_center,
                  size: 40,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 12),
                Text(
                  '더 궁금한 점이 있으신가요?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '설정 > 피드백 보내기에서 문의해주세요.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Help section widget
class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<_HelpItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark ? AppTheme.mustardYellow : AppTheme.mustardYellowDark,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: item,
            )),
      ],
    );
  }
}

/// Individual help item widget
class _HelpItem extends StatelessWidget {
  const _HelpItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.electricBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: AppTheme.electricBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
