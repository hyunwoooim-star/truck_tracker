import 'package:web/web.dart' as web;

/// Web-specific auth helper for OAuth redirects
class WebAuthHelper {
  /// Redirect to OAuth URL (replaces current page)
  static void redirectToOAuth(String url) {
    web.window.location.href = url;
  }

  /// Get current URL (for callback parsing)
  static String getCurrentUrl() {
    return web.window.location.href;
  }

  /// Get URL query parameter
  static String? getQueryParam(String name) {
    final uri = Uri.parse(web.window.location.href);
    return uri.queryParameters[name];
  }

  /// Check if current URL is OAuth callback
  static bool isOAuthCallback(String provider) {
    final path = web.window.location.pathname;
    return path.contains('/oauth/$provider/callback');
  }

  /// Clear URL hash/query (after processing callback)
  static void clearCallbackParams() {
    final uri = Uri.parse(web.window.location.href);
    final cleanUrl =
        '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}';
    web.window.history.replaceState(null, '', cleanUrl);
  }
}
