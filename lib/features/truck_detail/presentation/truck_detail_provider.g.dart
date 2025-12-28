// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(truckDetailRepository)
final truckDetailRepositoryProvider = TruckDetailRepositoryProvider._();

final class TruckDetailRepositoryProvider
    extends
        $FunctionalProvider<
          TruckDetailRepository,
          TruckDetailRepository,
          TruckDetailRepository
        >
    with $Provider<TruckDetailRepository> {
  TruckDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'truckDetailRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$truckDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<TruckDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TruckDetailRepository create(Ref ref) {
    return truckDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruckDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruckDetailRepository>(value),
    );
  }
}

String _$truckDetailRepositoryHash() =>
    r'1d4c3ed1a7745fb9d03d9c0cb4fed1e060f8924a';

@ProviderFor(truckDetailStream)
final truckDetailStreamProvider = TruckDetailStreamFamily._();

final class TruckDetailStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<TruckDetail?>,
          TruckDetail?,
          Stream<TruckDetail?>
        >
    with $FutureModifier<TruckDetail?>, $StreamProvider<TruckDetail?> {
  TruckDetailStreamProvider._({
    required TruckDetailStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckDetailStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckDetailStreamHash();

  @override
  String toString() {
    return r'truckDetailStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<TruckDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TruckDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return truckDetailStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckDetailStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckDetailStreamHash() => r'b9caf473d44857f9f332b86a7efb40965120de75';

final class TruckDetailStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<TruckDetail?>, String> {
  TruckDetailStreamFamily._()
    : super(
        retry: null,
        name: r'truckDetailStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TruckDetailStreamProvider call(String truckId) =>
      TruckDetailStreamProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckDetailStreamProvider';
}

@ProviderFor(TruckDetailNotifier)
final truckDetailProvider = TruckDetailNotifierFamily._();

final class TruckDetailNotifierProvider
    extends $StreamNotifierProvider<TruckDetailNotifier, TruckDetail?> {
  TruckDetailNotifierProvider._({
    required TruckDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckDetailNotifierHash();

  @override
  String toString() {
    return r'truckDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TruckDetailNotifier create() => TruckDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is TruckDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckDetailNotifierHash() =>
    r'e1a387b23f94f06f1109d2d25a7f3fe42a5a6fd8';

final class TruckDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TruckDetailNotifier,
          AsyncValue<TruckDetail?>,
          TruckDetail?,
          Stream<TruckDetail?>,
          String
        > {
  TruckDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'truckDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TruckDetailNotifierProvider call(String truckId) =>
      TruckDetailNotifierProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckDetailProvider';
}

abstract class _$TruckDetailNotifier extends $StreamNotifier<TruckDetail?> {
  late final _$args = ref.$arg as String;
  String get truckId => _$args;

  Stream<TruckDetail?> build(String truckId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TruckDetail?>, TruckDetail?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TruckDetail?>, TruckDetail?>,
              AsyncValue<TruckDetail?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
