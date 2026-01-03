import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/menu_item.dart';
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

  Future<void> addMenuItem(String truckId, MenuItem newItem) async {
    AppLogger.debug('Adding menu item to $truckId', tag: 'TruckDetailRepository');

    try {
      final detail = await getTruckDetail(truckId);

      // truck_details 문서가 없으면 새로 생성
      if (detail == null) {
        AppLogger.warning('Truck detail not found, creating new one', tag: 'TruckDetailRepository');
        final newDetail = TruckDetail(
          truckId: truckId,
          menuItems: [newItem],
          reviews: [],
          averageRating: 0.0,
          totalReviews: 0,
        );
        await updateTruckDetail(truckId, newDetail);
        AppLogger.success('New truck detail created with menu item', tag: 'TruckDetailRepository');
        return;
      }

      final updatedMenuItems = [...detail.menuItems, newItem];
      final updatedDetail = detail.copyWith(menuItems: updatedMenuItems);
      await updateTruckDetail(truckId, updatedDetail);

      AppLogger.success('Menu item added', tag: 'TruckDetailRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error adding menu item', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
      rethrow;
    }
  }

  Future<void> updateMenuItem(String truckId, MenuItem updatedItem) async {
    AppLogger.debug('Updating menu item ${updatedItem.id}', tag: 'TruckDetailRepository');

    try {
      final detail = await getTruckDetail(truckId);

      if (detail == null) {
        throw Exception('Truck detail not found');
      }

      final updatedMenuItems = detail.menuItems.map((item) {
        if (item.id == updatedItem.id) {
          return updatedItem;
        }
        return item;
      }).toList();

      final updatedDetail = detail.copyWith(menuItems: updatedMenuItems);
      await updateTruckDetail(truckId, updatedDetail);

      AppLogger.success('Menu item updated', tag: 'TruckDetailRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating menu item', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
      rethrow;
    }
  }

  Future<void> deleteMenuItem(String truckId, String menuItemId) async {
    AppLogger.debug('Deleting menu item $menuItemId', tag: 'TruckDetailRepository');

    try {
      final detail = await getTruckDetail(truckId);

      if (detail == null) {
        throw Exception('Truck detail not found');
      }

      final updatedMenuItems = detail.menuItems
          .where((item) => item.id != menuItemId)
          .toList();

      final updatedDetail = detail.copyWith(menuItems: updatedMenuItems);
      await updateTruckDetail(truckId, updatedDetail);

      AppLogger.success('Menu item deleted', tag: 'TruckDetailRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting menu item', error: e, stackTrace: stackTrace, tag: 'TruckDetailRepository');
      rethrow;
    }
  }
}
