import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/order.dart';

part 'order_repository.g.dart';

/// Repository for managing orders
class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  // ═══════════════════════════════════════════════════════════
  // WRITE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Place a new order
  Future<String> placeOrder(Order order) async {
    AppLogger.debug('Placing order', tag: 'OrderRepository');
    AppLogger.debug('Truck ID: ${order.truckId}', tag: 'OrderRepository');
    AppLogger.debug('User: ${order.userName}', tag: 'OrderRepository');
    AppLogger.debug('Items: ${order.items.length}', tag: 'OrderRepository');
    AppLogger.debug('Total: ₩${order.totalAmount}', tag: 'OrderRepository');

    try {
      final docRef = await _ordersCollection.add(order.toFirestore());

      AppLogger.success('Order placed: ${docRef.id}', tag: 'OrderRepository');
      return docRef.id;
    } catch (e, stackTrace) {
      AppLogger.error('Error placing order', error: e, stackTrace: stackTrace, tag: 'OrderRepository');
      rethrow;
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    AppLogger.debug('Updating order $orderId to $status', tag: 'OrderRepository');

    try {
      await _ordersCollection.doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Order status updated', tag: 'OrderRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating order status', error: e, stackTrace: stackTrace, tag: 'OrderRepository');
      rethrow;
    }
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId) async {
    AppLogger.debug('Cancelling order $orderId', tag: 'OrderRepository');

    try {
      await updateOrderStatus(orderId, OrderStatus.cancelled);
      AppLogger.success('Order cancelled', tag: 'OrderRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error cancelling order', error: e, stackTrace: stackTrace, tag: 'OrderRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Watch orders for a user (real-time stream)
  Stream<List<Order>> watchUserOrders(String userId) {
    AppLogger.debug('Watching orders for user $userId', tag: 'OrderRepository');

    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(100) // Limit to recent 100 orders for performance
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        try {
          return Order.fromFirestore(doc);
        } catch (e, stackTrace) {
          AppLogger.warning('Error parsing order ${doc.id}', tag: 'OrderRepository');
          return null;
        }
      }).whereType<Order>().toList();

      AppLogger.debug('Loaded ${orders.length} orders for user $userId', tag: 'OrderRepository');
      return orders;
    });
  }

  /// Watch orders for a truck (real-time stream)
  Stream<List<Order>> watchTruckOrders(String truckId) {
    AppLogger.debug('Watching orders for truck $truckId', tag: 'OrderRepository');

    return _ordersCollection
        .where('truckId', isEqualTo: truckId)
        .orderBy('createdAt', descending: true)
        .limit(50) // Limit to recent 50 orders for performance
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        try {
          return Order.fromFirestore(doc);
        } catch (e, stackTrace) {
          AppLogger.warning('Error parsing order ${doc.id}', tag: 'OrderRepository');
          return null;
        }
      }).whereType<Order>().toList();

      AppLogger.debug('Loaded ${orders.length} orders for truck $truckId', tag: 'OrderRepository');
      return orders;
    });
  }

  /// Get orders for a user (one-time fetch)
  Future<List<Order>> getUserOrders(String userId) async {
    AppLogger.debug('Fetching orders for user $userId', tag: 'OrderRepository');

    try {
      final snapshot = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final orders =
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();

      AppLogger.success('Fetched ${orders.length} orders', tag: 'OrderRepository');
      return orders;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching orders', error: e, stackTrace: stackTrace, tag: 'OrderRepository');
      return [];
    }
  }

  /// Get orders for a truck (one-time fetch)
  Future<List<Order>> getTruckOrders(String truckId) async {
    AppLogger.debug('Fetching orders for truck $truckId', tag: 'OrderRepository');

    try {
      final snapshot = await _ordersCollection
          .where('truckId', isEqualTo: truckId)
          .orderBy('createdAt', descending: true)
          .get();

      final orders =
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();

      AppLogger.success('Fetched ${orders.length} orders', tag: 'OrderRepository');
      return orders;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching orders', error: e, stackTrace: stackTrace, tag: 'OrderRepository');
      return [];
    }
  }

  /// Get single order by ID
  Future<Order?> getOrder(String orderId) async {
    AppLogger.debug('Fetching order $orderId', tag: 'OrderRepository');

    try {
      final doc = await _ordersCollection.doc(orderId).get();

      if (!doc.exists) {
        AppLogger.warning('Order not found', tag: 'OrderRepository');
        return null;
      }

      final order = Order.fromFirestore(doc);
      AppLogger.success('Order fetched', tag: 'OrderRepository');
      return order;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching order', error: e, stackTrace: stackTrace, tag: 'OrderRepository');
      return null;
    }
  }
}

@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepository();
}

/// Provider for watching user orders
@riverpod
Stream<List<Order>> userOrders(Ref ref, String userId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchUserOrders(userId);
}

/// Provider for watching truck orders
@riverpod
Stream<List<Order>> truckOrders(Ref ref, String truckId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchTruckOrders(truckId);
}
