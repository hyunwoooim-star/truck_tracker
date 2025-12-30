import 'package:flutter/material.dart';

/// 서비스 이용약관 화면
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용약관'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '제1조 (목적)',
              '''본 약관은 트럭아저씨(이하 "회사")가 제공하는 모바일 애플리케이션 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.''',
            ),
            _buildSection(
              context,
              '제2조 (용어의 정의)',
              '''본 약관에서 사용하는 용어의 정의는 다음과 같습니다.

1. "서비스"란 회사가 제공하는 푸드트럭 위치 정보 제공, 주문, 리뷰 등의 모바일 애플리케이션 서비스를 말합니다.

2. "이용자"란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 회원 및 비회원을 말합니다.

3. "회원"이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 서비스를 이용하는 자를 말합니다.

4. "사장님 회원"이란 푸드트럭을 운영하며 서비스를 통해 영업 정보를 등록하는 회원을 말합니다.

5. "손님 회원"이란 푸드트럭 정보를 조회하고 주문 및 리뷰를 작성하는 회원을 말합니다.''',
            ),
            _buildSection(
              context,
              '제3조 (약관의 효력 및 변경)',
              '''1. 본 약관은 서비스 화면에 게시하거나 기타의 방법으로 공지함으로써 효력이 발생합니다.

2. 회사는 합리적인 사유가 발생할 경우 관련 법령에 위배되지 않는 범위 내에서 본 약관을 변경할 수 있으며, 약관이 변경되는 경우 변경 내용과 적용일자를 명시하여 서비스 내에 적용일 7일 전에 공지합니다.

3. 변경된 약관에 동의하지 않는 회원은 회원 탈퇴를 요청할 수 있으며, 변경된 약관의 적용일 이후에도 서비스를 계속 이용하는 경우 변경된 약관에 동의한 것으로 간주합니다.''',
            ),
            _buildSection(
              context,
              '제4조 (서비스의 제공)',
              '''회사가 제공하는 서비스는 다음과 같습니다.

1. 손님 회원 서비스
   • 푸드트럭 위치 정보 조회
   • 푸드트럭 메뉴 조회 및 주문
   • 리뷰 작성 및 조회
   • 푸드트럭 즐겨찾기 및 팔로우
   • 사장님과 채팅
   • QR 체크인

2. 사장님 회원 서비스
   • 푸드트럭 정보 등록 및 관리
   • 메뉴 관리
   • 영업 상태 관리
   • 주문 관리
   • 리뷰 관리 및 답글
   • 통계 조회
   • 고객과 채팅

3. 기타 회사가 정하는 서비스''',
            ),
            _buildSection(
              context,
              '제5조 (서비스 이용)',
              '''1. 서비스는 연중무휴, 1일 24시간 제공을 원칙으로 합니다. 다만, 시스템 정기점검, 증설 및 교체 등의 사유로 서비스가 중단될 수 있습니다.

2. 회사는 서비스의 제공에 필요한 경우 정기점검을 실시할 수 있으며, 정기점검 시간은 서비스 제공 화면에 공지한 바에 따릅니다.

3. 회사는 천재지변, 전쟁, 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제됩니다.''',
            ),
            _buildSection(
              context,
              '제6조 (회원가입)',
              '''1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.

2. 회사는 다음 각 호에 해당하지 않는 한 회원가입을 승낙합니다.
   • 가입신청자가 본 약관에 의하여 이전에 회원자격을 상실한 적이 있는 경우
   • 등록 내용에 허위, 기재누락, 오기가 있는 경우
   • 기타 회원으로 등록하는 것이 회사의 기술상 현저히 지장이 있다고 판단되는 경우

3. 회원가입의 성립 시기는 회사의 승낙이 회원에게 도달한 시점으로 합니다.''',
            ),
            _buildSection(
              context,
              '제7조 (회원 탈퇴 및 자격 상실)',
              '''1. 회원은 회사에 언제든지 탈퇴를 요청할 수 있으며, 회사는 즉시 회원탈퇴를 처리합니다.

2. 회원이 다음 각 호의 사유에 해당하는 경우, 회사는 회원자격을 제한 및 정지시킬 수 있습니다.
   • 가입 신청 시에 허위 내용을 등록한 경우
   • 다른 사람의 서비스 이용을 방해하거나 그 정보를 도용하는 등 질서를 위협하는 경우
   • 서비스를 이용하여 법령 또는 본 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우
   • 허위 리뷰 작성 또는 악의적인 리뷰 조작 행위
   • 사장님 회원의 경우, 허위 정보 제공 또는 위생/안전 관련 문제 발생 시

3. 회사가 회원자격을 상실시키는 경우에는 회원등록을 말소합니다.''',
            ),
            _buildSection(
              context,
              '제8조 (이용자의 의무)',
              '''이용자는 다음 행위를 하여서는 안 됩니다.

1. 신청 또는 변경 시 허위 내용의 등록
2. 타인의 정보 도용
3. 회사가 게시한 정보의 변경
4. 회사가 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시
5. 회사와 기타 제3자의 저작권 등 지적재산권에 대한 침해
6. 회사 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위
7. 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 서비스에 공개 또는 게시하는 행위
8. 허위 리뷰 작성, 리뷰 조작 행위
9. 영업 방해 목적의 악의적 신고 행위''',
            ),
            _buildSection(
              context,
              '제9조 (게시물의 관리)',
              '''1. 회원의 게시물(리뷰, 채팅 등)이 관련 법령에 위반되는 내용을 포함하는 경우, 회사는 해당 게시물을 삭제할 수 있습니다.

2. 회사는 게시물이 다음 각 호에 해당하는 경우 사전 통지 없이 삭제할 수 있습니다.
   • 다른 회원 또는 제3자를 비방하거나 명예를 손상시키는 내용
   • 공공질서 및 미풍양속에 위반되는 내용
   • 범죄적 행위에 결부된다고 인정되는 내용
   • 회사의 저작권 등 지적재산권을 침해하는 내용
   • 허위 사실을 기재한 내용
   • 음란물 또는 청소년에게 유해한 내용

3. 회사는 게시물 관리 지침을 별도로 정하여 운영할 수 있습니다.''',
            ),
            _buildSection(
              context,
              '제10조 (주문 및 결제)',
              '''1. 이용자는 서비스 내에서 푸드트럭에 음식을 주문할 수 있습니다.

2. 주문은 사장님 회원이 확인 및 수락한 시점에 성립됩니다.

3. 결제는 현장 결제 또는 회사가 제공하는 결제 수단을 통해 이루어집니다.

4. 주문 취소는 사장님 회원이 주문을 확인하기 전까지 가능합니다.

5. 주문한 음식에 대한 품질 및 안전은 해당 푸드트럭 사장님에게 책임이 있습니다.''',
            ),
            _buildSection(
              context,
              '제11조 (면책조항)',
              '''1. 회사는 천재지변, 전쟁, 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제됩니다.

2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다.

3. 회사는 이용자가 서비스와 관련하여 게재한 정보, 자료, 사실의 신뢰도, 정확성 등의 내용에 관하여는 책임을 지지 않습니다.

4. 회사는 이용자 간 또는 이용자와 제3자 상호간에 서비스를 매개로 하여 거래 등을 한 경우에는 책임이 면제됩니다.

5. 푸드트럭에서 제공하는 음식의 품질, 위생, 맛 등에 대한 책임은 해당 푸드트럭 사장님에게 있습니다.''',
            ),
            _buildSection(
              context,
              '제12조 (분쟁해결)',
              '''1. 회사는 이용자로부터 제출되는 불만사항 및 의견을 우선적으로 처리합니다.

2. 회사와 이용자 간에 발생한 분쟁에 관한 소송은 대한민국 법률에 따르며, 회사의 본사 소재지를 관할하는 법원을 전속관할법원으로 합니다.''',
            ),
            _buildSection(
              context,
              '제13조 (저작권)',
              '''1. 회사가 작성한 서비스 내 저작물에 대한 저작권 기타 지적재산권은 회사에 귀속합니다.

2. 이용자가 서비스 내에 게시한 게시물의 저작권은 해당 게시물의 저작자에게 귀속됩니다.

3. 이용자는 서비스를 이용함으로써 얻은 정보 중 회사에게 지적재산권이 귀속된 정보를 회사의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '부칙',
              '''■ 공고일자: 2024년 12월 30일
■ 시행일자: 2024년 12월 30일

본 약관은 시행일로부터 적용되며, 종전의 약관은 본 약관으로 대체됩니다.''',
            ),
            const SizedBox(height: 20),
            _buildFooter(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '서비스 이용약관',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '트럭아저씨 (Truck Tracker)',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문의처',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.email_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('support@truckajeossi.com'),
            ],
          ),
        ],
      ),
    );
  }
}
