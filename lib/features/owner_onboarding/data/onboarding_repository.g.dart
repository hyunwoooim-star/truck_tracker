// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ownerOnboardingRepository)
final ownerOnboardingRepositoryProvider = OwnerOnboardingRepositoryProvider._();

final class OwnerOnboardingRepositoryProvider
    extends
        $FunctionalProvider<
          OwnerOnboardingRepository,
          OwnerOnboardingRepository,
          OwnerOnboardingRepository
        >
    with $Provider<OwnerOnboardingRepository> {
  OwnerOnboardingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerOnboardingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerOnboardingRepositoryHash();

  @$internal
  @override
  $ProviderElement<OwnerOnboardingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OwnerOnboardingRepository create(Ref ref) {
    return ownerOnboardingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OwnerOnboardingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OwnerOnboardingRepository>(value),
    );
  }
}

String _$ownerOnboardingRepositoryHash() =>
    r'0a7c26a82d80d1c347a28eaeac83b576002deba0';
