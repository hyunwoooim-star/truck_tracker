/// Stub for non-web platforms
class WebAuthHelper {
  static void redirectToOAuth(String url) {
    throw UnsupportedError('Web auth not supported on this platform');
  }

  static String getCurrentUrl() {
    throw UnsupportedError('Web auth not supported on this platform');
  }

  static String? getQueryParam(String name) {
    throw UnsupportedError('Web auth not supported on this platform');
  }

  static bool isOAuthCallback(String provider) {
    return false;
  }

  static void clearCallbackParams() {
    throw UnsupportedError('Web auth not supported on this platform');
  }
}
