// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_verification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(visitVerificationService)
final visitVerificationServiceProvider = VisitVerificationServiceProvider._();

final class VisitVerificationServiceProvider
    extends
        $FunctionalProvider<
          VisitVerificationService,
          VisitVerificationService,
          VisitVerificationService
        >
    with $Provider<VisitVerificationService> {
  VisitVerificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitVerificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitVerificationServiceHash();

  @$internal
  @override
  $ProviderElement<VisitVerificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VisitVerificationService create(Ref ref) {
    return visitVerificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VisitVerificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VisitVerificationService>(value),
    );
  }
}

String _$visitVerificationServiceHash() =>
    r'2f14132210d7d64171931b3b00fb5ef487b2d5eb';
