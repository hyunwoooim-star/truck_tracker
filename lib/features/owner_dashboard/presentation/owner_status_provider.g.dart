// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages operating status for Owner's truck
///
/// This syncs with Firestore in real-time

@ProviderFor(OwnerOperatingStatus)
final ownerOperatingStatusProvider = OwnerOperatingStatusProvider._();

/// Provider that manages operating status for Owner's truck
///
/// This syncs with Firestore in real-time
final class OwnerOperatingStatusProvider
    extends $NotifierProvider<OwnerOperatingStatus, bool> {
  /// Provider that manages operating status for Owner's truck
  ///
  /// This syncs with Firestore in real-time
  OwnerOperatingStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerOperatingStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerOperatingStatusHash();

  @$internal
  @override
  OwnerOperatingStatus create() => OwnerOperatingStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$ownerOperatingStatusHash() =>
    r'1c79e00e4e81cf45c95a9810cdaf9cde978836b4';

/// Provider that manages operating status for Owner's truck
///
/// This syncs with Firestore in real-time

abstract class _$OwnerOperatingStatus extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Stream provider to watch the owner's truck status in real-time

@ProviderFor(ownerTruckStatus)
final ownerTruckStatusProvider = OwnerTruckStatusProvider._();

/// Stream provider to watch the owner's truck status in real-time

final class OwnerTruckStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<TruckStatus?>,
          TruckStatus?,
          Stream<TruckStatus?>
        >
    with $FutureModifier<TruckStatus?>, $StreamProvider<TruckStatus?> {
  /// Stream provider to watch the owner's truck status in real-time
  OwnerTruckStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerTruckStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerTruckStatusHash();

  @$internal
  @override
  $StreamProviderElement<TruckStatus?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TruckStatus?> create(Ref ref) {
    return ownerTruckStatus(ref);
  }
}

String _$ownerTruckStatusHash() => r'a8199ec2ba9f2667c37874a7be0b0fc3d205d232';

/// Provider to get the owner's truck data
/// Uses ownedTruckId from user document to find the truck

@ProviderFor(ownerTruck)
final ownerTruckProvider = OwnerTruckProvider._();

/// Provider to get the owner's truck data
/// Uses ownedTruckId from user document to find the truck

final class OwnerTruckProvider
    extends $FunctionalProvider<AsyncValue<Truck?>, Truck?, Stream<Truck?>>
    with $FutureModifier<Truck?>, $StreamProvider<Truck?> {
  /// Provider to get the owner's truck data
  /// Uses ownedTruckId from user document to find the truck
  OwnerTruckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerTruckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerTruckHash();

  @$internal
  @override
  $StreamProviderElement<Truck?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Truck?> create(Ref ref) {
    return ownerTruck(ref);
  }
}

String _$ownerTruckHash() => r'275a73873b6f73169449a8a9d144749baf217bc8';
