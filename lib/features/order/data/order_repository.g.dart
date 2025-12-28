// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderRepository)
final orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'ad125924bfd6b4d7ba75c24a542b39f8aba0a469';

/// Provider for watching user orders

@ProviderFor(userOrders)
final userOrdersProvider = UserOrdersFamily._();

/// Provider for watching user orders

final class UserOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Order>>,
          List<Order>,
          Stream<List<Order>>
        >
    with $FutureModifier<List<Order>>, $StreamProvider<List<Order>> {
  /// Provider for watching user orders
  UserOrdersProvider._({
    required UserOrdersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userOrdersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userOrdersHash();

  @override
  String toString() {
    return r'userOrdersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Order>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Order>> create(Ref ref) {
    final argument = this.argument as String;
    return userOrders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserOrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userOrdersHash() => r'b82b31c74c9f616ce9824b81de3c48354584d6d4';

/// Provider for watching user orders

final class UserOrdersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Order>>, String> {
  UserOrdersFamily._()
    : super(
        retry: null,
        name: r'userOrdersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching user orders

  UserOrdersProvider call(String userId) =>
      UserOrdersProvider._(argument: userId, from: this);

  @override
  String toString() => r'userOrdersProvider';
}

/// Provider for watching truck orders

@ProviderFor(truckOrders)
final truckOrdersProvider = TruckOrdersFamily._();

/// Provider for watching truck orders

final class TruckOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Order>>,
          List<Order>,
          Stream<List<Order>>
        >
    with $FutureModifier<List<Order>>, $StreamProvider<List<Order>> {
  /// Provider for watching truck orders
  TruckOrdersProvider._({
    required TruckOrdersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckOrdersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckOrdersHash();

  @override
  String toString() {
    return r'truckOrdersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Order>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Order>> create(Ref ref) {
    final argument = this.argument as String;
    return truckOrders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckOrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckOrdersHash() => r'7dfda08ab320c1f5ff6bc17f18bd66dfd78f286b';

/// Provider for watching truck orders

final class TruckOrdersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Order>>, String> {
  TruckOrdersFamily._()
    : super(
        retry: null,
        name: r'truckOrdersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for watching truck orders

  TruckOrdersProvider call(String truckId) =>
      TruckOrdersProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckOrdersProvider';
}
