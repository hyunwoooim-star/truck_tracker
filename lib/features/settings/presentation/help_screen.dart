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
                title: 'QR 방문인증',
                description: '트럭 방문 시 사장님의 QR 코드를 스캔하면 스탬프가 적립됩니다. '
                    '10개 모으면 무료 쿠폰을 받을 수 있어요!',
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
                description: '고객 방문인증용 QR 코드를 생성하여 보여주세요.',
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

          const SizedBox(height: 24),

          // FAQ Section
          _FaqSection(
            icon: Icons.help_outline,
            title: '자주 묻는 질문 (FAQ)',
            items: [
              _FaqItem(
                question: '방문 인증이 안 돼요',
                answer: '방문 인증을 위해서는 다음 조건이 필요합니다:\n'
                    '• 트럭과 50m 이내에 있어야 합니다\n'
                    '• 하루에 같은 트럭은 1회만 인증 가능합니다\n'
                    '• GPS 권한이 필요합니다 (설정에서 위치 권한을 허용해주세요)\n'
                    '• 트럭이 "영업 중" 상태여야 합니다',
              ),
              _FaqItem(
                question: '스탬프가 안 쌓여요',
                answer: '스탬프가 쌓이지 않는 경우:\n'
                    '• 방문 인증이 정상적으로 완료되었는지 확인하세요\n'
                    '• 같은 트럭은 하루 1회만 스탬프가 적립됩니다\n'
                    '• 인터넷 연결 상태를 확인하세요\n'
                    '• 앱을 재시작해보세요',
              ),
              _FaqItem(
                question: '쿠폰은 어떻게 사용하나요?',
                answer: '스탬프 10개를 모으면 쿠폰이 발급됩니다:\n'
                    '• "내 정보" 탭에서 "내 쿠폰함"을 확인하세요\n'
                    '• 쿠폰을 탭하면 QR 코드가 표시됩니다\n'
                    '• 사장님께 QR 코드를 보여주시면 사용 처리됩니다',
              ),
              _FaqItem(
                question: '즐겨찾기가 안 돼요',
                answer: '즐겨찾기 문제 해결:\n'
                    '• 로그인이 되어있는지 확인하세요\n'
                    '• 인터넷 연결 상태를 확인하세요\n'
                    '• 앱을 종료 후 다시 시작해보세요',
              ),
              _FaqItem(
                question: '푸시 알림이 안 와요',
                answer: '푸시 알림 설정 확인:\n'
                    '• 기기 설정에서 앱 알림이 허용되어있는지 확인하세요\n'
                    '• 앱 내 "설정 > 알림 설정"에서 알림이 켜져있는지 확인하세요\n'
                    '• 배터리 절약 모드가 켜져있으면 알림이 지연될 수 있습니다',
              ),
              _FaqItem(
                question: '리뷰 작성이 안 돼요',
                answer: '리뷰를 작성하려면:\n'
                    '• 해당 트럭에서 주문을 완료해야 합니다\n'
                    '• 로그인이 되어있어야 합니다\n'
                    '• 리뷰 내용은 최소 5글자 이상이어야 합니다',
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

/// FAQ section widget
class _FaqSection extends StatelessWidget {
  const _FaqSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<_FaqItem> items;

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

/// Individual FAQ item widget with expandable answer
class _FaqItem extends StatefulWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          // Question header (tappable)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.help_outline,
                      size: 18,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          // Answer (expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
