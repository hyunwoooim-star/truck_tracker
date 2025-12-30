import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/order/domain/order.dart';
import 'package:truck_tracker/features/owner_dashboard/presentation/widgets/owner_stats_card.dart';

void main() {
  group('OwnerStatsCard', () {
    testWidgets('displays correct stats for empty orders', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OwnerStatsCard(orders: []),
          ),
        ),
      );

      // Should display 0 for all stats
      expect(find.text('0'), findsWidgets);
      expect(find.text('₩0'), findsWidgets);
    });

    testWidgets('displays correct stats for orders', (tester) async {
      final orders = [
        Order(
          id: '1',
          userId: 'user1',
          userName: 'Customer 1',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 10000,
          status: OrderStatus.completed,
          paymentMethod: 'cash',
          createdAt: DateTime.now(),
        ),
        Order(
          id: '2',
          userId: 'user2',
          userName: 'Customer 2',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 15000,
          status: OrderStatus.pending,
          paymentMethod: 'online',
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OwnerStatsCard(orders: orders),
          ),
        ),
      );

      // Should display order count
      expect(find.text('2'), findsOneWidget);

      // Should display completed count
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('shows today icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OwnerStatsCard(orders: []),
          ),
        ),
      );

      expect(find.byIcon(Icons.today), findsOneWidget);
    });

    testWidgets('shows revenue icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OwnerStatsCard(orders: []),
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('shows cash and online icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OwnerStatsCard(orders: []),
          ),
        ),
      );

      expect(find.byIcon(Icons.payments), findsOneWidget);
      expect(find.byIcon(Icons.credit_card), findsOneWidget);
    });
  });

  group('Order filtering', () {
    test('filters orders by today', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      final orders = [
        Order(
          id: '1',
          userId: 'user1',
          userName: 'Today Order',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 10000,
          status: OrderStatus.completed,
          createdAt: today,
        ),
        Order(
          id: '2',
          userId: 'user2',
          userName: 'Yesterday Order',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 15000,
          status: OrderStatus.completed,
          createdAt: yesterday,
        ),
      ];

      final todayOrders = orders.where((order) {
        if (order.createdAt == null) return false;
        final orderDate = order.createdAt!;
        return orderDate.year == today.year &&
            orderDate.month == today.month &&
            orderDate.day == today.day;
      }).toList();

      expect(todayOrders.length, 1);
      expect(todayOrders.first.userName, 'Today Order');
    });

    test('calculates revenue correctly', () {
      final orders = [
        Order(
          id: '1',
          userId: 'user1',
          userName: 'Customer',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 10000,
          status: OrderStatus.completed,
        ),
        Order(
          id: '2',
          userId: 'user2',
          userName: 'Customer',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 15000,
          status: OrderStatus.completed,
        ),
        Order(
          id: '3',
          userId: 'user3',
          userName: 'Customer',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 20000,
          status: OrderStatus.pending, // Not completed, shouldn't count
        ),
      ];

      final totalRevenue = orders
          .where((o) => o.status == OrderStatus.completed)
          .fold<int>(0, (sum, order) => sum + order.totalAmount);

      expect(totalRevenue, 25000); // 10000 + 15000
    });

    test('separates cash and online revenue', () {
      final orders = [
        Order(
          id: '1',
          userId: 'user1',
          userName: 'Cash Customer',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 10000,
          status: OrderStatus.completed,
          paymentMethod: 'cash',
        ),
        Order(
          id: '2',
          userId: 'user2',
          userName: 'Online Customer',
          truckId: 'truck1',
          truckName: 'Truck',
          items: [],
          totalAmount: 15000,
          status: OrderStatus.completed,
          paymentMethod: 'card',
        ),
      ];

      final cashRevenue = orders
          .where((o) => o.paymentMethod == 'cash' && o.status == OrderStatus.completed)
          .fold<int>(0, (sum, o) => sum + o.totalAmount);

      final onlineRevenue = orders
          .where((o) => o.paymentMethod != 'cash' && o.status == OrderStatus.completed)
          .fold<int>(0, (sum, o) => sum + o.totalAmount);

      expect(cashRevenue, 10000);
      expect(onlineRevenue, 15000);
    });
  });
}
