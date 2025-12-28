// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider = ScheduleRepositoryProvider._();

final class ScheduleRepositoryProvider
    extends
        $FunctionalProvider<
          ScheduleRepository,
          ScheduleRepository,
          ScheduleRepository
        >
    with $Provider<ScheduleRepository> {
  ScheduleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScheduleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScheduleRepository create(Ref ref) {
    return scheduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleRepository>(value),
    );
  }
}

String _$scheduleRepositoryHash() =>
    r'0961b45f21f081fbd866b70d750eac53db83f9a1';

@ProviderFor(todaySchedule)
final todayScheduleProvider = TodayScheduleFamily._();

final class TodayScheduleProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailySchedule?>,
          DailySchedule?,
          FutureOr<DailySchedule?>
        >
    with $FutureModifier<DailySchedule?>, $FutureProvider<DailySchedule?> {
  TodayScheduleProvider._({
    required TodayScheduleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'todayScheduleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todayScheduleHash();

  @override
  String toString() {
    return r'todayScheduleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DailySchedule?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailySchedule?> create(Ref ref) {
    final argument = this.argument as String;
    return todaySchedule(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayScheduleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todayScheduleHash() => r'33de0d2088fbccf9d1535d324a870e21e3570fbc';

final class TodayScheduleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DailySchedule?>, String> {
  TodayScheduleFamily._()
    : super(
        retry: null,
        name: r'todayScheduleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TodayScheduleProvider call(String truckId) =>
      TodayScheduleProvider._(argument: truckId, from: this);

  @override
  String toString() => r'todayScheduleProvider';
}
