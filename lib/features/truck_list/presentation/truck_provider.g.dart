// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository provider

@ProviderFor(truckRepository)
final truckRepositoryProvider = TruckRepositoryProvider._();

/// Repository provider

final class TruckRepositoryProvider
    extends
        $FunctionalProvider<TruckRepository, TruckRepository, TruckRepository>
    with $Provider<TruckRepository> {
  /// Repository provider
  TruckRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'truckRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$truckRepositoryHash();

  @$internal
  @override
  $ProviderElement<TruckRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TruckRepository create(Ref ref) {
    return truckRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruckRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruckRepository>(value),
    );
  }
}

String _$truckRepositoryHash() => r'8b1e16782766263a676c4d16bd32f7446f663995';

/// Firestore stream provider for real-time updates

@ProviderFor(firestoreTruckStream)
final firestoreTruckStreamProvider = FirestoreTruckStreamProvider._();

/// Firestore stream provider for real-time updates

final class FirestoreTruckStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Truck>>,
          List<Truck>,
          Stream<List<Truck>>
        >
    with $FutureModifier<List<Truck>>, $StreamProvider<List<Truck>> {
  /// Firestore stream provider for real-time updates
  FirestoreTruckStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreTruckStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreTruckStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Truck>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Truck>> create(Ref ref) {
    return firestoreTruckStream(ref);
  }
}

String _$firestoreTruckStreamHash() =>
    r'52a7440e0871ab21ea54bed99c10dc58ce458ba5';

/// Filter state provider

@ProviderFor(TruckFilterNotifier)
final truckFilterProvider = TruckFilterNotifierProvider._();

/// Filter state provider
final class TruckFilterNotifierProvider
    extends $NotifierProvider<TruckFilterNotifier, TruckFilterState> {
  /// Filter state provider
  TruckFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'truckFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$truckFilterNotifierHash();

  @$internal
  @override
  TruckFilterNotifier create() => TruckFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruckFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruckFilterState>(value),
    );
  }
}

String _$truckFilterNotifierHash() =>
    r'e0a459cc83fd6f0ad9e272418d13d85cdc6483a6';

/// Filter state provider

abstract class _$TruckFilterNotifier extends $Notifier<TruckFilterState> {
  TruckFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TruckFilterState, TruckFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TruckFilterState, TruckFilterState>,
              TruckFilterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Filtered truck list provider that combines Firestore stream with filter state

@ProviderFor(filteredTruckList)
final filteredTruckListProvider = FilteredTruckListProvider._();

/// Filtered truck list provider that combines Firestore stream with filter state

final class FilteredTruckListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Truck>>,
          List<Truck>,
          Stream<List<Truck>>
        >
    with $FutureModifier<List<Truck>>, $StreamProvider<List<Truck>> {
  /// Filtered truck list provider that combines Firestore stream with filter state
  FilteredTruckListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTruckListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTruckListHash();

  @$internal
  @override
  $StreamProviderElement<List<Truck>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Truck>> create(Ref ref) {
    return filteredTruckList(ref);
  }
}

String _$filteredTruckListHash() => r'cd97b2e32e002f53ebd62995521a5120636c14e8';

/// Sort state provider

@ProviderFor(SortOptionNotifier)
final sortOptionProvider = SortOptionNotifierProvider._();

/// Sort state provider
final class SortOptionNotifierProvider
    extends $NotifierProvider<SortOptionNotifier, SortOption> {
  /// Sort state provider
  SortOptionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortOptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortOptionNotifierHash();

  @$internal
  @override
  SortOptionNotifier create() => SortOptionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortOption>(value),
    );
  }
}

String _$sortOptionNotifierHash() =>
    r'18d83beb55ad392de7d5d57b0c373423fe0d78f2';

/// Sort state provider

