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
  String get showCustomersQRCode => '손님에게 방문인증용 QR 코드를 보여주세요';

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
  String get checkinSuccess => '방문인증 성공!';

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
  String get qrCheckInTooltip => 'QR 방문인증';

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
  String get edit => '수정';

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
  String get noOrdersYet => '아직 주문이 없습니다';

  @override
  String get noOrdersInColumn => '주문 없음';

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
  String get checkInQRCode => '방문인증 QR 코드';

  @override
  String get checkInQR => '방문인증 QR';

  @override
  String get bankTransfer => '계좌이체';

  @override
  String get showBankTransferQR => '계좌이체 결제를 위한 QR 코드';

  @override
  String get customerscanQR => '고객이 방문인증하려면 이 QR 코드를 스캔하세요';

  @override
  String truckID(Object id) {
    return '트럭 ID: $id';
  }

  @override
  String get checkInBenefits => '방문인증 혜택';

  @override
  String get benefitsList => '• 방문할 때마다 스탬프 적립\n• 10개 모으면 무료 쿠폰\n• 즐겨찾는 트럭 추적';

  @override
  String get pleaseEnterTruckID => '트럭 ID를 입력하세요';

  @override
  String get userNotLoggedIn => '로그인하지 않았습니다';

  @override
  String get truckNotFound => '트럭을 찾을 수 없습니다';

  @override
  String get alreadyCheckedInToday => '오늘 이미 이 트럭에서 방문인증 했습니다!';

  @override
  String checkInFailed(Object error) {
    return '방문인증 실패: $error';
  }

  @override
  String get checkInSuccessful => '방문인증 성공!';

  @override
  String loyaltyPoints(Object truck) {
    return '$truck • 스탬프 +1';
  }

  @override
  String get checkIn => 'QR 방문인증';

  @override
  String get scanQRCodeToCheckIn => 'QR 코드를 스캔하여 방문인증';

  @override
  String get earnLoyaltyPoints => '스탬프를 모아 무료 쿠폰을 받으세요!';

  @override
  String get or => '또는';

  @override
  String get enterTruckID => '트럭 ID 입력';

  @override
  String get enterTruckIDHint => '트럭 ID 입력 (예: truck_001)';

  @override
  String get checkInButton => '방문인증';

  @override
  String get howItWorks => '사용 방법';

  @override
  String get howItWorksList =>
      '1. 푸드트럭의 QR 코드를 스캔하세요\n2. 방문할 때마다 스탬프 1개 적립\n3. 스탬프 10개 모으면 무료 쿠폰!\n4. 하루에 트럭당 한 번만 인증 가능합니다';

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
  String get talkWithCustomers => '고객과 대화';

  @override
  String get noMessagesYet => '아직 메시지가 없습니다. 대화를 시작하세요!';

  @override
  String get errorLoadingMessages => '메시지 로딩 실패';

  @override
  String get me => '나';

  @override
  String get deleteMessage => '메시지 삭제';

  @override
  String get deleteMessageConfirmation => '정말 이 메시지를 삭제하시겠습니까?';

  @override
  String get messageDeleted => '메시지가 삭제되었습니다';

  @override
  String get messageDeleteFailed => '메시지 삭제에 실패했습니다';

  @override
  String get longPressToDelete => '꾹 눌러서 삭제';

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
  String get editReview => '리뷰 수정';

  @override
  String get myReview => '내 리뷰';

  @override
  String get deleteReview => '리뷰 삭제';

  @override
  String get deleteReviewConfirmation => '정말 이 리뷰를 삭제하시겠습니까?';

  @override
  String get reviewDeleted => '리뷰가 삭제되었습니다';

  @override
  String get reviewDeleteFailed => '리뷰 삭제에 실패했습니다';

  @override
  String get reviewUpdated => '리뷰가 수정되었습니다';

  @override
  String get reviewUpdateFailed => '리뷰 수정에 실패했습니다';

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
  String get purchaseRequiredForReview => '주문 후 리뷰를 작성할 수 있습니다';

  @override
  String get purchaseRequiredForTalk => '주문 후 댓글을 작성할 수 있습니다';

  @override
  String get verifyingPurchase => '구매 이력 확인 중...';

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

  @override
  String get truckList => '트럭 리스트';

  @override
  String get viewMap => '지도 보기';

  @override
  String get appInfo => '앱 정보';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get noTrucksAvailable => '현재 운영 중인 트럭이 없습니다';

  @override
  String get loadDataFailed => '데이터를 불러올 수 없습니다';

  @override
  String get favoriteFailed => '즐겨찾기 반영 실패!';

  @override
  String get favoriteSuccess => '즐겨찾기에 추가되었습니다!';

  @override
  String get favoriteRemoved => '즐겨찾기에서 제거되었습니다!';

  @override
  String get distance => '거리';

  @override
  String get rating => '평점';

  @override
  String get foodTruckMap => '푸드트럭 지도';

  @override
  String get cannotLoadMap => '지도를 불러올 수 없습니다';

  @override
  String get noTrucks => '트럭이 없습니다';

  @override
  String get pleaseRetryLater => '잠시 후 다시 시도해주세요';

  @override
  String get checkLater => '나중에 다시 확인해주세요';

  @override
  String get trucksWithoutLocation => '위치 정보가 없는 트럭들입니다';

  @override
  String trucksLocationNotSet(Object count) {
    return '총 $count개 트럭의 위치가 설정되지 않았습니다';
  }

  @override
  String get searchTrucks => '트럭 검색';

  @override
  String get searchPlaceholder => '트럭명, 메뉴, 위치로 검색';

  @override
  String get viewOnMap => '지도에서 보기';

  @override
  String get favorite => '즐겨찾기';

  @override
  String get statusOnRoute => '운행 중';

  @override
  String get statusResting => '대기 / 휴식';

  @override
  String get statusMaintenance => '점검 중';

  @override
  String get statusStopped => '대기';

  @override
  String get statusInspection => '점검';

  @override
  String get login => '로그인';

  @override
  String get signUp => '회원가입';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get pleaseEnterEmail => '이메일을 입력해주세요';

  @override
  String get pleaseEnterPassword => '비밀번호를 입력해주세요';

  @override
  String get invalidEmailFormat => '올바른 이메일 형식이 아닙니다';

  @override
  String get passwordMinLength => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get agreeToTermsRequired => '이용약관 및 개인정보 처리방침에 동의해주세요';

  @override
  String get agreeToTerms => '이용약관에 동의합니다 (필수)';

  @override
  String get agreeToPrivacy => '개인정보 처리방침에 동의합니다 (필수)';

  @override
  String get dontHaveAccount => '계정이 없으신가요? 회원가입';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요? 로그인';

  @override
  String get socialLogin => '소셜 로그인';

  @override
  String get continueWithKakao => '카카오로 계속하기';

  @override
  String get continueWithNaver => '네이버로 계속하기';

  @override
  String get browse => '둘러보기';

  @override
  String get ownerLogin => '사장님 로그인';

  @override
  String get errorUserNotFound => '등록되지 않은 이메일입니다';

  @override
  String get errorWrongPassword => '비밀번호가 올바르지 않습니다';

  @override
  String get errorEmailInUse => '이미 사용 중인 이메일입니다';

  @override
  String get errorWeakPassword => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get errorInvalidEmail => '올바른 이메일 형식이 아닙니다';

  @override
  String get errorLoginCancelled => '로그인이 취소되었습니다';

  @override
  String get errorLoginFailed => '로그인 중 오류가 발생했습니다';

  @override
  String get uploadDataWarning => '이 작업은 기존 데이터를 덮어쓰지 않고 새로 추가합니다.';

  @override
  String get upload => '업로드';

  @override
  String get uploadingData => '데이터 업로드 중...';

  @override
  String get privacyPolicyTitle => '개인정보 처리방침';

  @override
  String get privacyPolicyContent =>
      '트럭아저씨는 사용자의 개인정보를 소중히 다룹니다.\n\n수집하는 개인정보:\n• 이메일 주소, 이름, 프로필 사진\n• 위치 정보 (선택적)\n\n개인정보 이용 목적:\n• 서비스 제공 및 개선\n• 고객 지원\n\n개인정보 보유 및 이용 기간:\n• 회원 탈퇴 시까지\n\n사용자는 언제든지 개인정보 열람, 수정, 삭제를 요청할 수 있습니다.\n\n문의: support@truckajeossi.com';

  @override
  String get appName => '트럭아저씨';

  @override
  String get logout => '로그아웃';

  @override
  String get confirmLogout => '정말 로그아웃하시겠습니까?';

  @override
  String get analyticsDashboard => '통계 대시보드';

  @override
  String get scheduleSaved => '일정이 저장되었습니다';

  @override
  String saveFailed(Object error) {
    return '저장 실패: $error';
  }

  @override
  String get weeklySchedule => '주간 영업 일정표';

  @override
  String errorWithDetails(Object error) {
    return '오류: $error';
  }

  @override
  String get followedTruck => '트럭을 팔로우했습니다! 영업 시작 시 알림을 받으실 수 있습니다.';

  @override
  String get unfollowedTruck => '팔로우를 취소했습니다.';

  @override
  String get errorOccurred => '오류가 발생했습니다. 다시 시도해주세요.';

  @override
  String get following => '팔로잉';

  @override
  String get followers => '팔로워';

  @override
  String get myFollowedTrucks => '내가 팔로우한 트럭';

  @override
  String get noFollowedTrucks => '아직 팔로우한 트럭이 없습니다';

  @override
  String get notifications => '알림';

  @override
  String get notificationsOn => '알림 켜짐';

  @override
  String get notificationsOff => '알림 꺼짐';

  @override
  String get browseAndFollowTrucks => '트럭을 둘러보고 팔로우해보세요!';

  @override
  String get chat => '채팅';

  @override
  String get chatList => '채팅 목록';

  @override
  String get sendMessage => '메시지 전송';

  @override
  String get typeMessage => '메시지를 입력하세요...';

  @override
  String get noChatHistory => '아직 채팅 내역이 없습니다';

  @override
  String get startChatFromTruck => '트럭 상세 페이지에서 채팅을 시작해보세요';

  @override
  String get cannotLoadChat => '채팅 목록을 불러올 수 없습니다';

  @override
  String get cannotLoadMessages => '메시지를 불러올 수 없습니다';

  @override
  String get startChat => '채팅을 시작해보세요';

  @override
  String get yesterday => '어제';

  @override
  String get imageSendFailed => '이미지 전송에 실패했습니다';

  @override
  String get read => '읽음';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String enabledNotifications(Object count) {
    return '$count개 알림 활성화';
  }

  @override
  String get enableAll => '전체 켜기';

  @override
  String get disableAll => '전체 끄기';

  @override
  String get basicNotifications => '기본 알림';

  @override
  String get socialNotifications => '소셜 알림';

  @override
  String get marketingNotifications => '마케팅';

  @override
  String get locationBasedNotifications => '위치 기반 알림';

  @override
  String get truckOpeningNotification => '트럭 영업 시작';

  @override
  String get truckOpeningDesc => '팔로우한 트럭이 영업을 시작하면 알림';

  @override
  String get orderUpdatesNotification => '주문 상태 변경';

  @override
  String get orderUpdatesDesc => '주문이 준비되면 알림';

  @override
  String get newCouponsNotification => '새 쿠폰';

  @override
  String get newCouponsDesc => '팔로우한 트럭이 새 쿠폰을 발행하면 알림';

  @override
  String get reviewsNotification => '리뷰 답글';

  @override
  String get reviewsDesc => '작성한 리뷰에 사장님이 답글을 달면 알림';

  @override
  String get followedTrucksNotification => '팔로우한 트럭 활동';

  @override
  String get followedTrucksDesc => '팔로우한 트럭의 새로운 소식 알림';

  @override
  String get chatMessagesNotification => '채팅 메시지';

  @override
  String get chatMessagesDesc => '새 채팅 메시지를 받으면 알림';

  @override
  String get promotionsNotification => '프로모션';

  @override
  String get promotionsDesc => '특별 이벤트 및 프로모션 알림';

  @override
  String get nearbyTrucksNotification => '근처 트럭 알림';

  @override
  String get nearbyTrucksDesc => '근처에서 트럭이 영업을 시작하면 알림';

  @override
  String notificationRadius(Object radius) {
    return '알림 반경: $radius km';
  }

  @override
  String nearbyRadiusDesc(Object radius) {
    return '현재 위치로부터 ${radius}km 이내의 트럭이 영업을 시작하면 알림을 받습니다.';
  }

  @override
  String get resetSettings => '설정 초기화';

  @override
  String get resetSettingsConfirm => '알림 설정을 기본값으로 되돌립니다.\n계속하시겠습니까?';

  @override
  String get settingsReset => '설정이 초기화되었습니다';

  @override
  String get cannotLoadSettings => '설정을 불러올 수 없습니다';

  @override
  String get closeBusiness => '영업 종료';

  @override
  String get confirmCloseBusiness => '정말 영업을 종료하시겠습니까?';

  @override
  String get businessClosed => '영업 종료';

  @override
  String get todaysOrderStatus => '오늘의 주문 현황';

  @override
  String get totalOrders => '총 주문';

  @override
  String get completed => '완료';

  @override
  String get revenue => '매출';

  @override
  String get cash => '현금';

  @override
  String get online => '온라인';

  @override
  String get firestoreMigration => 'Firestore 데이터 마이그레이션';

  @override
  String get confirmMigration => '8개의 트럭 데이터를 Firestore에 업로드하시겠습니까?';

  @override
  String get migrationSuccess => '8개 트럭 데이터가 성공적으로 업로드되었습니다!';

  @override
  String uploadFailed(Object error) {
    return '업로드 실패: $error';
  }

  @override
  String distanceKm(Object distance) {
    return '$distance km';
  }

  @override
  String get openNow => '영업 중';

  @override
  String get closed => '휴업 중';

  @override
  String get myFavorites => '내 즐겨찾기';

  @override
  String get noFavoriteTrucksYet => '아직 즐겨찾기한 트럭이 없습니다';

  @override
  String get addFavoritesHint => '트럭 목록에서 ♥를 눌러 추가하세요';

  @override
  String get favoriteTrucksNotFound => '즐겨찾기한 트럭을 찾을 수 없습니다';

  @override
  String errorWithMessage(Object message) {
    return '오류: $message';
  }

  @override
  String get businessLocation => '영업 장소';

  @override
  String get businessLocationHint => '예: 강남역 2번 출구';

  @override
  String get startTime => '시작 시간';

  @override
  String get endTime => '종료 시간';

  @override
  String get menuManagement => '메뉴 관리';

  @override
  String get addMenuItem => '메뉴 추가';

  @override
  String get editMenuItem => '메뉴 수정';

  @override
  String get deleteMenuItem => '메뉴 삭제';

  @override
  String get menuItemName => '메뉴 이름';

  @override
  String get menuItemNameHint => '예: 닭꼬치';

  @override
  String get menuItemPrice => '가격';

  @override
  String get menuItemDescription => '설명 (선택사항)';

  @override
  String get confirmDeleteMenuItem => '이 메뉴를 삭제하시겠습니까?';

  @override
  String get menuItemAdded => '메뉴가 추가되었습니다';

  @override
  String get menuItemUpdated => '메뉴가 수정되었습니다';

  @override
  String get menuItemDeleted => '메뉴가 삭제되었습니다';

  @override
  String get available => '판매 중';

  @override
  String get delete => '삭제';

  @override
  String get menuItemImage => '메뉴 이미지';

  @override
  String get removeImage => '이미지 삭제';

  @override
  String get selectImageSource => '이미지 선택';

  @override
  String get gallery => '갤러리';

  @override
  String get camera => '카메라';

  @override
  String get imageUploadFailed => '이미지 업로드에 실패했습니다';

  @override
  String get truckImage => '트럭 이미지';

  @override
  String get truckImageUploadSuccess => '트럭 이미지가 업데이트되었습니다';

  @override
  String get reviewManagement => '리뷰 관리';

  @override
  String get reviewStats => '리뷰 통계';

  @override
  String get totalReviews => '총 리뷰';

  @override
  String get averageRating => '평균 평점';

  @override
  String get ratingDistribution => '평점 분포';

  @override
  String get recentReviews => '최근 리뷰';

  @override
  String get allReviews => '전체 리뷰';

  @override
  String get replyToReview => '답글 달기';

  @override
  String get editReply => '답글 수정';

  @override
  String get deleteReply => '답글 삭제';

  @override
  String get replyPlaceholder => '고객 리뷰에 답글을 작성하세요';

  @override
  String get replySent => '답글이 등록되었습니다';

  @override
  String get replyDeleted => '답글이 삭제되었습니다';

  @override
  String get confirmDeleteReply => '정말 답글을 삭제하시겠습니까?';

  @override
  String get noReviewsForTruck => '아직 받은 리뷰가 없습니다';

  @override
  String get viewAllReviews => '전체 리뷰 보기';

  @override
  String starsCount(Object count) {
    return '$count개';
  }

  @override
  String get bankAccountSettings => '계좌 정보 설정';

  @override
  String get bankAccountNotSet => '계좌 정보가 설정되지 않았습니다';

  @override
  String get setBankAccount => '계좌 설정하기';

  @override
  String get editBankAccount => '계좌 수정';

  @override
  String get bankName => '은행명';

  @override
  String get bankNameHint => '예: 카카오뱅크';

  @override
  String get accountNumber => '계좌번호';

  @override
  String get accountNumberHint => '예: 3333-12-1234567';

  @override
  String get accountHolder => '예금주';

  @override
  String get accountHolderHint => '예: 홍길동';

  @override
  String get bankAccountSaved => '계좌 정보가 저장되었습니다';

  @override
  String bankAccountFormat(Object bank, Object holder, Object number) {
    return '$bank $number ($holder)';
  }

  @override
  String get pleaseFillAllFields => '모든 항목을 입력해주세요';

  @override
  String get tapToViewDetails => '상세 보기를 탭하세요';

  @override
  String ranked(int rank) {
    return '$rank위';
  }

  @override
  String get operating => '운행 중';

  @override
  String get resting => '휴식 중';

  @override
  String get maintenance => '점검 중';

  @override
  String get couponScanner => '쿠폰 스캐너';

  @override
  String get couponScanGuide => '고객 쿠폰 QR 코드 스캔';

  @override
  String get couponScanDescription => '고객의 QR 코드를 카메라에 비춰주세요';

  @override
  String get couponUsedSuccess => '쿠폰이 사용되었습니다!';

  @override
  String get couponNotFound => '쿠폰을 찾을 수 없습니다';

  @override
  String get couponAlreadyUsed => '이미 사용된 쿠폰입니다';

  @override
  String get couponWrongTruck => '다른 트럭의 쿠폰입니다';

  @override
  String get couponUseFailed => '쿠폰 사용에 실패했습니다';

  @override
  String get couponScanFailed => '쿠폰 스캔에 실패했습니다';

  @override
  String get confirm => '확인';

  @override
  String get truckManagement => '트럭 관리';

  @override
  String get publicTalk => '공개 Talk';

  @override
  String get publicTalkDescription => '모든 고객이 볼 수 있는 공개 대화입니다';

  @override
  String get customerChats => '1:1 고객 채팅';

  @override
  String get customerChatsDescription => '고객과의 개인 채팅 목록입니다';

  @override
  String get noCustomerChats => '아직 채팅이 없습니다';

  @override
  String get errorLoadingChats => '채팅을 불러올 수 없습니다';

  @override
  String get contactAdmin => '관리자 문의';

  @override
  String get supportChatDescription => '운영 관련 문의사항을 관리자에게 직접 문의하세요';

  @override
  String get errorCreatingChat => '채팅방을 생성할 수 없습니다';

  @override
  String get startSupportChat => '문의사항을 입력해주세요';

  @override
  String get adminSupport => '관리자 지원';

  @override
  String get contactAdminDescription => '운영 관련 도움이 필요하시면 관리자에게 문의하세요';

  @override
  String get myCoupons => '내 쿠폰함';

  @override
  String get noCoupons => '보유한 쿠폰이 없습니다';

  @override
  String get earnCouponsHint => '트럭 방문 시 스탬프를 모아 쿠폰을 받으세요!';

  @override
  String get couponReady => '사용 가능!';

  @override
  String get stamps => '스탬프';

  @override
  String get useNow => '사용하기';

  @override
  String get expiresOn => '유효기간';

  @override
  String get showQR => 'QR 보기';

  @override
  String get couponQR => '쿠폰 QR';

  @override
  String get showQRToOwner => '사장님에게 이 QR 코드를 보여주세요';

  @override
  String get close => '닫기';

  @override
  String get visitHistory => '방문 기록';

  @override
  String get noVisitHistory => '방문 기록이 없습니다';

  @override
  String get visitTrucksHint => '트럭을 방문하고 QR 인증해보세요!';

  @override
  String get deleteAccount => '회원 탈퇴';

  @override
  String get deleteAccountWarning => '정말로 탈퇴하시겠습니까?\\n모든 데이터가 삭제되며 복구할 수 없습니다.';

  @override
  String get accountDeleted => '회원 탈퇴가 완료되었습니다';

  @override
  String get home => '홈';

  @override
  String get orders => '주문';

  @override
  String get stats => '통계';

  @override
  String get more => '더보기';

  @override
  String get orderManagement => '주문 관리';

  @override
  String get todayStats => '오늘 통계';

  @override
  String get couponAndReview => '쿠폰 & 리뷰';

  @override
  String get statsAndAnalytics => '통계 & 분석';

  @override
  String get other => '기타';

  @override
  String get orderCount => '주문 수';

  @override
  String get visits => '방문';

  @override
  String get realtime => '실시간';

  @override
  String get todayOrders => '오늘 주문';

  @override
  String get orderStatus => '주문 현황';

  @override
  String get soldOutStatus => '품절 현황';

  @override
  String get couponManagement => '쿠폰 관리';

  @override
  String get settings => '설정';

  @override
  String get uploadData => '데이터 업로드';

  @override
  String get businessApprovalRequired => '영업 승인이 필요합니다';

  @override
  String get businessApprovalDescription => '트럭 정보를 확인하고 영업 승인을 요청하세요';

  @override
  String get submitApprovalRequest => '승인 요청하기';

  @override
  String get approvalPending => '승인 대기 중';

  @override
  String get approvalPendingDescription => '관리자가 요청을 검토 중입니다. 잠시만 기다려주세요.';

  @override
  String get approvalApproved => '영업 승인 완료';

  @override
  String get approvalApprovedDescription => '축하합니다! 이제 영업을 시작할 수 있습니다.';

  @override
  String get approvalRejected => '승인 반려됨';

  @override
  String get approvalRejectedDescription => '요청이 반려되었습니다. 아래 사유를 확인해주세요.';

  @override
  String get rejectionReason => '반려 사유';

  @override
  String get resubmitApproval => '재신청하기';

  @override
  String get businessApprovals => '영업 승인';

  @override
  String get noApprovalRequests => '승인 요청이 없습니다';

  @override
  String get approveButton => '승인';

  @override
  String get rejectButton => '반려';

  @override
  String get enterRejectionReason => '반려 사유를 입력하세요';

  @override
  String get approvalSuccess => '승인되었습니다';

  @override
  String get rejectionSuccess => '반려되었습니다';
}
