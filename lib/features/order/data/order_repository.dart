import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/order.dart' as domain;

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
  Future<String> placeOrder(domain.Order order) async {
    debugPrint('🛒 OrderRepository: Placing order');
    debugPrint('   Truck ID: ${order.truckId}');
    debugPrint('   User: ${order.userName}');
    debugPrint('   Items: ${order.items.length}');
    debugPrint('   Total: ₩${order.totalAmount}');

    try {
      final docRef = await _ordersCollection.add(order.toFirestore());

      debugPrint('✅ Order placed: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error placing order: $e');
      rethrow;
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, domain.OrderStatus status) async {
    debugPrint('🛒 OrderRepository: Updating order $orderId to $status');

    try {
      await _ordersCollection.doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Order status updated');
    } catch (e) {
      debugPrint('❌ Error updating order status: $e');
      rethrow;
    }
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId) async {
    debugPrint('🛒 OrderRepository: Cancelling order $orderId');

    try {
      await updateOrderStatus(orderId, domain.OrderStatus.cancelled);
      debugPrint('✅ Order cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling order: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Watch orders for a user (real-time stream)
  Stream<List<domain.Order>> watchUserOrders(String userId) {
    debugPrint('📡 OrderRepository: Watching orders for user $userId');

    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        try {
          return domain.Order.fromFirestore(doc);
        } catch (e) {
          debugPrint('⚠️ Error parsing order ${doc.id}: $e');
          return null;
        }
      }).whereType<domain.Order>().toList();

      debugPrint('📡 Loaded ${orders.length} orders for user $userId');
      return orders;
    });
  }

  /// Watch orders for a truck (real-time stream)
  Stream<List<domain.Order>> watchTruckOrders(String truckId) {
    debugPrint('📡 OrderRepository: Watching orders for truck $truckId');

    return _ordersCollection
        .where('truckId', isEqualTo: truckId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        try {
          return domain.Order.fromFirestore(doc);
        } catch (e) {
          debugPrint('⚠️ Error parsing order ${doc.id}: $e');
          return null;
        }
      }).whereType<domain.Order>().toList();

      debugPrint('📡 Loaded ${orders.length} orders for truck $truckId');
      return orders;
    });
  }

  /// Get orders for a user (one-time fetch)
  Future<List<domain.Order>> getUserOrders(String userId) async {
    debugPrint('🛒 OrderRepository: Fetching orders for user $userId');

    try {
      final snapshot = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final orders =
          snapshot.docs.map((doc) => domain.Order.fromFirestore(doc)).toList();

      debugPrint('✅ Fetched ${orders.length} orders');
      return orders;
    } catch (e) {
      debugPrint('❌ Error fetching orders: $e');
      return [];
    }
  }

  /// Get orders for a truck (one-time fetch)
  Future<List<domain.Order>> getTruckOrders(String truckId) async {
    debugPrint('🛒 OrderRepository: Fetching orders for truck $truckId');

    try {
      final snapshot = await _ordersCollection
          .where('truckId', isEqualTo: truckId)
          .orderBy('createdAt', descending: true)
          .get();

      final orders =
          snapshot.docs.map((doc) => domain.Order.fromFirestore(doc)).toList();

      debugPrint('✅ Fetched ${orders.length} orders');
      return orders;
    } catch (e) {
      debugPrint('❌ Error fetching orders: $e');
      return [];
    }
  }

  /// Get single order by ID
  Future<domain.Order?> getOrder(String orderId) async {
    debugPrint('🛒 OrderRepository: Fetching order $orderId');

    try {
      final doc = await _ordersCollection.doc(orderId).get();

      if (!doc.exists) {
        debugPrint('⚠️ Order not found');
        return null;
      }

      final order = domain.Order.fromFirestore(doc);
      debugPrint('✅ Order fetched');
      return order;
    } catch (e) {
      debugPrint('❌ Error fetching order: $e');
      return null;
    }
  }
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository();
}

/// Provider for watching user orders
@riverpod
Stream<List<domain.Order>> userOrders(UserOrdersRef ref, String userId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchUserOrders(userId);
}

/// Provider for watching truck orders
@riverpod
Stream<List<domain.Order>> truckOrders(TruckOrdersRef ref, String truckId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchTruckOrders(truckId);
}
