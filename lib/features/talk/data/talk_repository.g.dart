// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$talkRepositoryHash() => r'b77e85ffcf54aa4ca46c185138ff844183bcfe3d';

/// See also [talkRepository].
@ProviderFor(talkRepository)
final talkRepositoryProvider = AutoDisposeProvider<TalkRepository>.internal(
  talkRepository,
  name: r'talkRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$talkRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TalkRepositoryRef = AutoDisposeProviderRef<TalkRepository>;
String _$truckTalkHash() => r'9300b624656b342f3e955b72093a62d23bef8948';

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

/// Provider for watching talk messages of a specific truck
///
/// Copied from [truckTalk].
@ProviderFor(truckTalk)
const truckTalkProvider = TruckTalkFamily();

/// Provider for watching talk messages of a specific truck
///
/// Copied from [truckTalk].
class TruckTalkFamily extends Family<AsyncValue<List<TalkMessage>>> {
  /// Provider for watching talk messages of a specific truck
  ///
  /// Copied from [truckTalk].
  const TruckTalkFamily();

  /// Provider for watching talk messages of a specific truck
  ///
  /// Copied from [truckTalk].
  TruckTalkProvider call(String truckId) {
    return TruckTalkProvider(truckId);
  }

  @override
  TruckTalkProvider getProviderOverride(covariant TruckTalkProvider provider) {
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
  String? get name => r'truckTalkProvider';
}

/// Provider for watching talk messages of a specific truck
///
/// Copied from [truckTalk].
class TruckTalkProvider extends AutoDisposeStreamProvider<List<TalkMessage>> {
  /// Provider for watching talk messages of a specific truck
  ///
  /// Copied from [truckTalk].
  TruckTalkProvider(String truckId)
    : this._internal(
        (ref) => truckTalk(ref as TruckTalkRef, truckId),
        from: truckTalkProvider,
        name: r'truckTalkProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckTalkHash,
        dependencies: TruckTalkFamily._dependencies,
        allTransitiveDependencies: TruckTalkFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckTalkProvider._internal(
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
    Stream<List<TalkMessage>> Function(TruckTalkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckTalkProvider._internal(
        (ref) => create(ref as TruckTalkRef),
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
  AutoDisposeStreamProviderElement<List<TalkMessage>> createElement() {
    return _TruckTalkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckTalkProvider && other.truckId == truckId;
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
mixin TruckTalkRef on AutoDisposeStreamProviderRef<List<TalkMessage>> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckTalkProviderElement
    extends AutoDisposeStreamProviderElement<List<TalkMessage>>
    with TruckTalkRef {
  _TruckTalkProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckTalkProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
