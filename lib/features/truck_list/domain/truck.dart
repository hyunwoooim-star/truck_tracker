import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'truck.freezed.dart';
part 'truck.g.dart';

enum TruckStatus { onRoute, resting, maintenance }

@freezed
sealed class Truck with _$Truck {
  const Truck._();

  const factory Truck({
    required String id,
    required String truckNumber,
    required String driverName,
    required TruckStatus status,
    required String foodType,
    required String locationDescription,
    required double latitude,
    required double longitude,
    @Default(false) bool isFavorite,
    required String imageUrl,
    @Default('') String ownerEmail, // 사장님 이메일 (인증용)
    @Default('') String contactPhone, // 연락처
    String? bankAccount, // 은행 계좌번호 (송금용 QR)
    @Default('') String announcement, // 오늘의 특별 공지
    @Default(0) int favoriteCount, // 즐겨찾기 카운트 (전체 사용자)
    @Default(0.0) double avgRating, // 평균 별점
    @Default(0) int totalReviews, // 총 리뷰 개수
    @Default(false) bool isOpen, // 영업 중 여부 (FCM 트리거용)
    Map<String, dynamic>? weeklySchedule, // 주간 영업 일정 (monday, tuesday, ...)
  }) = _Truck;

  // JSON serialization (for local/API use)
  factory Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);

  // Firestore serialization
  factory Truck.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Truck(
      id: doc.id,
      truckNumber: data['truckNumber'] as String? ?? '',
      driverName: data['driverName'] as String? ?? '',
      status: _statusFromString(data['status'] as String? ?? 'resting'),
      foodType: data['foodType'] as String? ?? '',
      locationDescription: data['locationDescription'] as String? ?? '',
      latitude: _parseDouble(data['latitude']) ?? 0.0,
      longitude: _parseDouble(data['longitude']) ?? 0.0,
      isFavorite: data['isFavorite'] as bool? ?? false,
      imageUrl: data['imageUrl'] as String? ?? '',
      ownerEmail: data['ownerEmail'] as String? ?? '',
      contactPhone: data['contactPhone'] as String? ?? '',
      bankAccount: data['bankAccount'] as String?,
      announcement: data['announcement'] as String? ?? '',
      favoriteCount: _parseInt(data['favoriteCount']) ?? 0,
      avgRating: _parseDouble(data['avgRating']) ?? 0.0,
      totalReviews: _parseInt(data['totalReviews']) ?? 0,
      isOpen: _parseBool(data['isOpen']) ?? false,
      weeklySchedule: data['weeklySchedule'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'truckNumber': truckNumber,
      'driverName': driverName,
      'status': status.name,
      'foodType': foodType,
      'locationDescription': locationDescription,
      'latitude': latitude,
      'longitude': longitude,
      'isFavorite': isFavorite,
      'imageUrl': imageUrl,
      'ownerEmail': ownerEmail,
      'contactPhone': contactPhone,
      'bankAccount': bankAccount,
      'announcement': announcement,
      'favoriteCount': favoriteCount,
      'avgRating': avgRating,
      'totalReviews': totalReviews,
      'isOpen': isOpen,
      'weeklySchedule': weeklySchedule,
    };
  }

  // 랭킹 점수 계산 (즐겨찾기 40% + 별점 60%)
  double get rankingScore {
    return (favoriteCount * 0.4) + (avgRating * 0.6);
  }

  static TruckStatus _statusFromString(String status) {
    switch (status) {
      case 'onRoute':
        return TruckStatus.onRoute;
      case 'resting':
        return TruckStatus.resting;
      case 'maintenance':
        return TruckStatus.maintenance;
      default:
        return TruckStatus.resting;
    }
  }

  /// Parse double from dynamic value (handles both String and num)
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Parse int from dynamic value (handles both String and num)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Parse bool from dynamic value (handles String "true"/"false" and bool)
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }
}
