// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueRepository)
final revenueRepositoryProvider = RevenueRepositoryProvider._();

final class RevenueRepositoryProvider
    extends
        $FunctionalProvider<
          RevenueRepository,
          RevenueRepository,
          RevenueRepository
        >
    with $Provider<RevenueRepository> {
  RevenueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueRepositoryHash();

  @$internal
  @override
  $ProviderElement<RevenueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RevenueRepository create(Ref ref) {
    return revenueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevenueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevenueRepository>(value),
    );
  }
}

String _$revenueRepositoryHash() => r'ab97c3fc7974922597a5d766be6771b1d57b437b';

/// 실시간 대시보드 Provider

@ProviderFor(realTimeDashboard)
final realTimeDashboardProvider = RealTimeDashboardFamily._();

/// 실시간 대시보드 Provider

final class RealTimeDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<RealTimeDashboard>,
          RealTimeDashboard,
          Stream<RealTimeDashboard>
        >
    with
        $FutureModifier<RealTimeDashboard>,
        $StreamProvider<RealTimeDashboard> {
  /// 실시간 대시보드 Provider
  RealTimeDashboardProvider._({
    required RealTimeDashboardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'realTimeDashboardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$realTimeDashboardHash();

  @override
  String toString() {
    return r'realTimeDashboardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<RealTimeDashboard> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RealTimeDashboard> create(Ref ref) {
    final argument = this.argument as String;
    return realTimeDashboard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RealTimeDashboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$realTimeDashboardHash() => r'06e013528b8ed2381e56e9a370500264c2828c78';

/// 실시간 대시보드 Provider

final class RealTimeDashboardFamily extends $Family
    with $FunctionalFamilyOverride<Stream<RealTimeDashboard>, String> {
  RealTimeDashboardFamily._()
    : super(
        retry: null,
        name: r'realTimeDashboardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 실시간 대시보드 Provider

  RealTimeDashboardProvider call(String truckId) =>
      RealTimeDashboardProvider._(argument: truckId, from: this);

  @override
  String toString() => r'realTimeDashboardProvider';
}

/// 매출 리포트 Provider

@ProviderFor(revenueReport)
final revenueReportProvider = RevenueReportFamily._();

/// 매출 리포트 Provider

final class RevenueReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<RevenueReport>,
          RevenueReport,
          FutureOr<RevenueReport>
        >
    with $FutureModifier<RevenueReport>, $FutureProvider<RevenueReport> {
  /// 매출 리포트 Provider
  RevenueReportProvider._({
    required RevenueReportFamily super.from,
    required (String, DateTimeRange<DateTime>) super.argument,
  }) : super(
         retry: null,
         name: r'revenueReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$revenueReportHash();

  @override
  String toString() {
    return r'revenueReportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RevenueReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RevenueReport> create(Ref ref) {
    final argument = this.argument as (String, DateTimeRange<DateTime>);
    return revenueReport(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RevenueReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$revenueReportHash() => r'c7dd24e0f25bc9d89cd505d765165138d6453bca';

/// 매출 리포트 Provider

final class RevenueReportFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RevenueReport>,
          (String, DateTimeRange<DateTime>)
        > {
  RevenueReportFamily._()
    : super(
        retry: null,
        name: r'revenueReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 매출 리포트 Provider

  RevenueReportProvider call(
    String truckId,
    DateTimeRange<DateTime> dateRange,
  ) => RevenueReportProvider._(argument: (truckId, dateRange), from: this);

  @override
  String toString() => r'revenueReportProvider';
}

/// 주간 요약 Provider

@ProviderFor(weeklySummary)
final weeklySummaryProvider = WeeklySummaryFamily._();

/// 주간 요약 Provider

final class WeeklySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// 주간 요약 Provider
  WeeklySummaryProvider._({
    required WeeklySummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'weeklySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weeklySummaryHash();

  @override
  String toString() {
    return r'weeklySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as String;
    return weeklySummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklySummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weeklySummaryHash() => r'0892e1e676d2cfd025e7b4bd2c1384354d4283c7';

/// 주간 요약 Provider

final class WeeklySummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, String> {
  WeeklySummaryFamily._()
    : super(
        retry: null,
        name: r'weeklySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 주간 요약 Provider

  WeeklySummaryProvider call(String truckId) =>
      WeeklySummaryProvider._(argument: truckId, from: this);

  @override
  String toString() => r'weeklySummaryProvider';
}

/// 리포트 기간 상태 Provider

@ProviderFor(ReportDateRange)
final reportDateRangeProvider = ReportDateRangeProvider._();

/// 리포트 기간 상태 Provider
final class ReportDateRangeProvider
    extends $NotifierProvider<ReportDateRange, DateTimeRange<DateTime>> {
  /// 리포트 기간 상태 Provider
  ReportDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportDateRangeHash();

  @$internal
  @override
  ReportDateRange create() => ReportDateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>>(value),
    );
  }
}

String _$reportDateRangeHash() => r'6b62f31fd51302b2d5ecb75e52c915e7cdc2b2a9';

/// 리포트 기간 상태 Provider

abstract class _$ReportDateRange extends $Notifier<DateTimeRange<DateTime>> {
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
