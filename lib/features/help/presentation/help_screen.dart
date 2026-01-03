import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/themes/app_theme.dart';

/// 도움말 화면 - 손님/사장님용 가이드
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('도움말'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '🛒 주문하기',
              [
                _HelpItem(
                  question: '푸드트럭 어떻게 찾나요?',
                  answer: '지도에서 트럭 위치를 확인하거나\n트럭 리스트에서 검색하세요.\n거리순/인기순 정렬도 가능합니다.',
                ),
                _HelpItem(
                  question: '주문은 어떻게 하나요?',
                  answer: '트럭 상세화면 → 메뉴 선택 → 장바구니\n→ 주문하기 → 계좌이체\n입금자명을 입력하면 주문 완료!',
                ),
                _HelpItem(
                  question: '계좌이체는 어떻게 하나요?',
                  answer: '1. 계좌번호 복사 버튼 클릭\n2. 은행앱 열기 버튼 클릭\n3. 은행앱에서 이체\n4. 입금자명 입력 후 완료',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              '⭐ 리뷰 & 즐겨찾기',
              [
                _HelpItem(
                  question: '리뷰는 어떻게 작성하나요?',
                  answer: '트럭 상세화면 하단의 리뷰 섹션\n→ 리뷰 작성 버튼\n→ 별점, 내용, 사진(선택) 입력',
                ),
                _HelpItem(
                  question: '즐겨찾기 기능은?',
                  answer: '자주 가는 트럭을 즐겨찾기 하면\n영업 시작 알림을 받을 수 있어요!',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              '🚚 사장님 기능',
              [
                _HelpItem(
                  question: '트럭 등록은 어떻게 하나요?',
                  answer: '트럭 번호 입력 → 6단계 온보딩\n1. 기본정보 2. 위치 3. 메뉴\n4. 영업시간 5. 계좌번호 6. 완료',
                ),
                _HelpItem(
                  question: '주문 관리는?',
                  answer: '사장님 대시보드 → 주문 관리\n칸반 보드로 직관적 관리!\n대기/준비중/완료 상태로 이동',
                ),
                _HelpItem(
                  question: '계좌이체 주문 확인은?',
                  answer: '주문 카드에 오렌지 테두리 표시\n입금자명이 표시됩니다.\n입금 확인 후 "준비중"으로 이동',
                ),
                _HelpItem(
                  question: '리뷰 관리는?',
                  answer: '사장님 대시보드 → 리뷰 관리\n필터: 별점별, 답글없음\n정렬: 최신순, 높은평점, 낮은평점',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              '❓ 자주 묻는 질문',
              [
                _HelpItem(
                  question: '영업 중인 트럭만 보려면?',
                  answer: '트럭 리스트 화면 상단\n필터 버튼 → "영업 중" 선택',
                ),
                _HelpItem(
                  question: '주문 취소는 어떻게 하나요?',
                  answer: '주문 접수 전: 장바구니 비우기\n주문 후: 사장님께 직접 문의\n(리뷰에 남겨주세요)',
                ),
                _HelpItem(
                  question: '알림 설정은?',
                  answer: '설정 → 알림 설정\n즐겨찾기 트럭 영업 시작 알림,\n주문 상태 변경 알림 등 설정 가능',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildContactSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_HelpItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.mustardYellow,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildHelpItem(item)),
      ],
    );
  }

  Widget _buildHelpItem(_HelpItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.mustardYellow15,
            AppTheme.mustardYellow10,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.mustardYellow, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.support_agent,
            color: AppTheme.mustardYellow,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            '더 궁금한 점이 있으신가요?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '문의사항은 GitHub Issues로\n언제든 남겨주세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final url = Uri.parse('https://github.com/hyunwoooim-star/truck_tracker/issues');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.bug_report),
            label: const Text('문의하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mustardYellow,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpItem {
  final String question;
  final String answer;

  const _HelpItem({
    required this.question,
    required this.answer,
  });
}
