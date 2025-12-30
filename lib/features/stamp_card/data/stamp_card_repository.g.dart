// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamp_card_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stampCardRepository)
final stampCardRepositoryProvider = StampCardRepositoryProvider._();

final class StampCardRepositoryProvider
    extends
        $FunctionalProvider<
          StampCardRepository,
          StampCardRepository,
          StampCardRepository
        >
    with $Provider<StampCardRepository> {
  StampCardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stampCardRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stampCardRepositoryHash();

  @$internal
  @override
  $ProviderElement<StampCardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StampCardRepository create(Ref ref) {
    return stampCardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StampCardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StampCardRepository>(value),
    );
  }
}

String _$stampCardRepositoryHash() =>
    r'7947c67bd166a692715cfb3db95b863055508f40';

/// 사용자의 특정 트럭 스탬프 카드 Provider

@ProviderFor(userStampCard)
final userStampCardProvider = UserStampCardFamily._();

/// 사용자의 특정 트럭 스탬프 카드 Provider

final class UserStampCardProvider
    extends
        $FunctionalProvider<
          AsyncValue<StampCard?>,
          StampCard?,
          Stream<StampCard?>
        >
    with $FutureModifier<StampCard?>, $StreamProvider<StampCard?> {
  /// 사용자의 특정 트럭 스탬프 카드 Provider
  UserStampCardProvider._({
    required UserStampCardFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'userStampCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userStampCardHash();

  @override
  String toString() {
    return r'userStampCardProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<StampCard?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<StampCard?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return userStampCard(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStampCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userStampCardHash() => r'bb09282dd368e9659ac526d9bd0a78ca45409543';

/// 사용자의 특정 트럭 스탬프 카드 Provider

final class UserStampCardFamily extends $Family
    with $FunctionalFamilyOverride<Stream<StampCard?>, (String, String)> {
  UserStampCardFamily._()
    : super(
        retry: null,
        name: r'userStampCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 사용자의 특정 트럭 스탬프 카드 Provider

  UserStampCardProvider call(String visitorId, String truckId) =>
      UserStampCardProvider._(argument: (visitorId, truckId), from: this);

  @override
  String toString() => r'userStampCardProvider';
}

/// 사용자의 모든 스탬프 카드 Provider

@ProviderFor(userStampCards)
final userStampCardsProvider = UserStampCardsFamily._();

/// 사용자의 모든 스탬프 카드 Provider

final class UserStampCardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StampCard>>,
          List<StampCard>,
          Stream<List<StampCard>>
        >
    with $FutureModifier<List<StampCard>>, $StreamProvider<List<StampCard>> {
  /// 사용자의 모든 스탬프 카드 Provider
  UserStampCardsProvider._({
    required UserStampCardsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userStampCardsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userStampCardsHash();

  @override
  String toString() {
    return r'userStampCardsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<StampCard>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StampCard>> create(Ref ref) {
    final argument = this.argument as String;
    return userStampCards(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStampCardsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userStampCardsHash() => r'2233f4bd3970e6561945d22392dc94eefbc6b218';

/// 사용자의 모든 스탬프 카드 Provider

final class UserStampCardsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<StampCard>>, String> {
  UserStampCardsFamily._()
    : super(
        retry: null,
        name: r'userStampCardsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 사용자의 모든 스탬프 카드 Provider

  UserStampCardsProvider call(String visitorId) =>
      UserStampCardsProvider._(argument: visitorId, from: this);

  @override
  String toString() => r'userStampCardsProvider';
}

/// 사용자의 사용 가능한 리워드 Provider

@ProviderFor(userRewards)
final userRewardsProvider = UserRewardsFamily._();

/// 사용자의 사용 가능한 리워드 Provider

final class UserRewardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Reward>>,
          List<Reward>,
          Stream<List<Reward>>
        >
    with $FutureModifier<List<Reward>>, $StreamProvider<List<Reward>> {
  /// 사용자의 사용 가능한 리워드 Provider
  UserRewardsProvider._({
    required UserRewardsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userRewardsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userRewardsHash();

  @override
  String toString() {
    return r'userRewardsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Reward>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Reward>> create(Ref ref) {
    final argument = this.argument as String;
    return userRewards(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserRewardsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userRewardsHash() => r'53d5bb1904d4bb6af39766f644505ac31c369ad1';

/// 사용자의 사용 가능한 리워드 Provider

final class UserRewardsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Reward>>, String> {
  UserRewardsFamily._()
    : super(
        retry: null,
        name: r'userRewardsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 사용자의 사용 가능한 리워드 Provider

  UserRewardsProvider call(String visitorId) =>
      UserRewardsProvider._(argument: visitorId, from: this);

  @override
  String toString() => r'userRewardsProvider';
}

/// 트럭의 발급된 리워드 목록 (사장님용)

@ProviderFor(truckRewards)
final truckRewardsProvider = TruckRewardsFamily._();

/// 트럭의 발급된 리워드 목록 (사장님용)

final class TruckRewardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Reward>>,
          List<Reward>,
          Stream<List<Reward>>
        >
    with $FutureModifier<List<Reward>>, $StreamProvider<List<Reward>> {
  /// 트럭의 발급된 리워드 목록 (사장님용)
  TruckRewardsProvider._({
    required TruckRewardsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckRewardsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckRewardsHash();

  @override
  String toString() {
    return r'truckRewardsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Reward>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Reward>> create(Ref ref) {
    final argument = this.argument as String;
    return truckRewards(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckRewardsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckRewardsHash() => r'dee85a77a4a2e0453e4c56b2766eea369ab87210';

/// 트럭의 발급된 리워드 목록 (사장님용)

final class TruckRewardsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Reward>>, String> {
  TruckRewardsFamily._()
    : super(
        retry: null,
        name: r'truckRewardsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 트럭의 발급된 리워드 목록 (사장님용)

  TruckRewardsProvider call(String truckId) =>
      TruckRewardsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckRewardsProvider';
}
