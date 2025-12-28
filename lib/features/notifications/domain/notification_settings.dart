import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// User's notification preferences
@freezed
sealed class NotificationSettings with _$NotificationSettings {
  const NotificationSettings._();

  const factory NotificationSettings({
    required String userId,
    @Default(true) bool truckOpenings, // 트럭 영업 시작
    @Default(true) bool orderUpdates, // 주문 상태 변경
    @Default(true) bool newCoupons, // 새 쿠폰 발행
    @Default(true) bool reviews, // 리뷰 답글
    @Default(true) bool promotions, // 프로모션
    @Default(false) bool nearbyTrucks, // 근처 트럭 (위치 기반)
    @Default(1000) int nearbyRadius, // 반경 (미터), 기본 1km
    @Default(true) bool followedTrucks, // 팔로우한 트럭 활동
    @Default(true) bool chatMessages, // 채팅 메시지
    DateTime? lastUpdated,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  factory NotificationSettings.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationSettings(
      userId: doc.id,
      truckOpenings: data['truckOpenings'] as bool? ?? true,
      orderUpdates: data['orderUpdates'] as bool? ?? true,
      newCoupons: data['newCoupons'] as bool? ?? true,
      reviews: data['reviews'] as bool? ?? true,
      promotions: data['promotions'] as bool? ?? true,
      nearbyTrucks: data['nearbyTrucks'] as bool? ?? false,
      nearbyRadius: data['nearbyRadius'] as int? ?? 1000,
      followedTrucks: data['followedTrucks'] as bool? ?? true,
      chatMessages: data['chatMessages'] as bool? ?? true,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'truckOpenings': truckOpenings,
      'orderUpdates': orderUpdates,
      'newCoupons': newCoupons,
      'reviews': reviews,
      'promotions': promotions,
      'nearbyTrucks': nearbyTrucks,
      'nearbyRadius': nearbyRadius,
      'followedTrucks': followedTrucks,
      'chatMessages': chatMessages,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  /// Create default settings for a new user
  factory NotificationSettings.defaultSettings(String userId) {
    return NotificationSettings(
      userId: userId,
      truckOpenings: true,
      orderUpdates: true,
      newCoupons: true,
      reviews: true,
      promotions: true,
      nearbyTrucks: false,
      nearbyRadius: 1000,
      followedTrucks: true,
      chatMessages: true,
      lastUpdated: DateTime.now(),
    );
  }

  /// Check if any notifications are enabled
  bool get hasAnyEnabled =>
      truckOpenings ||
      orderUpdates ||
      newCoupons ||
      reviews ||
      promotions ||
      nearbyTrucks ||
      followedTrucks ||
      chatMessages;

  /// Get count of enabled notification types
  int get enabledCount {
    int count = 0;
    if (truckOpenings) count++;
    if (orderUpdates) count++;
    if (newCoupons) count++;
    if (reviews) count++;
    if (promotions) count++;
    if (nearbyTrucks) count++;
    if (followedTrucks) count++;
    if (chatMessages) count++;
    return count;
  }

  /// Radius in kilometers (for display)
  double get nearbyRadiusKm => nearbyRadius / 1000.0;
}
