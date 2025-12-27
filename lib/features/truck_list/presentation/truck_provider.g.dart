// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$truckRepositoryHash() => r'd3843127b16224873bbe4ffef3db43d146316d35';

/// Repository provider
///
/// Copied from [truckRepository].
@ProviderFor(truckRepository)
final truckRepositoryProvider = AutoDisposeProvider<TruckRepository>.internal(
  truckRepository,
  name: r'truckRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$truckRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TruckRepositoryRef = AutoDisposeProviderRef<TruckRepository>;
String _$firestoreTruckStreamHash() =>
    r'8fcd08a079af5be5cd67a613544e1549452c2c9d';

/// Firestore stream provider for real-time updates
///
/// Copied from [firestoreTruckStream].
@ProviderFor(firestoreTruckStream)
final firestoreTruckStreamProvider =
    AutoDisposeStreamProvider<List<Truck>>.internal(
      firestoreTruckStream,
      name: r'firestoreTruckStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firestoreTruckStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirestoreTruckStreamRef = AutoDisposeStreamProviderRef<List<Truck>>;
String _$filteredTruckListHash() => r'3dd53a4398c0caee80e86eaa2198eae66fed6b3e';

/// Filtered truck list provider that combines Firestore stream with filter state
///
/// Copied from [filteredTruckList].
@ProviderFor(filteredTruckList)
final filteredTruckListProvider =
    AutoDisposeStreamProvider<List<Truck>>.internal(
      filteredTruckList,
      name: r'filteredTruckListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredTruckListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTruckListRef = AutoDisposeStreamProviderRef<List<Truck>>;
String _$filteredTrucksWithDistanceHash() =>
    r'5de18e5b56aac71a448c919688fec598e6894f68';

/// Filtered and sorted truck list with distance information
///
/// Copied from [filteredTrucksWithDistance].
@ProviderFor(filteredTrucksWithDistance)
final filteredTrucksWithDistanceProvider =
    AutoDisposeStreamProvider<List<TruckWithDistance>>.internal(
      filteredTrucksWithDistance,
      name: r'filteredTrucksWithDistanceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredTrucksWithDistanceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTrucksWithDistanceRef =
    AutoDisposeStreamProviderRef<List<TruckWithDistance>>;
String _$filteredTruckListMockHash() =>
    r'c2057472855252ecbeabcf5d944baca085d9e403';

/// LEGACY: Mock data filtered list (kept for reference/fallback)
///
/// Copied from [filteredTruckListMock].
@ProviderFor(filteredTruckListMock)
final filteredTruckListMockProvider =
    AutoDisposeProvider<AsyncValue<List<Truck>>>.internal(
      filteredTruckListMock,
      name: r'filteredTruckListMockProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredTruckListMockHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTruckListMockRef =
    AutoDisposeProviderRef<AsyncValue<List<Truck>>>;
String _$topRankedTrucksHash() => r'0e15e8e474be521498144b980686c5ab0d560abb';

/// Top 3 ranked trucks based on ranking score
/// Score = (favoriteCount * 0.4) + (avgRating * 0.6)
///
/// Copied from [topRankedTrucks].
@ProviderFor(topRankedTrucks)
final topRankedTrucksProvider = AutoDisposeStreamProvider<List<Truck>>.internal(
  topRankedTrucks,
  name: r'topRankedTrucksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$topRankedTrucksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TopRankedTrucksRef = AutoDisposeStreamProviderRef<List<Truck>>;
String _$truckFilterNotifierHash() =>
    r'ad5b897675b41fc72a234001ae1f408e98d4b97f';

/// Filter state provider
///
/// Copied from [TruckFilterNotifier].
@ProviderFor(TruckFilterNotifier)
final truckFilterNotifierProvider =
    AutoDisposeNotifierProvider<TruckFilterNotifier, TruckFilterState>.internal(
      TruckFilterNotifier.new,
      name: r'truckFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$truckFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TruckFilterNotifier = AutoDisposeNotifier<TruckFilterState>;
String _$sortOptionNotifierHash() =>
    r'7657c73ca502eab530f06ab78b271af96dfd90d5';

/// Sort state provider
///
/// Copied from [SortOptionNotifier].
@ProviderFor(SortOptionNotifier)
final sortOptionNotifierProvider =
    AutoDisposeNotifierProvider<SortOptionNotifier, SortOption>.internal(
      SortOptionNotifier.new,
      name: r'sortOptionNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sortOptionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SortOptionNotifier = AutoDisposeNotifier<SortOption>;
String _$truckListNotifierHash() => r'8b55c04190fe74c2ee90a5296fcd2e4389f6dbae';

/// See also [TruckListNotifier].
@ProviderFor(TruckListNotifier)
final truckListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TruckListNotifier, List<Truck>>.internal(
      TruckListNotifier.new,
      name: r'truckListNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$truckListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TruckListNotifier = AutoDisposeAsyncNotifier<List<Truck>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
