// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Location service provider

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

/// Location service provider

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  /// Location service provider
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'f7b3dbe3e362693a99dbd0c857f576f80a3f5f74';

/// Cached location service provider (with 30s throttling for battery optimization)

@ProviderFor(cachedLocationService)
final cachedLocationServiceProvider = CachedLocationServiceProvider._();

/// Cached location service provider (with 30s throttling for battery optimization)

final class CachedLocationServiceProvider
    extends
        $FunctionalProvider<
          CachedLocationService,
          CachedLocationService,
          CachedLocationService
        >
    with $Provider<CachedLocationService> {
  /// Cached location service provider (with 30s throttling for battery optimization)
  CachedLocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedLocationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedLocationServiceHash();

  @$internal
  @override
  $ProviderElement<CachedLocationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CachedLocationService create(Ref ref) {
    return cachedLocationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CachedLocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CachedLocationService>(value),
    );
  }
}

String _$cachedLocationServiceHash() =>
    r'62e370ddb596da3b761f9c32b57d416c3f99ffb7';

/// Current position provider (one-time fetch)

@ProviderFor(currentPosition)
final currentPositionProvider = CurrentPositionProvider._();

/// Current position provider (one-time fetch)

final class CurrentPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Position?>,
          Position?,
          FutureOr<Position?>
        >
    with $FutureModifier<Position?>, $FutureProvider<Position?> {
  /// Current position provider (one-time fetch)
  CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $FutureProviderElement<Position?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Position?> create(Ref ref) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'55a9f881cdcbabf1907c25d7ac7267ebb0144e6a';

/// Current position stream (real-time updates)

@ProviderFor(currentPositionStream)
final currentPositionStreamProvider = CurrentPositionStreamProvider._();

/// Current position stream (real-time updates)

final class CurrentPositionStreamProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, Stream<Position>>
    with $FutureModifier<Position>, $StreamProvider<Position> {
  /// Current position stream (real-time updates)
  CurrentPositionStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionStreamHash();

  @$internal
  @override
  $StreamProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Position> create(Ref ref) {
    return currentPositionStream(ref);
  }
}

String _$currentPositionStreamHash() =>
    r'9dc7bbc32eaddc667bdcdb02024e04bc1d7f723e';

/// Location permission provider

@ProviderFor(locationPermission)
final locationPermissionProvider = LocationPermissionProvider._();

/// Location permission provider

final class LocationPermissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocationPermission>,
          LocationPermission,
          FutureOr<LocationPermission>
        >
    with
        $FutureModifier<LocationPermission>,
        $FutureProvider<LocationPermission> {
  /// Location permission provider
  LocationPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationPermissionHash();

  @$internal
  @override
  $FutureProviderElement<LocationPermission> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocationPermission> create(Ref ref) {
    return locationPermission(ref);
  }
}

String _$locationPermissionHash() =>
    r'b728470a00931be1d6e1ff81e490728c940ef4cf';

/// Has location permission provider

@ProviderFor(hasLocationPermission)
final hasLocationPermissionProvider = HasLocationPermissionProvider._();

/// Has location permission provider

final class HasLocationPermissionProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Has location permission provider
  HasLocationPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasLocationPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasLocationPermissionHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return hasLocationPermission(ref);
  }
}

String _$hasLocationPermissionHash() =>
    r'2a25d7b5c19c6afe5ed99d10d3921d42dea3e0c1';

/// Cached position stream (throttled 30s, 50m distance filter for battery optimization)

@ProviderFor(cachedPositionStream)
final cachedPositionStreamProvider = CachedPositionStreamProvider._();

/// Cached position stream (throttled 30s, 50m distance filter for battery optimization)

final class CachedPositionStreamProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, Stream<Position>>
    with $FutureModifier<Position>, $StreamProvider<Position> {
  /// Cached position stream (throttled 30s, 50m distance filter for battery optimization)
  CachedPositionStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedPositionStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedPositionStreamHash();

  @$internal
  @override
  $StreamProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Position> create(Ref ref) {
    return cachedPositionStream(ref);
  }
}

String _$cachedPositionStreamHash() =>
    r'6c5212b9e81f55cb8048b59e2b1a3c3baeebbda5';

/// Cached position provider (one-time fetch with 30s cache)

@ProviderFor(cachedPosition)
final cachedPositionProvider = CachedPositionProvider._();

/// Cached position provider (one-time fetch with 30s cache)

final class CachedPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Position?>,
          Position?,
          FutureOr<Position?>
        >
    with $FutureModifier<Position?>, $FutureProvider<Position?> {
  /// Cached position provider (one-time fetch with 30s cache)
  CachedPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedPositionHash();

  @$internal
  @override
  $FutureProviderElement<Position?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Position?> create(Ref ref) {
    return cachedPosition(ref);
  }
}

String _$cachedPositionHash() => r'c455b71c39ba7656e58ac924b069fbf1f462d672';
