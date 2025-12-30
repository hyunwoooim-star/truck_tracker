import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/app_logger.dart';
import '../../truck_list/domain/truck.dart';

/// Service for managing custom map markers
/// Caches BitmapDescriptors for performance optimization
class MarkerService {
  // Singleton pattern
  static final MarkerService _instance = MarkerService._internal();
  factory MarkerService() => _instance;
  MarkerService._internal();

  // Cached markers
  BitmapDescriptor? _openMarker;
  BitmapDescriptor? _movingMarker;
  BitmapDescriptor? _closedMarker;

  bool _initialized = false;

  /// Initialize all marker icons
  /// Call this once at app startup or before using markers
  Future<void> initialize() async {
    if (_initialized) return;

    AppLogger.debug('Initializing marker service...', tag: 'MarkerService');

    try {
      // Load all markers in parallel
      final results = await Future.wait([
        _loadMarker('assets/markers/truck_marker.png'),
        _loadMarker('assets/markers/truck_marker_moving.png'),
        _loadMarker('assets/markers/truck_marker_closed.png'),
      ]);

      _openMarker = results[0];
      _movingMarker = results[1];
      _closedMarker = results[2];

      _initialized = true;
      AppLogger.success('Marker service initialized', tag: 'MarkerService');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize markers',
          error: e, stackTrace: stackTrace, tag: 'MarkerService');
      // Fallback to default markers if custom ones fail
      _initialized = true;
    }
  }

  /// Load a marker from assets and resize it
  Future<BitmapDescriptor> _loadMarker(String assetPath) async {
    try {
      // Load the image bytes
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 64, // Resize for map display
        targetHeight: 64,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      // Convert to bytes
      final ByteData? resizedData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (resizedData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      AppLogger.debug('Loaded marker: $assetPath', tag: 'MarkerService');
      return BitmapDescriptor.bytes(resizedData.buffer.asUint8List());
    } catch (e) {
      AppLogger.warning('Failed to load marker $assetPath, using default', tag: 'MarkerService');
      // Return default marker as fallback
      return BitmapDescriptor.defaultMarker;
    }
  }

  /// Get the appropriate marker for a truck based on its status
  BitmapDescriptor getMarkerForTruck(Truck truck) {
    if (!_initialized) {
      AppLogger.warning('MarkerService not initialized, using default marker', tag: 'MarkerService');
      return BitmapDescriptor.defaultMarker;
    }

    switch (truck.status) {
      case TruckStatus.onRoute:
        return _movingMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      case TruckStatus.resting:
        return _openMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case TruckStatus.maintenance:
        return _closedMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
  }

  /// Get marker by status directly
  BitmapDescriptor getMarkerByStatus(TruckStatus status) {
    if (!_initialized) {
      return BitmapDescriptor.defaultMarker;
    }

    switch (status) {
      case TruckStatus.onRoute:
        return _movingMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      case TruckStatus.resting:
        return _openMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case TruckStatus.maintenance:
        return _closedMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
  }

  /// Get the open/resting marker (yellow truck)
  BitmapDescriptor get openMarker =>
      _openMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

  /// Get the moving marker (blue truck)
  BitmapDescriptor get movingMarker =>
      _movingMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  /// Get the closed/maintenance marker (gray truck)
  BitmapDescriptor get closedMarker =>
      _closedMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);

  /// Check if markers are loaded
  bool get isInitialized => _initialized;

  /// Dispose resources (if needed)
  void dispose() {
    _openMarker = null;
    _movingMarker = null;
    _closedMarker = null;
    _initialized = false;
  }
}
