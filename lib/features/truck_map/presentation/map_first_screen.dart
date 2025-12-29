import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../core/constants/food_types.dart';
import '../../../core/constants/marker_colors.dart';
import '../../../core/themes/app_theme.dart';
import '../../../shared/widgets/status_tag.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../chat/presentation/chat_list_screen.dart';
import '../../chat/presentation/chat_provider.dart';
import '../../notifications/presentation/notification_settings_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final trucksAsync = ref.watch(filteredTruckListProvider);
    final l10n = AppLocalizations.of(context);

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

              // ✅ OPTIMIZATION: Only rebuild markers if truck list changed
              if (_lastTruckList != validTrucks) {
                _cachedMarkers = validTrucks.map((truck) {
                  return Marker(
                    markerId: MarkerId(truck.id),
                    position: LatLng(truck.latitude, truck.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        MarkerColors.getHue(truck.foodType)),
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

                    // Search Bar + Logout Button (Fixed)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(child: _SearchBar()),
                          const SizedBox(width: 8),
                          // Logout Button
                          Material(
                            color: AppTheme.charcoalMedium,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _showLogoutDialog(context, ref),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          child: Text(l10n.loadDataFailed,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        data: (trucks) {
                          if (trucks.isEmpty) {
                            return Center(
                              child: Text(l10n.noTrucks,
                                  style:
                                      const TextStyle(color: AppTheme.textSecondary)),
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

          // 🔄 Notification, Chat and Logout buttons (top-right corner, always visible)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Row(
              children: [
                // Notification Settings Button
                Material(
                  color: AppTheme.charcoalMedium95,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 10,
                  shadowColor: AppTheme.black50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationSettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.mustardYellow,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Chat Button with unread badge
                Consumer(
                  builder: (context, ref, _) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return const SizedBox.shrink();

                    final unreadCountAsync = ref.watch(unreadChatCountProvider(user.uid));

                    return unreadCountAsync.when(
                      data: (unreadCount) => Material(
                        color: AppTheme.charcoalMedium95,
                        borderRadius: BorderRadius.circular(12),
                        elevation: 10,
                        shadowColor: AppTheme.black50,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline,
                                  color: AppTheme.mustardYellow,
                                  size: 24,
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Center(
                                        child: Text(
                                          unreadCount > 9 ? '9+' : '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Logout Button
                Material(
                  color: AppTheme.charcoalMedium95,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 10,
                  shadowColor: AppTheme.black50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showLogoutDialog(context, ref),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show logout confirmation dialog
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

              // 🔄 Invalidate all user-specific providers
              ref.invalidate(currentUserTruckIdProvider);
              ref.invalidate(currentUserProvider);
              ref.invalidate(currentUserIdProvider);
              ref.invalidate(currentUserEmailProvider);
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
                        StatusTag(status: truck.status),
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

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTag = ref.watch(truckFilterProvider).selectedTag;

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
