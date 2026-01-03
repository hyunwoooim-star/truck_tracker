import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../core/constants/food_types.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../services/marker_service.dart';
import '../../../shared/widgets/toss_card.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/domain/truck_with_distance.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../chat/presentation/chat_list_screen.dart';
import '../../customer/presentation/my_coupons_screen.dart';
import '../../favorite/presentation/favorites_screen.dart';
import '../../settings/presentation/app_settings_screen.dart';
import '../../settings/presentation/my_reviews_screen.dart';
import '../../owner_dashboard/presentation/owner_dashboard_screen.dart';
import '../../location/presentation/location_provider.dart';

/// Map-First Screen with 3-tier DraggableScrollableSheet
/// Street Tycoon Architecture
class MapFirstScreen extends ConsumerStatefulWidget {
  const MapFirstScreen({super.key});

  @override
  ConsumerState<MapFirstScreen> createState() => _MapFirstScreenState();
}

class _MapFirstScreenState extends ConsumerState<MapFirstScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final MarkerService _markerService = MarkerService();

  static const double _minSheetSize = 0.1; // Collapsed: 10%
  static const double _halfSheetSize = 0.4; // Half: 40%
  static const double _maxSheetSize = 0.85; // Full: 85%

  double _currentSheetSize = _halfSheetSize;

  // ✅ OPTIMIZATION: Cache markers to prevent rebuilding on every frame
  Set<Marker>? _cachedMarkers;
  List<dynamic>? _lastTruckList;
  bool _markersInitialized = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
    _initializeMarkers();
  }

  Future<void> _initializeMarkers() async {
    await _markerService.initialize();
    if (mounted) {
      setState(() {
        _markersInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (_sheetController.isAttached) {
      setState(() {
        _currentSheetSize = _sheetController.size;
      });
    }
  }

  void _animateSheetToSize(double size) {
    _sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final trucksWithDistanceAsync = ref.watch(filteredTrucksWithDistanceProvider);
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    // PC 웹: 900px 이상이면 가로 레이아웃 (지도 + 리스트 나란히)
    final isWideScreen = screenWidth >= 900;

    if (isWideScreen) {
      return _buildWideLayout(context, trucksWithDistanceAsync, l10n);
    }

    // 모바일/태블릿: 기존 DraggableSheet 레이아웃
    return Scaffold(
      body: Stack(
        children: [
          // Base: Google Map (Full Screen)
          trucksWithDistanceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('$error',
                      style: const TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
            data: (trucksWithDistance) {
              final validTrucksWithDistance = trucksWithDistance
                  .where((t) => t.truck.latitude != 0.0 && t.truck.longitude != 0.0)
                  .toList();

              if (validTrucksWithDistance.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 64, color: AppTheme.textTertiary),
                      const SizedBox(height: 16),
                      Text(l10n.noTrucksAvailable,
                          style: const TextStyle(
                              fontSize: 18, color: AppTheme.textSecondary)),
                    ],
                  ),
                );
              }

              // Extract trucks for markers
              final validTrucks = validTrucksWithDistance.map((t) => t.truck).toList();

              // ✅ OPTIMIZATION: Only rebuild markers if truck list changed or markers initialized
              if (_lastTruckList != validTrucks || (_markersInitialized && _cachedMarkers == null)) {
                _cachedMarkers = validTrucks.map((truck) {
                  // Get custom truck marker based on status
                  final markerIcon = _markerService.getMarkerForTruck(truck);

                  // Status text for info window
                  String statusText = '';
                  switch (truck.status) {
                    case TruckStatus.onRoute:
                      statusText = ' 🚚 이동중';
                      break;
                    case TruckStatus.resting:
                      statusText = ' ✨ 영업중';
                      break;
                    case TruckStatus.maintenance:
                      statusText = ' 🔧 정비중';
                      break;
                  }

                  return Marker(
                    markerId: MarkerId(truck.id),
                    position: LatLng(truck.latitude, truck.longitude),
                    icon: markerIcon,
                    infoWindow: InfoWindow(
                      title: '${truck.foodType}$statusText',
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
              }

              final markers = _cachedMarkers!;

              final initialPosition = validTrucks.isNotEmpty
                  ? LatLng(validTrucks.first.latitude,
                      validTrucks.first.longitude)
                  : const LatLng(37.5665, 126.9780);

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
                  }
                },
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: false,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height *
                      _currentSheetSize *
                      0.9,
                ),
              );
            },
          ),

          // Owner Verification Status Banner
          _OwnerVerificationBanner(),

          // 3-Tier DraggableScrollableSheet
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _halfSheetSize,
            minChildSize: _minSheetSize,
            maxChildSize: _maxSheetSize,
            snap: true,
            snapSizes: const [_minSheetSize, _halfSheetSize, _maxSheetSize],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.midnightCharcoal,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    GestureDetector(
                      onTap: () {
                        if (_currentSheetSize < _halfSheetSize) {
                          _animateSheetToSize(_halfSheetSize);
                        } else if (_currentSheetSize < _maxSheetSize) {
                          _animateSheetToSize(_maxSheetSize);
                        } else {
                          _animateSheetToSize(_minSheetSize);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.mustardYellow,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Search Bar (Fixed)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: _SearchBar(),
                    ),

                    // Sort Options (거리순/인기순)
                    const _SortOptionsBar(),

                    // Filter Tags (Fixed)
                    const _FilterBar(),

                    const Divider(height: 1, color: AppTheme.charcoalLight),

                    // Truck List (Scrollable) - Toss Style
                    Expanded(
                      child: trucksWithDistanceAsync.when(
                        loading: () => ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: 5,
                          itemBuilder: (context, index) => const _SkeletonTruckCard(),
                        ),
                        error: (e, _) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 48, color: AppTheme.tossGray500),
                              const SizedBox(height: 12),
                              Text(
                                l10n.loadDataFailed,
                                style: TextStyle(color: AppTheme.tossGray500),
                              ),
                            ],
                          ),
                        ),
                        data: (trucksWithDistance) {
                          if (trucksWithDistance.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_shipping_outlined, size: 56, color: AppTheme.tossGray600),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.noTrucks,
                                    style: TextStyle(
                                      color: AppTheme.tossGray500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            itemCount: trucksWithDistance.length,
                            itemBuilder: (context, index) {
                              final truckWithDistance = trucksWithDistance[index];
                              // Staggered animation (50ms delay per item)
                              return _AnimatedTruckCard(
                                index: index,
                                child: _TruckCard(truckWithDistance: truckWithDistance),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 👋 Top-left greeting card with nickname
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Consumer(
              builder: (context, ref, child) {
                final nicknameAsync = ref.watch(currentUserNicknameProvider);
                return nicknameAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (nickname) {
                    if (nickname == null || nickname.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Material(
                      color: AppTheme.charcoalMedium95,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 8,
                      shadowColor: AppTheme.black50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.waving_hand,
                              color: AppTheme.mustardYellow,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$nickname님 안녕하세요!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🔄 Top-right menu button (hamburger style) - 역할별 메뉴
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: _RoleBasedMenuButton(),
          ),

          // 🎯 Custom "내 위치" button (웹에서 기본 myLocationButton 작동 안 해서 추가)
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * _currentSheetSize + 16,
            child: Material(
              color: AppTheme.charcoalMedium95,
              borderRadius: BorderRadius.circular(12),
              elevation: 8,
              shadowColor: AppTheme.black50,
              child: InkWell(
                onTap: () async {
                  try {
                    final position = await ref.read(currentPositionProvider.future);
                    if (position != null) {
                      final controller = await _mapController.future;
                      await controller.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(position.latitude, position.longitude),
                          16,
                        ),
                      );
                    } else {
                      if (context.mounted) {
                        SnackBarHelper.showWarning(context, '위치를 가져올 수 없습니다');
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      SnackBarHelper.showError(context, '위치 권한이 필요합니다');
                    }
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: AppTheme.mustardYellow,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PC 웹용 가로 레이아웃 (지도 왼쪽 + 트럭 리스트 오른쪽)
  Widget _buildWideLayout(
    BuildContext context,
    AsyncValue<List<TruckWithDistance>> trucksWithDistanceAsync,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      body: Row(
        children: [
          // 왼쪽: 지도 (60%)
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                trucksWithDistanceAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('$error', style: const TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                  data: (trucksWithDistance) {
                    final validTrucks = trucksWithDistance
                        .where((t) => t.truck.latitude != 0.0 && t.truck.longitude != 0.0)
                        .map((t) => t.truck)
                        .toList();

                    if (validTrucks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_shipping_outlined, size: 64, color: AppTheme.textTertiary),
                            const SizedBox(height: 16),
                            Text(l10n.noTrucksAvailable, style: const TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
                          ],
                        ),
                      );
                    }

                    // Rebuild markers if needed
                    if (_lastTruckList != validTrucks || (_markersInitialized && _cachedMarkers == null)) {
                      _cachedMarkers = validTrucks.map((truck) {
                        final markerIcon = _markerService.getMarkerForTruck(truck);
                        String statusText = '';
                        switch (truck.status) {
                          case TruckStatus.onRoute:
                            statusText = ' 🚚 이동중';
                            break;
                          case TruckStatus.resting:
                            statusText = ' ✨ 영업중';
                            break;
                          case TruckStatus.maintenance:
                            statusText = ' 🔧 정비중';
                            break;
                        }
                        return Marker(
                          markerId: MarkerId(truck.id),
                          position: LatLng(truck.latitude, truck.longitude),
                          icon: markerIcon,
                          infoWindow: InfoWindow(
                            title: '${truck.foodType}$statusText',
                            snippet: truck.locationDescription,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TruckDetailScreen(truck: truck)),
                            );
                          },
                        );
                      }).toSet();
                      _lastTruckList = validTrucks;
                    }

                    final initialPosition = validTrucks.isNotEmpty
                        ? LatLng(validTrucks.first.latitude, validTrucks.first.longitude)
                        : const LatLng(37.5665, 126.9780);

                    return GoogleMap(
                      initialCameraPosition: CameraPosition(target: initialPosition, zoom: 14),
                      onMapCreated: (controller) {
                        if (!_mapController.isCompleted) {
                          _mapController.complete(controller);
                        }
                      },
                      markers: _cachedMarkers ?? {},
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      compassEnabled: true,
                      mapToolbarEnabled: false,
                    );
                  },
                ),

                // 왼쪽 상단: 인사말
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final nicknameAsync = ref.watch(currentUserNicknameProvider);
                      return nicknameAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (nickname) {
                          if (nickname == null || nickname.isEmpty) return const SizedBox.shrink();
                          return Material(
                            color: AppTheme.charcoalMedium95,
                            borderRadius: BorderRadius.circular(12),
                            elevation: 8,
                            shadowColor: AppTheme.black50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.waving_hand, color: AppTheme.mustardYellow, size: 18),
                                  const SizedBox(width: 8),
                                  Text('$nickname님 안녕하세요!', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // 내 위치 버튼
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Material(
                    color: AppTheme.charcoalMedium95,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 8,
                    shadowColor: AppTheme.black50,
                    child: InkWell(
                      onTap: () async {
                        try {
                          final position = await ref.read(currentPositionProvider.future);
                          if (position != null) {
                            final controller = await _mapController.future;
                            await controller.animateCamera(
                              CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 16),
                            );
                          } else if (context.mounted) {
                            SnackBarHelper.showWarning(context, '위치를 가져올 수 없습니다');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            SnackBarHelper.showError(context, '위치 권한이 필요합니다');
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.my_location, color: AppTheme.mustardYellow, size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 오른쪽: 트럭 리스트 (40%, 최대 450px)
          Container(
            width: 400,
            constraints: const BoxConstraints(maxWidth: 450),
            decoration: const BoxDecoration(
              color: AppTheme.midnightCharcoal,
              border: Border(left: BorderSide(color: AppTheme.charcoalLight, width: 1)),
            ),
            child: Column(
              children: [
                // 상단 메뉴 버튼
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '주변 트럭',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _RoleBasedMenuButton(isCompact: true),
                    ],
                  ),
                ),

                // 검색바
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _SearchBar(),
                ),

                // 정렬 옵션
                const _SortOptionsBar(),

                // 필터 태그
                const _FilterBar(),

                const Divider(height: 1, color: AppTheme.charcoalLight),

                // 트럭 리스트
                Expanded(
                  child: trucksWithDistanceAsync.when(
                    loading: () => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: 5,
                      itemBuilder: (context, index) => const _SkeletonTruckCard(),
                    ),
                    error: (e, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: AppTheme.tossGray500),
                          const SizedBox(height: 12),
                          Text(l10n.loadDataFailed, style: TextStyle(color: AppTheme.tossGray500)),
                        ],
                      ),
                    ),
                    data: (trucksWithDistance) {
                      if (trucksWithDistance.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_shipping_outlined, size: 56, color: AppTheme.tossGray600),
                              const SizedBox(height: 12),
                              Text(l10n.noTrucks, style: TextStyle(color: AppTheme.tossGray500, fontSize: 15)),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: trucksWithDistance.length,
                        itemBuilder: (context, index) {
                          return _AnimatedTruckCard(
                            index: index,
                            child: _TruckCard(truckWithDistance: trucksWithDistance[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

/// 토스 스타일 트럭 카드 (탭 애니메이션 + 부드러운 그림자)
class _TruckCard extends StatelessWidget {
  const _TruckCard({required this.truckWithDistance});

  final TruckWithDistance truckWithDistance;

  @override
  Widget build(BuildContext context) {
    final truck = truckWithDistance.truck;
    final hasDistance = truckWithDistance.distanceInMeters != double.infinity;

    // 상태에 따른 TossStatusTag 선택
    Widget statusTag;
    switch (truck.status) {
      case TruckStatus.onRoute:
        statusTag = TossStatusTag.open(label: '운행중');
        break;
      case TruckStatus.resting:
        statusTag = TossStatusTag.resting(label: '대기중');
        break;
      case TruckStatus.maintenance:
        statusTag = TossStatusTag.maintenance(label: '점검중');
        break;
    }

    return TossTruckCard(
      imageUrl: truck.imageUrl,
      name: truck.truckNumber,
      foodType: truck.foodType,
      statusWidget: statusTag,
      distance: hasDistance ? truckWithDistance.distanceText : null,
      location: truck.locationDescription,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TruckDetailScreen(truck: truck),
          ),
        );
      },
      imageBuilder: (url) => CachedNetworkImage(
        imageUrl: url,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        memCacheHeight: 120,
        memCacheWidth: 120,
        placeholder: (context, url) => Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.tossGray800,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.tossBlue,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.tossGray800,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: AppTheme.tossGray500,
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// Sort options bar (거리순/이름순/평점순)
class _SortOptionsBar extends ConsumerWidget {
  const _SortOptionsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            '정렬',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: '거리순',
            icon: Icons.near_me,
            isSelected: currentSort == SortOption.distance,
            onTap: () => ref.read(sortOptionProvider.notifier).setSortOption(SortOption.distance),
          ),
          const SizedBox(width: 6),
          _SortChip(
            label: '이름순',
            icon: Icons.sort_by_alpha,
            isSelected: currentSort == SortOption.name,
            onTap: () => ref.read(sortOptionProvider.notifier).setSortOption(SortOption.name),
          ),
          const SizedBox(width: 6),
          _SortChip(
            label: '평점순',
            icon: Icons.star,
            isSelected: currentSort == SortOption.rating,
            onTap: () => ref.read(sortOptionProvider.notifier).setSortOption(SortOption.rating),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.mustardYellow : AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.mustardYellow : AppTheme.charcoalLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.black : AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTag = ref.watch(truckFilterProvider).selectedTag;

    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: FoodTypes.filterTags.map((tag) {
            final isSelected = tag == selectedTag;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(truckFilterProvider.notifier)
                        .setSelectedTag(tag);
                  }
                },
                selectedColor: AppTheme.mustardYellow,
                backgroundColor: AppTheme.charcoalMedium,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.mustardYellow
                      : AppTheme.charcoalLight,
                  width: 1.5,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                pressElevation: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(truckFilterProvider).searchKeyword;
    final l10n = AppLocalizations.of(context);

    if (_controller.text != searchKeyword) {
      _controller.text = searchKeyword;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.charcoalLight, width: 1),
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: l10n.searchTrucks,
          hintStyle: const TextStyle(color: AppTheme.textTertiary),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
          suffixIcon: searchKeyword.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textTertiary),
                  onPressed: () {
                    _controller.clear();
                    ref
                        .read(truckFilterProvider.notifier)
                        .setSearchKeyword('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppTheme.charcoalMedium,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onChanged: (value) {
          ref.read(truckFilterProvider.notifier).setSearchKeyword(value);
        },
      ),
    );
  }
}

/// Owner Verification Status Banner
/// Shows pending/rejected status for users who applied for owner verification
class _OwnerVerificationBanner extends ConsumerWidget {
  const _OwnerVerificationBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    if (!isAuthenticated) return const SizedBox.shrink();

    final requestStatusAsync = ref.watch(ownerRequestStatusProvider);

    return requestStatusAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
      data: (requestData) {
        if (requestData == null) return const SizedBox.shrink();

        final status = requestData['status'] as String?;
        if (status == null || status == 'approved') return const SizedBox.shrink();

        return Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: _buildBanner(context, ref, status, requestData),
        );
      },
    );
  }

  Widget _buildBanner(
    BuildContext context,
    WidgetRef ref,
    String status,
    Map<String, dynamic> requestData,
  ) {
    final isPending = status == 'pending';
    final rejectionReason = requestData['rejectionReason'] as String?;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPending
              ? Colors.orange.withValues(alpha: 0.9)
              : Colors.red.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isPending ? Icons.hourglass_empty : Icons.cancel_outlined,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isPending ? '사장님 인증 대기 중' : '사장님 인증 거절됨',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPending
                        ? '승인 후 사장님 기능을 사용할 수 있습니다'
                        : rejectionReason ?? '사유 미기재',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!isPending)
              TextButton(
                onPressed: () => _showReapplyDialog(context, ref),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('재신청'),
              ),
          ],
        ),
      ),
    );
  }

  void _showReapplyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: const Text(
          '사장님 인증 재신청',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '새로운 사업자등록증을 업로드하여 인증을 다시 신청하시겠습니까?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '취소',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToReapply(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mustardYellow,
              foregroundColor: Colors.black,
            ),
            child: const Text('재신청하기'),
          ),
        ],
      ),
    );
  }

  void _navigateToReapply(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _ReapplyScreen(),
      ),
    );
  }
}

/// Re-apply screen for rejected owner requests
class _ReapplyScreen extends ConsumerStatefulWidget {
  const _ReapplyScreen();

  @override
  ConsumerState<_ReapplyScreen> createState() => _ReapplyScreenState();
}

class _ReapplyScreenState extends ConsumerState<_ReapplyScreen> {
  String? _businessLicenseImagePath;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _businessLicenseImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '이미지 선택에 실패했습니다');
      }
    }
  }

  Future<void> _submitReapply() async {
    if (_businessLicenseImagePath == null) {
      SnackBarHelper.showWarning(context, '사업자등록증을 업로드해주세요');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUserId;

      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      await authService.submitOwnerRequestWithImage(userId, _businessLicenseImagePath!);

      // Refresh the status
      ref.invalidate(ownerRequestStatusProvider);

      if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showSuccess(context, '재신청이 접수되었습니다');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '재신청 실패: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoalDark,
      appBar: AppBar(
        title: const Text('사장님 인증 재신청'),
        backgroundColor: AppTheme.charcoalMedium,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '새로운 사업자등록증을 업로드해주세요',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '관리자 검토 후 승인 여부가 결정됩니다',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            // Image upload area
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _businessLicenseImagePath != null
                      ? Colors.green
                      : const Color(0xFF1E1E1E),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _businessLicenseImagePath != null
                          ? Icons.check_circle
                          : Icons.upload_file,
                      color: _businessLicenseImagePath != null
                          ? Colors.green
                          : const Color(0xFFB0B0B0),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _businessLicenseImagePath != null
                          ? '사업자등록증 선택됨'
                          : '탭하여 이미지 선택',
                      style: TextStyle(
                        color: _businessLicenseImagePath != null
                            ? Colors.green
                            : const Color(0xFFB0B0B0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReapply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mustardYellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  : const Text(
                      '재신청 제출',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 토스 스타일 스켈레톤 트럭 카드 (로딩 시 표시)
class _SkeletonTruckCard extends StatelessWidget {
  const _SkeletonTruckCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.tossGray900,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.tossShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 이미지 스켈레톤
          const SkeletonBox(width: 56, height: 56, borderRadius: 14),
          const SizedBox(width: 14),
          // 텍스트 스켈레톤
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: SkeletonLine(width: 100, height: 15)),
                    const SizedBox(width: 8),
                    const SkeletonBox(width: 50, height: 22, borderRadius: 6),
                  ],
                ),
                const SizedBox(height: 6),
                const SkeletonLine(width: 70, height: 13),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SkeletonBox(width: 55, height: 12, borderRadius: 4),
                    const SizedBox(width: 10),
                    const Expanded(child: SkeletonLine(width: 100, height: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 토스 스타일 Staggered 애니메이션 래퍼
class _AnimatedTruckCard extends StatefulWidget {
  const _AnimatedTruckCard({
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<_AnimatedTruckCard> createState() => _AnimatedTruckCardState();
}

class _AnimatedTruckCardState extends State<_AnimatedTruckCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Staggered delay: 50ms per item (max 5 items = 250ms)
    final delay = Duration(milliseconds: (widget.index.clamp(0, 5)) * 50);
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// 역할 기반 햄버거 메뉴 버튼
/// - 사장님: 대시보드, 채팅, 설정, 로그아웃
/// - 손님: 즐겨찾기, 내 리뷰, 내 쿠폰함, 채팅, 설정, 로그아웃
class _RoleBasedMenuButton extends ConsumerWidget {
  const _RoleBasedMenuButton({this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentUserRoleProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Material(
      color: isCompact ? AppTheme.charcoalMedium : AppTheme.charcoalMedium95,
      borderRadius: BorderRadius.circular(12),
      elevation: isCompact ? 0 : 10,
      shadowColor: AppTheme.black50,
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.menu,
          color: AppTheme.mustardYellow,
          size: isCompact ? 24 : 28,
        ),
        color: AppTheme.charcoalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        offset: const Offset(0, 50),
        onSelected: (value) => _handleMenuSelection(context, ref, value),
        itemBuilder: (context) {
          return roleAsync.when(
            data: (role) => _buildMenuItems(role, user != null),
            loading: () => _buildMenuItems('customer', user != null),
            error: (_, __) => _buildMenuItems('customer', user != null),
          );
        },
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'dashboard':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
        );
        break;
      case 'favorites':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
        break;
      case 'reviews':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyReviewsScreen()),
        );
        break;
      case 'coupons':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyCouponsScreen()),
        );
        break;
      case 'chat':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatListScreen()),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppSettingsScreen()),
        );
        break;
      case 'logout':
        _showLogoutDialog(context, ref);
        break;
    }
  }

  List<PopupMenuEntry<String>> _buildMenuItems(String role, bool isLoggedIn) {
    final items = <PopupMenuEntry<String>>[];

    if (role == 'owner' || role == 'admin') {
      // 사장님/관리자 메뉴
      items.add(_buildMenuItem(
        value: 'dashboard',
        icon: Icons.dashboard_outlined,
        label: '사장님 대시보드',
        iconColor: Colors.green,
      ));
    } else {
      // 손님 메뉴
      if (isLoggedIn) {
        items.add(_buildMenuItem(
          value: 'favorites',
          icon: Icons.favorite_outline,
          label: '즐겨찾기',
          iconColor: Colors.pink,
        ));
        items.add(_buildMenuItem(
          value: 'reviews',
          icon: Icons.rate_review_outlined,
          label: '내 리뷰',
        ));
        items.add(_buildMenuItem(
          value: 'coupons',
          icon: Icons.card_giftcard,
          label: '내 쿠폰함',
          iconColor: Colors.orange,
        ));
      }
    }

    // 공통 메뉴
    if (isLoggedIn) {
      items.add(_buildMenuItem(
        value: 'chat',
        icon: Icons.chat_bubble_outline,
        label: '채팅',
      ));
    }

    items.add(_buildMenuItem(
      value: 'settings',
      icon: Icons.settings_outlined,
      label: '설정',
    ));

    if (isLoggedIn) {
      items.add(const PopupMenuDivider());
      items.add(_buildMenuItem(
        value: 'logout',
        icon: Icons.logout,
        label: '로그아웃',
        iconColor: Colors.red,
        textColor: Colors.red,
      ));
    }

    return items;
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? textColor,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppTheme.mustardYellow),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: textColor ?? Colors.white)),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Text(l10n.logout, style: const TextStyle(color: Colors.white)),
        content: Text(l10n.confirmLogout, style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Sign out from Firebase
              await ref.read(authServiceProvider).signOut();

              // Invalidate all user-specific providers
              ref.invalidate(currentUserTruckIdProvider);
              ref.invalidate(currentUserProvider);
              ref.invalidate(currentUserIdProvider);
              ref.invalidate(currentUserEmailProvider);

              // Navigate back to LoginScreen
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.logout, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
