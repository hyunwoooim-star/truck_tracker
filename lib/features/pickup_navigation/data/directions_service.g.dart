// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directions_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(directionsService)
final directionsServiceProvider = DirectionsServiceProvider._();

final class DirectionsServiceProvider
    extends
        $FunctionalProvider<
          DirectionsService,
          DirectionsService,
          DirectionsService
        >
    with $Provider<DirectionsService> {
  DirectionsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'directionsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$directionsServiceHash();

  @$internal
  @override
  $ProviderElement<DirectionsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirectionsService create(Ref ref) {
    return directionsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirectionsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirectionsService>(value),
    );
  }
}

String _$directionsServiceHash() => r'bc682f8dc0f51d28374a707c78a5a7aab6c5453f';

/// 현재 위치 Provider

@ProviderFor(currentPosition)
final currentPositionProvider = CurrentPositionProvider._();

/// 현재 위치 Provider

final class CurrentPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Position?>,
          Position?,
          FutureOr<Position?>
        >
    with $FutureModifier<Position?>, $FutureProvider<Position?> {
  /// 현재 위치 Provider
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

String _$currentPositionHash() => r'5d45c1468d936b96161c729898d4dbdd6e2886f1';

/// 도보 경로 Provider

@ProviderFor(walkingRoute)
final walkingRouteProvider = WalkingRouteFamily._();

/// 도보 경로 Provider

final class WalkingRouteProvider
    extends
        $FunctionalProvider<
          AsyncValue<WalkingRoute?>,
          WalkingRoute?,
          FutureOr<WalkingRoute?>
        >
    with $FutureModifier<WalkingRoute?>, $FutureProvider<WalkingRoute?> {
  /// 도보 경로 Provider
  WalkingRouteProvider._({
    required WalkingRouteFamily super.from,
    required ({double destLat, double destLng}) super.argument,
  }) : super(
         retry: null,
         name: r'walkingRouteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$walkingRouteHash();

  @override
  String toString() {
    return r'walkingRouteProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<WalkingRoute?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WalkingRoute?> create(Ref ref) {
    final argument = this.argument as ({double destLat, double destLng});
    return walkingRoute(
      ref,
      destLat: argument.destLat,
      destLng: argument.destLng,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WalkingRouteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$walkingRouteHash() => r'f6282316adba46531ba5571d076ec035ea8faa52';

/// 도보 경로 Provider

final class WalkingRouteFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<WalkingRoute?>,
          ({double destLat, double destLng})
        > {
  WalkingRouteFamily._()
    : super(
        retry: null,
        name: r'walkingRouteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 도보 경로 Provider

  WalkingRouteProvider call({
    required double destLat,
    required double destLng,
  }) => WalkingRouteProvider._(
    argument: (destLat: destLat, destLng: destLng),
    from: this,
  );

  @override
  String toString() => r'walkingRouteProvider';
}
