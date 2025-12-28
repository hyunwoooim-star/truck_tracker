// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for toggling favorite status

@ProviderFor(FavoriteToggle)
final favoriteToggleProvider = FavoriteToggleProvider._();

/// Provider for toggling favorite status
final class FavoriteToggleProvider
    extends $AsyncNotifierProvider<FavoriteToggle, bool> {
  /// Provider for toggling favorite status
  FavoriteToggleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteToggleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteToggleHash();

  @$internal
  @override
  FavoriteToggle create() => FavoriteToggle();
}

String _$favoriteToggleHash() => r'f2af315200ab9a5847324a7d7be6f83b41c2c602';

/// Provider for toggling favorite status

abstract class _$FavoriteToggle extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Temporary provider for truck ID (will be passed via constructor in UI)

@ProviderFor(favoriteTruckId)
final favoriteTruckIdProvider = FavoriteTruckIdProvider._();

/// Temporary provider for truck ID (will be passed via constructor in UI)

final class FavoriteTruckIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Temporary provider for truck ID (will be passed via constructor in UI)
  FavoriteTruckIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteTruckIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteTruckIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return favoriteTruckId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$favoriteTruckIdHash() => r'6bf088d50c6231570957555d01dce86fc6e6385c';
