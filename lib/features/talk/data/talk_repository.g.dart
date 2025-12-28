// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(talkRepository)
final talkRepositoryProvider = TalkRepositoryProvider._();

final class TalkRepositoryProvider
    extends $FunctionalProvider<TalkRepository, TalkRepository, TalkRepository>
    with $Provider<TalkRepository> {
  TalkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'talkRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$talkRepositoryHash();

  @$internal
  @override
  $ProviderElement<TalkRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TalkRepository create(Ref ref) {
    return talkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TalkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TalkRepository>(value),
    );
  }
}

String _$talkRepositoryHash() => r'b77e85ffcf54aa4ca46c185138ff844183bcfe3d';

/// Provider for watching talk messages of a specific truck

@ProviderFor(truckTalk)
final truckTalkProvider = TruckTalkFamily._();

/// Provider for watching talk messages of a specific truck

final class TruckTalkProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TalkMessage>>,
          List<TalkMessage>,
          Stream<List<TalkMessage>>
        >
    with
        $FutureModifier<List<TalkMessage>>,
        $StreamProvider<List<TalkMessage>> {
  /// Provider for watching talk messages of a specific truck
  TruckTalkProvider._({
    required TruckTalkFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckTalkProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckTalkHash();

  @override
  String toString() {
    return r'truckTalkProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TalkMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TalkMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return truckTalk(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckTalkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckTalkHash() => r'9300b624656b342f3e955b72093a62d23bef8948';

/// Provider for watching talk messages of a specific truck

final class TruckTalkFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TalkMessage>>, String> {
  TruckTalkFamily._()
    : super(
        retry: null,
        name: r'truckTalkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching talk messages of a specific truck

  TruckTalkProvider call(String truckId) =>
      TruckTalkProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckTalkProvider';
}
