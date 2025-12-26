import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_item.dart';
import '../../review/domain/review.dart';

part 'truck_detail.freezed.dart';
part 'truck_detail.g.dart';

@freezed
class TruckDetail with _$TruckDetail {
  const TruckDetail._();

  const factory TruckDetail({
    required String truckId,
    required String operatingHours,
    required List<MenuItem> menuItems,
    required List<Review> reviews,
    @Default(4.5) double averageRating,
    @Default('') String description,
  }) = _TruckDetail;

  // JSON serialization (for local/API use)
  factory TruckDetail.fromJson(Map<String, dynamic> json) => _$TruckDetailFromJson(json);

  // Firestore serialization
  factory TruckDetail.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TruckDetail(
      truckId: doc.id,
      operatingHours: data['operatingHours'] as String? ?? '',
      menuItems: (data['menuItems'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (data['reviews'] as List<dynamic>?)
              ?.map((review) => Review.fromJson(review as Map<String, dynamic>))
              .toList() ??
          [],
      averageRating: (data['averageRating'] as num?)?.toDouble() ?? 4.5,
      description: data['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'operatingHours': operatingHours,
      'menuItems': menuItems.map((item) => item.toJson()).toList(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'averageRating': averageRating,
      'description': description,
    };
  }
}


