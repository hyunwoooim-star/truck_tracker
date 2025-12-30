import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/constants/food_types.dart';
import '../../../core/themes/app_theme.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../favorite/presentation/favorites_screen.dart';
import '../../truck_map/presentation/truck_map_screen.dart';
import '../../checkin/presentation/customer_checkin_screen.dart';
import '../domain/truck.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'truck_provider.dart';
import 'widgets/bento_truck_grid.dart';

class TruckListScreen extends ConsumerWidget {
  const TruckListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trucksWithDistanceAsync = ref.watch(filteredTrucksWithDistanceProvider);
    final topRankedAsync = ref.watch(topRankedTrucksProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).truckList),
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
          // Truck List with Pull-to-Refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Invalidate the Firestore stream to refresh data
                ref.invalidate(firestoreTruckStreamProvider);
                // Wait a moment for the stream to restart
                await Future.delayed(const Duration(milliseconds: 500));
              },
              color: AppTheme.mustardYellow,
              backgroundColor: AppTheme.charcoalMedium,
              child: trucksWithDistanceAsync.when(
                loading: () => const SkeletonTruckList(itemCount: 5),
                error: (e, stackTrace) => Center(
                  child: Text(
                    l10n.loadDataFailed,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                data: (trucksWithDistance) {
                  // Get top ranked trucks (sync or empty list if loading)
                  final topRanked = topRankedAsync.value ?? [];

                  // Empty State
                  if (trucksWithDistance.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 80,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noTrucks,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '검색 조건을 변경해 보세요',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.read(truckFilterProvider.notifier).clearAllFilters();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('필터 초기화'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.electricBlue,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Bento Grid layout with varied card sizes
                  return BentoTruckGrid(
                    trucksWithDistance: trucksWithDistance,
                    topRanked: topRanked,
                  );
              },
              ),
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

/// Premium filter bar with food type tags and icons
class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTag = ref.watch(truckFilterProvider).selectedTag;
    final filterState = ref.watch(truckFilterProvider);
    final activeFilterCount = _countActiveFilters(filterState);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Advanced Filter Button
                _FilterButton(
                  icon: Icons.tune,
                  label: '필터',
                  badgeCount: activeFilterCount,
                  isActive: filterState.hasActiveFilters,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const _AdvancedFilterDialog(),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Sort Button
                _FilterButton(
                  icon: Icons.swap_vert,
                  label: '정렬',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const _SortOptionsDialog(),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Category section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '카테고리',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Food Type Chips with emoji
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: FoodTypes.filterTags.length,
              itemBuilder: (context, index) {
                final tag = FoodTypes.filterTags[index];
                final isSelected = tag == selectedTag;
                final emoji = FoodTypes.getEmoji(tag);

                return Padding(
                  padding: EdgeInsets.only(right: index < FoodTypes.filterTags.length - 1 ? 8 : 0),
                  child: _FoodCategoryChip(
                    label: tag,
                    emoji: emoji,
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(truckFilterProvider.notifier).setSelectedTag(tag);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _countActiveFilters(TruckFilterState state) {
    int count = 0;
    if (state.selectedStatuses.isNotEmpty) count++;
    if (state.maxDistance != null) count++;
    if (state.minRating != null) count++;
    if (state.openOnly) count++;
    return count;
  }
}

// Premium filter button with badge
class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badgeCount;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppTheme.mustardYellow15 : AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? AppTheme.mustardYellow : AppTheme.charcoalLight,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? AppTheme.mustardYellow : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppTheme.mustardYellow : AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.mustardYellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Premium food category chip with emoji
class _FoodCategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _FoodCategoryChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.mustardYellow : AppTheme.charcoalMedium,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected ? AppTheme.mustardYellow : AppTheme.charcoalLight,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
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
      ref.read(truckFilterProvider.notifier)
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
    final searchKeyword = ref.watch(truckFilterProvider).searchKeyword;

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
          hintText: AppLocalizations.of(context).searchPlaceholder,
          hintStyle: const TextStyle(color: AppTheme.textTertiary),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
          suffixIcon: searchKeyword.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textTertiary),
                  onPressed: () {
                    _controller.clear();
                    ref.read(truckFilterProvider.notifier)
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

// App Drawer with Premium Design
class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppTheme.midnightCharcoal,
      child: Column(
        children: [
          // Premium DrawerHeader with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.charcoalMedium,
                  AppTheme.midnightCharcoal,
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.mustardYellow,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.mustardYellow30,
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '트럭아저씨',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Food Truck Tracker',
                  style: TextStyle(
                    color: AppTheme.mustardYellow80,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Navigation Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '내비게이션',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Truck List (Selected)
          _DrawerMenuItem(
            icon: Icons.restaurant_menu,
            title: AppLocalizations.of(context).truckList,
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),

          // Map View
          _DrawerMenuItem(
            icon: Icons.map_outlined,
            title: AppLocalizations.of(context).viewMap,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TruckMapScreen()),
              );
            },
          ),

          // Favorites
          _DrawerMenuItem(
            icon: Icons.favorite_outline,
            title: AppLocalizations.of(context).myFavorites,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),

          const SizedBox(height: 16),
          const Divider(color: AppTheme.charcoalLight, height: 1),
          const SizedBox(height: 8),

          // Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '정보',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          _DrawerMenuItem(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context).appInfo,
            onTap: () {
              final l10n = AppLocalizations.of(context);
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.truckUncle),
                  content: const Text(
                    'Version 1.0.0\n\n푸드트럭을 쉽게 찾고 관리할 수 있는 앱입니다.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.ok),
                    ),
                  ],
                ),
              );
            },
          ),

          _DrawerMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: AppLocalizations.of(context).privacyPolicy,
            onTap: () {
              final l10n = AppLocalizations.of(context);
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.privacyPolicyTitle),
                  content: SingleChildScrollView(
                    child: Text(
                      l10n.privacyPolicyContent,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.ok),
                    ),
                  ],
                ),
              );
            },
          ),

          const Spacer(),

          const Divider(color: AppTheme.charcoalLight, height: 1),

          // Logout Button with danger style
          Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authServiceProvider).signOut();
                  ref.invalidate(currentUserTruckIdProvider);
                  ref.invalidate(currentUserProvider);
                  ref.invalidate(currentUserIdProvider);
                  ref.invalidate(currentUserEmailProvider);
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.error30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: AppTheme.error, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).logout,
                        style: const TextStyle(
                          color: AppTheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Drawer Menu Item
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected ? AppTheme.mustardYellow15 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppTheme.mustardYellow : AppTheme.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppTheme.mustardYellow : AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.mustardYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Advanced Filter Dialog
class _AdvancedFilterDialog extends ConsumerWidget {
  const _AdvancedFilterDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(truckFilterProvider);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('고급 필터'),
          if (filterState.hasActiveFilters)
            TextButton(
              onPressed: () {
                ref.read(truckFilterProvider.notifier).clearAllFilters();
              },
              child: const Text('초기화', style: TextStyle(color: AppTheme.electricBlue)),
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Truck Status Filter
              const Text(
                '트럭 상태',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TruckStatus.values.map((status) {
                  final isSelected = filterState.selectedStatuses.contains(status);
                  String label;
                  switch (status) {
                    case TruckStatus.onRoute:
                      label = '운행 중';
                      break;
                    case TruckStatus.resting:
                      label = '휴식';
                      break;
                    case TruckStatus.maintenance:
                      label = '정비 중';
                      break;
                  }
                  return FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).toggleStatus(status);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Distance Filter
              const Text(
                '거리',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('전체'),
                    selected: filterState.maxDistance == null,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMaxDistance(null);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                  FilterChip(
                    label: const Text('1km 이내'),
                    selected: filterState.maxDistance == 1000,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMaxDistance(1000);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                  FilterChip(
                    label: const Text('5km 이내'),
                    selected: filterState.maxDistance == 5000,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMaxDistance(5000);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                  FilterChip(
                    label: const Text('10km 이내'),
                    selected: filterState.maxDistance == 10000,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMaxDistance(10000);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Rating Filter
              const Text(
                '평점',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('전체'),
                    selected: filterState.minRating == null,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMinRating(null);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                  FilterChip(
                    label: const Text('⭐ 3.0+'),
                    selected: filterState.minRating == 3.0,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMinRating(3.0);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                  FilterChip(
                    label: const Text('⭐ 4.0+'),
                    selected: filterState.minRating == 4.0,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMinRating(4.0);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                  FilterChip(
                    label: const Text('⭐ 4.5+'),
                    selected: filterState.minRating == 4.5,
                    onSelected: (_) {
                      ref.read(truckFilterProvider.notifier).setMinRating(4.5);
                    },
                    selectedColor: AppTheme.electricBlue,
                    checkmarkColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Open Only Filter
              SwitchListTile(
                title: const Text('영업 중만 표시'),
                subtitle: const Text('현재 영업 중인 트럭만 표시합니다'),
                value: filterState.openOnly,
                onChanged: (value) {
                  ref.read(truckFilterProvider.notifier).setOpenOnly(value);
                },
                activeTrackColor: AppTheme.electricBlue.withAlpha(128),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

/// Sort Options Dialog
class _SortOptionsDialog extends ConsumerWidget {
  const _SortOptionsDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: const Text('정렬'),
      content: RadioGroup<SortOption>(
        groupValue: currentSort,
        onChanged: (value) {
          if (value != null) {
            ref.read(sortOptionProvider.notifier).setSortOption(value);
            Navigator.pop(context);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: SortOption.values.map((option) {
            String label;
            IconData icon;
            switch (option) {
              case SortOption.distance:
                label = '가까운 순';
                icon = Icons.near_me;
                break;
              case SortOption.name:
                label = '이름 순';
                icon = Icons.sort_by_alpha;
                break;
              case SortOption.rating:
                label = '평점 순';
                icon = Icons.star;
                break;
            }
            return RadioListTile<SortOption>(
              title: Row(
                children: [
                  Icon(icon, size: 20, color: AppTheme.electricBlue),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
              value: option,
              activeColor: AppTheme.electricBlue,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}

