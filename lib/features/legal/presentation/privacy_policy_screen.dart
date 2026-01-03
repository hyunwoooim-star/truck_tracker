import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

/// 개인정보 처리방침 화면
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. 개인정보의 수집 및 이용 목적',
              '''Truck Tracker는 다음의 목적을 위하여 개인정보를 처리합니다:

• 회원 가입 및 관리
  - 이메일, 소셜 로그인 정보를 통한 회원제 서비스 제공
  - 본인 확인, 부정 이용 방지

• 푸드트럭 위치 서비스 제공
  - 사용자의 현재 위치 기반 근처 트럭 검색
  - 즐겨찾기 트럭 영업 시작 알림

• 주문 및 결제 서비스
  - 주문 내역 관리, 계좌이체 안내
  - 입금자명 확인을 위한 정보 수집

• 리뷰 및 커뮤니티 서비스
  - 리뷰 작성, 사진 업로드
  - 사장님 답글 기능

• 푸드트럭 사장님 서비스
  - 트럭 등록 및 관리
  - 주문 관리, 영업 상태 관리
  - 계좌번호 등록 (계좌이체 주문용)''',
            ),
            _buildSection(
              '2. 수집하는 개인정보 항목',
              '''필수 수집 항목:
• 회원가입: 이메일, 비밀번호 (또는 소셜 로그인 정보)
• 위치정보: GPS 좌표 (서비스 이용 시)
• 주문정보: 입금자명, 주문 내역

선택 수집 항목:
• 프로필: 닉네임, 프로필 사진
• 리뷰: 리뷰 내용, 사진
• 사장님: 트럭명, 연락처, 계좌번호''',
            ),
            _buildSection(
              '3. 개인정보의 보유 및 이용 기간',
              '''• 회원 탈퇴 시까지
• 관계 법령 위반 시 수사/조사 종료 시까지
• 리뷰/주문 기록: 작성 후 3년''',
            ),
            _buildSection(
              '4. 개인정보의 제3자 제공',
              '''Truck Tracker는 원칙적으로 개인정보를 제3자에게 제공하지 않습니다.
다만, 다음의 경우 예외로 합니다:

• 사용자가 사전에 동의한 경우
• 법령에 의해 요구되는 경우''',
            ),
            _buildSection(
              '5. 개인정보의 파기',
              '''• 보유 기간 만료 시 즉시 파기
• 전자적 파일: 복구 불가능한 방법으로 영구 삭제
• 종이 문서: 분쇄 또는 소각''',
            ),
            _buildSection(
              '6. 이용자의 권리',
              '''이용자는 언제든지 다음의 권리를 행사할 수 있습니다:

• 개인정보 열람 요구
• 개인정보 정정·삭제 요구
• 개인정보 처리 정지 요구
• 회원 탈퇴 (개인정보 삭제)

권리 행사는 앱 내 "설정" → "계정 관리"에서 가능합니다.''',
            ),
            _buildSection(
              '7. 개인정보 보호책임자',
              '''• 책임자: 개발자
• 이메일: GitHub Issues를 통해 문의
• GitHub: https://github.com/hyunwoooim-star/truck_tracker''',
            ),
            _buildSection(
              '8. 개인정보 처리방침 변경',
              '''본 방침은 2026년 1월 3일부터 시행됩니다.
법령이나 서비스 변경사항 반영을 위해 수정될 수 있습니다.''',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '최종 수정일: 2026년 1월 3일',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.mustardYellow,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
