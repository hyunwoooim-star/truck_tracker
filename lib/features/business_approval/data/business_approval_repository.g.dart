// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_approval_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(businessApprovalRepository)
final businessApprovalRepositoryProvider =
    BusinessApprovalRepositoryProvider._();

final class BusinessApprovalRepositoryProvider
    extends
        $FunctionalProvider<
          BusinessApprovalRepository,
          BusinessApprovalRepository,
          BusinessApprovalRepository
        >
    with $Provider<BusinessApprovalRepository> {
  BusinessApprovalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessApprovalRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessApprovalRepositoryHash();

  @$internal
  @override
  $ProviderElement<BusinessApprovalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BusinessApprovalRepository create(Ref ref) {
    return businessApprovalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BusinessApprovalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BusinessApprovalRepository>(value),
    );
  }
}

String _$businessApprovalRepositoryHash() =>
    r'405cc1258b36b387dd330a59e8ba9618a8d74630';

@ProviderFor(businessApproval)
final businessApprovalProvider = BusinessApprovalFamily._();

final class BusinessApprovalProvider
    extends
        $FunctionalProvider<
          AsyncValue<BusinessApproval?>,
          BusinessApproval?,
          Stream<BusinessApproval?>
        >
    with
        $FutureModifier<BusinessApproval?>,
        $StreamProvider<BusinessApproval?> {
  BusinessApprovalProvider._({
    required BusinessApprovalFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'businessApprovalProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$businessApprovalHash();

  @override
  String toString() {
    return r'businessApprovalProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<BusinessApproval?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BusinessApproval?> create(Ref ref) {
    final argument = this.argument as String;
    return businessApproval(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessApprovalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$businessApprovalHash() => r'480be646aa97e6bdb8fcd3841c199496b7cfdd59';

final class BusinessApprovalFamily extends $Family
    with $FunctionalFamilyOverride<Stream<BusinessApproval?>, String> {
  BusinessApprovalFamily._()
    : super(
        retry: null,
        name: r'businessApprovalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BusinessApprovalProvider call(String truckId) =>
      BusinessApprovalProvider._(argument: truckId, from: this);

  @override
  String toString() => r'businessApprovalProvider';
}

@ProviderFor(pendingApprovals)
final pendingApprovalsProvider = PendingApprovalsProvider._();

final class PendingApprovalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BusinessApproval>>,
          List<BusinessApproval>,
          Stream<List<BusinessApproval>>
        >
    with
        $FutureModifier<List<BusinessApproval>>,
        $StreamProvider<List<BusinessApproval>> {
  PendingApprovalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingApprovalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingApprovalsHash();

  @$internal
  @override
  $StreamProviderElement<List<BusinessApproval>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BusinessApproval>> create(Ref ref) {
    return pendingApprovals(ref);
  }
}

String _$pendingApprovalsHash() => r'fa881415bb1145ab49bb2d19875f1e719d872197';

@ProviderFor(allApprovals)
final allApprovalsProvider = AllApprovalsProvider._();

final class AllApprovalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BusinessApproval>>,
          List<BusinessApproval>,
          Stream<List<BusinessApproval>>
        >
    with
        $FutureModifier<List<BusinessApproval>>,
        $StreamProvider<List<BusinessApproval>> {
  AllApprovalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allApprovalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allApprovalsHash();

  @$internal
  @override
  $StreamProviderElement<List<BusinessApproval>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BusinessApproval>> create(Ref ref) {
    return allApprovals(ref);
  }
}

String _$allApprovalsHash() => r'47f54eed97af5ff89563e2a8bfa91efaffe35efe';
