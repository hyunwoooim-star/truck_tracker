import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/order/domain/order.dart';
import 'package:truck_tracker/features/order/domain/cart_item.dart';

void main() {
  group('Order model', () {
    test('creates Order with all required fields', () {
      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        userName: 'Test User',
        truckId: 'truck-789',
        truckName: 'Test Truck',
        items: [
          const CartItem(
            menuItemId: 'menu-1',
            name: 'Taco',
            price: 5000,
            quantity: 2,
          ),
        ],
        totalAmount: 10000,
        status: OrderStatus.pending,
        createdAt: DateTime(2025, 12, 29),
      );

      expect(order.id, 'order-123');
      expect(order.userId, 'user-456');
      expect(order.userName, 'Test User');
      expect(order.truckId, 'truck-789');
      expect(order.truckName, 'Test Truck');
      expect(order.items.length, 1);
      expect(order.totalAmount, 10000);
      expect(order.status, OrderStatus.pending);
    });

    test('default values are applied', () {
      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        userName: 'Test User',
        truckId: 'truck-789',
        truckName: 'Test Truck',
        items: [],
        totalAmount: 0,
        status: OrderStatus.pending,
      );

      expect(order.specialRequests, '');
      expect(order.paymentMethod, 'card');
      expect(order.source, 'customer');
      expect(order.itemName, isNull);
      expect(order.createdAt, isNull);
      expect(order.updatedAt, isNull);
    });

    test('toFirestore converts order correctly', () {
      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        userName: 'Test User',
        truckId: 'truck-789',
        truckName: 'Test Truck',
        items: [
          const CartItem(
            menuItemId: 'menu-1',
            name: 'Burger',
            price: 8000,
            quantity: 1,
          ),
        ],
        totalAmount: 8000,
        status: OrderStatus.confirmed,
        specialRequests: 'No onions',
        paymentMethod: 'cash',
        source: 'manual',
        itemName: 'Burger',
      );

      final firestore = order.toFirestore();

      expect(firestore['userId'], 'user-456');
      expect(firestore['userName'], 'Test User');
      expect(firestore['truckId'], 'truck-789');
      expect(firestore['truckName'], 'Test Truck');
      expect(firestore['totalAmount'], 8000);
      expect(firestore['status'], 'confirmed');
      expect(firestore['specialRequests'], 'No onions');
      expect(firestore['paymentMethod'], 'cash');
      expect(firestore['source'], 'manual');
      expect(firestore['itemName'], 'Burger');
      expect(firestore['items'], isA<List>());
    });
  });

  group('OrderStatus', () {
    test('has all expected values', () {
      expect(OrderStatus.values, contains(OrderStatus.pending));
      expect(OrderStatus.values, contains(OrderStatus.confirmed));
      expect(OrderStatus.values, contains(OrderStatus.preparing));
      expect(OrderStatus.values, contains(OrderStatus.ready));
      expect(OrderStatus.values, contains(OrderStatus.completed));
      expect(OrderStatus.values, contains(OrderStatus.cancelled));
      expect(OrderStatus.values.length, 6);
    });

    test('status name conversion works correctly', () {
      expect(OrderStatus.pending.name, 'pending');
      expect(OrderStatus.confirmed.name, 'confirmed');
      expect(OrderStatus.preparing.name, 'preparing');
      expect(OrderStatus.ready.name, 'ready');
      expect(OrderStatus.completed.name, 'completed');
      expect(OrderStatus.cancelled.name, 'cancelled');
    });
  });

  group('CartItem', () {
    test('creates CartItem with required fields', () {
      const item = CartItem(
        menuItemId: 'menu-1',
        name: 'Taco',
        price: 5000,
        quantity: 2,
      );

      expect(item.menuItemId, 'menu-1');
      expect(item.name, 'Taco');
      expect(item.price, 5000);
      expect(item.quantity, 2);
    });

    test('CartItem toJson works correctly', () {
      const item = CartItem(
        menuItemId: 'menu-1',
        name: 'Taco',
        price: 5000,
        quantity: 2,
      );

      final json = item.toJson();

      expect(json['menuItemId'], 'menu-1');
      expect(json['name'], 'Taco');
      expect(json['price'], 5000);
      expect(json['quantity'], 2);
    });

    test('CartItem fromJson works correctly', () {
      final json = {
        'menuItemId': 'menu-2',
        'name': 'Burrito',
        'price': 7000,
        'quantity': 3,
      };

      final item = CartItem.fromJson(json);

      expect(item.menuItemId, 'menu-2');
      expect(item.name, 'Burrito');
      expect(item.price, 7000);
      expect(item.quantity, 3);
    });
  });
}
