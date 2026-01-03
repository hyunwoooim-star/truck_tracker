import 'package:flutter/material.dart';

import '../../../core/themes/app_theme.dart';

/// 이용약관 화면
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('이용약관'),
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
              '제1조 (목적)',
              '''본 약관은 Truck Tracker(이하 "서비스")의 이용과 관련하여 서비스 제공자와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.''',
            ),
            _buildSection(
              '제2조 (정의)',
              '''1. "서비스"란 푸드트럭 위치 찾기, 주문, 리뷰 등을 제공하는 모바일/웹 애플리케이션을 의미합니다.

2. "이용자"란 본 약관에 따라 서비스를 이용하는 회원 및 비회원을 말합니다.

3. "회원"이란 서비스에 가입하여 아이디를 부여받은 자를 말합니다.

4. "푸드트럭 사장님"이란 서비스에 트럭을 등록하고 주문을 받는 회원을 말합니다.''',
            ),
            _buildSection(
              '제3조 (약관의 효력 및 변경)',
              '''1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에게 그 효력이 발생합니다.

2. 서비스 제공자는 필요 시 약관을 변경할 수 있으며, 변경된 약관은 공지 후 7일이 경과한 날부터 효력이 발생합니다.

3. 이용자가 변경된 약관에 동의하지 않을 경우, 서비스 이용을 중단하고 탈퇴할 수 있습니다.''',
            ),
            _buildSection(
              '제4조 (회원가입)',
              '''1. 이용자는 서비스가 정한 가입 양식에 따라 회원정보를 기입한 후 본 약관에 동의함으로써 회원가입을 신청합니다.

2. 서비스는 다음 각 호의 경우 회원가입을 거부할 수 있습니다:
   • 타인의 명의를 이용한 경우
   • 허위 정보를 기재한 경우
   • 부정한 용도로 서비스를 이용하려는 경우''',
            ),
            _buildSection(
              '제5조 (서비스의 제공)',
              '''서비스는 다음과 같은 서비스를 제공합니다:

1. 푸드트럭 위치 검색 및 지도 표시
2. 푸드트럭 메뉴 조회 및 주문
3. 계좌이체 안내 서비스
4. 리뷰 작성 및 조회
5. 즐겨찾기 및 알림 서비스
6. 푸드트럭 등록 및 관리 (사장님)
7. 주문 관리 (사장님)''',
            ),
            _buildSection(
              '제6조 (서비스의 중단)',
              '''1. 서비스는 다음 각 호의 경우 서비스 제공을 일시 중단할 수 있습니다:
   • 설비 점검, 보수 등의 사유
   • 전기통신사업법에 규정된 기간통신사업자의 중단
   • 천재지변, 국가비상사태 등 불가항력적 사유

2. 서비스 중단 시 사전 또는 사후 공지합니다.''',
            ),
            _buildSection(
              '제7조 (주문 및 결제)',
              '''1. 본 서비스는 계좌이체 방식의 주문을 지원합니다.

2. 이용자는 주문 시 정확한 입금자명을 입력해야 합니다.

3. 주문 취소는 푸드트럭 사장님과 직접 협의해야 합니다.

4. 서비스는 주문 중개 역할만 하며, 실제 거래는 이용자와 푸드트럭 사장님 간에 이루어집니다.''',
            ),
            _buildSection(
              '제8조 (이용자의 의무)',
              '''1. 이용자는 다음 행위를 해서는 안 됩니다:
   • 타인의 정보 도용
   • 허위 정보 입력
   • 서비스 운영 방해
   • 타인에게 피해를 주는 행위
   • 음란물, 불법 정보 게시
   • 악의적 리뷰 작성

2. 위반 시 서비스 이용이 제한될 수 있습니다.''',
            ),
            _buildSection(
              '제9조 (책임의 제한)',
              '''1. 서비스는 천재지변, 불가항력으로 인한 서비스 제공 불가 시 책임이 면제됩니다.

2. 서비스는 이용자 간의 거래에 대해 책임지지 않습니다.

3. 이용자가 게시한 정보의 신뢰성, 정확성에 대한 책임은 이용자에게 있습니다.''',
            ),
            _buildSection(
              '제10조 (분쟁의 해결)',
              '''1. 서비스와 이용자 간 분쟁은 상호 협의를 통해 해결합니다.

2. 협의가 이루어지지 않을 경우, 관할 법원은 서비스 제공자의 소재지 법원으로 합니다.''',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '시행일: 2026년 1월 3일',
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
