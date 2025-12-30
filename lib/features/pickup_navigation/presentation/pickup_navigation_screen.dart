import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../data/directions_service.dart';
import '../domain/walking_route.dart';

/// 픽업 네비게이션 화면 (도보 경로 안내)
class PickupNavigationScreen extends ConsumerStatefulWidget {
  final String truckName;
  final String truckAddress;
  final double truckLat;
  final double truckLng;
  final String? orderId;

  const PickupNavigationScreen({
    super.key,
    required this.truckName,
    required this.truckAddress,
    required this.truckLat,
    required this.truckLng,
    this.orderId,
  });

  @override
  ConsumerState<PickupNavigationScreen> createState() => _PickupNavigationScreenState();
}

class _PickupNavigationScreenState extends ConsumerState<PickupNavigationScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  WalkingRoute? _route;
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStream;
  int _selectedStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeNavigation() async {
    // 위치 권한 확인
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }
    }

    // 현재 위치 가져오기
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // 경로 조회
      final service = ref.read(directionsServiceProvider);
      _route = await service.getWalkingRoute(
        originLat: _currentPosition!.latitude,
        originLng: _currentPosition!.longitude,
        destLat: widget.truckLat,
        destLng: widget.truckLng,
      );

      // 실시간 위치 추적 시작
      _startLocationTracking();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarHelper.showError(context, '위치를 가져올 수 없습니다');
      }
    }
  }

  void _startLocationTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10미터마다 업데이트
      ),
    ).listen((position) {
      setState(() => _currentPosition = position);
      _updateRoute(position);
    });
  }

  Future<void> _updateRoute(Position position) async {
    final service = ref.read(directionsServiceProvider);
    final newRoute = await service.getWalkingRoute(
      originLat: position.latitude,
      originLng: position.longitude,
      destLat: widget.truckLat,
      destLng: widget.truckLng,
    );

    if (newRoute != null && mounted) {
      setState(() => _route = newRoute);
    }
  }

  void _centerOnUser() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _fitBounds() {
    if (_currentPosition == null || _mapController == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        _currentPosition!.latitude < widget.truckLat
            ? _currentPosition!.latitude
            : widget.truckLat,
        _currentPosition!.longitude < widget.truckLng
            ? _currentPosition!.longitude
            : widget.truckLng,
      ),
      northeast: LatLng(
        _currentPosition!.latitude > widget.truckLat
            ? _currentPosition!.latitude
            : widget.truckLat,
        _currentPosition!.longitude > widget.truckLng
            ? _currentPosition!.longitude
            : widget.truckLng,
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  Future<void> _openExternalMaps() async {
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${widget.truckLat},${widget.truckLng}'
      '&travelmode=walking',
    );

    try {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '지도 앱을 열 수 없습니다');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoalDark,
      appBar: AppBar(
        backgroundColor: AppTheme.charcoalDark,
        title: const Text('픽업 경로 안내'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: '외부 지도 앱 열기',
            onPressed: _openExternalMaps,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.electricBlue),
            )
          : _currentPosition == null
              ? _buildLocationDisabled()
              : _buildNavigationView(),
    );
  }

  Widget _buildLocationDisabled() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              '위치 권한이 필요합니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '트럭까지의 경로를 안내하려면\n위치 권한을 허용해주세요',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Geolocator.openAppSettings(),
              icon: const Icon(Icons.settings),
              label: const Text('설정 열기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _openExternalMaps,
              child: const Text('외부 지도 앱으로 열기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationView() {
    return Column(
      children: [
        // ETA Header
        _buildEtaHeader(),

        // Map
        Expanded(
          flex: 3,
          child: _buildMap(),
        ),

        // Route Steps
        if (_route != null && _route!.steps.isNotEmpty)
          Expanded(
            flex: 2,
            child: _buildRouteSteps(),
          ),
      ],
    );
  }

  Widget _buildEtaHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ETA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.electricBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_walk,
              color: AppTheme.electricBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _route != null ? '도보 ${_route!.durationText}' : '계산 중...',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.electricBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _route?.distanceText ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: AppTheme.textTertiary)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.truckName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Recenter button
          IconButton(
            onPressed: _fitBounds,
            icon: const Icon(Icons.zoom_out_map, color: AppTheme.textSecondary),
          ),
          IconButton(
            onPressed: _centerOnUser,
            icon: const Icon(Icons.my_location, color: AppTheme.electricBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final markers = <Marker>{
      // Truck marker
      Marker(
        markerId: const MarkerId('truck'),
        position: LatLng(widget.truckLat, widget.truckLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: widget.truckName),
      ),
      // User marker
      if (_currentPosition != null)
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: '현재 위치'),
        ),
    };

    final polylines = <Polyline>{};
    if (_route != null) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _route!.googleMapsPolyline,
          color: AppTheme.electricBlue,
          width: 5,
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : LatLng(widget.truckLat, widget.truckLng),
        zoom: 15,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        Future.delayed(const Duration(milliseconds: 500), _fitBounds);
      },
      markers: markers,
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Widget _buildRouteSteps() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.charcoalLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Steps header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.list, color: AppTheme.textSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  '경로 안내 (${_route!.steps.length}단계)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Steps list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _route!.steps.length,
              itemBuilder: (context, index) {
                final step = _route!.steps[index];
                final isSelected = index == _selectedStepIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedStepIndex = index);
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(step.startLat, step.startLng),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.electricBlue.withValues(alpha: 0.2)
                          : AppTheme.charcoalLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.electricBlue
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Step number
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.electricBlue
                                : AppTheme.charcoalMedium,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.black
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Direction icon
                        _buildDirectionIcon(step.maneuver),
                        const SizedBox(width: 12),
                        // Instruction
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.instruction,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? AppTheme.textPrimary
                                      : AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${step.distanceText} • ${step.durationText}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionIcon(String? maneuver) {
    IconData icon;
    switch (maneuver) {
      case 'turn-left':
        icon = Icons.turn_left;
        break;
      case 'turn-right':
        icon = Icons.turn_right;
        break;
      case 'turn-slight-left':
        icon = Icons.turn_slight_left;
        break;
      case 'turn-slight-right':
        icon = Icons.turn_slight_right;
        break;
      case 'turn-sharp-left':
        icon = Icons.turn_sharp_left;
        break;
      case 'turn-sharp-right':
        icon = Icons.turn_sharp_right;
        break;
      case 'uturn-left':
      case 'uturn-right':
        icon = Icons.u_turn_left;
        break;
      case 'straight':
        icon = Icons.straight;
        break;
      default:
        icon = Icons.arrow_forward;
    }

    return Icon(icon, color: AppTheme.textSecondary, size: 20);
  }
}
