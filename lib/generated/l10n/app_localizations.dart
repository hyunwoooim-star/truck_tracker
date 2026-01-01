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

  /// No description provided for @edit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get edit;

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

  /// No description provided for @noOrdersYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 주문이 없습니다'**
  String get noOrdersYet;

  /// No description provided for @noOrdersInColumn.
  ///
  /// In ko, this message translates to:
  /// **'주문 없음'**
  String get noOrdersInColumn;

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

  /// No description provided for @talkWithCustomers.
  ///
  /// In ko, this message translates to:
  /// **'고객과 대화'**
  String get talkWithCustomers;

  /// No description provided for @noMessagesYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 메시지가 없습니다. 대화를 시작하세요!'**
  String get noMessagesYet;

  /// No description provided for @errorLoadingMessages.
  ///
  /// In ko, this message translates to:
  /// **'메시지 로딩 실패'**
  String get errorLoadingMessages;

  /// No description provided for @me.
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get me;

  /// No description provided for @deleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'메시지 삭제'**
  String get deleteMessage;

  /// No description provided for @deleteMessageConfirmation.
  ///
  /// In ko, this message translates to:
  /// **'정말 이 메시지를 삭제하시겠습니까?'**
  String get deleteMessageConfirmation;

  /// No description provided for @messageDeleted.
  ///
  /// In ko, this message translates to:
  /// **'메시지가 삭제되었습니다'**
  String get messageDeleted;

  /// No description provided for @messageDeleteFailed.
  ///
  /// In ko, this message translates to:
  /// **'메시지 삭제에 실패했습니다'**
  String get messageDeleteFailed;

  /// No description provided for @longPressToDelete.
  ///
  /// In ko, this message translates to:
  /// **'꾹 눌러서 삭제'**
  String get longPressToDelete;

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

  /// No description provided for @editReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 수정'**
  String get editReview;

  /// No description provided for @myReview.
  ///
  /// In ko, this message translates to:
  /// **'내 리뷰'**
  String get myReview;

  /// No description provided for @deleteReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 삭제'**
  String get deleteReview;

  /// No description provided for @deleteReviewConfirmation.
  ///
  /// In ko, this message translates to:
  /// **'정말 이 리뷰를 삭제하시겠습니까?'**
  String get deleteReviewConfirmation;

  /// No description provided for @reviewDeleted.
  ///
  /// In ko, this message translates to:
  /// **'리뷰가 삭제되었습니다'**
  String get reviewDeleted;

  /// No description provided for @reviewDeleteFailed.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 삭제에 실패했습니다'**
  String get reviewDeleteFailed;

  /// No description provided for @reviewUpdated.
  ///
  /// In ko, this message translates to:
  /// **'리뷰가 수정되었습니다'**
  String get reviewUpdated;

  /// No description provided for @reviewUpdateFailed.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 수정에 실패했습니다'**
  String get reviewUpdateFailed;

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

  /// No description provided for @purchaseRequiredForReview.
  ///
  /// In ko, this message translates to:
  /// **'주문 후 리뷰를 작성할 수 있습니다'**
  String get purchaseRequiredForReview;

  /// No description provided for @purchaseRequiredForTalk.
  ///
  /// In ko, this message translates to:
  /// **'주문 후 댓글을 작성할 수 있습니다'**
  String get purchaseRequiredForTalk;

  /// No description provided for @verifyingPurchase.
  ///
  /// In ko, this message translates to:
  /// **'구매 이력 확인 중...'**
  String get verifyingPurchase;

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

  /// No description provided for @truckList.
  ///
  /// In ko, this message translates to:
  /// **'트럭 리스트'**
  String get truckList;

  /// No description provided for @viewMap.
  ///
  /// In ko, this message translates to:
  /// **'지도 보기'**
  String get viewMap;

  /// No description provided for @appInfo.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get appInfo;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// No description provided for @noTrucksAvailable.
  ///
  /// In ko, this message translates to:
  /// **'현재 운영 중인 트럭이 없습니다'**
  String get noTrucksAvailable;

  /// No description provided for @loadDataFailed.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러올 수 없습니다'**
  String get loadDataFailed;

  /// No description provided for @favoriteFailed.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 반영 실패!'**
  String get favoriteFailed;

  /// No description provided for @favoriteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기에 추가되었습니다!'**
  String get favoriteSuccess;

  /// No description provided for @favoriteRemoved.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기에서 제거되었습니다!'**
  String get favoriteRemoved;

  /// No description provided for @distance.
  ///
  /// In ko, this message translates to:
  /// **'거리'**
  String get distance;

  /// No description provided for @rating.
  ///
  /// In ko, this message translates to:
  /// **'평점'**
  String get rating;

  /// No description provided for @foodTruckMap.
  ///
  /// In ko, this message translates to:
  /// **'푸드트럭 지도'**
  String get foodTruckMap;

  /// No description provided for @cannotLoadMap.
  ///
  /// In ko, this message translates to:
  /// **'지도를 불러올 수 없습니다'**
  String get cannotLoadMap;

  /// No description provided for @noTrucks.
  ///
  /// In ko, this message translates to:
  /// **'트럭이 없습니다'**
  String get noTrucks;

  /// No description provided for @pleaseRetryLater.
  ///
  /// In ko, this message translates to:
  /// **'잠시 후 다시 시도해주세요'**
  String get pleaseRetryLater;

  /// No description provided for @checkLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에 다시 확인해주세요'**
  String get checkLater;

  /// No description provided for @trucksWithoutLocation.
  ///
  /// In ko, this message translates to:
  /// **'위치 정보가 없는 트럭들입니다'**
  String get trucksWithoutLocation;

  /// No description provided for @trucksLocationNotSet.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개 트럭의 위치가 설정되지 않았습니다'**
  String trucksLocationNotSet(Object count);

  /// No description provided for @searchTrucks.
  ///
  /// In ko, this message translates to:
  /// **'트럭 검색'**
  String get searchTrucks;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'트럭 번호, 기사명, 메뉴, 위치로 검색'**
  String get searchPlaceholder;

  /// No description provided for @viewOnMap.
  ///
  /// In ko, this message translates to:
  /// **'지도에서 보기'**
  String get viewOnMap;

  /// No description provided for @favorite.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get favorite;

  /// No description provided for @statusOnRoute.
  ///
  /// In ko, this message translates to:
  /// **'운행 중'**
  String get statusOnRoute;

  /// No description provided for @statusResting.
  ///
  /// In ko, this message translates to:
  /// **'대기 / 휴식'**
  String get statusResting;

  /// No description provided for @statusMaintenance.
  ///
  /// In ko, this message translates to:
  /// **'점검 중'**
  String get statusMaintenance;

  /// No description provided for @statusStopped.
  ///
  /// In ko, this message translates to:
  /// **'대기'**
  String get statusStopped;

  /// No description provided for @statusInspection.
  ///
  /// In ko, this message translates to:
  /// **'점검'**
  String get statusInspection;

  /// No description provided for @login.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요'**
  String get pleaseEnterPassword;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식이 아닙니다'**
  String get invalidEmailFormat;

  /// No description provided for @passwordMinLength.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 최소 6자 이상이어야 합니다'**
  String get passwordMinLength;

  /// No description provided for @agreeToTermsRequired.
  ///
  /// In ko, this message translates to:
  /// **'이용약관 및 개인정보 처리방침에 동의해주세요'**
  String get agreeToTermsRequired;

  /// No description provided for @agreeToTerms.
  ///
  /// In ko, this message translates to:
  /// **'이용약관에 동의합니다 (필수)'**
  String get agreeToTerms;

  /// No description provided for @agreeToPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침에 동의합니다 (필수)'**
  String get agreeToPrivacy;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정이 없으신가요? 회원가입'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있으신가요? 로그인'**
  String get alreadyHaveAccount;

  /// No description provided for @socialLogin.
  ///
  /// In ko, this message translates to:
  /// **'소셜 로그인'**
  String get socialLogin;

  /// No description provided for @continueWithKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오로 계속하기'**
  String get continueWithKakao;

  /// No description provided for @continueWithNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버로 계속하기'**
  String get continueWithNaver;

  /// No description provided for @browse.
  ///
  /// In ko, this message translates to:
  /// **'둘러보기'**
  String get browse;

  /// No description provided for @ownerLogin.
  ///
  /// In ko, this message translates to:
  /// **'사장님 로그인'**
  String get ownerLogin;

  /// No description provided for @errorUserNotFound.
  ///
  /// In ko, this message translates to:
  /// **'등록되지 않은 이메일입니다'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 올바르지 않습니다'**
  String get errorWrongPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In ko, this message translates to:
  /// **'이미 사용 중인 이메일입니다'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 최소 6자 이상이어야 합니다'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식이 아닙니다'**
  String get errorInvalidEmail;

  /// No description provided for @errorLoginCancelled.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 취소되었습니다'**
  String get errorLoginCancelled;

  /// No description provided for @errorLoginFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그인 중 오류가 발생했습니다'**
  String get errorLoginFailed;

  /// No description provided for @uploadDataWarning.
  ///
  /// In ko, this message translates to:
  /// **'이 작업은 기존 데이터를 덮어쓰지 않고 새로 추가합니다.'**
  String get uploadDataWarning;

  /// No description provided for @upload.
  ///
  /// In ko, this message translates to:
  /// **'업로드'**
  String get upload;

  /// No description provided for @uploadingData.
  ///
  /// In ko, this message translates to:
  /// **'데이터 업로드 중...'**
  String get uploadingData;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In ko, this message translates to:
  /// **'트럭아저씨는 사용자의 개인정보를 소중히 다룹니다.\n\n수집하는 개인정보:\n• 이메일 주소, 이름, 프로필 사진\n• 위치 정보 (선택적)\n\n개인정보 이용 목적:\n• 서비스 제공 및 개선\n• 고객 지원\n\n개인정보 보유 및 이용 기간:\n• 회원 탈퇴 시까지\n\n사용자는 언제든지 개인정보 열람, 수정, 삭제를 요청할 수 있습니다.\n\n문의: support@truckajeossi.com'**
  String get privacyPolicyContent;

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'트럭아저씨'**
  String get appName;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In ko, this message translates to:
  /// **'정말 로그아웃하시겠습니까?'**
  String get confirmLogout;

  /// No description provided for @analyticsDashboard.
  ///
  /// In ko, this message translates to:
  /// **'통계 대시보드'**
  String get analyticsDashboard;

  /// No description provided for @scheduleSaved.
  ///
  /// In ko, this message translates to:
  /// **'일정이 저장되었습니다'**
  String get scheduleSaved;

  /// No description provided for @saveFailed.
  ///
  /// In ko, this message translates to:
  /// **'저장 실패: {error}'**
  String saveFailed(Object error);

  /// No description provided for @weeklySchedule.
  ///
  /// In ko, this message translates to:
  /// **'주간 영업 일정표'**
  String get weeklySchedule;

  /// No description provided for @errorWithDetails.
  ///
  /// In ko, this message translates to:
  /// **'오류: {error}'**
  String errorWithDetails(Object error);

  /// No description provided for @followedTruck.
  ///
  /// In ko, this message translates to:
  /// **'트럭을 팔로우했습니다! 영업 시작 시 알림을 받으실 수 있습니다.'**
  String get followedTruck;

  /// No description provided for @unfollowedTruck.
  ///
  /// In ko, this message translates to:
  /// **'팔로우를 취소했습니다.'**
  String get unfollowedTruck;

  /// No description provided for @errorOccurred.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다. 다시 시도해주세요.'**
  String get errorOccurred;

  /// No description provided for @following.
  ///
  /// In ko, this message translates to:
  /// **'팔로잉'**
  String get following;

  /// No description provided for @followers.
  ///
  /// In ko, this message translates to:
  /// **'팔로워'**
  String get followers;

  /// No description provided for @myFollowedTrucks.
  ///
  /// In ko, this message translates to:
  /// **'내가 팔로우한 트럭'**
  String get myFollowedTrucks;

  /// No description provided for @noFollowedTrucks.
  ///
  /// In ko, this message translates to:
  /// **'아직 팔로우한 트럭이 없습니다'**
  String get noFollowedTrucks;

  /// No description provided for @notifications.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notifications;

  /// No description provided for @notificationsOn.
  ///
  /// In ko, this message translates to:
  /// **'알림 켜짐'**
  String get notificationsOn;

  /// No description provided for @notificationsOff.
  ///
  /// In ko, this message translates to:
  /// **'알림 꺼짐'**
  String get notificationsOff;

  /// No description provided for @browseAndFollowTrucks.
  ///
  /// In ko, this message translates to:
  /// **'트럭을 둘러보고 팔로우해보세요!'**
  String get browseAndFollowTrucks;

  /// No description provided for @chat.
  ///
  /// In ko, this message translates to:
  /// **'채팅'**
  String get chat;

  /// No description provided for @chatList.
  ///
  /// In ko, this message translates to:
  /// **'채팅 목록'**
  String get chatList;

  /// No description provided for @sendMessage.
  ///
  /// In ko, this message translates to:
  /// **'메시지 전송'**
  String get sendMessage;

  /// No description provided for @typeMessage.
  ///
  /// In ko, this message translates to:
  /// **'메시지를 입력하세요...'**
  String get typeMessage;

  /// No description provided for @noChatHistory.
  ///
  /// In ko, this message translates to:
  /// **'아직 채팅 내역이 없습니다'**
  String get noChatHistory;

  /// No description provided for @startChatFromTruck.
  ///
  /// In ko, this message translates to:
  /// **'트럭 상세 페이지에서 채팅을 시작해보세요'**
  String get startChatFromTruck;

  /// No description provided for @cannotLoadChat.
  ///
  /// In ko, this message translates to:
  /// **'채팅 목록을 불러올 수 없습니다'**
  String get cannotLoadChat;

  /// No description provided for @cannotLoadMessages.
  ///
  /// In ko, this message translates to:
  /// **'메시지를 불러올 수 없습니다'**
  String get cannotLoadMessages;

  /// No description provided for @startChat.
  ///
  /// In ko, this message translates to:
  /// **'채팅을 시작해보세요'**
  String get startChat;

  /// No description provided for @yesterday.
  ///
  /// In ko, this message translates to:
  /// **'어제'**
  String get yesterday;

  /// No description provided for @imageSendFailed.
  ///
  /// In ko, this message translates to:
  /// **'이미지 전송에 실패했습니다'**
  String get imageSendFailed;

  /// No description provided for @read.
  ///
  /// In ko, this message translates to:
  /// **'읽음'**
  String get read;

  /// No description provided for @notificationSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSettings;

  /// No description provided for @enabledNotifications.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 알림 활성화'**
  String enabledNotifications(Object count);

  /// No description provided for @enableAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 켜기'**
  String get enableAll;

  /// No description provided for @disableAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 끄기'**
  String get disableAll;

  /// No description provided for @basicNotifications.
  ///
  /// In ko, this message translates to:
  /// **'기본 알림'**
  String get basicNotifications;

  /// No description provided for @socialNotifications.
  ///
  /// In ko, this message translates to:
  /// **'소셜 알림'**
  String get socialNotifications;

  /// No description provided for @marketingNotifications.
  ///
  /// In ko, this message translates to:
  /// **'마케팅'**
  String get marketingNotifications;

  /// No description provided for @locationBasedNotifications.
  ///
  /// In ko, this message translates to:
  /// **'위치 기반 알림'**
  String get locationBasedNotifications;

  /// No description provided for @truckOpeningNotification.
  ///
  /// In ko, this message translates to:
  /// **'트럭 영업 시작'**
  String get truckOpeningNotification;

  /// No description provided for @truckOpeningDesc.
  ///
  /// In ko, this message translates to:
  /// **'팔로우한 트럭이 영업을 시작하면 알림'**
  String get truckOpeningDesc;

  /// No description provided for @orderUpdatesNotification.
  ///
  /// In ko, this message translates to:
  /// **'주문 상태 변경'**
  String get orderUpdatesNotification;

  /// No description provided for @orderUpdatesDesc.
  ///
  /// In ko, this message translates to:
  /// **'주문이 준비되면 알림'**
  String get orderUpdatesDesc;

  /// No description provided for @newCouponsNotification.
  ///
  /// In ko, this message translates to:
  /// **'새 쿠폰'**
  String get newCouponsNotification;

  /// No description provided for @newCouponsDesc.
  ///
  /// In ko, this message translates to:
  /// **'팔로우한 트럭이 새 쿠폰을 발행하면 알림'**
  String get newCouponsDesc;

  /// No description provided for @reviewsNotification.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 답글'**
  String get reviewsNotification;

  /// No description provided for @reviewsDesc.
  ///
  /// In ko, this message translates to:
  /// **'작성한 리뷰에 사장님이 답글을 달면 알림'**
  String get reviewsDesc;

  /// No description provided for @followedTrucksNotification.
  ///
  /// In ko, this message translates to:
  /// **'팔로우한 트럭 활동'**
  String get followedTrucksNotification;

  /// No description provided for @followedTrucksDesc.
  ///
  /// In ko, this message translates to:
  /// **'팔로우한 트럭의 새로운 소식 알림'**
  String get followedTrucksDesc;

  /// No description provided for @chatMessagesNotification.
  ///
  /// In ko, this message translates to:
  /// **'채팅 메시지'**
  String get chatMessagesNotification;

  /// No description provided for @chatMessagesDesc.
  ///
  /// In ko, this message translates to:
  /// **'새 채팅 메시지를 받으면 알림'**
  String get chatMessagesDesc;

  /// No description provided for @promotionsNotification.
  ///
  /// In ko, this message translates to:
  /// **'프로모션'**
  String get promotionsNotification;

  /// No description provided for @promotionsDesc.
  ///
  /// In ko, this message translates to:
  /// **'특별 이벤트 및 프로모션 알림'**
  String get promotionsDesc;

  /// No description provided for @nearbyTrucksNotification.
  ///
  /// In ko, this message translates to:
  /// **'근처 트럭 알림'**
  String get nearbyTrucksNotification;

  /// No description provided for @nearbyTrucksDesc.
  ///
  /// In ko, this message translates to:
  /// **'근처에서 트럭이 영업을 시작하면 알림'**
  String get nearbyTrucksDesc;

  /// No description provided for @notificationRadius.
  ///
  /// In ko, this message translates to:
  /// **'알림 반경: {radius} km'**
  String notificationRadius(Object radius);

  /// No description provided for @nearbyRadiusDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치로부터 {radius}km 이내의 트럭이 영업을 시작하면 알림을 받습니다.'**
  String nearbyRadiusDesc(Object radius);

  /// No description provided for @resetSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정 초기화'**
  String get resetSettings;

  /// No description provided for @resetSettingsConfirm.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정을 기본값으로 되돌립니다.\n계속하시겠습니까?'**
  String get resetSettingsConfirm;

  /// No description provided for @settingsReset.
  ///
  /// In ko, this message translates to:
  /// **'설정이 초기화되었습니다'**
  String get settingsReset;

  /// No description provided for @cannotLoadSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정을 불러올 수 없습니다'**
  String get cannotLoadSettings;

  /// No description provided for @closeBusiness.
  ///
  /// In ko, this message translates to:
  /// **'영업 종료'**
  String get closeBusiness;

  /// No description provided for @confirmCloseBusiness.
  ///
  /// In ko, this message translates to:
  /// **'정말 영업을 종료하시겠습니까?'**
  String get confirmCloseBusiness;

  /// No description provided for @businessClosed.
  ///
  /// In ko, this message translates to:
  /// **'영업이 종료되었습니다.'**
  String get businessClosed;

  /// No description provided for @todaysOrderStatus.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 주문 현황'**
  String get todaysOrderStatus;

  /// No description provided for @totalOrders.
  ///
  /// In ko, this message translates to:
  /// **'총 주문'**
  String get totalOrders;

  /// No description provided for @completed.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completed;

  /// No description provided for @revenue.
  ///
  /// In ko, this message translates to:
  /// **'매출'**
  String get revenue;

  /// No description provided for @cash.
  ///
  /// In ko, this message translates to:
  /// **'현금'**
  String get cash;

  /// No description provided for @online.
  ///
  /// In ko, this message translates to:
  /// **'온라인'**
  String get online;

  /// No description provided for @firestoreMigration.
  ///
  /// In ko, this message translates to:
  /// **'Firestore 데이터 마이그레이션'**
  String get firestoreMigration;

  /// No description provided for @confirmMigration.
  ///
  /// In ko, this message translates to:
  /// **'8개의 트럭 데이터를 Firestore에 업로드하시겠습니까?'**
  String get confirmMigration;

  /// No description provided for @migrationSuccess.
  ///
  /// In ko, this message translates to:
  /// **'8개 트럭 데이터가 성공적으로 업로드되었습니다!'**
  String get migrationSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In ko, this message translates to:
  /// **'업로드 실패: {error}'**
  String uploadFailed(Object error);

  /// No description provided for @distanceKm.
  ///
  /// In ko, this message translates to:
  /// **'{distance} km'**
  String distanceKm(Object distance);

  /// No description provided for @openNow.
  ///
  /// In ko, this message translates to:
  /// **'영업 중'**
  String get openNow;

  /// No description provided for @closed.
  ///
  /// In ko, this message translates to:
  /// **'휴업 중'**
  String get closed;

  /// No description provided for @myFavorites.
  ///
  /// In ko, this message translates to:
  /// **'내 즐겨찾기'**
  String get myFavorites;

  /// No description provided for @noFavoriteTrucksYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 즐겨찾기한 트럭이 없습니다'**
  String get noFavoriteTrucksYet;

  /// No description provided for @addFavoritesHint.
  ///
  /// In ko, this message translates to:
  /// **'트럭 목록에서 ♥를 눌러 추가하세요'**
  String get addFavoritesHint;

  /// No description provided for @favoriteTrucksNotFound.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기한 트럭을 찾을 수 없습니다'**
  String get favoriteTrucksNotFound;

  /// No description provided for @errorWithMessage.
  ///
  /// In ko, this message translates to:
  /// **'오류: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @businessLocation.
  ///
  /// In ko, this message translates to:
  /// **'영업 장소'**
  String get businessLocation;

  /// No description provided for @businessLocationHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 강남역 2번 출구'**
  String get businessLocationHint;

  /// No description provided for @startTime.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In ko, this message translates to:
  /// **'종료 시간'**
  String get endTime;

  /// No description provided for @menuManagement.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 관리'**
  String get menuManagement;

  /// No description provided for @addMenuItem.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 추가'**
  String get addMenuItem;

  /// No description provided for @editMenuItem.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 수정'**
  String get editMenuItem;

  /// No description provided for @deleteMenuItem.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 삭제'**
  String get deleteMenuItem;

  /// No description provided for @menuItemName.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 이름'**
  String get menuItemName;

  /// No description provided for @menuItemNameHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 닭꼬치'**
  String get menuItemNameHint;

  /// No description provided for @menuItemPrice.
  ///
  /// In ko, this message translates to:
  /// **'가격'**
  String get menuItemPrice;

  /// No description provided for @menuItemDescription.
  ///
  /// In ko, this message translates to:
  /// **'설명 (선택사항)'**
  String get menuItemDescription;

  /// No description provided for @confirmDeleteMenuItem.
  ///
  /// In ko, this message translates to:
  /// **'이 메뉴를 삭제하시겠습니까?'**
  String get confirmDeleteMenuItem;

  /// No description provided for @menuItemAdded.
  ///
  /// In ko, this message translates to:
  /// **'메뉴가 추가되었습니다'**
  String get menuItemAdded;

  /// No description provided for @menuItemUpdated.
  ///
  /// In ko, this message translates to:
  /// **'메뉴가 수정되었습니다'**
  String get menuItemUpdated;

  /// No description provided for @menuItemDeleted.
  ///
  /// In ko, this message translates to:
  /// **'메뉴가 삭제되었습니다'**
  String get menuItemDeleted;

  /// No description provided for @available.
  ///
  /// In ko, this message translates to:
  /// **'판매 중'**
  String get available;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @menuItemImage.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 이미지'**
  String get menuItemImage;

  /// No description provided for @removeImage.
  ///
  /// In ko, this message translates to:
  /// **'이미지 삭제'**
  String get removeImage;

  /// No description provided for @selectImageSource.
  ///
  /// In ko, this message translates to:
  /// **'이미지 선택'**
  String get selectImageSource;

  /// No description provided for @gallery.
  ///
  /// In ko, this message translates to:
  /// **'갤러리'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In ko, this message translates to:
  /// **'카메라'**
  String get camera;

  /// No description provided for @imageUploadFailed.
  ///
  /// In ko, this message translates to:
  /// **'이미지 업로드에 실패했습니다'**
  String get imageUploadFailed;

  /// No description provided for @truckImage.
  ///
  /// In ko, this message translates to:
  /// **'트럭 이미지'**
  String get truckImage;

  /// No description provided for @truckImageUploadSuccess.
  ///
  /// In ko, this message translates to:
  /// **'트럭 이미지가 업데이트되었습니다'**
  String get truckImageUploadSuccess;

  /// No description provided for @reviewManagement.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 관리'**
  String get reviewManagement;

  /// No description provided for @reviewStats.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 통계'**
  String get reviewStats;

  /// No description provided for @totalReviews.
  ///
  /// In ko, this message translates to:
  /// **'총 리뷰'**
  String get totalReviews;

  /// No description provided for @averageRating.
  ///
  /// In ko, this message translates to:
  /// **'평균 평점'**
  String get averageRating;

  /// No description provided for @ratingDistribution.
  ///
  /// In ko, this message translates to:
  /// **'평점 분포'**
  String get ratingDistribution;

  /// No description provided for @recentReviews.
  ///
  /// In ko, this message translates to:
  /// **'최근 리뷰'**
  String get recentReviews;

  /// No description provided for @allReviews.
  ///
  /// In ko, this message translates to:
  /// **'전체 리뷰'**
  String get allReviews;

  /// No description provided for @replyToReview.
  ///
  /// In ko, this message translates to:
  /// **'답글 달기'**
  String get replyToReview;

  /// No description provided for @editReply.
  ///
  /// In ko, this message translates to:
  /// **'답글 수정'**
  String get editReply;

  /// No description provided for @deleteReply.
  ///
  /// In ko, this message translates to:
  /// **'답글 삭제'**
  String get deleteReply;

  /// No description provided for @replyPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'고객 리뷰에 답글을 작성하세요'**
  String get replyPlaceholder;

  /// No description provided for @replySent.
  ///
  /// In ko, this message translates to:
  /// **'답글이 등록되었습니다'**
  String get replySent;

  /// No description provided for @replyDeleted.
  ///
  /// In ko, this message translates to:
  /// **'답글이 삭제되었습니다'**
  String get replyDeleted;

  /// No description provided for @confirmDeleteReply.
  ///
  /// In ko, this message translates to:
  /// **'정말 답글을 삭제하시겠습니까?'**
  String get confirmDeleteReply;

  /// No description provided for @noReviewsForTruck.
  ///
  /// In ko, this message translates to:
  /// **'아직 받은 리뷰가 없습니다'**
  String get noReviewsForTruck;

  /// No description provided for @viewAllReviews.
  ///
  /// In ko, this message translates to:
  /// **'전체 리뷰 보기'**
  String get viewAllReviews;

  /// No description provided for @starsCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String starsCount(Object count);

  /// No description provided for @bankAccountSettings.
  ///
  /// In ko, this message translates to:
  /// **'계좌 정보 설정'**
  String get bankAccountSettings;

  /// No description provided for @bankAccountNotSet.
  ///
  /// In ko, this message translates to:
  /// **'계좌 정보가 설정되지 않았습니다'**
  String get bankAccountNotSet;

  /// No description provided for @setBankAccount.
  ///
  /// In ko, this message translates to:
  /// **'계좌 설정하기'**
  String get setBankAccount;

  /// No description provided for @editBankAccount.
  ///
  /// In ko, this message translates to:
  /// **'계좌 수정'**
  String get editBankAccount;

  /// No description provided for @bankName.
  ///
  /// In ko, this message translates to:
  /// **'은행명'**
  String get bankName;

  /// No description provided for @bankNameHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 카카오뱅크'**
  String get bankNameHint;

  /// No description provided for @accountNumber.
  ///
  /// In ko, this message translates to:
  /// **'계좌번호'**
  String get accountNumber;

  /// No description provided for @accountNumberHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 3333-12-1234567'**
  String get accountNumberHint;

  /// No description provided for @accountHolder.
  ///
  /// In ko, this message translates to:
  /// **'예금주'**
  String get accountHolder;

  /// No description provided for @accountHolderHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 홍길동'**
  String get accountHolderHint;

  /// No description provided for @bankAccountSaved.
  ///
  /// In ko, this message translates to:
  /// **'계좌 정보가 저장되었습니다'**
  String get bankAccountSaved;

  /// No description provided for @bankAccountFormat.
  ///
  /// In ko, this message translates to:
  /// **'{bank} {number} ({holder})'**
  String bankAccountFormat(Object bank, Object holder, Object number);

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In ko, this message translates to:
  /// **'모든 항목을 입력해주세요'**
  String get pleaseFillAllFields;

  /// No description provided for @tapToViewDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 보기를 탭하세요'**
  String get tapToViewDetails;

  /// No description provided for @ranked.
  ///
  /// In ko, this message translates to:
  /// **'{rank}위'**
  String ranked(int rank);

  /// No description provided for @operating.
  ///
  /// In ko, this message translates to:
  /// **'운행 중'**
  String get operating;

  /// No description provided for @resting.
  ///
  /// In ko, this message translates to:
  /// **'휴식 중'**
  String get resting;

  /// No description provided for @maintenance.
  ///
  /// In ko, this message translates to:
  /// **'점검 중'**
  String get maintenance;

  /// No description provided for @couponScanner.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 스캐너'**
  String get couponScanner;

  /// No description provided for @couponScanGuide.
  ///
  /// In ko, this message translates to:
  /// **'고객 쿠폰 QR 코드 스캔'**
  String get couponScanGuide;

  /// No description provided for @couponScanDescription.
  ///
  /// In ko, this message translates to:
  /// **'고객의 QR 코드를 카메라에 비춰주세요'**
  String get couponScanDescription;

  /// No description provided for @couponUsedSuccess.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰이 사용되었습니다!'**
  String get couponUsedSuccess;

  /// No description provided for @couponNotFound.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰을 찾을 수 없습니다'**
  String get couponNotFound;

  /// No description provided for @couponAlreadyUsed.
  ///
  /// In ko, this message translates to:
  /// **'이미 사용된 쿠폰입니다'**
  String get couponAlreadyUsed;

  /// No description provided for @couponWrongTruck.
  ///
  /// In ko, this message translates to:
  /// **'다른 트럭의 쿠폰입니다'**
  String get couponWrongTruck;

  /// No description provided for @couponUseFailed.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 사용에 실패했습니다'**
  String get couponUseFailed;

  /// No description provided for @couponScanFailed.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 스캔에 실패했습니다'**
  String get couponScanFailed;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @truckManagement.
  ///
  /// In ko, this message translates to:
  /// **'트럭 관리'**
  String get truckManagement;

  /// No description provided for @publicTalk.
  ///
  /// In ko, this message translates to:
  /// **'공개 Talk'**
  String get publicTalk;

  /// No description provided for @publicTalkDescription.
  ///
  /// In ko, this message translates to:
  /// **'모든 고객이 볼 수 있는 공개 대화입니다'**
  String get publicTalkDescription;

  /// No description provided for @customerChats.
  ///
  /// In ko, this message translates to:
  /// **'1:1 고객 채팅'**
  String get customerChats;

  /// No description provided for @customerChatsDescription.
  ///
  /// In ko, this message translates to:
  /// **'고객과의 개인 채팅 목록입니다'**
  String get customerChatsDescription;

  /// No description provided for @noCustomerChats.
  ///
  /// In ko, this message translates to:
  /// **'아직 채팅이 없습니다'**
  String get noCustomerChats;

  /// No description provided for @errorLoadingChats.
  ///
  /// In ko, this message translates to:
  /// **'채팅을 불러올 수 없습니다'**
  String get errorLoadingChats;

  /// No description provided for @contactAdmin.
  ///
  /// In ko, this message translates to:
  /// **'관리자 문의'**
  String get contactAdmin;

  /// No description provided for @supportChatDescription.
  ///
  /// In ko, this message translates to:
  /// **'운영 관련 문의사항을 관리자에게 직접 문의하세요'**
  String get supportChatDescription;

  /// No description provided for @errorCreatingChat.
  ///
  /// In ko, this message translates to:
  /// **'채팅방을 생성할 수 없습니다'**
  String get errorCreatingChat;

  /// No description provided for @startSupportChat.
  ///
  /// In ko, this message translates to:
  /// **'문의사항을 입력해주세요'**
  String get startSupportChat;

  /// No description provided for @adminSupport.
  ///
  /// In ko, this message translates to:
  /// **'관리자 지원'**
  String get adminSupport;

  /// No description provided for @contactAdminDescription.
  ///
  /// In ko, this message translates to:
  /// **'운영 관련 도움이 필요하시면 관리자에게 문의하세요'**
  String get contactAdminDescription;

  /// No description provided for @myCoupons.
  ///
  /// In ko, this message translates to:
  /// **'내 쿠폰함'**
  String get myCoupons;

  /// No description provided for @noCoupons.
  ///
  /// In ko, this message translates to:
  /// **'보유한 쿠폰이 없습니다'**
  String get noCoupons;

  /// No description provided for @earnCouponsHint.
  ///
  /// In ko, this message translates to:
  /// **'트럭 방문 시 스탬프를 모아 쿠폰을 받으세요!'**
  String get earnCouponsHint;

  /// No description provided for @couponReady.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능!'**
  String get couponReady;

  /// No description provided for @stamps.
  ///
  /// In ko, this message translates to:
  /// **'스탬프'**
  String get stamps;

  /// No description provided for @useNow.
  ///
  /// In ko, this message translates to:
  /// **'사용하기'**
  String get useNow;

  /// No description provided for @expiresOn.
  ///
  /// In ko, this message translates to:
  /// **'유효기간'**
  String get expiresOn;

  /// No description provided for @showQR.
  ///
  /// In ko, this message translates to:
  /// **'QR 보기'**
  String get showQR;

  /// No description provided for @couponQR.
  ///
  /// In ko, this message translates to:
  /// **'쿠폰 QR'**
  String get couponQR;

  /// No description provided for @showQRToOwner.
  ///
  /// In ko, this message translates to:
  /// **'사장님에게 이 QR 코드를 보여주세요'**
  String get showQRToOwner;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @visitHistory.
  ///
  /// In ko, this message translates to:
  /// **'방문 기록'**
  String get visitHistory;

  /// No description provided for @noVisitHistory.
  ///
  /// In ko, this message translates to:
  /// **'방문 기록이 없습니다'**
  String get noVisitHistory;

  /// No description provided for @visitTrucksHint.
  ///
  /// In ko, this message translates to:
  /// **'트럭을 방문하고 체크인해보세요!'**
  String get visitTrucksHint;

  /// No description provided for @deleteAccount.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get deleteAccount;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In ko, this message translates to:
  /// **'정말로 탈퇴하시겠습니까?\\n모든 데이터가 삭제되며 복구할 수 없습니다.'**
  String get deleteAccountWarning;

  /// No description provided for @accountDeleted.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴가 완료되었습니다'**
  String get accountDeleted;
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
