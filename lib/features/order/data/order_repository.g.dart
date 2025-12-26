// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRepositoryHash() => r'9253d73f04ce8fb2e624da9bd81ad25a644540cd';

/// See also [orderRepository].
@ProviderFor(orderRepository)
final orderRepositoryProvider = AutoDisposeProvider<OrderRepository>.internal(
  orderRepository,
  name: r'orderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderRepositoryRef = AutoDisposeProviderRef<OrderRepository>;
String _$userOrdersHash() => r'fad867b94a6045b524701a79f1b91c313e218fb3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for watching user orders
///
/// Copied from [userOrders].
@ProviderFor(userOrders)
const userOrdersProvider = UserOrdersFamily();

/// Provider for watching user orders
///
/// Copied from [userOrders].
class UserOrdersFamily extends Family<AsyncValue<List<domain.Order>>> {
  /// Provider for watching user orders
  ///
  /// Copied from [userOrders].
  const UserOrdersFamily();

  /// Provider for watching user orders
  ///
  /// Copied from [userOrders].
  UserOrdersProvider call(String userId) {
    return UserOrdersProvider(userId);
  }

  @override
  UserOrdersProvider getProviderOverride(
    covariant UserOrdersProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userOrdersProvider';
}

/// Provider for watching user orders
///
/// Copied from [userOrders].
class UserOrdersProvider extends AutoDisposeStreamProvider<List<domain.Order>> {
  /// Provider for watching user orders
  ///
  /// Copied from [userOrders].
  UserOrdersProvider(String userId)
    : this._internal(
        (ref) => userOrders(ref as UserOrdersRef, userId),
        from: userOrdersProvider,
        name: r'userOrdersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userOrdersHash,
        dependencies: UserOrdersFamily._dependencies,
        allTransitiveDependencies: UserOrdersFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserOrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<domain.Order>> Function(UserOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserOrdersProvider._internal(
        (ref) => create(ref as UserOrdersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<domain.Order>> createElement() {
    return _UserOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserOrdersProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserOrdersRef on AutoDisposeStreamProviderRef<List<domain.Order>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserOrdersProviderElement
    extends AutoDisposeStreamProviderElement<List<domain.Order>>
    with UserOrdersRef {
  _UserOrdersProviderElement(super.provider);

  @override
  String get userId => (origin as UserOrdersProvider).userId;
}

String _$truckOrdersHash() => r'b76284d25f7e6ad1ccabdbebbd8c0ab9e5758eef';

/// Provider for watching truck orders
///
/// Copied from [truckOrders].
@ProviderFor(truckOrders)
const truckOrdersProvider = TruckOrdersFamily();

/// Provider for watching truck orders
///
/// Copied from [truckOrders].
class TruckOrdersFamily extends Family<AsyncValue<List<domain.Order>>> {
  /// Provider for watching truck orders
  ///
  /// Copied from [truckOrders].
  const TruckOrdersFamily();

  /// Provider for watching truck orders
  ///
  /// Copied from [truckOrders].
  TruckOrdersProvider call(String truckId) {
    return TruckOrdersProvider(truckId);
  }

  @override
  TruckOrdersProvider getProviderOverride(
    covariant TruckOrdersProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckOrdersProvider';
}

/// Provider for watching truck orders
///
/// Copied from [truckOrders].
class TruckOrdersProvider
    extends AutoDisposeStreamProvider<List<domain.Order>> {
  /// Provider for watching truck orders
  ///
  /// Copied from [truckOrders].
  TruckOrdersProvider(String truckId)
    : this._internal(
        (ref) => truckOrders(ref as TruckOrdersRef, truckId),
        from: truckOrdersProvider,
        name: r'truckOrdersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckOrdersHash,
        dependencies: TruckOrdersFamily._dependencies,
        allTransitiveDependencies: TruckOrdersFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckOrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Override overrideWith(
    Stream<List<domain.Order>> Function(TruckOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckOrdersProvider._internal(
        (ref) => create(ref as TruckOrdersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<domain.Order>> createElement() {
    return _TruckOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckOrdersProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckOrdersRef on AutoDisposeStreamProviderRef<List<domain.Order>> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckOrdersProviderElement
    extends AutoDisposeStreamProviderElement<List<domain.Order>>
    with TruckOrdersRef {
  _TruckOrdersProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckOrdersProvider).truckId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
