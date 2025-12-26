// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationServiceHash() => r'f7b3dbe3e362693a99dbd0c857f576f80a3f5f74';

/// Location service provider
///
/// Copied from [locationService].
@ProviderFor(locationService)
final locationServiceProvider = AutoDisposeProvider<LocationService>.internal(
  locationService,
  name: r'locationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationServiceRef = AutoDisposeProviderRef<LocationService>;
String _$cachedLocationServiceHash() =>
    r'62e370ddb596da3b761f9c32b57d416c3f99ffb7';

/// Cached location service provider (with 30s throttling for battery optimization)
///
/// Copied from [cachedLocationService].
@ProviderFor(cachedLocationService)
final cachedLocationServiceProvider =
    AutoDisposeProvider<CachedLocationService>.internal(
      cachedLocationService,
      name: r'cachedLocationServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedLocationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedLocationServiceRef =
    AutoDisposeProviderRef<CachedLocationService>;
String _$currentPositionHash() => r'55a9f881cdcbabf1907c25d7ac7267ebb0144e6a';

/// Current position provider (one-time fetch)
///
/// Copied from [currentPosition].
@ProviderFor(currentPosition)
final currentPositionProvider = AutoDisposeFutureProvider<Position?>.internal(
  currentPosition,
  name: r'currentPositionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPositionRef = AutoDisposeFutureProviderRef<Position?>;
String _$currentPositionStreamHash() =>
    r'9dc7bbc32eaddc667bdcdb02024e04bc1d7f723e';

/// Current position stream (real-time updates)
///
/// Copied from [currentPositionStream].
@ProviderFor(currentPositionStream)
final currentPositionStreamProvider =
    AutoDisposeStreamProvider<Position>.internal(
      currentPositionStream,
      name: r'currentPositionStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentPositionStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPositionStreamRef = AutoDisposeStreamProviderRef<Position>;
String _$locationPermissionHash() =>
    r'b728470a00931be1d6e1ff81e490728c940ef4cf';

/// Location permission provider
///
/// Copied from [locationPermission].
@ProviderFor(locationPermission)
final locationPermissionProvider =
    AutoDisposeFutureProvider<LocationPermission>.internal(
      locationPermission,
      name: r'locationPermissionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationPermissionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationPermissionRef =
    AutoDisposeFutureProviderRef<LocationPermission>;
String _$hasLocationPermissionHash() =>
    r'2a25d7b5c19c6afe5ed99d10d3921d42dea3e0c1';

/// Has location permission provider
///
/// Copied from [hasLocationPermission].
@ProviderFor(hasLocationPermission)
final hasLocationPermissionProvider = AutoDisposeFutureProvider<bool>.internal(
  hasLocationPermission,
  name: r'hasLocationPermissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasLocationPermissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasLocationPermissionRef = AutoDisposeFutureProviderRef<bool>;
String _$cachedPositionStreamHash() =>
    r'6c5212b9e81f55cb8048b59e2b1a3c3baeebbda5';

/// Cached position stream (throttled 30s, 50m distance filter for battery optimization)
///
/// Copied from [cachedPositionStream].
@ProviderFor(cachedPositionStream)
final cachedPositionStreamProvider =
    AutoDisposeStreamProvider<Position>.internal(
      cachedPositionStream,
      name: r'cachedPositionStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cachedPositionStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedPositionStreamRef = AutoDisposeStreamProviderRef<Position>;
String _$cachedPositionHash() => r'c455b71c39ba7656e58ac924b069fbf1f462d672';

/// Cached position provider (one-time fetch with 30s cache)
///
/// Copied from [cachedPosition].
@ProviderFor(cachedPosition)
final cachedPositionProvider = AutoDisposeFutureProvider<Position?>.internal(
  cachedPosition,
  name: r'cachedPositionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cachedPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedPositionRef = AutoDisposeFutureProviderRef<Position?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
