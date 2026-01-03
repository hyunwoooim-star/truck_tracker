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
    final isBankTransfer = order.paymentMethod == 'bank_transfer';
    final depositorName = _extractDepositorName(order.specialRequests);

    return InkWell(
      onTap: () => _showOrderDetails(context, order),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.midnightCharcoal,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isBankTransfer ? AppTheme.orange30 : AppTheme.mustardYellow20,
            width: isBankTransfer ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.userName,
                    style: const TextStyle(
                      color: AppTheme.mustardYellow,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isBankTransfer)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.orange30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '계좌이체',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${order.items.length}개 메뉴 - ₩${_formatAmount(order.totalAmount)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            if (depositorName != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.orange, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    '입금: $depositorName',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (order.specialRequests.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '요청: ${order.specialRequests}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
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
                    tooltip: '준비 시작',
                  ),
                if (order.status == OrderStatus.preparing)
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green, size: 20),
                    onPressed: () => _moveOrder(ref, order, OrderStatus.ready),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: '준비 완료',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _extractDepositorName(String specialRequests) {
    if (specialRequests.isEmpty) return null;
    final match = RegExp(r'입금자명:\s*(.+)').firstMatch(specialRequests);
    return match?.group(1)?.trim();
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    final depositorName = _extractDepositorName(order.specialRequests);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: AppTheme.mustardYellow, size: 20),
            const SizedBox(width: 8),
            const Text('주문 상세', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: '주문자', value: order.userName),
              _DetailRow(label: '주문 ID', value: order.id.substring(0, 8)),
              if (order.paymentMethod == 'bank_transfer') ...[
                _DetailRow(label: '결제 방식', value: '계좌이체', valueColor: Colors.orange),
                if (depositorName != null)
                  _DetailRow(label: '입금자명', value: depositorName, valueColor: Colors.orange),
              ] else
                _DetailRow(label: '결제 방식', value: _getPaymentMethodLabel(order.paymentMethod)),
              const Divider(color: Colors.grey, height: 24),
              const Text(
                '주문 메뉴',
                style: TextStyle(
                  color: AppTheme.mustardYellow,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.menuName} x${item.quantity}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    Text(
                      '₩${_formatAmount(item.price * item.quantity)}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              )),
              const Divider(color: Colors.grey, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '총 금액',
                    style: TextStyle(
                      color: AppTheme.mustardYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₩${_formatAmount(order.totalAmount)}',
                    style: const TextStyle(
                      color: AppTheme.mustardYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (order.specialRequests.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  '요청사항',
                  style: TextStyle(
                    color: AppTheme.mustardYellow,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.specialRequests,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기', style: TextStyle(color: AppTheme.mustardYellow)),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'card':
        return '카드';
      case 'cash':
        return '현장결제';
      case 'kakao':
        return '카카오페이';
      case 'toss':
        return '토스';
      default:
        return method;
    }
  }

  Future<void> _moveOrder(
      WidgetRef ref, Order order, OrderStatus newStatus) async {
    final repository = ref.read(orderRepositoryProvider);
    await repository.updateOrderStatus(order.id, newStatus);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
