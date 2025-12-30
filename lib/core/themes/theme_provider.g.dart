// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing app theme mode with persistence

@ProviderFor(AppThemeModeNotifier)
final appThemeModeProvider = AppThemeModeNotifierProvider._();

/// Provider for managing app theme mode with persistence
final class AppThemeModeNotifierProvider
    extends $NotifierProvider<AppThemeModeNotifier, AppThemeMode> {
  /// Provider for managing app theme mode with persistence
  AppThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeNotifierHash();

  @$internal
  @override
  AppThemeModeNotifier create() => AppThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeMode>(value),
    );
  }
}

String _$appThemeModeNotifierHash() =>
    r'5e0f336f9cc0b7ab219b09bf5e2479d4e742012d';

/// Provider for managing app theme mode with persistence

abstract class _$AppThemeModeNotifier extends $Notifier<AppThemeMode> {
  AppThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppThemeMode, AppThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeMode, AppThemeMode>,
              AppThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that returns the actual ThemeData based on current mode

@ProviderFor(currentTheme)
final currentThemeProvider = CurrentThemeProvider._();

/// Provider that returns the actual ThemeData based on current mode

final class CurrentThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provider that returns the actual ThemeData based on current mode
  CurrentThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return currentTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$currentThemeHash() => r'df1c55be6ff4b27eb9e882f5a032d8e1922d19f4';

/// Provider that returns ThemeMode for MaterialApp

@ProviderFor(appThemeModeForMaterial)
final appThemeModeForMaterialProvider = AppThemeModeForMaterialProvider._();

/// Provider that returns ThemeMode for MaterialApp

final class AppThemeModeForMaterialProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  /// Provider that returns ThemeMode for MaterialApp
  AppThemeModeForMaterialProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeForMaterialProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeForMaterialHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return appThemeModeForMaterial(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appThemeModeForMaterialHash() =>
    r'a2d0255ecf4e72a361279915c1f451888b4a3bcc';
