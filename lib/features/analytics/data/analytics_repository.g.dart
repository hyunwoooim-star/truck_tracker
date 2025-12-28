// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider = AnalyticsRepositoryProvider._();

final class AnalyticsRepositoryProvider
    extends
        $FunctionalProvider<
          AnalyticsRepository,
          AnalyticsRepository,
          AnalyticsRepository
        >
    with $Provider<AnalyticsRepository> {
  AnalyticsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalyticsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsRepository create(Ref ref) {
    return analyticsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsRepository>(value),
    );
  }
}

String _$analyticsRepositoryHash() =>
    r'f250e4697d4a5a6a098297c0a41915f7aa308579';

/// Provider for today's analytics

@ProviderFor(todayAnalytics)
final todayAnalyticsProvider = TodayAnalyticsFamily._();

/// Provider for today's analytics

final class TodayAnalyticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<TruckAnalytics>,
          TruckAnalytics,
          FutureOr<TruckAnalytics>
        >
    with $FutureModifier<TruckAnalytics>, $FutureProvider<TruckAnalytics> {
  /// Provider for today's analytics
  TodayAnalyticsProvider._({
    required TodayAnalyticsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'todayAnalyticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todayAnalyticsHash();

  @override
  String toString() {
    return r'todayAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TruckAnalytics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TruckAnalytics> create(Ref ref) {
    final argument = this.argument as String;
    return todayAnalytics(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayAnalyticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todayAnalyticsHash() => r'7236987c6ff3f97d1bb6944c3e4e403257b2d760';

/// Provider for today's analytics

final class TodayAnalyticsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TruckAnalytics>, String> {
  TodayAnalyticsFamily._()
    : super(
        retry: null,
        name: r'todayAnalyticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for today's analytics

  TodayAnalyticsProvider call(String truckId) =>
      TodayAnalyticsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'todayAnalyticsProvider';
}

/// Date range state notifier

@ProviderFor(AnalyticsDateRangeNotifier)
final analyticsDateRangeProvider = AnalyticsDateRangeNotifierProvider._();

/// Date range state notifier
final class AnalyticsDateRangeNotifierProvider
    extends
        $NotifierProvider<AnalyticsDateRangeNotifier, DateTimeRange<DateTime>> {
  /// Date range state notifier
  AnalyticsDateRangeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsDateRangeNotifierHash();

  @$internal
  @override
  AnalyticsDateRangeNotifier create() => AnalyticsDateRangeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>>(value),
    );
  }
}

String _$analyticsDateRangeNotifierHash() =>
    r'deef71cc7346a89c0fdeee8e2d3275c526e7c9f9';

/// Date range state notifier

abstract class _$AnalyticsDateRangeNotifier
    extends $Notifier<DateTimeRange<DateTime>> {
  DateTimeRange<DateTime> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<DateTimeRange<DateTime>, DateTimeRange<DateTime>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTimeRange<DateTime>, DateTimeRange<DateTime>>,
              DateTimeRange<DateTime>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for analytics range

@ProviderFor(analyticsRange)
final analyticsRangeProvider = AnalyticsRangeFamily._();

/// Provider for analytics range

final class AnalyticsRangeProvider
    extends
        $FunctionalProvider<
          AsyncValue<TruckAnalyticsRange>,
          TruckAnalyticsRange,
          FutureOr<TruckAnalyticsRange>
        >
    with
        $FutureModifier<TruckAnalyticsRange>,
        $FutureProvider<TruckAnalyticsRange> {
  /// Provider for analytics range
  AnalyticsRangeProvider._({
    required AnalyticsRangeFamily super.from,
    required (String, DateTimeRange<DateTime>) super.argument,
  }) : super(
         retry: null,
         name: r'analyticsRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsRangeHash();

  @override
  String toString() {
    return r'analyticsRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<TruckAnalyticsRange> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TruckAnalyticsRange> create(Ref ref) {
    final argument = this.argument as (String, DateTimeRange<DateTime>);
    return analyticsRange(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsRangeHash() => r'7b0763362dd03bb2d51415ae2ff49f66c9468e61';

/// Provider for analytics range

final class AnalyticsRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<TruckAnalyticsRange>,
          (String, DateTimeRange<DateTime>)
        > {
  AnalyticsRangeFamily._()
    : super(
        retry: null,
        name: r'analyticsRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for analytics range

  AnalyticsRangeProvider call(
    String truckId,
    DateTimeRange<DateTime> dateRange,
  ) => AnalyticsRangeProvider._(argument: (truckId, dateRange), from: this);

  @override
  String toString() => r'analyticsRangeProvider';
}
