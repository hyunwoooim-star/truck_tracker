import 'package:flutter/material.dart';

/// 개인정보처리방침 화면 (한국 개인정보 보호법 준수)
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보처리방침'),
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
              '제1조 (개인정보의 처리 목적)',
              '''트럭아저씨(이하 "회사")는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

1. 회원 가입 및 관리
   - 회원제 서비스 이용에 따른 본인확인, 개인식별, 가입의사 확인, 회원자격 유지·관리, 서비스 부정이용 방지 등

2. 서비스 제공
   - 푸드트럭 위치 정보 제공, 주문 처리, 결제 서비스, 맞춤 서비스 제공, 리뷰 서비스 등

3. 고객 지원
   - 민원처리, 고지사항 전달, 문의 응대 등

4. 마케팅 및 광고 활용
   - 이벤트 및 광고성 정보 제공 (동의 시에만)''',
            ),
            _buildSection(
              context,
              '제2조 (처리하는 개인정보의 항목)',
              '''회사는 다음의 개인정보 항목을 처리하고 있습니다.

1. 필수 수집 항목
   • 이메일 주소
   • 이름 (닉네임)
   • 프로필 사진 (소셜 로그인 시)

2. 선택 수집 항목
   • 위치 정보 (GPS)
   • 휴대폰 번호

3. 자동 수집 항목
   • 서비스 이용 기록
   • 접속 로그
   • 기기 정보 (OS, 앱 버전)

4. 사장님 회원 추가 항목
   • 사업자 정보
   • 계좌 정보 (정산용)''',
            ),
            _buildSection(
              context,
              '제3조 (개인정보의 처리 및 보유 기간)',
              '''회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

1. 회원 정보: 회원 탈퇴 시까지
   - 단, 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지

2. 거래 기록: 5년 (전자상거래법)
   - 계약 또는 청약철회 등에 관한 기록: 5년
   - 대금결제 및 재화 등의 공급에 관한 기록: 5년
   - 소비자의 불만 또는 분쟁처리에 관한 기록: 3년

3. 접속 기록: 3개월 (통신비밀보호법)''',
            ),
            _buildSection(
              context,
              '제4조 (개인정보의 제3자 제공)',
              '''회사는 정보주체의 개인정보를 제1조에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.

현재 개인정보를 제3자에게 제공하고 있지 않습니다.

※ 향후 제3자 제공이 필요한 경우, 별도의 동의를 받겠습니다.''',
            ),
            _buildSection(
              context,
              '제5조 (개인정보 처리의 위탁)',
              '''회사는 원활한 서비스 제공을 위해 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.

1. Firebase (Google LLC)
   - 위탁 업무: 클라우드 데이터 저장 및 인증 서비스
   - 보유 기간: 회원 탈퇴 시 또는 위탁 계약 종료 시

2. Firebase Cloud Messaging (Google LLC)
   - 위탁 업무: 푸시 알림 발송
   - 보유 기간: 서비스 이용 기간

회사는 위탁계약 체결 시 관련 법령에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적·관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리·감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.''',
            ),
            _buildSection(
              context,
              '제6조 (정보주체의 권리·의무 및 행사방법)',
              '''정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.

1. 개인정보 열람 요구
2. 오류 등이 있을 경우 정정 요구
3. 삭제 요구
4. 처리정지 요구

■ 권리 행사 방법
- 앱 내 [마이페이지 > 설정]에서 직접 처리
- 이메일: support@truckajeossi.com
- 서면, 전화, 이메일을 통해 요청 가능

회사는 정보주체의 권리 행사 요청을 받은 경우 지체 없이(10일 이내) 처리하며, 처리가 지연될 경우 그 사유와 처리 예정일을 통지합니다.''',
            ),
            _buildSection(
              context,
              '제7조 (개인정보의 파기)',
              '''회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.

■ 파기 절차
정보주체가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다.

■ 파기 방법
- 전자적 파일 형태: 복구 및 재생이 불가능하도록 기술적 방법을 사용하여 삭제
- 종이에 출력된 정보: 분쇄기로 분쇄하거나 소각''',
            ),
            _buildSection(
              context,
              '제8조 (개인정보의 안전성 확보조치)',
              '''회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.

1. 관리적 조치
   - 내부관리계획 수립·시행
   - 개인정보 취급 직원 최소화 및 교육

2. 기술적 조치
   - 개인정보처리시스템 접근권한 관리
   - 접근통제시스템 설치
   - 고유식별정보 등의 암호화
   - 보안프로그램 설치

3. 물리적 조치
   - 전산실, 자료보관실 등에 대한 접근통제''',
            ),
            _buildSection(
              context,
              '제9조 (개인정보 보호책임자)',
              '''회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

■ 개인정보 보호책임자
- 성명: 임현우
- 직책: 대표
- 연락처: support@truckajeossi.com

■ 개인정보 보호 담당부서
- 부서명: 고객지원팀
- 연락처: support@truckajeossi.com

정보주체는 서비스를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다.''',
            ),
            _buildSection(
              context,
              '제10조 (권익침해 구제방법)',
              '''정보주체는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을 문의하실 수 있습니다.

■ 개인정보 침해신고센터 (한국인터넷진흥원 운영)
- 소관업무: 개인정보 침해사실 신고, 상담 신청
- 홈페이지: privacy.kisa.or.kr
- 전화: (국번없이) 118

■ 개인정보 분쟁조정위원회
- 소관업무: 개인정보 분쟁조정신청, 집단분쟁조정
- 홈페이지: www.kopico.go.kr
- 전화: (국번없이) 1833-6972

■ 대검찰청 사이버수사과
- 전화: (국번없이) 1301
- 홈페이지: www.spo.go.kr

■ 경찰청 사이버안전국
- 전화: (국번없이) 182
- 홈페이지: ecrm.cyber.go.kr''',
            ),
            _buildSection(
              context,
              '제11조 (개인정보 처리방침의 변경)',
              '''이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.

■ 공고일자: 2026년 1월 1일
■ 시행일자: 2026년 1월 1일''',
            ),
            const SizedBox(height: 40),
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
          '개인정보처리방침',
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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withAlpha(50)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '본 방침은 개인정보 보호법에 따라 작성되었습니다.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue[700],
                      ),
                ),
              ),
            ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문의처',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email_outlined, size: 16, color: isDark ? Colors.grey[400] : Colors.grey),
              const SizedBox(width: 8),
              Text(
                'support@truckajeossi.com',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
