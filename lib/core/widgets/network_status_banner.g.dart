// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_status_banner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for network connectivity status

@ProviderFor(NetworkStatusNotifier)
final networkStatusProvider = NetworkStatusNotifierProvider._();

/// Provider for network connectivity status
final class NetworkStatusNotifierProvider
    extends $NotifierProvider<NetworkStatusNotifier, NetworkStatus> {
  /// Provider for network connectivity status
  NetworkStatusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkStatusNotifierHash();

  @$internal
  @override
  NetworkStatusNotifier create() => NetworkStatusNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkStatus>(value),
    );
  }
}

String _$networkStatusNotifierHash() =>
    r'0b68c299e911cdd216aa50b899168d6177607b9b';

/// Provider for network connectivity status

abstract class _$NetworkStatusNotifier extends $Notifier<NetworkStatus> {
  NetworkStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NetworkStatus, NetworkStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkStatus, NetworkStatus>,
              NetworkStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
