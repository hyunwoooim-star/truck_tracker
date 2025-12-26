import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constants/marker_colors.dart';
import '../../../core/utils/app_logger.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';

class TruckMapScreen extends ConsumerStatefulWidget {
  const TruckMapScreen({
    super.key,
    this.initialTruckId,
    this.initialLatLng,
  });

  final String? initialTruckId;
  final LatLng? initialLatLng;

  @override
  ConsumerState<TruckMapScreen> createState() => _TruckMapScreenState();
}

class _TruckMapScreenState extends ConsumerState<TruckMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  // ✅ OPTIMIZATION: Cache markers to prevent rebuilding on every frame
  Set<Marker>? _cachedMarkers;
  List<dynamic>? _lastTruckList;

  // Get marker color from centralized MarkerColors
  static double _getMarkerHue(String foodType) => MarkerColors.getHue(foodType);

  @override
  Widget build(BuildContext context) {
    final trucksAsync = ref.watch(filteredTruckListProvider);

    AppLogger.debug('TruckMapScreen REBUILD at ${DateTime.now()}', tag: 'TruckMapScreen');
    AppLogger.debug('AsyncValue State: ${trucksAsync.runtimeType}', tag: 'TruckMapScreen');

    trucksAsync.when(
      data: (trucks) => AppLogger.debug('Data received: ${trucks.length} trucks', tag: 'TruckMapScreen'),
      loading: () => AppLogger.debug('Loading...', tag: 'TruckMapScreen'),
      error: (e, s) => AppLogger.error('AsyncValue error', error: e, tag: 'TruckMapScreen'),
    );

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodTruckMap),
      ),
      body: trucksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          AppLogger.error('CRITICAL ERROR IN TRUCKMAP SCREEN', error: error, stackTrace: stack, tag: 'TruckMapScreen');
          AppLogger.error('Error Type: ${error.runtimeType}', tag: 'TruckMapScreen');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(l10n.cannotLoadMap,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '$error',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Force rebuild
                    ref.invalidate(filteredTruckListProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          );
        },
        data: (trucks) {
          AppLogger.debug('Received ${trucks.length} trucks from Firestore', tag: 'TruckMapScreen');

          // Log all trucks and their status
          for (final truck in trucks) {
            AppLogger.debug('Truck ${truck.id}: ${truck.foodType} - Status: ${truck.status.name} - Lat: ${truck.latitude}, Lng: ${truck.longitude}', tag: 'TruckMapScreen');
          }

          // Handle empty data
          if (trucks.isEmpty) {
            AppLogger.warning('No trucks received from Firestore!', tag: 'TruckMapScreen');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noTrucksAvailable,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(l10n.pleaseRetryLater,
                    style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(filteredTruckListProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.refresh),
                  ),
                ],
              ),
            );
          }
          
          // Filter out trucks with invalid coordinates (0,0)
          final validTrucks = trucks.where((truck) {
            final isValid = truck.latitude != 0.0 && truck.longitude != 0.0;
            if (!isValid) {
              AppLogger.warning('Truck ${truck.id} has invalid coordinates: ${truck.latitude}, ${truck.longitude}', tag: 'TruckMapScreen');
            }
            return isValid;
          }).toList();

          AppLogger.success('Valid trucks for map: ${validTrucks.length}', tag: 'TruckMapScreen');

          // Show which trucks are valid for map
          for (final truck in validTrucks) {
            AppLogger.debug('Valid for map: Truck ${truck.id} (${truck.foodType}) - ${truck.status.name}', tag: 'TruckMapScreen');
          }

          // Check if all trucks were filtered out
          if (validTrucks.isEmpty) {
            AppLogger.warning('All trucks have invalid coordinates!', tag: 'TruckMapScreen');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(l10n.trucksWithoutLocation,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(l10n.trucksLocationNotSet.replaceAll('{count}', '${trucks.length}'),
                    style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(filteredTruckListProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          // ✅ OPTIMIZATION: Only rebuild markers if truck list changed
          if (_lastTruckList != validTrucks) {
            _cachedMarkers = validTrucks.map((truck) {
              final position = LatLng(truck.latitude, truck.longitude);

              // Determine marker appearance based on status
              final markerAlpha = truck.status == TruckStatus.maintenance ? 0.3 : 1.0;

              AppLogger.debug('Creating marker for ${truck.id} (${truck.foodType}) at ${truck.latitude}, ${truck.longitude}, status: ${truck.status}', tag: 'TruckMapScreen');

              return Marker(
                markerId: MarkerId(truck.id),
                position: position,
                icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(truck.foodType)),
                alpha: markerAlpha, // Dim maintenance trucks
                infoWindow: InfoWindow(
                  title: '${truck.foodType} ${truck.status == TruckStatus.maintenance ? '(정비중)' : ''}',
                  snippet: truck.locationDescription,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TruckDetailScreen(truck: truck),
                    ),
                  );
                },
              );
            }).toSet();
            _lastTruckList = validTrucks;
            AppLogger.debug('Markers rebuilt: ${_cachedMarkers!.length}', tag: 'TruckMapScreen');
          } else {
            AppLogger.debug('Using cached markers: ${_cachedMarkers!.length}', tag: 'TruckMapScreen');
          }

          final markers = _cachedMarkers!;

          // Find first operating truck for initial camera position
          final operatingTrucks = validTrucks
              .where((t) => t.status == TruckStatus.onRoute || t.status == TruckStatus.resting)
              .toList();

          final initialPosition = _initialLatLng(validTrucks, widget.initialTruckId, widget.initialLatLng) ??
              (operatingTrucks.isNotEmpty
                  ? LatLng(operatingTrucks.first.latitude, operatingTrucks.first.longitude)
                  : (validTrucks.isNotEmpty
                      ? LatLng(validTrucks.first.latitude, validTrucks.first.longitude)
                      : const LatLng(37.5665, 126.9780))); // Default: Seoul City Hall

          AppLogger.debug('Initial camera position: $initialPosition', tag: 'TruckMapScreen');

          if (validTrucks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noTrucksAvailable,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.checkLater,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 🚀 OPTIMIZATION: RepaintBoundary prevents map from re-rendering on parent rebuilds
          return RepaintBoundary(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14,
              ),
              onMapCreated: (controller) async {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }

                // Auto-focus to first operating truck after map loads
                if (widget.initialTruckId == null && widget.initialLatLng == null && operatingTrucks.isNotEmpty) {
                  AppLogger.debug('Auto-focusing to first operating truck: ${operatingTrucks.first.id}', tag: 'TruckMapScreen');
                  await Future.delayed(const Duration(milliseconds: 500));
                  await controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(operatingTrucks.first.latitude, operatingTrucks.first.longitude),
                        zoom: 15,
                      ),
                    ),
                  );
                } else {
                  await _moveToTruck(widget.initialTruckId, widget.initialLatLng, validTrucks);
                }
              },
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: false,
            ),
          );
        },
      ),
    );
  }

  LatLng? _initialLatLng(List trucks, String? targetId, LatLng? targetLatLng) {
    if (targetLatLng != null) return targetLatLng;
    if (targetId == null) return null;

    // Use safe null-aware access instead of firstWhere with orElse
    final truck = trucks.cast<dynamic>()
        .where((t) => t.id == targetId)
        .firstOrNull;

    if (truck == null) return null;
    return LatLng(truck.latitude, truck.longitude);
  }

  Future<void> _moveToTruck(
      String? targetId, LatLng? targetLatLng, List trucks) async {
    if (targetId == null && targetLatLng == null) return;
    final controller = await _mapController.future;
    final target = targetLatLng ??
        _initialLatLng(trucks, targetId, null) ??
        const LatLng(37.5665, 126.9780);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15),
      ),
    );
  }

  @override
  void dispose() {
    // 🧹 CLEANUP: Dispose Google Map controller to prevent memory leaks
    _mapController.future.then((controller) => controller.dispose());
    super.dispose();
  }
}


