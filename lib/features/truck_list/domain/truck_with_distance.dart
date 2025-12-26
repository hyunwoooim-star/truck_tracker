import '../domain/truck.dart';

/// Truck with distance information
class TruckWithDistance {
  const TruckWithDistance({
    required this.truck,
    required this.distanceInMeters,
  });

  final Truck truck;
  final double distanceInMeters;

  /// Get formatted distance text (e.g., "350m" or "1.2km")
  String get distanceText {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  /// Sort comparison for distance
  int compareByDistance(TruckWithDistance other) {
    return distanceInMeters.compareTo(other.distanceInMeters);
  }
}





