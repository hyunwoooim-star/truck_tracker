import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/utils/app_logger.dart';
import 'location_service.dart';

/// Cached location service that throttles GPS updates to save battery
class CachedLocationService {
  CachedLocationService({required LocationService locationService})
      : _locationService = locationService {
    _setupLifecycleListener();
  }

  final LocationService _locationService;

  Position? _cachedPosition;
  DateTime? _cacheTimestamp;
  static const Duration _cacheInterval = Duration(seconds: 30);

  // 🔋 OPTIMIZATION: Track app lifecycle to pause GPS in background
  AppLifecycleListener? _lifecycleListener;
  bool _isAppInForeground = true;

  // ═══════════════════════════════════════════════════════════
  // APP LIFECYCLE MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  /// Set up app lifecycle listener to pause GPS in background
  void _setupLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        switch (state) {
          case AppLifecycleState.resumed:
          case AppLifecycleState.inactive:
            // App is visible or partially visible
            _isAppInForeground = true;
            AppLogger.debug('GPS RESUMED - App returned to foreground', tag: 'CachedLocationService');
            break;

          case AppLifecycleState.paused:
          case AppLifecycleState.detached:
          case AppLifecycleState.hidden:
            // App is in background or being terminated
            _isAppInForeground = false;
            AppLogger.debug('GPS PAUSED - App moved to background (battery saving)', tag: 'CachedLocationService');
            break;
        }
      },
    );
  }

  /// Dispose lifecycle listener (call when service is no longer needed)
  void dispose() {
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
    AppLogger.debug('CachedLocationService disposed', tag: 'CachedLocationService');
  }

  // ═══════════════════════════════════════════════════════════
  // CACHE MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  /// Check if cached position is still valid
  bool _isCacheValid() {
    if (_cachedPosition == null || _cacheTimestamp == null) return false;
    final age = DateTime.now().difference(_cacheTimestamp!);
    return age < _cacheInterval;
  }

  /// Clear the cached position
  void clearCache() {
    _cachedPosition = null;
    _cacheTimestamp = null;
    AppLogger.debug('Cache cleared', tag: 'CachedLocationService');
  }

  // ═══════════════════════════════════════════════════════════
  // GET CACHED POSITION
  // ═══════════════════════════════════════════════════════════

  /// Get current position with caching (30s cache interval)
  Future<Position?> getPosition() async {
    if (_isCacheValid()) {
      final age = DateTime.now().difference(_cacheTimestamp!).inSeconds;
      AppLogger.debug('Using cached position (age: ${age}s)', tag: 'CachedLocationService');
      return _cachedPosition;
    }

    AppLogger.debug('Cache miss - fetching new position', tag: 'CachedLocationService');
    final position = await _locationService.getCurrentPosition();

    if (position != null) {
      _cachedPosition = position;
      _cacheTimestamp = DateTime.now();
      AppLogger.debug('Position cached successfully', tag: 'CachedLocationService');
    }

    return position;
  }

  // ═══════════════════════════════════════════════════════════
  // WATCH POSITION (THROTTLED STREAM)
  // ═══════════════════════════════════════════════════════════

  /// Watch position stream with 30s throttle and 50m distance filter
  ///
  /// This significantly reduces:
  /// - GPS polling frequency (battery saving)
  /// - Firestore write operations (cost saving)
  /// - UI rebuild frequency (performance improvement)
  ///
  /// 🔋 OPTIMIZATION: Automatically pauses GPS when app is in background
  Stream<Position> watchPositionCached() {
    AppLogger.debug('Creating throttled position stream', tag: 'CachedLocationService');
    AppLogger.debug('Throttle interval: 30 seconds', tag: 'CachedLocationService');
    AppLogger.debug('Minimum distance: 50 meters', tag: 'CachedLocationService');
    AppLogger.debug('Background pause: ENABLED', tag: 'CachedLocationService');

    return _locationService
        .watchPosition()
        // 🔋 OPTIMIZATION: Skip GPS updates when app is in background
        .where((_) {
          if (!_isAppInForeground) {
            AppLogger.debug('Skipping GPS update - app in background', tag: 'CachedLocationService');
          }
          return _isAppInForeground;
        })
        // Throttle to maximum one update every 30 seconds
        .throttleTime(
          const Duration(seconds: 30),
          // Use trailing edge to get the most recent position
          trailing: true,
          leading: false,
        )
        // Filter out small movements (< 50m)
        .distinct((prev, curr) {
          final distance = _calculateDistance(prev, curr);
          final shouldEmit = distance >= 50;

          if (!shouldEmit) {
            AppLogger.debug(
              'Skipping update - distance too small: ${distance.toStringAsFixed(1)}m',
              tag: 'CachedLocationService'
            );
          } else {
            AppLogger.debug(
              'Emitting update - distance: ${distance.toStringAsFixed(1)}m',
              tag: 'CachedLocationService'
            );
          }

          return shouldEmit;
        });
  }

  // ═══════════════════════════════════════════════════════════
  // DISTANCE CALCULATION
  // ═══════════════════════════════════════════════════════════

  /// Calculate distance between two positions using Haversine formula
  double _calculateDistance(Position p1, Position p2) {
    return _locationService.calculateDistance(
      p1.latitude,
      p1.longitude,
      p2.latitude,
      p2.longitude,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PASSTHROUGH METHODS
  // ═══════════════════════════════════════════════════════════

  /// Pass through to underlying location service
  Future<bool> ensurePermission() => _locationService.ensurePermission();

  /// Pass through to underlying location service
  Future<Position?> getLastKnownPosition() =>
      _locationService.getLastKnownPosition();

  /// Pass through to underlying location service
  String getDistanceText(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      _locationService.getDistanceText(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  /// Pass through to underlying location service
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) =>
      _locationService.calculateDistance(lat1, lon1, lat2, lon2);
}
