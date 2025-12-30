// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentRepository)
final paymentRepositoryProvider = PaymentRepositoryProvider._();

final class PaymentRepositoryProvider
    extends
        $FunctionalProvider<
          PaymentRepository,
          PaymentRepository,
          PaymentRepository
        >
    with $Provider<PaymentRepository> {
  PaymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentRepositoryHash();

  @$internal
  @override
  $ProviderElement<PaymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PaymentRepository create(Ref ref) {
    return paymentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentRepository>(value),
    );
  }
}

String _$paymentRepositoryHash() => r'65159e4619b91a7710c12a462323736a42f7b914';

/// Provider for watching user payments

@ProviderFor(userPayments)
final userPaymentsProvider = UserPaymentsFamily._();

/// Provider for watching user payments

final class UserPaymentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          Stream<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $StreamProvider<List<Payment>> {
  /// Provider for watching user payments
  UserPaymentsProvider._({
    required UserPaymentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userPaymentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userPaymentsHash();

  @override
  String toString() {
    return r'userPaymentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Payment>> create(Ref ref) {
    final argument = this.argument as String;
    return userPayments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPaymentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userPaymentsHash() => r'a1fdec85c59a8b1f07f904bd9d9c48a6f224fbec';

/// Provider for watching user payments

final class UserPaymentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Payment>>, String> {
  UserPaymentsFamily._()
    : super(
        retry: null,
        name: r'userPaymentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching user payments

  UserPaymentsProvider call(String userId) =>
      UserPaymentsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userPaymentsProvider';
}
