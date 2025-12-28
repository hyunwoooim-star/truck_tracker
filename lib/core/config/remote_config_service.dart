import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../utils/app_logger.dart';

/// Firebase Remote Config Service
///
/// Provides secure access to API keys and configuration values
/// stored in Firebase Remote Config instead of .env files.
///
/// Keys are fetched from Firebase Console and cached locally.
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _initialized = false;

  /// Initialize Remote Config with default settings
  ///
  /// Should be called during app startup (e.g., in main.dart)
  ///
  /// Throws exception if initialization fails
  Future<void> initialize() async {
    if (_initialized) {
      AppLogger.debug('RemoteConfigService already initialized', tag: 'RemoteConfig');
      return;
    }

    try {
      AppLogger.info('Initializing Firebase Remote Config...', tag: 'RemoteConfig');

      // Configure fetch settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Set default values (fallback if fetch fails)
      await _remoteConfig.setDefaults(const {
        'kakao_app_key': '',
        'naver_client_id': '',
        'naver_client_secret': '',
      });

      // Fetch and activate latest values
      final bool updated = await _remoteConfig.fetchAndActivate();

      if (updated) {
        AppLogger.success('Remote Config fetched and activated', tag: 'RemoteConfig');
      } else {
        AppLogger.info('Remote Config already up to date', tag: 'RemoteConfig');
      }

      _initialized = true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Remote Config',
        error: e,
        stackTrace: stackTrace,
        tag: 'RemoteConfig',
      );
      rethrow;
    }
  }

  /// Get Kakao Native App Key
  ///
  /// Returns empty string if not configured
  String get kakaoAppKey {
    _ensureInitialized();
    final key = _remoteConfig.getString('kakao_app_key');
    AppLogger.debug('Retrieved Kakao App Key: ${key.isNotEmpty ? "[REDACTED]" : "[EMPTY]"}', tag: 'RemoteConfig');
    return key;
  }

  /// Get Naver Client ID
  ///
  /// Returns empty string if not configured
  String get naverClientId {
    _ensureInitialized();
    final id = _remoteConfig.getString('naver_client_id');
    AppLogger.debug('Retrieved Naver Client ID: ${id.isNotEmpty ? "[REDACTED]" : "[EMPTY]"}', tag: 'RemoteConfig');
    return id;
  }

  /// Get Naver Client Secret
  ///
  /// Returns empty string if not configured
  String get naverClientSecret {
    _ensureInitialized();
    final secret = _remoteConfig.getString('naver_client_secret');
    AppLogger.debug('Retrieved Naver Client Secret: ${secret.isNotEmpty ? "[REDACTED]" : "[EMPTY]"}', tag: 'RemoteConfig');
    return secret;
  }

  /// Ensure Remote Config is initialized before accessing values
  void _ensureInitialized() {
    if (!_initialized) {
      AppLogger.warning(
        'RemoteConfigService not initialized! Call initialize() first. Using default values.',
        tag: 'RemoteConfig',
      );
    }
  }

  /// Force refresh config values (bypass cache)
  ///
  /// Useful for testing or when immediate updates are needed
  Future<void> forceRefresh() async {
    try {
      AppLogger.info('Force refreshing Remote Config...', tag: 'RemoteConfig');
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration.zero, // Bypass cache
      ));
      await _remoteConfig.fetchAndActivate();
      AppLogger.success('Remote Config force refreshed', tag: 'RemoteConfig');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to force refresh Remote Config',
        error: e,
        stackTrace: stackTrace,
        tag: 'RemoteConfig',
      );
    }
  }
}
