import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../location/presentation/location_provider.dart';
import '../data/truck_repository.dart';
import '../domain/truck.dart';
import '../domain/truck_with_distance.dart';

part 'truck_provider.g.dart';

/// Repository provider
@riverpod
TruckRepository truckRepository(TruckRepositoryRef ref) {
  return TruckRepository();
}

/// Firestore stream provider for real-time updates
@riverpod
Stream<List<Truck>> firestoreTruckStream(FirestoreTruckStreamRef ref) {
  print('🚀 firestoreTruckStreamProvider - Creating new stream subscription');
  final repository = ref.watch(truckRepositoryProvider);

  final stream = repository.watchTrucks();

  // Add debug listener
  return stream.map((trucks) {
    print(
      '📡 firestoreTruckStreamProvider - Emitting ${trucks.length} trucks to subscribers',
    );
    return trucks;
  });
}

/// Filter state to manage selected tag and search keyword
class TruckFilterState {
  const TruckFilterState({this.selectedTag = '전체', this.searchKeyword = ''});

  final String selectedTag;
  final String searchKeyword;

  TruckFilterState copyWith({String? selectedTag, String? searchKeyword}) {
    return TruckFilterState(
      selectedTag: selectedTag ?? this.selectedTag,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

/// Filter state provider
@riverpod
class TruckFilterNotifier extends AutoDisposeNotifier<TruckFilterState> {
  @override
  TruckFilterState build() => const TruckFilterState();

  void setSelectedTag(String tag) {
    state = state.copyWith(selectedTag: tag);
  }

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }
}

/// Filtered truck list provider that combines Firestore stream with filter state
@riverpod
Stream<List<Truck>> filteredTruckList(FilteredTruckListRef ref) async* {
  print('🔍 filteredTruckListProvider - Starting filtered stream');

  final trucksStream = ref.watch(firestoreTruckStreamProvider.stream);
  final filterState = ref.watch(truckFilterNotifierProvider);

  print(
    '🔍 Current filter: tag="${filterState.selectedTag}", keyword="${filterState.searchKeyword}"',
  );

  await for (final trucks in trucksStream) {
    print('');
    print(
      '🔍 filteredTruckListProvider - Received ${trucks.length} trucks from upstream',
    );

    // 🔥 DEBUG: Show all trucks with their status
    for (final truck in trucks) {
      print(
        '  🚚 Truck ${truck.id}: ${truck.foodType} - Status: ${truck.status.name}',
      );
    }

    var filtered = trucks;

    // Filter by selected tag
    if (filterState.selectedTag != '전체') {
      filtered = filtered
          .where((truck) => truck.foodType == filterState.selectedTag)
          .toList();
      print(
        '  🏷️  After tag filter: ${filtered.length} trucks (tag: ${filterState.selectedTag})',
      );
    }

    // Filter by search keyword
    if (filterState.searchKeyword.isNotEmpty) {
      final keyword = filterState.searchKeyword.toLowerCase();
      filtered = filtered.where((truck) {
        return truck.truckNumber.toLowerCase().contains(keyword) ||
            truck.driverName.toLowerCase().contains(keyword) ||
            truck.foodType.toLowerCase().contains(keyword) ||
            truck.locationDescription.toLowerCase().contains(keyword);
      }).toList();
      print(
        '  🔎 After search filter: ${filtered.length} trucks (keyword: $keyword)',
      );
    }

    print('  ✅ Yielding ${filtered.length} filtered trucks to UI');
    print('');

    yield filtered;
  }
}

/// Sort option enum
enum SortOption {
  distance, // 가까운 순
  name, // 이름 순
  rating, // 평점 순 (추후)
}

/// Sort state provider
@riverpod
class SortOptionNotifier extends AutoDisposeNotifier<SortOption> {
  @override
  SortOption build() => SortOption.distance; // Default: distance sort

  void setSortOption(SortOption option) {
    state = option;
  }
}

/// Filtered and sorted truck list with distance information
@riverpod
Stream<List<TruckWithDistance>> filteredTrucksWithDistance(
  FilteredTrucksWithDistanceRef ref,
) async* {
  print('📍 filteredTrucksWithDistanceProvider - Starting');

  final trucksStream = ref.watch(filteredTruckListProvider.stream);
  final sortOption = ref.watch(sortOptionNotifierProvider);
  final locationService = ref.watch(locationServiceProvider);

  // Get current position (non-blocking)
  Position? userPosition;
  try {
    userPosition = await locationService.getCurrentPosition();
    if (userPosition != null) {
      print(
        '📍 User position: ${userPosition.latitude}, ${userPosition.longitude}',
      );
    }
  } catch (e) {
    print('⚠️ Could not get user position: $e');
  }

  await for (final trucks in trucksStream) {
    print('📍 Processing ${trucks.length} trucks with distance');

    // Convert to TruckWithDistance
    final trucksWithDistance = trucks.map((truck) {
      double distance = double.infinity;

      if (userPosition != null) {
        distance = locationService.calculateDistance(
          userPosition.latitude,
          userPosition.longitude,
          truck.latitude,
          truck.longitude,
        );
      }

      return TruckWithDistance(truck: truck, distanceInMeters: distance);
    }).toList();

    // Sort based on sort option
    switch (sortOption) {
      case SortOption.distance:
        trucksWithDistance.sort((a, b) => a.compareByDistance(b));
        print('📍 Sorted by distance');
        break;
      case SortOption.name:
        trucksWithDistance.sort(
          (a, b) => a.truck.foodType.compareTo(b.truck.foodType),
        );
        print('📍 Sorted by name');
        break;
      case SortOption.rating:
        trucksWithDistance.sort(
          (a, b) => b.truck.avgRating.compareTo(a.truck.avgRating),
        );
        print('📍 Sorted by rating');
        break;
    }

    yield trucksWithDistance;
  }
}

/// LEGACY: Mock data filtered list (kept for reference/fallback)
@riverpod
AsyncValue<List<Truck>> filteredTruckListMock(FilteredTruckListMockRef ref) {
  final trucksAsync = ref.watch(truckListNotifierProvider);
  final filterState = ref.watch(truckFilterNotifierProvider);

  return trucksAsync.when(
    data: (trucks) {
      var filtered = trucks;

      // Filter by selected tag
      if (filterState.selectedTag != '전체') {
        filtered = filtered
            .where((truck) => truck.foodType == filterState.selectedTag)
            .toList();
      }

      // Filter by search keyword (truck name or location)
      if (filterState.searchKeyword.isNotEmpty) {
        final keyword = filterState.searchKeyword.toLowerCase();
        filtered = filtered.where((truck) {
          return truck.truckNumber.toLowerCase().contains(keyword) ||
              truck.driverName.toLowerCase().contains(keyword) ||
              truck.foodType.toLowerCase().contains(keyword) ||
              truck.locationDescription.toLowerCase().contains(keyword);
        }).toList();
      }

      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
}

@riverpod
class TruckListNotifier extends AutoDisposeAsyncNotifier<List<Truck>> {
  Timer? _positionUpdateTimer;
  static const _positionUpdateInterval = Duration(seconds: 5);
  static const _movementRange =
      0.0001; // Small movement for realistic simulation

  static const _seedData = [
    Truck(
      id: '1',
      truckNumber: 'BM-001',
      driverName: '배민 라이더 박빠름',
      status: TruckStatus.onRoute,
      foodType: '닭꼬치',
      locationDescription: '2번 출구 앞',
      latitude: 37.5665,
      longitude: 126.9780, // 시청
      imageUrl:
          'https://images.unsplash.com/photo-1532635241-17e820acc59f?w=400&fit=crop',
    ),
    Truck(
      id: '2',
      truckNumber: 'BM-002',
      driverName: '배민 트럭 김든든',
      status: TruckStatus.resting,
      foodType: '호떡',
      locationDescription: '공원 분수대 옆',
      latitude: 37.5700,
      longitude: 126.9820, // 광화문 인근
      imageUrl:
          'https://images.unsplash.com/photo-1619871790279-d6a290068400?w=400&fit=crop',
    ),
    Truck(
      id: '3',
      truckNumber: 'BM-003',
      driverName: '배민 기사 이꼼꼼',
      status: TruckStatus.maintenance,
      foodType: '어묵',
      locationDescription: '시청 광장',
      latitude: 37.5610,
      longitude: 126.9930, // 명동 쪽
      imageUrl:
          'https://images.unsplash.com/photo-1598515213685-011520970387?w=400&fit=crop',
    ),
    Truck(
      id: '4',
      truckNumber: 'BM-004',
      driverName: '배민 라이더 최쾌속',
      status: TruckStatus.onRoute,
      foodType: '심야라멘',
      locationDescription: '3번 출구 앞',
      latitude: 37.5580,
      longitude: 126.9368, // 신촌역
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&fit=crop',
    ),
    Truck(
      id: '5',
      truckNumber: 'BM-005',
      driverName: '배민 트럭 정정시',
      status: TruckStatus.resting,
      foodType: '붕어빵',
      locationDescription: '학교 후문',
      latitude: 37.5125,
      longitude: 127.1028, // 잠실
      imageUrl:
          'https://images.unsplash.com/photo-1610818020073-a59407428699?w=400&fit=crop',
    ),
    Truck(
      id: '6',
      truckNumber: 'BM-006',
      driverName: '배민 라이더 조맛나',
      status: TruckStatus.onRoute,
      foodType: '불막창',
      locationDescription: '강남역 10번 출구',
      latitude: 37.4979,
      longitude: 127.0276, // 강남역
      imageUrl:
          'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&fit=crop',
    ),
    Truck(
      id: '7',
      truckNumber: 'BM-007',
      driverName: '배민 트럭 윤달콤',
      status: TruckStatus.onRoute,
      foodType: '크레페퀸',
      locationDescription: '홍대 놀이터 앞',
      latitude: 37.5563,
      longitude: 126.9237, // 홍대입구역
      imageUrl:
          'https://images.unsplash.com/photo-1519915212116-7cfef71f1d3e?w=400&fit=crop',
    ),
    Truck(
      id: '8',
      truckNumber: 'BM-008',
      driverName: '배민 기사 강바삭',
      status: TruckStatus.resting,
      foodType: '옛날통닭',
      locationDescription: '건대 로데오거리',
      latitude: 37.5403,
      longitude: 127.0688, // 건대입구역
      imageUrl:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400&fit=crop',
    ),
  ];

  @override
  Future<List<Truck>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final initialData = _seedData;

    // Start position update timer to simulate real-time movement
    _startPositionUpdates();

    // Cleanup timer when provider is disposed
    ref.onDispose(() {
      _cleanup();
    });

    return initialData;
  }

  void _startPositionUpdates() {
    _positionUpdateTimer?.cancel();
    _positionUpdateTimer = Timer.periodic(_positionUpdateInterval, (_) {
      _updateTruckPositions();
    });
  }

  void _updateTruckPositions() {
    final currentTrucks = state.value;
    if (currentTrucks == null || currentTrucks.isEmpty) return;

    final random = Random();
    final updatedTrucks = currentTrucks.map((truck) {
      // Only update position for trucks that are on route
      if (truck.status != TruckStatus.onRoute) return truck;

      // Add small random movement to simulate real-time updates
      final latOffset = (random.nextDouble() - 0.5) * _movementRange;
      final lngOffset = (random.nextDouble() - 0.5) * _movementRange;

      return truck.copyWith(
        latitude: truck.latitude + latOffset,
        longitude: truck.longitude + lngOffset,
      );
    }).toList();

    state = AsyncData(updatedTrucks);
  }

  void _cleanup() {
    _positionUpdateTimer?.cancel();
    _positionUpdateTimer = null;
  }

  Future<void> toggleFavorite(String id) async {
    final previous = state.value ?? [];
    // optimistic update
    final updated = previous
        .map((t) => t.id == id ? t.copyWith(isFavorite: !t.isFavorite) : t)
        .toList();
    state = AsyncData(updated);

    try {
      // mock latency
      await Future<void>.delayed(const Duration(milliseconds: 350));
      // mock failure chance 15%
      final fail = Random().nextDouble() < 0.15;
      if (fail) throw Exception('toggle_failed');
    } catch (_) {
      // rollback
      state = AsyncData(previous);
      rethrow;
    }
  }
}

/// Top 3 ranked trucks based on ranking score
/// Score = (favoriteCount * 0.4) + (avgRating * 0.6)
@riverpod
Stream<List<Truck>> topRankedTrucks(TopRankedTrucksRef ref) async* {
  print('🏆 topRankedTrucksProvider - Starting Top 3 calculation');

  final trucksStream = ref.watch(firestoreTruckStreamProvider.stream);

  await for (final trucks in trucksStream) {
    print('🏆 Calculating Top 3 from ${trucks.length} trucks');

    // Sort by ranking score (descending)
    final sorted = trucks.toList()
      ..sort((a, b) => b.rankingScore.compareTo(a.rankingScore));

    // Take top 3
    final top3 = sorted.take(3).toList();

    print('🏆 Top 3 Trucks:');
    for (var i = 0; i < top3.length; i++) {
      final truck = top3[i];
      print(
        '  ${i + 1}. ${truck.truckNumber} - Score: ${truck.rankingScore.toStringAsFixed(2)} '
        '(Favorites: ${truck.favoriteCount}, Rating: ${truck.avgRating.toStringAsFixed(1)})',
      );
    }

    yield top3;
  }
}
