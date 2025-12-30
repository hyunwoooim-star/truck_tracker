import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

/// Service for converting coordinates to human-readable addresses
class GeocodingService {
  static final GeocodingService _instance = GeocodingService._internal();
  factory GeocodingService() => _instance;
  GeocodingService._internal();

  /// Cache for addresses to avoid repeated API calls
  final Map<String, String> _addressCache = {};

  /// Convert latitude/longitude to a readable address
  /// Returns cached result if available
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    // Create cache key
    final cacheKey = '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';

    // Return cached address if available
    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey]!;
    }

    try {
      // Web platform doesn't support geocoding
      if (kIsWeb) {
        return _formatCoordinates(latitude, longitude);
      }

      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = _formatAddress(place);
        _addressCache[cacheKey] = address;
        return address;
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }

    // Fallback to formatted coordinates
    return _formatCoordinates(latitude, longitude);
  }

  /// Format placemark into a readable Korean address
  String _formatAddress(Placemark place) {
    final parts = <String>[];

    // Korean address format: 시/도 > 구/군 > 동/읍/면 > 상세주소
    if (place.administrativeArea?.isNotEmpty == true) {
      parts.add(place.administrativeArea!); // 서울특별시, 경기도 등
    }
    if (place.locality?.isNotEmpty == true) {
      parts.add(place.locality!); // 강남구, 수원시 등
    }
    if (place.subLocality?.isNotEmpty == true) {
      parts.add(place.subLocality!); // 역삼동 등
    }
    if (place.thoroughfare?.isNotEmpty == true) {
      parts.add(place.thoroughfare!); // 도로명
    }

    if (parts.isEmpty) {
      // Fallback: use whatever is available
      if (place.street?.isNotEmpty == true) {
        return place.street!;
      }
      if (place.name?.isNotEmpty == true) {
        return place.name!;
      }
    }

    return parts.join(' ');
  }

  /// Format coordinates as a readable string (fallback)
  String _formatCoordinates(double latitude, double longitude) {
    final latDir = latitude >= 0 ? 'N' : 'S';
    final lngDir = longitude >= 0 ? 'E' : 'W';
    return '${latitude.abs().toStringAsFixed(4)}°$latDir, ${longitude.abs().toStringAsFixed(4)}°$lngDir';
  }

  /// Get a short address (just district/neighborhood)
  Future<String> getShortAddress(double latitude, double longitude) async {
    final cacheKey = 'short_${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';

    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey]!;
    }

    try {
      if (kIsWeb) {
        return _formatCoordinates(latitude, longitude);
      }

      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Short format: just 구 + 동
        final parts = <String>[];
        if (place.locality?.isNotEmpty == true) {
          parts.add(place.locality!);
        }
        if (place.subLocality?.isNotEmpty == true) {
          parts.add(place.subLocality!);
        }

        if (parts.isNotEmpty) {
          final shortAddress = parts.join(' ');
          _addressCache[cacheKey] = shortAddress;
          return shortAddress;
        }
      }
    } catch (e) {
      debugPrint('Short geocoding error: $e');
    }

    return _formatCoordinates(latitude, longitude);
  }

  /// Clear the address cache
  void clearCache() {
    _addressCache.clear();
  }
}
