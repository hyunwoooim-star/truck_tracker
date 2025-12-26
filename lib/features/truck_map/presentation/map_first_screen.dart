import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/food_types.dart';
import '../../../core/themes/app_theme.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/presentation/truck_provider.dart';

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

  static const double _minSheetSize = 0.1; // Collapsed: 10%
  static const double _halfSheetSize = 0.4; // Half: 40%
  static const double _maxSheetSize = 0.85; // Full: 85%

  double _currentSheetSize = _halfSheetSize;

  // ✅ OPTIMIZATION: Cache markers to prevent rebuilding on every frame
  Set<Marker>? _cachedMarkers;
  List<dynamic>? _lastTruckList;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
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

  static double _getMarkerHue(String foodType) {
    final colorMap = {
      '닭꼬치': BitmapDescriptor.hueRed,
      '불막창': BitmapDescriptor.hueRose,
      '호떡': BitmapDescriptor.hueOrange,
      '붕어빵': BitmapDescriptor.hueYellow,
      '어묵': BitmapDescriptor.hueYellow,
      '옛날통닭': BitmapDescriptor.hueGreen,
      '심야라멘': BitmapDescriptor.hueViolet,
      '크레페퀸': BitmapDescriptor.hueMagenta,
    };
    return colorMap[foodType] ?? 175.0;
  }

  @override
  Widget build(BuildContext context) {
    final trucksAsync = ref.watch(filteredTruckListProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Base: Google Map (Full Screen)
          trucksAsync.when(
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
            data: (trucks) {
              final validTrucks = trucks
                  .where((t) => t.latitude != 0.0 && t.longitude != 0.0)
                  .toList();

              if (validTrucks.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          size: 64, color: AppTheme.textTertiary),
                      SizedBox(height: 16),
                      Text('현재 운영 중인 트럭이 없습니다',
                          style: TextStyle(
                              fontSize: 18, color: AppTheme.textSecondary)),
                    ],
                  ),
                );
              }

              // ✅ OPTIMIZATION: Only rebuild markers if truck list changed
              if (_lastTruckList != validTrucks) {
                _cachedMarkers = validTrucks.map((truck) {
                  return Marker(
                    markerId: MarkerId(truck.id),
                    position: LatLng(truck.latitude, truck.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        _getMarkerHue(truck.foodType)),
                    alpha: truck.status == TruckStatus.maintenance ? 0.3 : 1.0,
                    infoWindow: InfoWindow(
                      title: truck.foodType,
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

                    // Filter Tags (Fixed)
                    const _FilterBar(),

                    const Divider(height: 1, color: AppTheme.charcoalLight),

                    // Truck List (Scrollable)
                    Expanded(
                      child: trucksAsync.when(
                        loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme.mustardYellow)),
                        error: (e, _) => Center(
                          child: Text('데이터를 불러올 수 없습니다',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        data: (trucks) {
                          if (trucks.isEmpty) {
                            return const Center(
                              child: Text('트럭이 없습니다',
                                  style:
                                      TextStyle(color: AppTheme.textSecondary)),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            itemCount: trucks.length,
                            itemExtent: 100.0, // ✅ OPTIMIZATION: Fixed height for better scroll performance
                            itemBuilder: (context, index) {
                              final truck = trucks[index];
                              return _TruckCard(truck: truck);
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
        ],
      ),
    );
  }
}

class _TruckCard extends StatelessWidget {
  const _TruckCard({required this.truck});

  final Truck truck;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TruckDetailScreen(truck: truck),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.charcoalMedium,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.charcoalLight, width: 1),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: truck.imageUrl,
                  width: 72,
                  height: 72,
                  maxHeightDiskCache: 150,  // 🚀 OPTIMIZATION: Limit cached image size
                  maxWidthDiskCache: 150,   // 🚀 OPTIMIZATION: Limit cached image size
                  memCacheHeight: 150,      // 🚀 OPTIMIZATION: Limit memory cache size
                  memCacheWidth: 150,       // 🚀 OPTIMIZATION: Limit memory cache size
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 72,
                    height: 72,
                    color: AppTheme.charcoalLight,
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.mustardYellow,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 72,
                    height: 72,
                    color: AppTheme.charcoalLight,
                    child: const Icon(Icons.local_shipping_outlined,
                        color: AppTheme.textTertiary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            truck.truckNumber,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _StatusTag(status: truck.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(truck.driverName,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.restaurant,
                            size: 16, color: AppTheme.mustardYellow),
                        const SizedBox(width: 4),
                        Text(truck.foodType,
                            style: const TextStyle(
                                color: AppTheme.mustardYellow,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Icon(Icons.location_on,
                            size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            truck.locationDescription,
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final TruckStatus status;

  String get _label {
    switch (status) {
      case TruckStatus.onRoute:
        return '운행 중';
      case TruckStatus.resting:
        return '대기';
      case TruckStatus.maintenance:
        return '점검';
    }
  }

  Color get _bgColor {
    switch (status) {
      case TruckStatus.onRoute:
        return AppTheme.mustardYellow15;
      case TruckStatus.resting:
        return AppTheme.textTertiary15;
      case TruckStatus.maintenance:
        return AppTheme.orange15;
    }
  }

  Color get _textColor {
    switch (status) {
      case TruckStatus.onRoute:
        return AppTheme.mustardYellow;
      case TruckStatus.resting:
        return AppTheme.textSecondary;
      case TruckStatus.maintenance:
        return const Color(0xFFFF9800);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTag = ref.watch(truckFilterNotifierProvider).selectedTag;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                    fontSize: 14,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(truckFilterNotifierProvider.notifier)
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                labelPadding: const EdgeInsets.symmetric(horizontal: 12),
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
    final searchKeyword = ref.watch(truckFilterNotifierProvider).searchKeyword;

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
          hintText: '트럭 검색',
          hintStyle: const TextStyle(color: AppTheme.textTertiary),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
          suffixIcon: searchKeyword.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textTertiary),
                  onPressed: () {
                    _controller.clear();
                    ref
                        .read(truckFilterNotifierProvider.notifier)
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
          ref.read(truckFilterNotifierProvider.notifier).setSearchKeyword(value);
        },
      ),
    );
  }
}
