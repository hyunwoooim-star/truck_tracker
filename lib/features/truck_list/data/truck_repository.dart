import 'package:cloud_firestore/cloud_firestore.dart';
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
    print('🔥 TruckRepository.watchTrucks() - Setting up Firestore stream listener (limit: $limit)');

    return _trucksCollection
        .where('status', whereIn: ['onRoute', 'resting'])  // Filter out maintenance trucks
        .limit(limit)  // 🚀 OPTIMIZATION: Limit results to prevent excessive reads
        .snapshots()
        .map((snapshot) {
      print('');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔥 FIRESTORE SNAPSHOT RECEIVED at ${DateTime.now()}');
      print('📦 Total documents in snapshot: ${snapshot.docs.length}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      final trucks = snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          
          // 🛡️ SAFETY: Check if document data exists
          if (data == null) {
            print('  ⚠️ Truck ${doc.id} has null data - skipping');
            return null;
          }
          
          // 🛡️ SAFETY: Check for required fields
          if (!data.containsKey('latitude') || !data.containsKey('longitude')) {
            print('  ⚠️ Truck ${doc.id} missing coordinates - skipping');
            return null;
          }
          
          final truck = Truck.fromFirestore(doc);
          
          // 🛡️ SAFETY: Validate coordinates
          if (truck.latitude == 0.0 && truck.longitude == 0.0) {
            print('  ⚠️ Truck ${doc.id} has (0,0) coordinates - skipping');
            return null;
          }
          
          if (truck.latitude < -90 || truck.latitude > 90 || 
              truck.longitude < -180 || truck.longitude > 180) {
            print('  ⚠️ Truck ${doc.id} has invalid coordinates: ${truck.latitude}, ${truck.longitude} - skipping');
            return null;
          }
          
          print('  ✅ Parsed: ${truck.id} (${truck.foodType}) - ${truck.status.name} - lat:${truck.latitude}, lng:${truck.longitude}');
          return truck;
        } catch (e, stackTrace) {
          print('  ❌ Error parsing truck ${doc.id}: $e');
          print('  📋 Data: ${doc.data()}');
          print('  📋 Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
          return null;
        }
      }).whereType<Truck>().toList();
      
      print('');
      print('✨ Successfully parsed ${trucks.length} trucks');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('');
      
      return trucks;
    });
  }

  /// Get all trucks once (limited to 50 for performance)
  Future<List<Truck>> getTrucks({int limit = 50}) async {
    print('🔥 TruckRepository.getTrucks() - Fetching trucks (limit: $limit)');
    final snapshot = await _trucksCollection.limit(limit).get();
    print('   Retrieved ${snapshot.docs.length} trucks');
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
    print('🔥 TruckRepository.openForBusiness() CALLED');
    print('   Truck ID: $truckId');
    print('   Location: $latitude, $longitude');

    try {
      await _trucksCollection.doc(truckId).update({
        'latitude': latitude,
        'longitude': longitude,
        'isOpen': true,
        'status': TruckStatus.onRoute.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Truck opened for business successfully!');
      print('   Document: trucks/$truckId');
      print('   isOpen: true (FCM notification will be triggered)');
    } catch (e, stackTrace) {
      print('❌ Open for business failed!');
      print('   Error: $e');
      print('   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  /// Update truck status
  Future<void> updateStatus(String truckId, TruckStatus status) async {
    print('');
    print('🔥 TruckRepository.updateStatus() CALLED');
    print('   Truck ID: $truckId');
    print('   New Status: ${status.name}');
    print('   Firestore Path: trucks/$truckId');
    
    try {
      await _trucksCollection.doc(truckId).update({
        'status': status.name,
      });
      
      print('✅ Firestore UPDATE SUCCESS!');
      print('   Document: trucks/$truckId');
      print('   Field: status = ${status.name}');
      print('');
    } catch (e, stackTrace) {
      print('❌ Firestore UPDATE FAILED!');
      print('   Error: $e');
      print('   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      print('');
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
    print('🔥 TruckRepository.updateMenuItems() CALLED');
    print('   Truck ID: $truckId');
    print('   Menu Items Count: ${menuItems.length}');

    try {
      await _trucksCollection.doc(truckId).update({
        'menuItems': menuItems,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Menu items updated successfully!');
      print('   Document: trucks/$truckId');
    } catch (e, stackTrace) {
      print('❌ Menu items update failed!');
      print('   Error: $e');
      print('   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  /// Update announcement for a truck
  Future<void> updateAnnouncement(String truckId, String announcement) async {
    print('📢 TruckRepository.updateAnnouncement() CALLED');
    print('   Truck ID: $truckId');
    print('   Announcement: $announcement');

    try {
      await _trucksCollection.doc(truckId).update({
        'announcement': announcement,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Announcement updated successfully!');
      print('   Document: trucks/$truckId');
    } catch (e, stackTrace) {
      print('❌ Announcement update failed!');
      print('   Error: $e');
      print('   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  /// Update favorite count for a truck
  Future<void> updateFavoriteCount(String truckId, int count) async {
    print('⭐ TruckRepository.updateFavoriteCount() CALLED');
    print('   Truck ID: $truckId');
    print('   Favorite Count: $count');

    try {
      await _trucksCollection.doc(truckId).update({
        'favoriteCount': count,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Favorite count updated successfully!');
      print('   Document: trucks/$truckId');
    } catch (e, stackTrace) {
      print('❌ Favorite count update failed!');
      print('   Error: $e');
      print('   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }

  /// Update rating statistics for a truck
  Future<void> updateRatings(String truckId, double avgRating, int totalReviews) async {
    print('⭐ TruckRepository.updateRatings() CALLED');
    print('   Truck ID: $truckId');
    print('   Avg Rating: $avgRating');
    print('   Total Reviews: $totalReviews');

    try {
      await _trucksCollection.doc(truckId).update({
        'avgRating': avgRating,
        'totalReviews': totalReviews,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Ratings updated successfully!');
      print('   Document: trucks/$truckId');
    } catch (e, stackTrace) {
      print('❌ Ratings update failed!');
      print('   Error: $e');
      print('   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      rethrow;
    }
  }
}

