import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cached_location_service.dart';
import '../location_service.dart';

part 'location_provider.g.dart';

/// Location service provider
@riverpod
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}

/// Cached location service provider (with 30s throttling for battery optimization)
@riverpod
CachedLocationService cachedLocationService(CachedLocationServiceRef ref) {
  return CachedLocationService(
    locationService: ref.watch(locationServiceProvider),
  );
}

/// Current position provider (one-time fetch)
@riverpod
Future<Position?> currentPosition(CurrentPositionRef ref) async {
  final service = ref.watch(locationServiceProvider);
  return await service.getCurrentPosition();
}

/// Current position stream (real-time updates)
@riverpod
Stream<Position> currentPositionStream(CurrentPositionStreamRef ref) {
  final service = ref.watch(locationServiceProvider);
  return service.watchPosition();
}

/// Location permission provider
@riverpod
Future<LocationPermission> locationPermission(LocationPermissionRef ref) async {
  final service = ref.watch(locationServiceProvider);
  return await service.checkPermission();
}

/// Has location permission provider
@riverpod
Future<bool> hasLocationPermission(HasLocationPermissionRef ref) async {
  final service = ref.watch(locationServiceProvider);
  return await service.ensurePermission();
}

/// Cached position stream (throttled 30s, 50m distance filter for battery optimization)
@riverpod
Stream<Position> cachedPositionStream(CachedPositionStreamRef ref) {
  final service = ref.watch(cachedLocationServiceProvider);
  return service.watchPositionCached();
}

/// Cached position provider (one-time fetch with 30s cache)
@riverpod
Future<Position?> cachedPosition(CachedPositionRef ref) async {
  final service = ref.watch(cachedLocationServiceProvider);
  return await service.getPosition();
}





