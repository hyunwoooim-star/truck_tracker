// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for AppVersionService

@ProviderFor(appVersionService)
final appVersionServiceProvider = AppVersionServiceProvider._();

/// Provider for AppVersionService

final class AppVersionServiceProvider
    extends
        $FunctionalProvider<
          AppVersionService,
          AppVersionService,
          AppVersionService
        >
    with $Provider<AppVersionService> {
  /// Provider for AppVersionService
  AppVersionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionServiceHash();

  @$internal
  @override
  $ProviderElement<AppVersionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppVersionService create(Ref ref) {
    return appVersionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppVersionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppVersionService>(value),
    );
  }
}

String _$appVersionServiceHash() => r'5d2d6a05eb796f427cd25c0d55ae04840c017491';

/// Provider for version check result

@ProviderFor(versionCheck)
final versionCheckProvider = VersionCheckProvider._();

/// Provider for version check result

final class VersionCheckProvider
    extends
        $FunctionalProvider<
          AsyncValue<VersionCheckResult>,
          VersionCheckResult,
          FutureOr<VersionCheckResult>
        >
    with
        $FutureModifier<VersionCheckResult>,
        $FutureProvider<VersionCheckResult> {
  /// Provider for version check result
  VersionCheckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionCheckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionCheckHash();

  @$internal
  @override
  $FutureProviderElement<VersionCheckResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VersionCheckResult> create(Ref ref) {
    return versionCheck(ref);
  }
}

String _$versionCheckHash() => r'd5dead38b3c470e990fdc9ceb310ddfbfba8e204';
