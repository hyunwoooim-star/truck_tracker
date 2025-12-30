import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/app_logger.dart';
import '../domain/truck.dart';

/// Repository for managing Truck data with Firestore
class TruckRepository {
  TruckRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Reference to the trucks collection
  CollectionReference<Map<String, dynamic>> get _trucksCollection =>
      _firestore.collection('trucks');

  /// Watch all trucks in real-time (limited to 50 for performance)
  Stream<List<Truck>> watchTrucks({int limit = 50}) {
    AppLogger.debug('Setting up Firestore stream listener (limit: $limit)', tag: 'TruckRepository');

    return _trucksCollection
        .where('status', whereIn: ['onRoute', 'resting'])  // Filter out maintenance trucks
        .limit(limit)  // 🚀 OPTIMIZATION: Limit results to prevent excessive reads
        .snapshots()
        .map((snapshot) {
      AppLogger.debug('Firestore snapshot received: ${snapshot.docs.length} documents', tag: 'TruckRepository');
      
      final trucks = snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          
          // 🛡️ SAFETY: Check if document data exists
          if (data == null) {
            AppLogger.warning('Truck ${doc.id} has null data - skipping', tag: 'TruckRepository');
            return null;
          }

          // 🛡️ SAFETY: Check for required fields
          if (!data.containsKey('latitude') || !data.containsKey('longitude')) {
            AppLogger.warning('Truck ${doc.id} missing coordinates - skipping', tag: 'TruckRepository');
            return null;
          }
          
          final truck = Truck.fromFirestore(doc);
          
          // 🛡️ SAFETY: Validate coordinates
          if (truck.latitude == 0.0 && truck.longitude == 0.0) {
            AppLogger.warning('Truck ${doc.id} has (0,0) coordinates - skipping', tag: 'TruckRepository');
            return null;
          }

          if (truck.latitude < -90 || truck.latitude > 90 ||
              truck.longitude < -180 || truck.longitude > 180) {
            AppLogger.warning('Truck ${doc.id} has invalid coordinates: ${truck.latitude}, ${truck.longitude}', tag: 'TruckRepository');
            return null;
          }

          AppLogger.debug('Parsed: ${truck.id} (${truck.foodType}) - ${truck.status.name}', tag: 'TruckRepository');
          return truck;
        } catch (e, stackTrace) {
          AppLogger.error('Error parsing truck ${doc.id}', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
          return null;
        }
      }).whereType<Truck>().toList();

      AppLogger.success('Successfully parsed ${trucks.length} trucks', tag: 'TruckRepository');
      
      return trucks;
    });
  }

  /// Get all trucks once (limited to 50 for performance)
  Future<List<Truck>> getTrucks({int limit = 50}) async {
    AppLogger.debug('Fetching trucks (limit: $limit)', tag: 'TruckRepository');
    final snapshot = await _trucksCollection.limit(limit).get();
    AppLogger.debug('Retrieved ${snapshot.docs.length} trucks', tag: 'TruckRepository');
    return snapshot.docs.map((doc) => Truck.fromFirestore(doc)).toList();
  }

  /// Get a single truck by ID
  Future<Truck?> getTruck(String truckId) async {
    final doc = await _trucksCollection.doc(truckId).get();
    if (!doc.exists) return null;
    return Truck.fromFirestore(doc);
  }

  /// Add a new truck
  Future<void> addTruck(Truck truck) async {
    await _trucksCollection.doc(truck.id).set(truck.toFirestore());
  }

  /// Update an existing truck
  Future<void> updateTruck(Truck truck) async {
    await _trucksCollection.doc(truck.id).update(truck.toFirestore());
  }

  /// Update truck location (for GPS tracking)
  Future<void> updateLocation(String truckId, double latitude, double longitude) async {
    await _trucksCollection.doc(truckId).update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// Update truck location and set isOpen to true (for business opening)
  Future<void> openForBusiness(String truckId, double latitude, double longitude) async {
    AppLogger.debug('Opening truck for business: $truckId at ($latitude, $longitude)', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'latitude': latitude,
        'longitude': longitude,
        'isOpen': true,
        'status': TruckStatus.onRoute.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Truck opened for business: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Open for business failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Update truck status
  Future<void> updateStatus(String truckId, TruckStatus status) async {
    AppLogger.debug('Updating truck status: $truckId → ${status.name}', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'status': status.name,
      });

      AppLogger.success('Status updated: trucks/$truckId = ${status.name}', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Status update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String truckId, bool isFavorite) async {
    await _trucksCollection.doc(truckId).update({
      'isFavorite': isFavorite,
    });
  }

  /// Delete a truck
  Future<void> deleteTruck(String truckId) async {
    await _trucksCollection.doc(truckId).delete();
  }

  /// Batch add multiple trucks (for migration)
  Future<void> addTrucksBatch(List<Truck> trucks) async {
    final batch = _firestore.batch();
    
    for (final truck in trucks) {
      final docRef = _trucksCollection.doc(truck.id);
      batch.set(docRef, truck.toFirestore());
    }
    
    await batch.commit();
  }

  /// Delete all trucks (use with caution!)
  Future<void> deleteAllTrucks() async {
    final snapshot = await _trucksCollection.get();
    final batch = _firestore.batch();
    
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  /// Update menu items for a truck (real-time update)
  Future<void> updateMenuItems(String truckId, List<Map<String, dynamic>> menuItems) async {
    AppLogger.debug('Updating menu items for truck $truckId (${menuItems.length} items)', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'menuItems': menuItems,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Menu items updated: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Menu items update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Update announcement for a truck
  Future<void> updateAnnouncement(String truckId, String announcement) async {
    AppLogger.debug('Updating announcement for truck $truckId', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'announcement': announcement,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Announcement updated: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Announcement update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Update favorite count for a truck
  Future<void> updateFavoriteCount(String truckId, int count) async {
    AppLogger.debug('Updating favorite count for truck $truckId: $count', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'favoriteCount': count,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Favorite count updated: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Favorite count update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Update rating statistics for a truck
  Future<void> updateRatings(String truckId, double avgRating, int totalReviews) async {
    AppLogger.debug('Updating ratings for truck $truckId: $avgRating ($totalReviews reviews)', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'avgRating': avgRating,
        'totalReviews': totalReviews,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Ratings updated: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Ratings update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Update bank account for a truck (for payment QR)
  Future<void> updateBankAccount(String truckId, String bankAccount) async {
    AppLogger.debug('Updating bank account for truck $truckId', tag: 'TruckRepository');

    try {
      await _trucksCollection.doc(truckId).update({
        'bankAccount': bankAccount,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Bank account updated: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Bank account update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }

  /// Update truck profile (name, driver, phone, image)
  Future<void> updateTruckProfile({
    required String truckId,
    required String truckNumber,
    required String driverName,
    required String contactPhone,
    String? imageUrl,
  }) async {
    AppLogger.debug('Updating profile for truck $truckId', tag: 'TruckRepository');

    try {
      final updateData = <String, dynamic>{
        'truckNumber': truckNumber,
        'driverName': driverName,
        'contactPhone': contactPhone,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Only update imageUrl if provided (allows clearing with empty string)
      if (imageUrl != null) {
        updateData['imageUrl'] = imageUrl;
      }

      await _trucksCollection.doc(truckId).update(updateData);

      AppLogger.success('Profile updated: trucks/$truckId', tag: 'TruckRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Profile update failed for truck $truckId', error: e, stackTrace: stackTrace, tag: 'TruckRepository');
      rethrow;
    }
  }
}

