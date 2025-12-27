// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$truckDetailRepositoryHash() =>
    r'938a9dfb4753e5c3e58858e2e8b7e9846ae2c131';

/// See also [truckDetailRepository].
@ProviderFor(truckDetailRepository)
final truckDetailRepositoryProvider =
    AutoDisposeProvider<TruckDetailRepository>.internal(
      truckDetailRepository,
      name: r'truckDetailRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$truckDetailRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TruckDetailRepositoryRef =
    AutoDisposeProviderRef<TruckDetailRepository>;
String _$truckDetailStreamHash() => r'85cd681bce732150c714725d4ecd9c9eeb7acf75';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [truckDetailStream].
@ProviderFor(truckDetailStream)
const truckDetailStreamProvider = TruckDetailStreamFamily();

/// See also [truckDetailStream].
class TruckDetailStreamFamily extends Family<AsyncValue<TruckDetail?>> {
  /// See also [truckDetailStream].
  const TruckDetailStreamFamily();

  /// See also [truckDetailStream].
  TruckDetailStreamProvider call(String truckId) {
    return TruckDetailStreamProvider(truckId);
  }

  @override
  TruckDetailStreamProvider getProviderOverride(
    covariant TruckDetailStreamProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckDetailStreamProvider';
}

/// See also [truckDetailStream].
class TruckDetailStreamProvider
    extends AutoDisposeStreamProvider<TruckDetail?> {
  /// See also [truckDetailStream].
  TruckDetailStreamProvider(String truckId)
    : this._internal(
        (ref) => truckDetailStream(ref as TruckDetailStreamRef, truckId),
        from: truckDetailStreamProvider,
        name: r'truckDetailStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckDetailStreamHash,
        dependencies: TruckDetailStreamFamily._dependencies,
        allTransitiveDependencies:
            TruckDetailStreamFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckDetailStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Override overrideWith(
    Stream<TruckDetail?> Function(TruckDetailStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckDetailStreamProvider._internal(
        (ref) => create(ref as TruckDetailStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TruckDetail?> createElement() {
    return _TruckDetailStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckDetailStreamProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckDetailStreamRef on AutoDisposeStreamProviderRef<TruckDetail?> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckDetailStreamProviderElement
    extends AutoDisposeStreamProviderElement<TruckDetail?>
    with TruckDetailStreamRef {
  _TruckDetailStreamProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckDetailStreamProvider).truckId;
}

String _$truckDetailNotifierHash() =>
    r'e1a387b23f94f06f1109d2d25a7f3fe42a5a6fd8';

abstract class _$TruckDetailNotifier
    extends BuildlessAutoDisposeStreamNotifier<TruckDetail?> {
  late final String truckId;

  Stream<TruckDetail?> build(String truckId);
}

/// See also [TruckDetailNotifier].
@ProviderFor(TruckDetailNotifier)
const truckDetailNotifierProvider = TruckDetailNotifierFamily();

/// See also [TruckDetailNotifier].
class TruckDetailNotifierFamily extends Family<AsyncValue<TruckDetail?>> {
  /// See also [TruckDetailNotifier].
  const TruckDetailNotifierFamily();

  /// See also [TruckDetailNotifier].
  TruckDetailNotifierProvider call(String truckId) {
    return TruckDetailNotifierProvider(truckId);
  }

  @override
  TruckDetailNotifierProvider getProviderOverride(
    covariant TruckDetailNotifierProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckDetailNotifierProvider';
}

/// See also [TruckDetailNotifier].
class TruckDetailNotifierProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          TruckDetailNotifier,
          TruckDetail?
        > {
  /// See also [TruckDetailNotifier].
  TruckDetailNotifierProvider(String truckId)
    : this._internal(
        () => TruckDetailNotifier()..truckId = truckId,
        from: truckDetailNotifierProvider,
        name: r'truckDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckDetailNotifierHash,
        dependencies: TruckDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            TruckDetailNotifierFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Stream<TruckDetail?> runNotifierBuild(
    covariant TruckDetailNotifier notifier,
  ) {
    return notifier.build(truckId);
  }

  @override
  Override overrideWith(TruckDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TruckDetailNotifierProvider._internal(
        () => create()..truckId = truckId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<TruckDetailNotifier, TruckDetail?>
  createElement() {
    return _TruckDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckDetailNotifierProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckDetailNotifierRef
    on AutoDisposeStreamNotifierProviderRef<TruckDetail?> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckDetailNotifierProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          TruckDetailNotifier,
          TruckDetail?
        >
    with TruckDetailNotifierRef {
  _TruckDetailNotifierProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckDetailNotifierProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
