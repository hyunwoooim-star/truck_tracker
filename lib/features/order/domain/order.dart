import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus { pending, confirmed, preparing, ready, completed, cancelled }

/// Order model for customer orders
@freezed
class Order with _$Order {
  const Order._();

  const factory Order({
    required String id,
    required String userId,
    required String userName,
    required String truckId,
    required String truckName,
    required List<CartItem> items,
    required int totalAmount,
    required OrderStatus status,
    @Default('') String specialRequests,
    @Default('card') String paymentMethod, // 'card', 'cash', 'kakao', 'toss'
    @Default('customer') String source, // 'customer', 'manual' (for cash sales)
    String? itemName, // Simple item name for manual cash sales
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Create from Firestore document
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle both new schema (items + totalAmount) and legacy schema (itemName + amount)
    final items = (data['items'] as List<dynamic>?)
            ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    final totalAmount = (data['totalAmount'] as num?)?.toInt() ??
                        (data['amount'] as num?)?.toInt() ??
                        0;

    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      truckId: data['truckId'] ?? '',
      truckName: data['truckName'] ?? '',
      items: items,
      totalAmount: totalAmount,
      status: _statusFromString(data['status'] as String? ?? 'pending'),
      specialRequests: data['specialRequests'] ?? '',
      paymentMethod: data['paymentMethod'] ?? 'card',
      source: data['source'] ?? 'customer',
      itemName: data['itemName'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
                 (data['timestamp'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'truckId': truckId,
      'truckName': truckName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'specialRequests': specialRequests,
      'paymentMethod': paymentMethod,
      'source': source,
      if (itemName != null) 'itemName': itemName,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static OrderStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
