// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ownerCommandCenter => 'Owner Command Center';

  @override
  String get inputCashSale => 'Input Cash Sale';

  @override
  String get amount => 'Amount (₩)';

  @override
  String get memoOptional => 'Memo (optional)';

  @override
  String get submitSale => 'Submit Sale';

  @override
  String get cashSaleRecordedSuccessfully => 'Cash sale recorded successfully';

  @override
  String get truckQRCode => 'Truck QR Code';

  @override
  String get showCustomersQRCode => 'Show customers this QR code to check in';

  @override
  String get todaysStatistics => 'Today\'s Statistics';

  @override
  String get views => 'Views';

  @override
  String get reviews => 'Reviews';

  @override
  String get favorites => 'Favorites';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get viewFullAnalytics => 'View Full Analytics';

  @override
  String get manageReviews => 'Manage Reviews';

  @override
  String get editTruckInfo => 'Edit Truck Info';

  @override
  String get updateLocation => 'Update Location';

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoadingDashboard => 'Error loading dashboard';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get downloadCSV => 'Download CSV';

  @override
  String get date => 'Date';

  @override
  String get clicks => 'Clicks';

  @override
  String get csvDownloadedSuccessfully => 'CSV downloaded successfully';

  @override
  String get errorDownloadingCSV => 'Error downloading CSV';

  @override
  String get scanQRCode => 'Scan QR Code';

  @override
  String get checkinSuccess => 'Check-in Success!';

  @override
  String get invalidQRCode => 'Invalid QR Code';

  @override
  String get cameraPermissionRequired => 'Camera Permission Required';

  @override
  String get enableCameraToScan => 'Enable camera to scan QR codes';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get qrCheckInTooltip => 'QR Check-In';

  @override
  String get scheduleTooltip => 'Schedule';

  @override
  String get analyticsTooltip => 'Analytics';

  @override
  String get uploadDataTooltip => 'Upload Data';

  @override
  String get noTruckRegistered => 'No truck registered';

  @override
  String get errorLoadingTruckData => 'Error loading truck data';

  @override
  String get alreadyOpenForBusiness => 'Already open for business!';

  @override
  String get couldNotGetGPSLocation => 'Could not get GPS location';

  @override
  String get businessStartedNotification =>
      'Business started! Followers will be notified 🔔';

  @override
  String get businessOpen => 'BUSINESS OPEN';

  @override
  String get startBusiness => 'START BUSINESS';

  @override
  String get todaysSpecialNotice => 'Today\'s Special Notice';

  @override
  String get noAnnouncementSet => '(No announcement set)';

  @override
  String get editAnnouncement => 'Edit Announcement';

  @override
  String get announcementDisplayedMessage =>
      'This will be displayed at the top of your truck detail page.';

  @override
  String get announcement => 'Announcement';

  @override
  String get announcementHint =>
      'e.g., \"Today\'s special: 30% off chicken skewers!\"';

  @override
  String get announcementUpdated => 'Announcement updated!';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get itemName => 'Item Name';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String cashSaleRecorded(Object amount) {
    return 'Cash sale recorded: ₩$amount';
  }

  @override
  String get regularsNearby => 'Regulars Nearby';

  @override
  String get todaysRevenue => 'Today\'s Revenue';

  @override
  String get orderBoard => 'Order Board';

  @override
  String get pending => 'Pending';

  @override
  String get preparing => 'Preparing';

  @override
  String get ready => 'Ready';

  @override
  String get errorLoadingOrders => 'Error loading orders';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get noOrdersInColumn => 'No orders';

  @override
  String get menuItems => 'Menu Items';

  @override
  String get noMenuItems => 'No menu items';

  @override
  String get errorLoadingMenu => 'Error loading menu';

  @override
  String get customerConversations => 'Customer Conversations';

  @override
  String orderItemsTotal(Object count, Object total) {
    return '$count items - ₩$total';
  }

  @override
  String get selectDateRangeTooltip => 'Select Date Range';

  @override
  String get downloadCSVTooltip => 'Download CSV';

  @override
  String get clickCount => 'Click Count';

  @override
  String get reviewCount => 'Review Count';

  @override
  String get favoriteCount => 'Favorite Count';

  @override
  String get csvDownloadSuccess => 'CSV downloaded successfully';

  @override
  String csvDownloadError(Object error) {
    return 'Error downloading CSV: $error';
  }

  @override
  String get total => 'TOTAL';

  @override
  String get average => 'AVERAGE';

  @override
  String get checkInQRCode => 'Check-In QR Code';

  @override
  String get checkInQR => 'Check-In QR';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get showBankTransferQR => 'Show this QR for bank transfer payments';

  @override
  String get customerscanQR => 'Customers scan this QR code to check in';

  @override
  String truckID(Object id) {
    return 'Truck ID: $id';
  }

  @override
  String get checkInBenefits => 'Check-in Benefits';

  @override
  String get benefitsList =>
      '• Earn 10 loyalty points per visit\n• Track favorite trucks\n• Get special promotions';

  @override
  String get pleaseEnterTruckID => 'Please enter a truck ID';

  @override
  String get userNotLoggedIn => 'User not logged in';

  @override
  String get truckNotFound => 'Truck not found';

  @override
  String get alreadyCheckedInToday =>
      'You have already checked in to this truck today!';

  @override
  String checkInFailed(Object error) {
    return 'Check-in failed: $error';
  }

  @override
  String get checkInSuccessful => 'Check-in successful!';

  @override
  String loyaltyPoints(Object truck) {
    return '$truck • +10 loyalty points';
  }

  @override
  String get checkIn => 'Check-In';

  @override
  String get scanQRCodeToCheckIn => 'Scan QR Code to Check In';

  @override
  String get earnLoyaltyPoints => 'Earn loyalty points with every visit!';

  @override
  String get or => 'OR';

  @override
  String get enterTruckID => 'Enter Truck ID';

  @override
  String get enterTruckIDHint => 'Enter truck ID (e.g., truck_001)';

  @override
  String get checkInButton => 'CHECK IN';

  @override
  String get howItWorks => 'How it works';

  @override
  String get howItWorksList =>
      '1. Scan the QR code at the food truck\n2. Earn 10 loyalty points per visit\n3. Track your favorite trucks\n4. You can only check in once per day per truck';

  @override
  String get errorLoadingData => 'Cannot load data';

  @override
  String get todaysSpecialAnnouncement => 'Today\'s Special Announcement';

  @override
  String todayLocation(Object location) {
    return 'Today: $location';
  }

  @override
  String get menu => 'Menu';

  @override
  String get errorLoadingReviews => 'Cannot load reviews';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get talkWithOwner => 'Talk with Owner';

  @override
  String get talkWithCustomers => 'Talk with Customers';

  @override
  String get noMessagesYet => 'No messages yet. Start the conversation!';

  @override
  String get errorLoadingMessages => 'Error loading messages';

  @override
  String get me => 'Me';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get deleteMessageConfirmation =>
      'Are you sure you want to delete this message?';

  @override
  String get messageDeleted => 'Message deleted';

  @override
  String get messageDeleteFailed => 'Failed to delete message';

  @override
  String get longPressToDelete => 'Long press to delete';

  @override
  String get navigation => 'Navigation';

  @override
  String totalItems(Object count) {
    return 'Total $count items';
  }

  @override
  String get placeOrder => 'Place Order';

  @override
  String get writeReview => 'Write Review';

  @override
  String get editReview => 'Edit Review';

  @override
  String get myReview => 'My Review';

  @override
  String get deleteReview => 'Delete Review';

  @override
  String get deleteReviewConfirmation =>
      'Are you sure you want to delete this review?';

  @override
  String get reviewDeleted => 'Review deleted successfully';

  @override
  String get reviewDeleteFailed => 'Failed to delete review';

  @override
  String get reviewUpdated => 'Review updated successfully';

  @override
  String get reviewUpdateFailed => 'Failed to update review';

  @override
  String get soldOut => 'Sold Out';

  @override
  String priceWon(Object price) {
    return '$price won';
  }

  @override
  String get addToCart => 'Add';

  @override
  String get ownerReply => 'Owner Reply';

  @override
  String get location => 'Location';

  @override
  String get chooseNavigationApp => 'Choose navigation app:';

  @override
  String get naverMap => 'Naver Map';

  @override
  String get kakaoMap => 'Kakao Map';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get cannotOpenNaverMap => 'Cannot open Naver Map';

  @override
  String get cannotOpenKakaoMap => 'Cannot open Kakao Map';

  @override
  String get cannotOpenGoogleMaps => 'Cannot open Google Maps';

  @override
  String get loginRequiredToOrder => 'Login required to place order';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String totalMenuItems(Object count) {
    return 'Total $count menu items';
  }

  @override
  String get wouldYouLikeToOrder => 'Would you like to place order?';

  @override
  String orderCompleted(Object orderId) {
    return 'Order completed! (Order ID: $orderId)';
  }

  @override
  String orderFailed(Object error) {
    return 'Order failed: $error';
  }

  @override
  String get truckUncle => 'Truck Uncle';

  @override
  String get loginRequired => 'Login required';

  @override
  String get reviewSubmitted => 'Review submitted';

  @override
  String reviewSubmissionFailed(Object error) {
    return 'Review submission failed: $error';
  }

  @override
  String get purchaseRequiredForReview =>
      'You can write a review after placing an order';

  @override
  String get purchaseRequiredForTalk =>
      'You can leave a comment after placing an order';

  @override
  String get verifyingPurchase => 'Verifying purchase...';

  @override
  String get starRating => 'Star Rating';

  @override
  String get reviewContent => 'Review Content';

  @override
  String get reviewPlaceholder => 'Please write a review for this truck';

  @override
  String get pleaseEnterReviewContent => 'Please enter review content';

  @override
  String get pleaseEnterAtLeast5Chars => 'Please enter at least 5 characters';

  @override
  String get photosOptionalMax3 => 'Photos (optional, max 3)';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get submit => 'Submit';

  @override
  String get truckList => 'Truck List';

  @override
  String get viewMap => 'View Map';

  @override
  String get appInfo => 'App Info';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get noTrucksAvailable => 'No trucks available';

  @override
  String get loadDataFailed => 'Failed to load data';

  @override
  String get favoriteFailed =>
      'Failed to add favorite! Please try again later.';

  @override
  String get favoriteSuccess => 'Added to favorites!';

  @override
  String get favoriteRemoved => 'Removed from favorites!';

  @override
  String get distance => 'Distance';

  @override
  String get rating => 'Rating';

  @override
  String get foodTruckMap => 'Food Truck Map';

  @override
  String get cannotLoadMap => 'Cannot load map';

  @override
  String get noTrucks => 'No trucks';

  @override
  String get pleaseRetryLater => 'Please try again later';

  @override
  String get checkLater => 'Please check again later';

  @override
  String get trucksWithoutLocation => 'Trucks without location information';

  @override
  String trucksLocationNotSet(Object count) {
    return '$count trucks without location set';
  }

  @override
  String get searchTrucks => 'Search trucks';

  @override
  String get searchPlaceholder =>
      'Search by truck number, driver name, menu, location';

  @override
  String get viewOnMap => 'View on map';

  @override
  String get favorite => 'Favorite';

  @override
  String get statusOnRoute => 'On Route';

  @override
  String get statusResting => 'Resting';

  @override
  String get statusMaintenance => 'Maintenance';

  @override
  String get statusStopped => 'Stopped';

  @override
  String get statusInspection => 'Inspection';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get agreeToTermsRequired => 'Please agree to terms and privacy policy';

  @override
  String get agreeToTerms => 'Agree to Terms (Required)';

  @override
  String get agreeToPrivacy => 'Agree to Privacy Policy (Required)';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get socialLogin => 'Social Login';

  @override
  String get continueWithKakao => 'Continue with Kakao';

  @override
  String get continueWithNaver => 'Continue with Naver';

  @override
  String get browse => 'Browse';

  @override
  String get ownerLogin => 'Owner Login';

  @override
  String get errorUserNotFound => 'Email not registered';

  @override
  String get errorWrongPassword => 'Incorrect password';

  @override
  String get errorEmailInUse => 'Email already in use';

  @override
  String get errorWeakPassword => 'Password must be at least 6 characters';

  @override
  String get errorInvalidEmail => 'Invalid email format';

  @override
  String get errorLoginCancelled => 'Login cancelled';

  @override
  String get errorLoginFailed => 'Error during login';

  @override
  String get uploadDataWarning =>
      'This will add new data without overwriting existing data.';

  @override
  String get upload => 'Upload';

  @override
  String get uploadingData => 'Uploading data...';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyContent =>
      'Truck Uncle values your privacy.\n\nInformation we collect:\n• Email address, name, profile photo\n• Location information (optional)\n\nPurpose of use:\n• Service provision and improvement\n• Customer support\n\nData retention period:\n• Until account deletion\n\nYou can request to view, modify, or delete your personal information at any time.\n\nContact: support@truckajeossi.com';

  @override
  String get appName => 'Truck Uncle';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Are you sure you want to logout?';

  @override
  String get analyticsDashboard => 'Analytics Dashboard';

  @override
  String get scheduleSaved => 'Schedule saved successfully';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get weeklySchedule => 'Weekly Schedule';

  @override
  String errorWithDetails(Object error) {
    return 'Error: $error';
  }

  @override
  String get followedTruck =>
      'Followed! You will receive notifications when this truck opens.';

  @override
  String get unfollowedTruck => 'Unfollowed this truck.';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';

  @override
  String get following => 'Following';

  @override
  String get followers => 'Followers';

  @override
  String get myFollowedTrucks => 'My Followed Trucks';

  @override
  String get noFollowedTrucks => 'You haven\'t followed any trucks yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsOn => 'Notifications On';

  @override
  String get notificationsOff => 'Notifications Off';

  @override
  String get browseAndFollowTrucks => 'Browse and follow your favorite trucks!';

  @override
  String get chat => 'Chat';

  @override
  String get chatList => 'Chat List';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get noChatHistory => 'No chat history yet';

  @override
  String get startChatFromTruck => 'Start a chat from the truck detail page';

  @override
  String get cannotLoadChat => 'Cannot load chat list';

  @override
  String get cannotLoadMessages => 'Cannot load messages';

  @override
  String get startChat => 'Start chatting';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get imageSendFailed => 'Failed to send image';

  @override
  String get read => 'Read';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String enabledNotifications(Object count) {
    return '$count notifications enabled';
  }

  @override
  String get enableAll => 'Enable All';

  @override
  String get disableAll => 'Disable All';

  @override
  String get basicNotifications => 'Basic Notifications';

  @override
  String get socialNotifications => 'Social Notifications';

  @override
  String get marketingNotifications => 'Marketing';

  @override
  String get locationBasedNotifications => 'Location-Based Notifications';

  @override
  String get truckOpeningNotification => 'Truck Opening';

  @override
  String get truckOpeningDesc =>
      'Get notified when followed trucks start business';

  @override
  String get orderUpdatesNotification => 'Order Updates';

  @override
  String get orderUpdatesDesc => 'Get notified when your order is ready';

  @override
  String get newCouponsNotification => 'New Coupons';

  @override
  String get newCouponsDesc =>
      'Get notified when followed trucks issue new coupons';

  @override
  String get reviewsNotification => 'Review Replies';

  @override
  String get reviewsDesc => 'Get notified when owners reply to your reviews';

  @override
  String get followedTrucksNotification => 'Followed Truck Activity';

  @override
  String get followedTrucksDesc => 'Get updates about trucks you follow';

  @override
  String get chatMessagesNotification => 'Chat Messages';

  @override
  String get chatMessagesDesc => 'Get notified of new chat messages';

  @override
  String get promotionsNotification => 'Promotions';

  @override
  String get promotionsDesc => 'Receive special events and promotions';

  @override
  String get nearbyTrucksNotification => 'Nearby Trucks';

  @override
  String get nearbyTrucksDesc =>
      'Get notified when trucks start business nearby';

  @override
  String notificationRadius(Object radius) {
    return 'Notification Radius: $radius km';
  }

  @override
  String nearbyRadiusDesc(Object radius) {
    return 'You will receive notifications when trucks within ${radius}km of your location start business.';
  }

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetSettingsConfirm =>
      'Reset notification settings to default.\nContinue?';

  @override
  String get settingsReset => 'Settings have been reset';

  @override
  String get cannotLoadSettings => 'Cannot load settings';

  @override
  String get closeBusiness => 'Close Business';

  @override
  String get confirmCloseBusiness => 'Are you sure you want to close business?';

  @override
  String get businessClosed => 'Business has been closed.';

  @override
  String get todaysOrderStatus => 'Today\'s Order Status';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get completed => 'Completed';

  @override
  String get revenue => 'Revenue';

  @override
  String get cash => 'Cash';

  @override
  String get online => 'Online';

  @override
  String get firestoreMigration => 'Firestore Data Migration';

  @override
  String get confirmMigration => 'Upload 8 truck data to Firestore?';

  @override
  String get migrationSuccess => '8 truck data successfully uploaded!';

  @override
  String uploadFailed(Object error) {
    return 'Upload failed: $error';
  }

  @override
  String distanceKm(Object distance) {
    return '$distance km';
  }

  @override
  String get openNow => 'Open Now';

  @override
  String get closed => 'Closed';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get noFavoriteTrucksYet => 'You haven\'t favorited any trucks yet';

  @override
  String get addFavoritesHint => 'Tap ♥ in the truck list to add favorites';

  @override
  String get favoriteTrucksNotFound => 'Favorited trucks not found';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String get businessLocation => 'Business Location';

  @override
  String get businessLocationHint => 'e.g., Gangnam Station Exit 2';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get menuManagement => 'Menu Management';

  @override
  String get addMenuItem => 'Add Menu Item';

  @override
  String get editMenuItem => 'Edit Menu Item';

  @override
  String get deleteMenuItem => 'Delete Menu Item';

  @override
  String get menuItemName => 'Menu Item Name';

  @override
  String get menuItemNameHint => 'e.g., Chicken Skewer';

  @override
  String get menuItemPrice => 'Price';

  @override
  String get menuItemDescription => 'Description (optional)';

  @override
  String get confirmDeleteMenuItem =>
      'Are you sure you want to delete this menu item?';

  @override
  String get menuItemAdded => 'Menu item added';

  @override
  String get menuItemUpdated => 'Menu item updated';

  @override
  String get menuItemDeleted => 'Menu item deleted';

  @override
  String get available => 'Available';

  @override
  String get delete => 'Delete';

  @override
  String get menuItemImage => 'Menu Image';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get imageUploadFailed => 'Image upload failed';

  @override
  String get truckImage => 'Truck Image';

  @override
  String get truckImageUploadSuccess => 'Truck image updated successfully';

  @override
  String get reviewManagement => 'Review Management';

  @override
  String get reviewStats => 'Review Statistics';

  @override
  String get totalReviews => 'Total Reviews';

  @override
  String get averageRating => 'Average Rating';

  @override
  String get ratingDistribution => 'Rating Distribution';

  @override
  String get recentReviews => 'Recent Reviews';

  @override
  String get allReviews => 'All Reviews';

  @override
  String get replyToReview => 'Reply';

  @override
  String get editReply => 'Edit Reply';

  @override
  String get deleteReply => 'Delete Reply';

  @override
  String get replyPlaceholder => 'Write a reply to the customer review';

  @override
  String get replySent => 'Reply sent';

  @override
  String get replyDeleted => 'Reply deleted';

  @override
  String get confirmDeleteReply =>
      'Are you sure you want to delete this reply?';

  @override
  String get noReviewsForTruck => 'No reviews yet';

  @override
  String get viewAllReviews => 'View All Reviews';

  @override
  String starsCount(Object count) {
    return '$count';
  }

  @override
  String get bankAccountSettings => 'Bank Account Settings';

  @override
  String get bankAccountNotSet => 'Bank account not set';

  @override
  String get setBankAccount => 'Set Bank Account';

  @override
  String get editBankAccount => 'Edit Bank Account';

  @override
  String get bankName => 'Bank Name';

  @override
  String get bankNameHint => 'e.g., Chase Bank';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get accountNumberHint => 'e.g., 1234567890';

  @override
  String get accountHolder => 'Account Holder';

  @override
  String get accountHolderHint => 'e.g., John Doe';

  @override
  String get bankAccountSaved => 'Bank account saved';

  @override
  String bankAccountFormat(Object bank, Object holder, Object number) {
    return '$bank $number ($holder)';
  }

  @override
  String get pleaseFillAllFields => 'Please fill in all fields';

  @override
  String get tapToViewDetails => 'Tap to view details';

  @override
  String ranked(int rank) {
    return 'Ranked #$rank';
  }

  @override
  String get operating => 'Operating';

  @override
  String get resting => 'Resting';

  @override
  String get maintenance => 'Maintenance';
}
