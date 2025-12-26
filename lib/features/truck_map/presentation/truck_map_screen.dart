import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // Enhanced color mapping helper based on food characteristics
  static double _getMarkerHue(String foodType) {
    // Categorize food types by color based on their characteristics:
    // Red (0°) - Spicy/Grilled foods
    // Orange (30°) - Warm/Sweet foods
    // Yellow (60°) - Light/Savory foods
    // Green (120°) - Fresh/Healthy foods
    // Cyan (180°) - Cool/Refreshing foods
    // Blue (240°) - Specialty/Premium foods
    // Magenta (300°) - Desserts/Sweets
    // Rose (330°) - Rich/Hearty foods
    
    final colorMap = {
      // Spicy/Grilled - Red
      '닭꼬치': BitmapDescriptor.hueRed, // 0° - Grilled chicken
      '불막창': BitmapDescriptor.hueRose, // 330° - Spicy grilled intestines
      
      // Warm/Sweet - Orange/Yellow
      '호떡': BitmapDescriptor.hueOrange, // 30° - Sweet pancake
      '붕어빵': BitmapDescriptor.hueYellow, // 60° - Fish-shaped pastry
      
      // Savory/Comfort - Yellow/Green
      '어묵': BitmapDescriptor.hueYellow, // 60° - Fish cake
      '옛날통닭': BitmapDescriptor.hueGreen, // 120° - Fried chicken
      
      // Specialty/Premium - Violet/Blue
      '심야라멘': BitmapDescriptor.hueViolet, // 270° - Late night ramen
      
      // Desserts - Magenta/Rose
      '크레페퀸': BitmapDescriptor.hueMagenta, // 300° - Crepe dessert
    };
    
    // Robust fallback: return Baemin Mint for any unmatched types
    return colorMap[foodType] ?? 175.0; // Baemin Mint (Cyan-ish)
  }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('푸드트럭 지도'),
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
                const Text('지도를 불러올 수 없습니다', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  label: const Text('다시 시도'),
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
                  const Text('현재 운영 중인 트럭이 없습니다', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('잠시 후 다시 시도해주세요', 
                    style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(filteredTruckListProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('새로고침'),
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
                  const Text('위치 정보가 없는 트럭들입니다', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('총 ${trucks.length}개 트럭의 위치가 설정되지 않았습니다', 
                    style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(filteredTruckListProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 시도'),
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '현재 운영 중인 트럭이 없습니다',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '나중에 다시 확인해주세요',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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


