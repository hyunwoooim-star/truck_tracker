// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get ownerCommandCenter => '사장님 관리센터';

  @override
  String get inputCashSale => '현금 판매 입력';

  @override
  String get amount => '금액 (₩)';

  @override
  String get memoOptional => '메모 (선택사항)';

  @override
  String get submitSale => '판매 등록';

  @override
  String get cashSaleRecordedSuccessfully => '현금 판매가 등록되었습니다';

  @override
  String get truckQRCode => '푸드트럭 QR 코드';

  @override
  String get showCustomersQRCode => '손님에게 체크인용 QR 코드를 보여주세요';

  @override
  String get todaysStatistics => '오늘의 통계';

  @override
  String get views => '조회수';

  @override
  String get reviews => '리뷰';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get viewFullAnalytics => '전체 통계 보기';

  @override
  String get manageReviews => '리뷰 관리';

  @override
  String get editTruckInfo => '트럭 정보 수정';

  @override
  String get updateLocation => '위치 업데이트';

  @override
  String get loading => '로딩 중...';

  @override
  String get errorLoadingDashboard => '대시보드 로딩 실패';

  @override
  String get selectDateRange => '날짜 범위 선택';

  @override
  String get downloadCSV => 'CSV 다운로드';

  @override
  String get date => '날짜';

  @override
  String get clicks => '클릭';

  @override
  String get csvDownloadedSuccessfully => 'CSV 다운로드 완료';

  @override
  String get errorDownloadingCSV => 'CSV 다운로드 실패';

  @override
  String get scanQRCode => 'QR 코드 스캔';

  @override
  String get checkinSuccess => '체크인 성공!';

  @override
  String get invalidQRCode => '유효하지 않은 QR 코드';

  @override
  String get cameraPermissionRequired => '카메라 권한 필요';

  @override
  String get enableCameraToScan => 'QR 코드 스캔을 위해 카메라를 활성화하세요';

  @override
  String get error => '오류';

  @override
  String get success => '성공';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get retry => '다시 시도';

  @override
  String get refresh => '새로고침';

  @override
  String get qrCheckInTooltip => 'QR 체크인';

  @override
  String get scheduleTooltip => '일정';

  @override
  String get analyticsTooltip => '통계';

  @override
  String get uploadDataTooltip => '데이터 업로드';

  @override
  String get noTruckRegistered => '등록된 트럭이 없습니다';

  @override
  String get errorLoadingTruckData => '트럭 데이터 로딩 실패';

  @override
  String get alreadyOpenForBusiness => '이미 영업 중입니다!';

  @override
  String get couldNotGetGPSLocation => 'GPS 위치를 가져올 수 없습니다';

  @override
  String get businessStartedNotification => '영업을 시작했습니다! 팔로워들에게 알림이 전송됩니다 🔔';

  @override
  String get businessOpen => '영업 중';

  @override
  String get startBusiness => '영업 시작';

  @override
  String get todaysSpecialNotice => '오늘의 특별 공지';

  @override
  String get noAnnouncementSet => '(공지사항이 설정되지 않았습니다)';

  @override
  String get editAnnouncement => '공지사항 수정';

  @override
  String get announcementDisplayedMessage => '이 공지사항은 트럭 상세 페이지 상단에 표시됩니다.';

  @override
  String get announcement => '공지사항';

  @override
  String get announcementHint => '예: \"오늘의 특별 메뉴: 닭꼬치 30% 할인!\"';

  @override
  String get announcementUpdated => '공지사항이 업데이트되었습니다!';

  @override
  String get save => '저장';

  @override
  String get itemName => '상품명';

  @override
  String get invalidAmount => '잘못된 금액입니다';

  @override
  String cashSaleRecorded(Object amount) {
    return '현금 판매 기록: ₩$amount';
  }

  @override
  String get regularsNearby => '주변 단골';

  @override
  String get todaysRevenue => '오늘의 매출';

  @override
  String get orderBoard => '주문 보드';

  @override
  String get pending => '대기';

  @override
  String get preparing => '준비 중';

  @override
  String get ready => '준비 완료';

  @override
  String get errorLoadingOrders => '주문 로딩 실패';

  @override
  String get menuItems => '메뉴 항목';

  @override
  String get noMenuItems => '메뉴 항목이 없습니다';

  @override
  String get errorLoadingMenu => '메뉴 로딩 실패';

  @override
  String get customerConversations => '고객 대화';

  @override
  String orderItemsTotal(Object count, Object total) {
    return '$count개 항목 - ₩$total';
  }

  @override
  String get selectDateRangeTooltip => '날짜 범위 선택';

  @override
  String get downloadCSVTooltip => 'CSV 다운로드';

  @override
  String get clickCount => '클릭 수';

  @override
  String get reviewCount => '리뷰 수';

  @override
  String get favoriteCount => '즐겨찾기 수';

  @override
  String get csvDownloadSuccess => 'CSV 다운로드 완료';

  @override
  String csvDownloadError(Object error) {
    return 'CSV 다운로드 실패: $error';
  }

  @override
  String get total => '합계';

  @override
  String get average => '평균';

  @override
  String get checkInQRCode => '체크인 QR 코드';

  @override
  String get checkInQR => '체크인 QR';

  @override
  String get bankTransfer => '계좌이체';

  @override
  String get showBankTransferQR => '계좌이체 결제를 위한 QR 코드';

  @override
  String get customerscanQR => '고객이 체크인하려면 이 QR 코드를 스캔하세요';

  @override
  String truckID(Object id) {
    return '트럭 ID: $id';
  }

  @override
  String get checkInBenefits => '체크인 혜택';

  @override
  String get benefitsList => '• 방문할 때마다 10 포인트 적립\n• 즐겨찾는 트럭 추적\n• 특별 프로모션 받기';

  @override
  String get pleaseEnterTruckID => '트럭 ID를 입력하세요';

  @override
  String get userNotLoggedIn => '로그인하지 않았습니다';

  @override
  String get truckNotFound => '트럭을 찾을 수 없습니다';

  @override
  String get alreadyCheckedInToday => '오늘 이미 이 트럭에 체크인했습니다!';

  @override
  String checkInFailed(Object error) {
    return '체크인 실패: $error';
  }

  @override
  String get checkInSuccessful => '체크인 성공!';

  @override
  String loyaltyPoints(Object truck) {
    return '$truck • +10 포인트';
  }

  @override
  String get checkIn => '체크인';

  @override
  String get scanQRCodeToCheckIn => 'QR 코드를 스캔하여 체크인';

  @override
  String get earnLoyaltyPoints => '방문할 때마다 포인트를 획득하세요!';

  @override
  String get or => '또는';

  @override
  String get enterTruckID => '트럭 ID 입력';

  @override
  String get enterTruckIDHint => '트럭 ID 입력 (예: truck_001)';

  @override
  String get checkInButton => '체크인';

  @override
  String get howItWorks => '사용 방법';

  @override
  String get howItWorksList =>
      '1. 푸드트럭의 QR 코드를 스캔하세요\n2. 방문할 때마다 10 포인트 적립\n3. 즐겨찾는 트럭을 추적하세요\n4. 하루에 트럭당 한 번만 체크인할 수 있습니다';

  @override
  String get errorLoadingData => '데이터를 불러올 수 없습니다';

  @override
  String get todaysSpecialAnnouncement => '오늘의 특별 공지';

  @override
  String todayLocation(Object location) {
    return '오늘: $location';
  }

  @override
  String get menu => '메뉴';

  @override
  String get errorLoadingReviews => '리뷰를 불러올 수 없습니다';

  @override
  String get reviewsTitle => '리뷰';

  @override
  String get noReviewsYet => '아직 리뷰가 없습니다';

  @override
  String get talkWithOwner => '사장님과 대화';

  @override
  String get navigation => '길찾기';

  @override
  String totalItems(Object count) {
    return '총 $count개';
  }

  @override
  String get placeOrder => '주문하기';

  @override
  String get writeReview => '리뷰 작성';

  @override
  String get soldOut => '품절';

  @override
  String priceWon(Object price) {
    return '$price원';
  }

  @override
  String get addToCart => '담기';

  @override
  String get ownerReply => '사장님 답글';

  @override
  String get location => '위치';

  @override
  String get chooseNavigationApp => '길찾기 앱 선택:';

  @override
  String get naverMap => '네이버지도';

  @override
  String get kakaoMap => '카카오맵';

  @override
  String get googleMaps => '구글맵';

  @override
  String get cannotOpenNaverMap => '네이버지도를 열 수 없습니다';

  @override
  String get cannotOpenKakaoMap => '카카오맵을 열 수 없습니다';

  @override
  String get cannotOpenGoogleMaps => '구글맵을 열 수 없습니다';

  @override
  String get loginRequiredToOrder => '주문하려면 로그인이 필요합니다';

  @override
  String get confirmOrder => '주문 확인';

  @override
  String totalMenuItems(Object count) {
    return '총 $count개 메뉴';
  }

  @override
  String get wouldYouLikeToOrder => '주문하시겠습니까?';

  @override
  String orderCompleted(Object orderId) {
    return '주문이 완료되었습니다! (주문번호: $orderId)';
  }

  @override
  String orderFailed(Object error) {
    return '주문 실패: $error';
  }

  @override
  String get truckUncle => '트럭아저씨';

  @override
  String get loginRequired => '로그인이 필요합니다';

  @override
  String get reviewSubmitted => '리뷰가 등록되었습니다';

  @override
  String reviewSubmissionFailed(Object error) {
    return '리뷰 등록 실패: $error';
  }

  @override
  String get starRating => '별점';

  @override
  String get reviewContent => '리뷰 내용';

  @override
  String get reviewPlaceholder => '이 트럭에 대한 리뷰를 작성해주세요';

  @override
  String get pleaseEnterReviewContent => '리뷰 내용을 입력해주세요';

  @override
  String get pleaseEnterAtLeast5Chars => '최소 5자 이상 입력해주세요';

  @override
  String get photosOptionalMax3 => '사진 (선택, 최대 3장)';

  @override
  String get addPhoto => '사진 추가';

  @override
  String get submit => '등록';
}
