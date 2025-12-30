// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_verification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(visitVerificationRepository)
final visitVerificationRepositoryProvider =
    VisitVerificationRepositoryProvider._();

final class VisitVerificationRepositoryProvider
    extends
        $FunctionalProvider<
          VisitVerificationRepository,
          VisitVerificationRepository,
          VisitVerificationRepository
        >
    with $Provider<VisitVerificationRepository> {
  VisitVerificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitVerificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitVerificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<VisitVerificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VisitVerificationRepository create(Ref ref) {
    return visitVerificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VisitVerificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VisitVerificationRepository>(value),
    );
  }
}

String _$visitVerificationRepositoryHash() =>
    r'715fd1c6f605b0d95f414dd3a5119a22ee6d5e5f';

/// 트럭별 방문 인증 횟수 Provider

@ProviderFor(truckVisitCount)
final truckVisitCountProvider = TruckVisitCountFamily._();

/// 트럭별 방문 인증 횟수 Provider

final class TruckVisitCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// 트럭별 방문 인증 횟수 Provider
  TruckVisitCountProvider._({
    required TruckVisitCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckVisitCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckVisitCountHash();

  @override
  String toString() {
    return r'truckVisitCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return truckVisitCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckVisitCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckVisitCountHash() => r'b66f50441ba45c2e9aef4bf09f4c814ec33e27d7';

/// 트럭별 방문 인증 횟수 Provider

final class TruckVisitCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  TruckVisitCountFamily._()
    : super(
        retry: null,
        name: r'truckVisitCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 트럭별 방문 인증 횟수 Provider

  TruckVisitCountProvider call(String truckId) =>
      TruckVisitCountProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckVisitCountProvider';
}

/// 트럭별 최근 방문자 목록 Provider

@ProviderFor(truckRecentVisits)
final truckRecentVisitsProvider = TruckRecentVisitsFamily._();

/// 트럭별 최근 방문자 목록 Provider

final class TruckRecentVisitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VisitVerification>>,
          List<VisitVerification>,
          Stream<List<VisitVerification>>
        >
    with
        $FutureModifier<List<VisitVerification>>,
        $StreamProvider<List<VisitVerification>> {
  /// 트럭별 최근 방문자 목록 Provider
  TruckRecentVisitsProvider._({
    required TruckRecentVisitsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckRecentVisitsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckRecentVisitsHash();

  @override
  String toString() {
    return r'truckRecentVisitsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<VisitVerification>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VisitVerification>> create(Ref ref) {
    final argument = this.argument as String;
    return truckRecentVisits(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckRecentVisitsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckRecentVisitsHash() => r'b81a9a26198c7796a16ecbe9aed724b8a2619ab3';

/// 트럭별 최근 방문자 목록 Provider

final class TruckRecentVisitsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<VisitVerification>>, String> {
  TruckRecentVisitsFamily._()
    : super(
        retry: null,
        name: r'truckRecentVisitsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 트럭별 최근 방문자 목록 Provider

  TruckRecentVisitsProvider call(String truckId) =>
      TruckRecentVisitsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckRecentVisitsProvider';
}

/// 사용자의 특정 트럭 방문 여부 (오늘) Provider

@ProviderFor(hasVisitedToday)
final hasVisitedTodayProvider = HasVisitedTodayFamily._();

/// 사용자의 특정 트럭 방문 여부 (오늘) Provider

final class HasVisitedTodayProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 사용자의 특정 트럭 방문 여부 (오늘) Provider
  HasVisitedTodayProvider._({
    required HasVisitedTodayFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'hasVisitedTodayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasVisitedTodayHash();

  @override
  String toString() {
    return r'hasVisitedTodayProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as (String, String);
    return hasVisitedToday(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is HasVisitedTodayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasVisitedTodayHash() => r'fc7cbf48f21e237650e7b39a5386154ac6ff62b8';

/// 사용자의 특정 트럭 방문 여부 (오늘) Provider

final class HasVisitedTodayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (String, String)> {
  HasVisitedTodayFamily._()
    : super(
        retry: null,
        name: r'hasVisitedTodayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 사용자의 특정 트럭 방문 여부 (오늘) Provider

  HasVisitedTodayProvider call(String visitorId, String truckId) =>
      HasVisitedTodayProvider._(argument: (visitorId, truckId), from: this);

  @override
  String toString() => r'hasVisitedTodayProvider';
}
