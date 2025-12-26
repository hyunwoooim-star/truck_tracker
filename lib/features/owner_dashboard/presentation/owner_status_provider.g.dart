// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerTruckStatusHash() => r'1445f9b52bd064aa1a14b69c8d52017a2b8a8634';

/// Stream provider to watch the owner's truck status in real-time
///
/// Copied from [ownerTruckStatus].
@ProviderFor(ownerTruckStatus)
final ownerTruckStatusProvider =
    AutoDisposeStreamProvider<TruckStatus?>.internal(
      ownerTruckStatus,
      name: r'ownerTruckStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ownerTruckStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OwnerTruckStatusRef = AutoDisposeStreamProviderRef<TruckStatus?>;
String _$ownerTruckHash() => r'5f82ff47d0081c0d3ed4cc5eceba8dc4446a51b9';

/// Provider to get the owner's truck data
///
/// Copied from [ownerTruck].
@ProviderFor(ownerTruck)
final ownerTruckProvider = AutoDisposeStreamProvider<Truck?>.internal(
  ownerTruck,
  name: r'ownerTruckProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ownerTruckHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OwnerTruckRef = AutoDisposeStreamProviderRef<Truck?>;
String _$ownerOperatingStatusHash() =>
    r'a22de5a16980fbf9a17adfe9b03ecbff408ec3e0';

/// Provider that manages operating status for Owner's truck
///
/// This syncs with Firestore in real-time
///
/// Copied from [OwnerOperatingStatus].
@ProviderFor(OwnerOperatingStatus)
final ownerOperatingStatusProvider =
    AutoDisposeNotifierProvider<OwnerOperatingStatus, bool>.internal(
      OwnerOperatingStatus.new,
      name: r'ownerOperatingStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ownerOperatingStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OwnerOperatingStatus = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
