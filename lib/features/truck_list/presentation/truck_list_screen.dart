import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/constants/food_types.dart';
import '../../../core/themes/app_theme.dart';
import '../../../shared/widgets/status_tag.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../owner_dashboard/presentation/owner_dashboard_screen.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';
import '../../truck_map/presentation/truck_map_screen.dart';
import '../../checkin/presentation/customer_checkin_screen.dart';
import '../domain/truck.dart';
import 'truck_provider.dart';

class TruckListScreen extends ConsumerWidget {
  const TruckListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trucksAsync = ref.watch(filteredTruckListProvider);
    final topRankedAsync = ref.watch(topRankedTrucksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.truckList),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'QR Check-In',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CustomerCheckinScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const _AppDrawer(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _SearchBar(),
          ),
          // Filter Bar
          const _FilterBar(),
          // Truck List
          Expanded(
            child: trucksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, __) => Center(
                child: Text(
                  AppLocalizations.of(context)!.loadDataFailed,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              data: (trucks) {
                // Get top ranked trucks (sync or empty list if loading)
                final topRanked = topRankedAsync.valueOrNull ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  itemCount: trucks.length,
                  itemExtent: 180.0,  // Approximate card height for better scroll performance
                  itemBuilder: (context, index) {
                    final truck = trucks[index];

                    // Check if this truck is in Top 3
                    final rankIndex = topRanked.indexWhere((t) => t.id == truck.id);
                    final rank = rankIndex >= 0 ? rankIndex + 1 : null;

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
                            border: Border.all(
                              color: AppTheme.charcoalLight,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Truck image with ranking badge
                                Stack(
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
                                          alignment: Alignment.center,
                                          child: const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppTheme.electricBlue,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: 72,
                                          height: 72,
                                          color: AppTheme.charcoalLight,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.local_shipping_outlined,
                                            color: AppTheme.textTertiary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Ranking badge (Top 3)
                                    if (rank != null)
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFC107), // Mustard yellow
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.black30,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.workspace_premium,
                                                size: 14,
                                                color: Colors.black87,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                '#$rank',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  truck.truckNumber,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  truck.driverName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          StatusTag(status: truck.status),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => TruckMapScreen(
                                                    initialTruckId: truck.id,
                                                    initialLatLng: LatLng(
                                                      truck.latitude,
                                                      truck.longitude,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                              color: AppTheme.electricBlue,
                                            ),
                                            tooltip: '지도에서 보기',
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              final notifier = ref.read(
                                                  truckListNotifierProvider.notifier);
                                              try {
                                                await notifier.toggleFavorite(truck.id);
                                              } catch (_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: AppTheme.electricBlue,
                                                    content: Text(
                                                      AppLocalizations.of(context)!.favoriteFailed,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              truck.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: truck.isFavorite
                                                  ? AppTheme.electricBlue
                                                  : AppTheme.textTertiary,
                                            ),
                                            tooltip: '즐겨찾기',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '메뉴',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: AppTheme.textTertiary,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  truck.foodType,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        color: AppTheme.textPrimary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                truck.locationDescription,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: AppTheme.textSecondary,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '위치',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: AppTheme.textTertiary,
                                                    ),
                                              ),
                                            ],
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TruckMapScreen()),
          );
        },
        backgroundColor: AppTheme.electricBlue,
        foregroundColor: Colors.black,
        child: const Icon(Icons.map),
      ),
    );
  }
}

/// Horizontal scrolling filter bar with food type tags
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
                    ref.read(truckFilterNotifierProvider.notifier)
                        .setSelectedTag(tag);
                  }
                },
                selectedColor: AppTheme.electricBlue,
                backgroundColor: AppTheme.charcoalMedium,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.electricBlue
                      : AppTheme.charcoalLight,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

/// Search bar with rounded corners and subtle shadow
class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  late TextEditingController _controller;
  bool _isInitialized = false;

  // 🚀 OPTIMIZATION: Debounce search input to reduce excessive queries
  final _searchSubject = BehaviorSubject<String>();
  StreamSubscription<String>? _searchSubscription;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // 🚀 OPTIMIZATION: Set up debounced search with 500ms delay
    _searchSubscription = _searchSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .distinct() // Skip duplicate consecutive values
        .listen((searchQuery) {
      // Update filter only after user stops typing for 500ms
      ref.read(truckFilterNotifierProvider.notifier)
          .setSearchKeyword(searchQuery);
    });
  }

  @override
  void dispose() {
    _searchSubject.close();
    _searchSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(truckFilterNotifierProvider).searchKeyword;

    // Sync controller with state on first build
    if (!_isInitialized) {
      _controller.text = searchKeyword;
      _isInitialized = true;
    } else if (_controller.text != searchKeyword) {
      // Only update if changed externally (e.g., filter reset)
      _controller.text = searchKeyword;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.charcoalLight,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: '트럭 번호, 기사명, 메뉴, 위치로 검색',
          hintStyle: const TextStyle(color: AppTheme.textTertiary),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
          suffixIcon: searchKeyword.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textTertiary),
                  onPressed: () {
                    _controller.clear();
                    ref.read(truckFilterNotifierProvider.notifier)
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          // 🚀 OPTIMIZATION: Emit to debounced stream instead of direct update
          _searchSubject.add(value);
        },
      ),
    );
  }
}

// App Drawer with Boss Mode
class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.midnightCharcoal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.local_shipping,
                  size: 40,
                  color: AppTheme.electricBlue,
                ),
                const SizedBox(height: 16),
                const Text(
                  '트럭아저씨',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Food Truck Tracker',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: Text(AppLocalizations.of(context)!.truckList),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text(AppLocalizations.of(context)!.viewMap),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TruckMapScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.appInfo),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('트럭아저씨'),
                  content: const Text(
                    'Version 1.0.0\n\n푸드트럭을 쉽게 찾고 관리할 수 있는 앱입니다.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(AppLocalizations.of(context)!.privacyPolicy),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('개인정보 처리방침'),
                  content: const SingleChildScrollView(
                    child: Text(
                      '트럭아저씨는 사용자의 개인정보를 소중히 다룹니다.\n\n'
                      '수집하는 개인정보:\n'
                      '- 이메일 주소\n'
                      '- 위치 정보 (선택적)\n'
                      '- 기기 정보\n\n'
                      '개인정보 이용 목적:\n'
                      '- 서비스 제공 및 운영\n'
                      '- 푸드트럭 위치 추적 서비스\n'
                      '- 사용자 인증 및 관리\n\n'
                      '개인정보 보유 및 이용 기간:\n'
                      '- 회원 탈퇴 시까지\n'
                      '- 관계 법령에 따라 보존 필요 시 해당 기간까지\n\n'
                      '사용자는 언제든지 개인정보 열람, 수정, 삭제를 요청할 수 있습니다.\n\n'
                      '문의: support@truckajeossi.com',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          const Divider(),
          // Boss Mode Button (Hidden at the bottom)
          ListTile(
            leading: const Icon(
              Icons.admin_panel_settings,
              color: AppTheme.electricBlue,
            ),
            title: const Text(
              '사장님 로그인',
              style: TextStyle(
                color: AppTheme.electricBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.electricBlue,
            ),
            onTap: () {
              Navigator.pop(context);
              // Sign out to trigger AuthWrapper to show LoginScreen
              ref.read(authServiceProvider).signOut();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

