import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/app_logger.dart';

part 'app_version_service.g.dart';

/// Current app version (should match pubspec.yaml)
const String kCurrentAppVersion = '1.0.0';

/// Model for version check result
class VersionCheckResult {
  final bool needsUpdate;
  final bool forceUpdate;
  final String? latestVersion;
  final String? updateMessage;
  final String? updateUrl;

  const VersionCheckResult({
    required this.needsUpdate,
    required this.forceUpdate,
    this.latestVersion,
    this.updateMessage,
    this.updateUrl,
  });

  static const VersionCheckResult noUpdateNeeded = VersionCheckResult(
    needsUpdate: false,
    forceUpdate: false,
  );
}

/// Service for checking app version against Remote Config
class AppVersionService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Initialize Remote Config with defaults
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Set default values
      await _remoteConfig.setDefaults({
        'minimum_version': kCurrentAppVersion,
        'latest_version': kCurrentAppVersion,
        'force_update': false,
        'update_message': '새로운 버전이 출시되었습니다!',
        'update_url_android': 'https://play.google.com/store/apps/details?id=com.example.truck_tracker',
        'update_url_ios': 'https://apps.apple.com/app/id123456789',
      });

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();

      AppLogger.debug('Remote Config initialized', tag: 'AppVersionService');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Remote Config',
        error: e,
        stackTrace: stackTrace,
        tag: 'AppVersionService',
      );
    }
  }

  /// Check if app needs update
  Future<VersionCheckResult> checkForUpdate() async {
    try {
      // Fetch latest config
      await _remoteConfig.fetchAndActivate();

      final minimumVersion = _remoteConfig.getString('minimum_version');
      final latestVersion = _remoteConfig.getString('latest_version');
      final forceUpdate = _remoteConfig.getBool('force_update');
      final updateMessage = _remoteConfig.getString('update_message');
      final updateUrl = _remoteConfig.getString('update_url_android'); // TODO: platform check

      final needsUpdate = _compareVersions(kCurrentAppVersion, latestVersion) < 0;
      final mustUpdate = _compareVersions(kCurrentAppVersion, minimumVersion) < 0;

      AppLogger.debug(
        'Version check: current=$kCurrentAppVersion, latest=$latestVersion, min=$minimumVersion',
        tag: 'AppVersionService',
      );

      if (mustUpdate || (needsUpdate && forceUpdate)) {
        return VersionCheckResult(
          needsUpdate: true,
          forceUpdate: true,
          latestVersion: latestVersion,
          updateMessage: updateMessage,
          updateUrl: updateUrl,
        );
      } else if (needsUpdate) {
        return VersionCheckResult(
          needsUpdate: true,
          forceUpdate: false,
          latestVersion: latestVersion,
          updateMessage: updateMessage,
          updateUrl: updateUrl,
        );
      }

      return VersionCheckResult.noUpdateNeeded;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Version check failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'AppVersionService',
      );
      return VersionCheckResult.noUpdateNeeded;
    }
  }

  /// Compare two version strings (e.g., "1.0.0" vs "1.1.0")
  /// Returns: -1 if v1 < v2, 0 if v1 == v2, 1 if v1 > v2
  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Pad with zeros if needed
    while (parts1.length < 3) {
      parts1.add(0);
    }
    while (parts2.length < 3) {
      parts2.add(0);
    }

    for (int i = 0; i < 3; i++) {
      if (parts1[i] < parts2[i]) return -1;
      if (parts1[i] > parts2[i]) return 1;
    }

    return 0;
  }
}

/// Provider for AppVersionService
@riverpod
AppVersionService appVersionService(Ref ref) {
  return AppVersionService();
}

/// Provider for version check result
@riverpod
Future<VersionCheckResult> versionCheck(Ref ref) async {
  final service = ref.watch(appVersionServiceProvider);
  await service.initialize();
  return service.checkForUpdate();
}

/// Dialog to show when update is available
class UpdateRequiredDialog extends StatelessWidget {
  final VersionCheckResult result;
  final VoidCallback? onUpdate;
  final VoidCallback? onLater;

  const UpdateRequiredDialog({
    super.key,
    required this.result,
    this.onUpdate,
    this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(result.forceUpdate ? '업데이트 필요' : '새 버전 출시'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.updateMessage ?? '새로운 버전이 출시되었습니다.'),
          const SizedBox(height: 8),
          if (result.latestVersion != null)
            Text(
              '최신 버전: ${result.latestVersion}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
        ],
      ),
      actions: [
        if (!result.forceUpdate)
          TextButton(
            onPressed: onLater ?? () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
        ElevatedButton(
          onPressed: onUpdate,
          child: const Text('업데이트'),
        ),
      ],
    );
  }
}
