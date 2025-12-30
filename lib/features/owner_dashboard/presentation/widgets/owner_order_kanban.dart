import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../order/data/order_repository.dart';
import '../../../order/domain/order.dart';

/// 주문 칸반 보드
class OwnerOrderKanban extends ConsumerWidget {
  final String truckId;

  const OwnerOrderKanban({super.key, required this.truckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(truckOrdersProvider(truckId));

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '주문 보드',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ordersAsync.when(
            data: (orders) {
              final pending =
                  orders.where((o) => o.status == OrderStatus.pending).toList();
              final preparing = orders
                  .where((o) => o.status == OrderStatus.preparing)
                  .toList();
              final ready =
                  orders.where((o) => o.status == OrderStatus.ready).toList();

              return SizedBox(
                height: 320,
                child: Row(
                  children: [
                    Expanded(
                      child: _KanbanColumn(
                        title: '대기',
                        orders: pending,
                        color: AppTheme.mustardYellow30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KanbanColumn(
                        title: '준비 중',
                        orders: preparing,
                        color: AppTheme.orange30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KanbanColumn(
                        title: '완료',
                        orders: ready,
                        color: AppTheme.green30,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.mustardYellow),
            ),
            error: (error, stackTrace) => const Center(
              child: Text(
                '주문 로딩 실패',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KanbanColumn extends ConsumerWidget {
  final String title;
  final List<Order> orders;
  final Color color;

  const _KanbanColumn({
    required this.title,
    required this.orders,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${orders.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Text(
                      '주문 없음',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _OrderCard(order: order);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.midnightCharcoal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.mustardYellow20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.userName,
            style: const TextStyle(
              color: AppTheme.mustardYellow,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.items.length} items - ₩${order.totalAmount}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order.status == OrderStatus.pending)
                IconButton(
                  icon: const Icon(Icons.arrow_forward,
                      color: AppTheme.mustardYellow, size: 20),
                  onPressed: () => _moveOrder(ref, order, OrderStatus.preparing),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (order.status == OrderStatus.preparing)
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green, size: 20),
                  onPressed: () => _moveOrder(ref, order, OrderStatus.ready),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _moveOrder(
      WidgetRef ref, Order order, OrderStatus newStatus) async {
    final repository = ref.read(orderRepositoryProvider);
    await repository.updateOrderStatus(order.id, newStatus);
  }
}
