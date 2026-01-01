/// API Configuration
///
/// Public API keys and endpoints for OAuth and other services.
/// These can be overridden at build time using --dart-define:
///
/// ```bash
/// flutter build web --dart-define=KAKAO_CLIENT_ID=your_key
/// flutter build web --dart-define=NAVER_CLIENT_ID=your_key
/// ```
///
/// Note: These are public client IDs, not secrets.
/// Secrets should be stored in Firebase Cloud Functions using defineSecret().
class ApiConfig {
  ApiConfig._();

  // ═══════════════════════════════════════════════════════════
  // OAUTH CLIENT IDs (Public - safe to include in client code)
  // ═══════════════════════════════════════════════════════════

  /// Kakao REST API Key (공개 키)
  /// Used for OAuth redirect, not for signing requests
  static const String kakaoClientId = String.fromEnvironment(
    'KAKAO_CLIENT_ID',
    defaultValue: '9b29da5ab6db839b37a65c79afe9b52e',
  );

  /// Naver Client ID (공개 키)
  static const String naverClientId = String.fromEnvironment(
    'NAVER_CLIENT_ID',
    defaultValue: '9szh6EOxjf8b40x9ZHKH',
  );

  // ═══════════════════════════════════════════════════════════
  // OAUTH REDIRECT URIs
  // ═══════════════════════════════════════════════════════════

  /// Kakao OAuth redirect URI
  static const String kakaoRedirectUri = String.fromEnvironment(
    'KAKAO_REDIRECT_URI',
    defaultValue: 'https://truck-tracker-fa0b0.web.app/kakao',
  );

  /// Naver OAuth redirect URI
  static const String naverRedirectUri = String.fromEnvironment(
    'NAVER_REDIRECT_URI',
    defaultValue: 'https://truck-tracker-fa0b0.web.app/oauth/naver/callback',
  );

  // ═══════════════════════════════════════════════════════════
  // CLOUD FUNCTIONS ENDPOINTS
  // ═══════════════════════════════════════════════════════════

  /// Base URL for Cloud Functions
  static const String cloudFunctionsBaseUrl = String.fromEnvironment(
    'CLOUD_FUNCTIONS_URL',
    defaultValue: 'https://us-central1-truck-tracker-fa0b0.cloudfunctions.net',
  );

  /// Custom token endpoint
  static String get createCustomTokenUrl =>
      '$cloudFunctionsBaseUrl/createCustomToken';

  /// Naver callback endpoint
  static String get naverCallbackUrl =>
      '$cloudFunctionsBaseUrl/naverCallback';

  /// Kakao callback endpoint
  static String get kakaoCallbackUrl =>
      '$cloudFunctionsBaseUrl/kakaoCallback';

  // ═══════════════════════════════════════════════════════════
  // FIREBASE CONFIG
  // ═══════════════════════════════════════════════════════════

  /// Firebase project ID
  static const String firebaseProjectId = 'truck-tracker-fa0b0';

  /// Firebase Storage bucket
  static const String firebaseStorageBucket =
      'truck-tracker-fa0b0.firebasestorage.app';
}
