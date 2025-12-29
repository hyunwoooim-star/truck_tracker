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
  String get searchPlaceholder => '트럭 번호, 기사명, 메뉴, 위치로 검색';

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
  String get startAsOwnerTest => '사장님으로 시작하기 (테스트)';

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
  String get businessClosed => '영업이 종료되었습니다.';

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
}