abstract class _$SortOptionNotifier extends $Notifier<SortOption> {
  SortOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SortOption, SortOption>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortOption, SortOption>,
              SortOption,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Filtered and sorted truck list with distance information

@ProviderFor(filteredTrucksWithDistance)
final filteredTrucksWithDistanceProvider =
    FilteredTrucksWithDistanceProvider._();

/// Filtered and sorted truck list with distance information

final class FilteredTrucksWithDistanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TruckWithDistance>>,
          List<TruckWithDistance>,
          Stream<List<TruckWithDistance>>
        >
    with
        $FutureModifier<List<TruckWithDistance>>,
        $StreamProvider<List<TruckWithDistance>> {
  /// Filtered and sorted truck list with distance information
  FilteredTrucksWithDistanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTrucksWithDistanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTrucksWithDistanceHash();

  @$internal
  @override
  $StreamProviderElement<List<TruckWithDistance>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TruckWithDistance>> create(Ref ref) {
    return filteredTrucksWithDistance(ref);
  }
}

String _$filteredTrucksWithDistanceHash() =>
    r'7f177208176c3b3c7b63e8eefb3a3ee575ce7c73';

/// LEGACY: Mock data filtered list (kept for reference/fallback)

@ProviderFor(filteredTruckListMock)
final filteredTruckListMockProvider = FilteredTruckListMockProvider._();

/// LEGACY: Mock data filtered list (kept for reference/fallback)

final class FilteredTruckListMockProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Truck>>,
          AsyncValue<List<Truck>>,
          AsyncValue<List<Truck>>
        >
    with $Provider<AsyncValue<List<Truck>>> {
  /// LEGACY: Mock data filtered list (kept for reference/fallback)
  FilteredTruckListMockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTruckListMockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTruckListMockHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Truck>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Truck>> create(Ref ref) {
    return filteredTruckListMock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Truck>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Truck>>>(value),
    );
  }
}

String _$filteredTruckListMockHash() =>
    r'bd22af34a98a2256a69e4042cb688579bf30894e';

@ProviderFor(TruckListNotifier)
final truckListProvider = TruckListNotifierProvider._();

final class TruckListNotifierProvider
    extends $AsyncNotifierProvider<TruckListNotifier, List<Truck>> {
  TruckListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'truckListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$truckListNotifierHash();

  @$internal
  @override
  TruckListNotifier create() => TruckListNotifier();
}

String _$truckListNotifierHash() => r'ca74633a9938181f293377eae717e09b55da1fe9';

abstract class _$TruckListNotifier extends $AsyncNotifier<List<Truck>> {
  FutureOr<List<Truck>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Truck>>, List<Truck>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Truck>>, List<Truck>>,
              AsyncValue<List<Truck>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Top 3 ranked trucks based on ranking score
/// Score = (favoriteCount * 0.4) + (avgRating * 0.6)

@ProviderFor(topRankedTrucks)
final topRankedTrucksProvider = TopRankedTrucksProvider._();

/// Top 3 ranked trucks based on ranking score
/// Score = (favoriteCount * 0.4) + (avgRating * 0.6)

final class TopRankedTrucksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Truck>>,
          List<Truck>,
          Stream<List<Truck>>
        >
    with $FutureModifier<List<Truck>>, $StreamProvider<List<Truck>> {
  /// Top 3 ranked trucks based on ranking score
  /// Score = (favoriteCount * 0.4) + (avgRating * 0.6)
  TopRankedTrucksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topRankedTrucksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topRankedTrucksHash();

  @$internal
  @override
  $StreamProviderElement<List<Truck>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Truck>> create(Ref ref) {
    return topRankedTrucks(ref);
  }
}

String _$topRankedTrucksHash() => r'6140258a6051f5dcd6248f06f54c74a6b6144661';

/// Provider for getting a single truck by ID

@ProviderFor(singleTruck)
final singleTruckProvider = SingleTruckFamily._();

/// Provider for getting a single truck by ID

final class SingleTruckProvider
    extends $FunctionalProvider<AsyncValue<Truck?>, Truck?, FutureOr<Truck?>>
    with $FutureModifier<Truck?>, $FutureProvider<Truck?> {
  /// Provider for getting a single truck by ID
  SingleTruckProvider._({
    required SingleTruckFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'singleTruckProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleTruckHash();

  @override
  String toString() {
    return r'singleTruckProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Truck?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Truck?> create(Ref ref) {
    final argument = this.argument as String;
    return singleTruck(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleTruckProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleTruckHash() => r'00044f5c94ce7b73b6329c271eeb0d77c891790d';

/// Provider for getting a single truck by ID

final class SingleTruckFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Truck?>, String> {
  SingleTruckFamily._()
    : super(
        retry: null,
        name: r'singleTruckProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting a single truck by ID

  SingleTruckProvider call(String truckId) =>
      SingleTruckProvider._(argument: truckId, from: this);

  @override
  String toString() => r'singleTruckProvider';
}
