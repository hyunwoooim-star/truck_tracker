import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../domain/truck_detail.dart';

class TruckDetailRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _detailsCollection =>
      _firestore.collection('truck_details');

  Stream<TruckDetail?> watchTruckDetail(String truckId) {
    debugPrint('📡 TruckDetailRepository: Watching truck detail $truckId');

    return _detailsCollection.doc(truckId).snapshots().map((doc) {
      if (!doc.exists) {
        debugPrint('⚠️ Truck detail $truckId not found');
        return null;
      }

      try {
        final detail = TruckDetail.fromFirestore(doc);
        debugPrint('✅ Loaded truck detail: ${detail.menuItems.length} items');
        return detail;
      } catch (e) {
        debugPrint('❌ Error parsing truck detail: $e');
        return null;
      }
    });
  }

  Future<TruckDetail?> getTruckDetail(String truckId) async {
    debugPrint('🛒 TruckDetailRepository: Fetching truck detail $truckId');

    try {
      final doc = await _detailsCollection.doc(truckId).get();

      if (!doc.exists) {
        debugPrint('⚠️ Truck detail not found');
        return null;
      }

      final detail = TruckDetail.fromFirestore(doc);
      debugPrint('✅ Truck detail fetched');
      return detail;
    } catch (e) {
      debugPrint('❌ Error fetching truck detail: $e');
      return null;
    }
  }

  Future<void> updateTruckDetail(String truckId, TruckDetail detail) async {
    debugPrint('🛒 TruckDetailRepository: Updating truck detail $truckId');

    try {
      await _detailsCollection.doc(truckId).set(detail.toFirestore());
      debugPrint('✅ Truck detail updated');
    } catch (e) {
      debugPrint('❌ Error updating truck detail: $e');
      rethrow;
    }
  }

  Future<void> toggleMenuItemSoldOut(String truckId, String menuItemId) async {
    debugPrint('🛒 TruckDetailRepository: Toggling sold-out for $menuItemId');

    try {
      final detail = await getTruckDetail(truckId);

      if (detail == null) {
        throw Exception('Truck detail not found');
      }

      final updatedMenuItems = detail.menuItems.map((item) {
        if (item.id == menuItemId) {
          return item.copyWith(isSoldOut: !item.isSoldOut);
        }
        return item;
      }).toList();

      final updatedDetail = detail.copyWith(menuItems: updatedMenuItems);
      await updateTruckDetail(truckId, updatedDetail);

      debugPrint('✅ Menu item sold-out status toggled');
    } catch (e) {
      debugPrint('❌ Error toggling sold-out: $e');
      rethrow;
    }
  }
}
