// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminStatsRepository)
final adminStatsRepositoryProvider = AdminStatsRepositoryProvider._();

final class AdminStatsRepositoryProvider
    extends
        $FunctionalProvider<
          AdminStatsRepository,
          AdminStatsRepository,
          AdminStatsRepository
        >
    with $Provider<AdminStatsRepository> {
  AdminStatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminStatsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminStatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminStatsRepository create(Ref ref) {
    return adminStatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminStatsRepository>(value),
    );
  }
}

String _$adminStatsRepositoryHash() =>
    r'32832ffd79f8ded4de94c2941e83543de286eb55';

@ProviderFor(adminStats)
final adminStatsProvider = AdminStatsProvider._();

final class AdminStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminStats>,
          AdminStats,
          Stream<AdminStats>
        >
    with $FutureModifier<AdminStats>, $StreamProvider<AdminStats> {
  AdminStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminStatsHash();

  @$internal
  @override
  $StreamProviderElement<AdminStats> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AdminStats> create(Ref ref) {
    return adminStats(ref);
  }
}

String _$adminStatsHash() => r'0f1341cc0d3b5388541ce51f3aa6b74a39ba20fa';

@ProviderFor(pendingOwnerRequests)
final pendingOwnerRequestsProvider = PendingOwnerRequestsProvider._();

final class PendingOwnerRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  PendingOwnerRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingOwnerRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingOwnerRequestsHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return pendingOwnerRequests(ref);
  }
}

String _$pendingOwnerRequestsHash() =>
    r'ad06d30ee79384fc8382fe005952a357f8a6e610';

@ProviderFor(recentAdminActivity)
final recentAdminActivityProvider = RecentAdminActivityProvider._();

final class RecentAdminActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  RecentAdminActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentAdminActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentAdminActivityHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return recentAdminActivity(ref);
  }
}

String _$recentAdminActivityHash() =>
    r'b3dc2b83648683b99d6695ecaee215431f5dfd80';
