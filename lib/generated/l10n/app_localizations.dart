import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ko'),
    Locale('en'),
  ];

  /// No description provided for @ownerCommandCenter.
  ///
  /// In ko, this message translates to:
  /// **'사장님 관리센터'**
  String get ownerCommandCenter;

  /// No description provided for @inputCashSale.
  ///
  /// In ko, this message translates to:
  /// **'현금 판매 입력'**
  String get inputCashSale;

  /// No description provided for @amount.
  ///
  /// In ko, this message translates to:
  /// **'금액 (₩)'**
  String get amount;

  /// No description provided for @memoOptional.
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택사항)'**
  String get memoOptional;

  /// No description provided for @submitSale.
  ///
  /// In ko, this message translates to:
  /// **'판매 등록'**
  String get submitSale;

  /// No description provided for @cashSaleRecordedSuccessfully.
  ///
  /// In ko, this message translates to:
  /// **'현금 판매가 등록되었습니다'**
  String get cashSaleRecordedSuccessfully;

  /// No description provided for @truckQRCode.
  ///
  /// In ko, this message translates to:
  /// **'푸드트럭 QR 코드'**
  String get truckQRCode;

  /// No description provided for @showCustomersQRCode.
  ///
  /// In ko, this message translates to:
  /// **'손님에게 체크인용 QR 코드를 보여주세요'**
  String get showCustomersQRCode;

  /// No description provided for @todaysStatistics.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 통계'**
  String get todaysStatistics;

  /// No description provided for @views.
  ///
  /// In ko, this message translates to:
  /// **'조회수'**
  String get views;

  /// No description provided for @reviews.
  ///
  /// In ko, this message translates to:
  /// **'리뷰'**
  String get reviews;

  /// No description provided for @favorites.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get favorites;

  /// No description provided for @quickActions.
  ///
  /// In ko, this message translates to:
  /// **'빠른 작업'**
  String get quickActions;

  /// No description provided for @viewFullAnalytics.
  ///
  /// In ko, this message translates to:
  /// **'전체 통계 보기'**
  String get viewFullAnalytics;

  /// No description provided for @manageReviews.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 관리'**
  String get manageReviews;

  /// No description provided for @editTruckInfo.
  ///
  /// In ko, this message translates to:
  /// **'트럭 정보 수정'**
  String get editTruckInfo;

  /// No description provided for @updateLocation.
  ///
  /// In ko, this message translates to:
  /// **'위치 업데이트'**
  String get updateLocation;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loading;

  /// No description provided for @errorLoadingDashboard.
  ///
  /// In ko, this message translates to:
  /// **'대시보드 로딩 실패'**
  String get errorLoadingDashboard;

  /// No description provided for @selectDateRange.
  ///
  /// In ko, this message translates to:
  /// **'날짜 범위 선택'**
  String get selectDateRange;

  /// No description provided for @downloadCSV.
  ///
  /// In ko, this message translates to:
  /// **'CSV 다운로드'**
  String get downloadCSV;

  /// No description provided for @date.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get date;

  /// No description provided for @clicks.
  ///
  /// In ko, this message translates to:
  /// **'클릭'**
  String get clicks;

  /// No description provided for @csvDownloadedSuccessfully.
  ///
  /// In ko, this message translates to:
  /// **'CSV 다운로드 완료'**
  String get csvDownloadedSuccessfully;

  /// No description provided for @errorDownloadingCSV.
  ///
  /// In ko, this message translates to:
  /// **'CSV 다운로드 실패'**
  String get errorDownloadingCSV;

  /// No description provided for @scanQRCode.
  ///
  /// In ko, this message translates to:
  /// **'QR 코드 스캔'**
  String get scanQRCode;

  /// No description provided for @checkinSuccess.
  ///
  /// In ko, this message translates to:
  /// **'체크인 성공!'**
  String get checkinSuccess;

  /// No description provided for @invalidQRCode.
  ///
  /// In ko, this message translates to:
  /// **'유효하지 않은 QR 코드'**
  String get invalidQRCode;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In ko, this message translates to:
  /// **'카메라 권한 필요'**
  String get cameraPermissionRequired;

  /// No description provided for @enableCameraToScan.
  ///
  /// In ko, this message translates to:
  /// **'QR 코드 스캔을 위해 카메라를 활성화하세요'**
  String get enableCameraToScan;

  /// No description provided for @error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get error;

  /// No description provided for @success.
  ///
  /// In ko, this message translates to:
  /// **'성공'**
  String get success;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get refresh;

  /// No description provided for @qrCheckInTooltip.
  ///
  /// In ko, this message translates to:
  /// **'QR 체크인'**
  String get qrCheckInTooltip;

  /// No description provided for @scheduleTooltip.
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get scheduleTooltip;

  /// No description provided for @analyticsTooltip.
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get analyticsTooltip;

  /// No description provided for @uploadDataTooltip.
  ///
  /// In ko, this message translates to:
  /// **'데이터 업로드'**
  String get uploadDataTooltip;

  /// No description provided for @noTruckRegistered.
  ///
  /// In ko, this message translates to:
  /// **'등록된 트럭이 없습니다'**
  String get noTruckRegistered;

  /// No description provided for @errorLoadingTruckData.
  ///
  /// In ko, this message translates to:
  /// **'트럭 데이터 로딩 실패'**
  String get errorLoadingTruckData;

  /// No description provided for @alreadyOpenForBusiness.
  ///
  /// In ko, this message translates to:
  /// **'이미 영업 중입니다!'**
  String get alreadyOpenForBusiness;

  /// No description provided for @couldNotGetGPSLocation.
  ///
  /// In ko, this message translates to:
  /// **'GPS 위치를 가져올 수 없습니다'**
  String get couldNotGetGPSLocation;

  /// No description provided for @businessStartedNotification.
  ///
  /// In ko, this message translates to:
  /// **'영업을 시작했습니다! 팔로워들에게 알림이 전송됩니다 🔔'**
  String get businessStartedNotification;

  /// No description provided for @businessOpen.
  ///
  /// In ko, this message translates to:
  /// **'영업 중'**
  String get businessOpen;

  /// No description provided for @startBusiness.
  ///
  /// In ko, this message translates to:
  /// **'영업 시작'**
  String get startBusiness;

  /// No description provided for @todaysSpecialNotice.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 특별 공지'**
  String get todaysSpecialNotice;

  /// No description provided for @noAnnouncementSet.
  ///
  /// In ko, this message translates to:
  /// **'(공지사항이 설정되지 않았습니다)'**
  String get noAnnouncementSet;

  /// No description provided for @editAnnouncement.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 수정'**
  String get editAnnouncement;

  /// No description provided for @announcementDisplayedMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 공지사항은 트럭 상세 페이지 상단에 표시됩니다.'**
  String get announcementDisplayedMessage;

  /// No description provided for @announcement.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get announcement;

  /// No description provided for @announcementHint.
  ///
  /// In ko, this message translates to:
  /// **'예: \"오늘의 특별 메뉴: 닭꼬치 30% 할인!\"'**
  String get announcementHint;

  /// No description provided for @announcementUpdated.
  ///
  /// In ko, this message translates to:
  /// **'공지사항이 업데이트되었습니다!'**
  String get announcementUpdated;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @itemName.
  ///
  /// In ko, this message translates to:
  /// **'상품명'**
  String get itemName;

  /// No description provided for @invalidAmount.
  ///
  /// In ko, this message translates to:
  /// **'잘못된 금액입니다'**
  String get invalidAmount;

  /// No description provided for @cashSaleRecorded.
  ///
  /// In ko, this message translates to:
  /// **'현금 판매 기록: ₩{amount}'**
  String cashSaleRecorded(Object amount);

  /// No description provided for @regularsNearby.
  ///
  /// In ko, this message translates to:
  /// **'주변 단골'**
  String get regularsNearby;

  /// No description provided for @todaysRevenue.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 매출'**
  String get todaysRevenue;

  /// No description provided for @orderBoard.
  ///
  /// In ko, this message translates to:
  /// **'주문 보드'**
  String get orderBoard;

  /// No description provided for @pending.
  ///
  /// In ko, this message translates to:
  /// **'대기'**
  String get pending;

  /// No description provided for @preparing.
  ///
  /// In ko, this message translates to:
  /// **'준비 중'**
  String get preparing;

  /// No description provided for @ready.
  ///
  /// In ko, this message translates to:
  /// **'준비 완료'**
  String get ready;

  /// No description provided for @errorLoadingOrders.
  ///
  /// In ko, this message translates to:
  /// **'주문 로딩 실패'**
  String get errorLoadingOrders;

  /// No description provided for @menuItems.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 항목'**
  String get menuItems;

  /// No description provided for @noMenuItems.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 항목이 없습니다'**
  String get noMenuItems;

  /// No description provided for @errorLoadingMenu.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 로딩 실패'**
  String get errorLoadingMenu;

  /// No description provided for @customerConversations.
  ///
  /// In ko, this message translates to:
  /// **'고객 대화'**
  String get customerConversations;

  /// No description provided for @orderItemsTotal.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 항목 - ₩{total}'**
  String orderItemsTotal(Object count, Object total);

  /// No description provided for @selectDateRangeTooltip.
  ///
  /// In ko, this message translates to:
  /// **'날짜 범위 선택'**
  String get selectDateRangeTooltip;

  /// No description provided for @downloadCSVTooltip.
  ///
  /// In ko, this message translates to:
  /// **'CSV 다운로드'**
  String get downloadCSVTooltip;

  /// No description provided for @clickCount.
  ///
  /// In ko, this message translates to:
  /// **'클릭 수'**
  String get clickCount;

  /// No description provided for @reviewCount.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 수'**
  String get reviewCount;

  /// No description provided for @favoriteCount.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 수'**
  String get favoriteCount;

  /// No description provided for @csvDownloadSuccess.
  ///
  /// In ko, this message translates to:
  /// **'CSV 다운로드 완료'**
  String get csvDownloadSuccess;

  /// No description provided for @csvDownloadError.
  ///
  /// In ko, this message translates to:
  /// **'CSV 다운로드 실패: {error}'**
  String csvDownloadError(Object error);

  /// No description provided for @total.
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get total;

  /// No description provided for @average.
  ///
  /// In ko, this message translates to:
  /// **'평균'**
  String get average;

  /// No description provided for @checkInQRCode.
  ///
  /// In ko, this message translates to:
  /// **'체크인 QR 코드'**
  String get checkInQRCode;

  /// No description provided for @checkInQR.
  ///
  /// In ko, this message translates to:
  /// **'체크인 QR'**
  String get checkInQR;

  /// No description provided for @bankTransfer.
  ///
  /// In ko, this message translates to:
  /// **'계좌이체'**
  String get bankTransfer;

  /// No description provided for @showBankTransferQR.
  ///
  /// In ko, this message translates to:
  /// **'계좌이체 결제를 위한 QR 코드'**
  String get showBankTransferQR;

  /// No description provided for @customerscanQR.
  ///
  /// In ko, this message translates to:
  /// **'고객이 체크인하려면 이 QR 코드를 스캔하세요'**
  String get customerscanQR;

  /// No description provided for @truckID.
  ///
  /// In ko, this message translates to:
  /// **'트럭 ID: {id}'**
  String truckID(Object id);

  /// No description provided for @checkInBenefits.
  ///
  /// In ko, this message translates to:
  /// **'체크인 혜택'**
  String get checkInBenefits;

  /// No description provided for @benefitsList.
  ///
  /// In ko, this message translates to:
  /// **'• 방문할 때마다 10 포인트 적립\n• 즐겨찾는 트럭 추적\n• 특별 프로모션 받기'**
  String get benefitsList;

  /// No description provided for @pleaseEnterTruckID.
  ///
  /// In ko, this message translates to:
  /// **'트럭 ID를 입력하세요'**
  String get pleaseEnterTruckID;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In ko, this message translates to:
  /// **'로그인하지 않았습니다'**
  String get userNotLoggedIn;

  /// No description provided for @truckNotFound.
  ///
  /// In ko, this message translates to:
  /// **'트럭을 찾을 수 없습니다'**
  String get truckNotFound;

  /// No description provided for @alreadyCheckedInToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 이미 이 트럭에 체크인했습니다!'**
  String get alreadyCheckedInToday;

  /// No description provided for @checkInFailed.
  ///
  /// In ko, this message translates to:
  /// **'체크인 실패: {error}'**
  String checkInFailed(Object error);

  /// No description provided for @checkInSuccessful.
  ///
  /// In ko, this message translates to:
  /// **'체크인 성공!'**
  String get checkInSuccessful;

  /// No description provided for @loyaltyPoints.
  ///
  /// In ko, this message translates to:
  /// **'{truck} • +10 포인트'**
  String loyaltyPoints(Object truck);

  /// No description provided for @checkIn.
  ///
  /// In ko, this message translates to:
  /// **'체크인'**
  String get checkIn;

  /// No description provided for @scanQRCodeToCheckIn.
  ///
  /// In ko, this message translates to:
  /// **'QR 코드를 스캔하여 체크인'**
  String get scanQRCodeToCheckIn;

  /// No description provided for @earnLoyaltyPoints.
  ///
  /// In ko, this message translates to:
  /// **'방문할 때마다 포인트를 획득하세요!'**
  String get earnLoyaltyPoints;

  /// No description provided for @or.
  ///
  /// In ko, this message translates to:
  /// **'또는'**
  String get or;

  /// No description provided for @enterTruckID.
  ///
  /// In ko, this message translates to:
  /// **'트럭 ID 입력'**
  String get enterTruckID;

  /// No description provided for @enterTruckIDHint.
  ///
  /// In ko, this message translates to:
  /// **'트럭 ID 입력 (예: truck_001)'**
  String get enterTruckIDHint;

  /// No description provided for @checkInButton.
  ///
  /// In ko, this message translates to:
  /// **'체크인'**
  String get checkInButton;

  /// No description provided for @howItWorks.
  ///
  /// In ko, this message translates to:
  /// **'사용 방법'**
  String get howItWorks;

  /// No description provided for @howItWorksList.
  ///
  /// In ko, this message translates to:
  /// **'1. 푸드트럭의 QR 코드를 스캔하세요\n2. 방문할 때마다 10 포인트 적립\n3. 즐겨찾는 트럭을 추적하세요\n4. 하루에 트럭당 한 번만 체크인할 수 있습니다'**
  String get howItWorksList;

  /// No description provided for @errorLoadingData.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러올 수 없습니다'**
  String get errorLoadingData;

  /// No description provided for @todaysSpecialAnnouncement.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 특별 공지'**
  String get todaysSpecialAnnouncement;

  /// No description provided for @todayLocation.
  ///
  /// In ko, this message translates to:
  /// **'오늘: {location}'**
  String todayLocation(Object location);

  /// No description provided for @menu.
  ///
  /// In ko, this message translates to:
  /// **'메뉴'**
  String get menu;

  /// No description provided for @errorLoadingReviews.
  ///
  /// In ko, this message translates to:
  /// **'리뷰를 불러올 수 없습니다'**
  String get errorLoadingReviews;

  /// No description provided for @reviewsTitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰'**
  String get reviewsTitle;

  /// No description provided for @noReviewsYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 리뷰가 없습니다'**
  String get noReviewsYet;

  /// No description provided for @talkWithOwner.
  ///
  /// In ko, this message translates to:
  /// **'사장님과 대화'**
  String get talkWithOwner;

  /// No description provided for @navigation.
  ///
  /// In ko, this message translates to:
  /// **'길찾기'**
  String get navigation;

  /// No description provided for @totalItems.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개'**
  String totalItems(Object count);

  /// No description provided for @placeOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하기'**
  String get placeOrder;

  /// No description provided for @writeReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 작성'**
  String get writeReview;

  /// No description provided for @soldOut.
  ///
  /// In ko, this message translates to:
  /// **'품절'**
  String get soldOut;

  /// No description provided for @priceWon.
  ///
  /// In ko, this message translates to:
  /// **'{price}원'**
  String priceWon(Object price);

  /// No description provided for @addToCart.
  ///
  /// In ko, this message translates to:
  /// **'담기'**
  String get addToCart;

  /// No description provided for @ownerReply.
  ///
  /// In ko, this message translates to:
  /// **'사장님 답글'**
  String get ownerReply;

  /// No description provided for @location.
  ///
  /// In ko, this message translates to:
  /// **'위치'**
  String get location;

  /// No description provided for @chooseNavigationApp.
  ///
  /// In ko, this message translates to:
  /// **'길찾기 앱 선택:'**
  String get chooseNavigationApp;

  /// No description provided for @naverMap.
  ///
  /// In ko, this message translates to:
  /// **'네이버지도'**
  String get naverMap;

  /// No description provided for @kakaoMap.
  ///
  /// In ko, this message translates to:
  /// **'카카오맵'**
  String get kakaoMap;

  /// No description provided for @googleMaps.
  ///
  /// In ko, this message translates to:
  /// **'구글맵'**
  String get googleMaps;

  /// No description provided for @cannotOpenNaverMap.
  ///
  /// In ko, this message translates to:
  /// **'네이버지도를 열 수 없습니다'**
  String get cannotOpenNaverMap;

  /// No description provided for @cannotOpenKakaoMap.
  ///
  /// In ko, this message translates to:
  /// **'카카오맵을 열 수 없습니다'**
  String get cannotOpenKakaoMap;

  /// No description provided for @cannotOpenGoogleMaps.
  ///
  /// In ko, this message translates to:
  /// **'구글맵을 열 수 없습니다'**
  String get cannotOpenGoogleMaps;

  /// No description provided for @loginRequiredToOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하려면 로그인이 필요합니다'**
  String get loginRequiredToOrder;

  /// No description provided for @confirmOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문 확인'**
  String get confirmOrder;

  /// No description provided for @totalMenuItems.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개 메뉴'**
  String totalMenuItems(Object count);

  /// No description provided for @wouldYouLikeToOrder.
  ///
  /// In ko, this message translates to:
  /// **'주문하시겠습니까?'**
  String get wouldYouLikeToOrder;

  /// No description provided for @orderCompleted.
  ///
  /// In ko, this message translates to:
  /// **'주문이 완료되었습니다! (주문번호: {orderId})'**
  String orderCompleted(Object orderId);

  /// No description provided for @orderFailed.
  ///
  /// In ko, this message translates to:
  /// **'주문 실패: {error}'**
  String orderFailed(Object error);

  /// No description provided for @truckUncle.
  ///
  /// In ko, this message translates to:
  /// **'트럭아저씨'**
  String get truckUncle;

  /// No description provided for @loginRequired.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다'**
  String get loginRequired;

  /// No description provided for @reviewSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'리뷰가 등록되었습니다'**
  String get reviewSubmitted;

  /// No description provided for @reviewSubmissionFailed.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 등록 실패: {error}'**
  String reviewSubmissionFailed(Object error);

  /// No description provided for @starRating.
  ///
  /// In ko, this message translates to:
  /// **'별점'**
  String get starRating;

  /// No description provided for @reviewContent.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 내용'**
  String get reviewContent;

  /// No description provided for @reviewPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'이 트럭에 대한 리뷰를 작성해주세요'**
  String get reviewPlaceholder;

  /// No description provided for @pleaseEnterReviewContent.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 내용을 입력해주세요'**
  String get pleaseEnterReviewContent;

  /// No description provided for @pleaseEnterAtLeast5Chars.
  ///
  /// In ko, this message translates to:
  /// **'최소 5자 이상 입력해주세요'**
  String get pleaseEnterAtLeast5Chars;

  /// No description provided for @photosOptionalMax3.
  ///
  /// In ko, this message translates to:
  /// **'사진 (선택, 최대 3장)'**
  String get photosOptionalMax3;

  /// No description provided for @addPhoto.
  ///
  /// In ko, this message translates to:
  /// **'사진 추가'**
  String get addPhoto;

  /// No description provided for @submit.
  ///
  /// In ko, this message translates to:
  /// **'등록'**
  String get submit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
