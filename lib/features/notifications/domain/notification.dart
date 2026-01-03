import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType {
  orderUpdate,      // 주문 상태 변경
  newOrder,         // 새 주문 (사장님용)
  truckOpen,        // 즐겨찾기 트럭 영업 시작
  promotion,        // 프로모션/쿠폰
  checkin,          // 체크인 완료
  system,           // 시스템 알림
}

@freezed
sealed class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required String id,
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? truckId,
    String? orderId,
    String? chatRoomId,
    Map<String, dynamic>? data,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      body: data['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.system,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool? ?? false,
      truckId: data['truckId'] as String?,
      orderId: data['orderId'] as String?,
      chatRoomId: data['chatRoomId'] as String?,
      data: data['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      if (truckId != null) 'truckId': truckId,
      if (orderId != null) 'orderId': orderId,
      if (chatRoomId != null) 'chatRoomId': chatRoomId,
      if (data != null) 'data': data,
    };
  }

  String get typeLabel {
    switch (type) {
      case NotificationType.orderUpdate:
        return '주문';
      case NotificationType.newOrder:
        return '새 주문';
      case NotificationType.truckOpen:
        return '영업 알림';
      case NotificationType.promotion:
        return '프로모션';
      case NotificationType.checkin:
        return '체크인';
      case NotificationType.system:
        return '시스템';
    }
  }
}
