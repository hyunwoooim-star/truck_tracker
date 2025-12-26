// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleRepositoryHash() =>
    r'85fb357cc129c9eacba355128d9132d718df1195';

/// See also [scheduleRepository].
@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider =
    AutoDisposeProvider<ScheduleRepository>.internal(
      scheduleRepository,
      name: r'scheduleRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scheduleRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduleRepositoryRef = AutoDisposeProviderRef<ScheduleRepository>;
String _$todayScheduleHash() => r'e68e71c9bd3046dcf41fb84988a58e2c56a2a040';

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

/// See also [todaySchedule].
@ProviderFor(todaySchedule)
const todayScheduleProvider = TodayScheduleFamily();

/// See also [todaySchedule].
class TodayScheduleFamily extends Family<AsyncValue<DailySchedule?>> {
  /// See also [todaySchedule].
  const TodayScheduleFamily();

  /// See also [todaySchedule].
  TodayScheduleProvider call(String truckId) {
    return TodayScheduleProvider(truckId);
  }

  @override
  TodayScheduleProvider getProviderOverride(
    covariant TodayScheduleProvider provider,
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
  String? get name => r'todayScheduleProvider';
}

/// See also [todaySchedule].
class TodayScheduleProvider extends AutoDisposeFutureProvider<DailySchedule?> {
  /// See also [todaySchedule].
  TodayScheduleProvider(String truckId)
    : this._internal(
        (ref) => todaySchedule(ref as TodayScheduleRef, truckId),
        from: todayScheduleProvider,
        name: r'todayScheduleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todayScheduleHash,
        dependencies: TodayScheduleFamily._dependencies,
        allTransitiveDependencies:
            TodayScheduleFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TodayScheduleProvider._internal(
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
    FutureOr<DailySchedule?> Function(TodayScheduleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodayScheduleProvider._internal(
        (ref) => create(ref as TodayScheduleRef),
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
  AutoDisposeFutureProviderElement<DailySchedule?> createElement() {
    return _TodayScheduleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayScheduleProvider && other.truckId == truckId;
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
mixin TodayScheduleRef on AutoDisposeFutureProviderRef<DailySchedule?> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TodayScheduleProviderElement
    extends AutoDisposeFutureProviderElement<DailySchedule?>
    with TodayScheduleRef {
  _TodayScheduleProviderElement(super.provider);

  @override
  String get truckId => (origin as TodayScheduleProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
