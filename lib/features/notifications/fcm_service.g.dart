// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for FCM Service with proper lifecycle management

@ProviderFor(fcmService)
final fcmServiceProvider = FcmServiceProvider._();

/// Provider for FCM Service with proper lifecycle management

final class FcmServiceProvider
    extends $FunctionalProvider<FcmService, FcmService, FcmService>
    with $Provider<FcmService> {
  /// Provider for FCM Service with proper lifecycle management
  FcmServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmServiceHash();

  @$internal
  @override
  $ProviderElement<FcmService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FcmService create(Ref ref) {
    return fcmService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FcmService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FcmService>(value),
    );
  }
}

String _$fcmServiceHash() => r'81d627b3874e11a7a6429f537209968053ce9267';
