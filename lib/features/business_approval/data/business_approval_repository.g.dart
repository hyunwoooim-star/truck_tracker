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
    r'c0367b8db52b95ee925c65a63adfbaa279a267c5';

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

String _$businessApprovalHash() => r'105bb5c1757fc624f93f1bf56b06fe932f621d3b';

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

String _$pendingApprovalsHash() => r'945762088195058c022bfb3a7d965ee2a88e7bff';

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

String _$allApprovalsHash() => r'2d71144cf63b7d192c3378dd80bb3f386939eb1c';
