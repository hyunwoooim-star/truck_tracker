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

String _$locationServiceHash() => r'38d15292e1d1d4553c8f07a36b00411aa0a8d30e';

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
    r'1697223d57e2aec2212fe38a3439cbc845769037';

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

String _$currentPositionHash() => r'1de9ec7ce7bce1e4f94caec9183bb5855e9b34fc';

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
    r'67de064595e2c9a0b4c6b3c20a48c88e86fdf730';

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
    r'654c454a917f2e7fa789861b07636280d4c6f491';

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
    r'741dc69c3dd3c35cd88842e1903ffc8ab1d477ff';

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
    r'607aa94fc8c1172216ac41bdfbcde46ecc66df22';

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

String _$cachedPositionHash() => r'700c5715d664306e43710ab6f13232ee6c23c384';
