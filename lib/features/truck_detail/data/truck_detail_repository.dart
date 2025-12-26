import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/truck_detail.dart';

class TruckDetailRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _detailsCollection =>
      _firestore.collection('truck_details');

  Stream<TruckDetail?> watchTruckDetail(String truckId) {
    AppLogger.debug('Watching truck detail $truckId', tag: 'TruckDetailRepository');

    return _detailsCollection.doc(truckId).snapshots().map((doc) {
      if (!doc.exists) {
        AppLogger.warning('Truck detail $truckId not found', tag: 'TruckDetailRepository');
        return null;
      }

      try {
        final detail = TruckDetail.fromFirestore(doc);
        AppLogger.debug('Loaded truck detail: ${detail.menuItems.length} items', tag: 'TruckDetailRepository');
        return detail;
      } catch (e, stackTrace) {
        AppLogger.error('Error parsing truck detail', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
        return null;
      }
    });
  }

  Future<TruckDetail?> getTruckDetail(String truckId) async {
    AppLogger.debug('Fetching truck detail $truckId', tag: 'TruckDetailRepository');

    try {
      final doc = await _detailsCollection.doc(truckId).get();

      if (!doc.exists) {
        AppLogger.warning('Truck detail not found', tag: 'TruckDetailRepository');
        return null;
      }

      final detail = TruckDetail.fromFirestore(doc);
      AppLogger.success('Truck detail fetched', tag: 'TruckDetailRepository');
      return detail;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching truck detail', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
      return null;
    }
  }

  Future<void> updateTruckDetail(String truckId, TruckDetail detail) async {
    AppLogger.debug('Updating truck detail $truckId', tag: 'TruckDetailRepository');

    try {
      await _detailsCollection.doc(truckId).set(detail.toFirestore());
      AppLogger.success('Truck detail updated', tag: 'TruckDetailRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating truck detail', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
      rethrow;
    }
  }

  Future<void> toggleMenuItemSoldOut(String truckId, String menuItemId) async {
    AppLogger.debug('Toggling sold-out for $menuItemId', tag: 'TruckDetailRepository');

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

      AppLogger.success('Menu item sold-out status toggled', tag: 'TruckDetailRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error toggling sold-out', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
      rethrow;
    }
  }
}
