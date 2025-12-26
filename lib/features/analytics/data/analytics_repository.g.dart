// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsRepositoryHash() =>
    r'f250e4697d4a5a6a098297c0a41915f7aa308579';

/// See also [analyticsRepository].
@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider =
    AutoDisposeProvider<AnalyticsRepository>.internal(
      analyticsRepository,
      name: r'analyticsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsRepositoryRef = AutoDisposeProviderRef<AnalyticsRepository>;
String _$todayAnalyticsHash() => r'7236987c6ff3f97d1bb6944c3e4e403257b2d760';

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

/// Provider for today's analytics
///
/// Copied from [todayAnalytics].
@ProviderFor(todayAnalytics)
const todayAnalyticsProvider = TodayAnalyticsFamily();

/// Provider for today's analytics
///
/// Copied from [todayAnalytics].
class TodayAnalyticsFamily extends Family<AsyncValue<TruckAnalytics>> {
  /// Provider for today's analytics
  ///
  /// Copied from [todayAnalytics].
  const TodayAnalyticsFamily();

  /// Provider for today's analytics
  ///
  /// Copied from [todayAnalytics].
  TodayAnalyticsProvider call(String truckId) {
    return TodayAnalyticsProvider(truckId);
  }

  @override
  TodayAnalyticsProvider getProviderOverride(
    covariant TodayAnalyticsProvider provider,
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
  String? get name => r'todayAnalyticsProvider';
}

/// Provider for today's analytics
///
/// Copied from [todayAnalytics].
class TodayAnalyticsProvider extends AutoDisposeFutureProvider<TruckAnalytics> {
  /// Provider for today's analytics
  ///
  /// Copied from [todayAnalytics].
  TodayAnalyticsProvider(String truckId)
    : this._internal(
        (ref) => todayAnalytics(ref as TodayAnalyticsRef, truckId),
        from: todayAnalyticsProvider,
        name: r'todayAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todayAnalyticsHash,
        dependencies: TodayAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            TodayAnalyticsFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TodayAnalyticsProvider._internal(
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
    FutureOr<TruckAnalytics> Function(TodayAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodayAnalyticsProvider._internal(
        (ref) => create(ref as TodayAnalyticsRef),
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
  AutoDisposeFutureProviderElement<TruckAnalytics> createElement() {
    return _TodayAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayAnalyticsProvider && other.truckId == truckId;
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
mixin TodayAnalyticsRef on AutoDisposeFutureProviderRef<TruckAnalytics> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TodayAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<TruckAnalytics>
    with TodayAnalyticsRef {
  _TodayAnalyticsProviderElement(super.provider);

  @override
  String get truckId => (origin as TodayAnalyticsProvider).truckId;
}

String _$analyticsRangeHash() => r'7b0763362dd03bb2d51415ae2ff49f66c9468e61';

/// Provider for analytics range
///
/// Copied from [analyticsRange].
@ProviderFor(analyticsRange)
const analyticsRangeProvider = AnalyticsRangeFamily();

/// Provider for analytics range
///
/// Copied from [analyticsRange].
class AnalyticsRangeFamily extends Family<AsyncValue<TruckAnalyticsRange>> {
  /// Provider for analytics range
  ///
  /// Copied from [analyticsRange].
  const AnalyticsRangeFamily();

  /// Provider for analytics range
  ///
  /// Copied from [analyticsRange].
  AnalyticsRangeProvider call(
    String truckId,
    DateTimeRange<DateTime> dateRange,
  ) {
    return AnalyticsRangeProvider(truckId, dateRange);
  }

  @override
  AnalyticsRangeProvider getProviderOverride(
    covariant AnalyticsRangeProvider provider,
  ) {
    return call(provider.truckId, provider.dateRange);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'analyticsRangeProvider';
}

/// Provider for analytics range
///
/// Copied from [analyticsRange].
class AnalyticsRangeProvider
    extends AutoDisposeFutureProvider<TruckAnalyticsRange> {
  /// Provider for analytics range
  ///
  /// Copied from [analyticsRange].
  AnalyticsRangeProvider(String truckId, DateTimeRange<DateTime> dateRange)
    : this._internal(
        (ref) => analyticsRange(ref as AnalyticsRangeRef, truckId, dateRange),
        from: analyticsRangeProvider,
        name: r'analyticsRangeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$analyticsRangeHash,
        dependencies: AnalyticsRangeFamily._dependencies,
        allTransitiveDependencies:
            AnalyticsRangeFamily._allTransitiveDependencies,
        truckId: truckId,
        dateRange: dateRange,
      );

  AnalyticsRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
    required this.dateRange,
  }) : super.internal();

  final String truckId;
  final DateTimeRange<DateTime> dateRange;

  @override
  Override overrideWith(
    FutureOr<TruckAnalyticsRange> Function(AnalyticsRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnalyticsRangeProvider._internal(
        (ref) => create(ref as AnalyticsRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TruckAnalyticsRange> createElement() {
    return _AnalyticsRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsRangeProvider &&
        other.truckId == truckId &&
        other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnalyticsRangeRef on AutoDisposeFutureProviderRef<TruckAnalyticsRange> {
  /// The parameter `truckId` of this provider.
  String get truckId;

  /// The parameter `dateRange` of this provider.
  DateTimeRange<DateTime> get dateRange;
}

class _AnalyticsRangeProviderElement
    extends AutoDisposeFutureProviderElement<TruckAnalyticsRange>
    with AnalyticsRangeRef {
  _AnalyticsRangeProviderElement(super.provider);

  @override
  String get truckId => (origin as AnalyticsRangeProvider).truckId;
  @override
  DateTimeRange<DateTime> get dateRange =>
      (origin as AnalyticsRangeProvider).dateRange;
}

String _$analyticsDateRangeNotifierHash() =>
    r'deef71cc7346a89c0fdeee8e2d3275c526e7c9f9';

/// Date range state notifier
///
/// Copied from [AnalyticsDateRangeNotifier].
@ProviderFor(AnalyticsDateRangeNotifier)
final analyticsDateRangeNotifierProvider =
    AutoDisposeNotifierProvider<
      AnalyticsDateRangeNotifier,
      DateTimeRange
    >.internal(
      AnalyticsDateRangeNotifier.new,
      name: r'analyticsDateRangeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsDateRangeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnalyticsDateRangeNotifier = AutoDisposeNotifier<DateTimeRange>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
