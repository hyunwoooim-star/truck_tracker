import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service to manage truck ownership (1-Owner-1-Truck policy)
class TruckOwnershipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════
  // TRUCK ID MANAGEMENT (1-100)
  // ═══════════════════════════════════════════════════════════

  /// Get list of available truck IDs (not owned by anyone)
  Future<List<int>> getAvailableTruckIds() async {
    debugPrint('🚛 TruckOwnershipService: Fetching available truck IDs');
    
    try {
      // Get all trucks
      final trucksSnapshot = await _firestore.collection('trucks').get();
      
      // Get occupied truck IDs
      final occupiedIds = trucksSnapshot.docs
          .where((doc) {
            final data = doc.data();
            final ownerId = data['ownerId'] as String?;
            return ownerId != null && ownerId.isNotEmpty;
          })
          .map((doc) => int.parse(doc.id))
          .toSet();
      
      // Generate list of available IDs (1-100)
      final availableIds = <int>[];
      for (int i = 1; i <= 100; i++) {
        if (!occupiedIds.contains(i)) {
          availableIds.add(i);
        }
      }
      
      debugPrint('✅ Available truck IDs: ${availableIds.length}/100');
      debugPrint('   IDs: ${availableIds.take(10).join(', ')}${availableIds.length > 10 ? '...' : ''}');
      
      return availableIds;
    } catch (e) {
      debugPrint('❌ Error fetching available truck IDs: $e');
      rethrow;
    }
  }

  /// Check if a truck ID is available
  Future<bool> isTruckIdAvailable(int truckId) async {
    if (truckId < 1 || truckId > 100) {
      return false;
    }
    
    try {
      final truckDoc = await _firestore.collection('trucks').doc('$truckId').get();
      
      if (!truckDoc.exists) {
        return true; // Truck doesn't exist yet, so it's available
      }
      
      final ownerId = truckDoc.data()?['ownerId'] as String?;
      return ownerId == null || ownerId.isEmpty;
    } catch (e) {
      debugPrint('❌ Error checking truck availability: $e');
      return false;
    }
  }

  /// Check if a user already owns a truck
  Future<int?> getUserOwnedTruckId(String userId) async {
    try {
      // Check in users collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final ownedTruckId = userDoc.data()?['ownedTruckId'] as int?;
      
      if (ownedTruckId != null) {
        debugPrint('✅ User $userId owns truck #$ownedTruckId');
        return ownedTruckId;
      }
      
      // Double-check in trucks collection
      final trucksSnapshot = await _firestore
          .collection('trucks')
          .where('ownerId', isEqualTo: userId)
          .limit(1)
          .get();
      
      if (trucksSnapshot.docs.isNotEmpty) {
        final truckId = int.parse(trucksSnapshot.docs.first.id);
        debugPrint('✅ Found truck ownership in trucks collection: #$truckId');
        
        // Sync back to user document
        await _firestore.collection('users').doc(userId).update({
          'ownedTruckId': truckId,
        });
        
        return truckId;
      }
      
      debugPrint('   User $userId does not own any truck');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user owned truck: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TRUCK CLAIMING (1-Owner-1-Truck Policy Enforcement)
  // ═══════════════════════════════════════════════════════════

  /// Claim a truck (enforces 1-owner-1-truck policy)
  Future<bool> claimTruck({
    required String userId,
    required int truckId,
    required String userEmail,
    required String userName,
  }) async {
    debugPrint('🚛 TruckOwnershipService: Attempting to claim truck #$truckId for user $userId');
    
    if (truckId < 1 || truckId > 100) {
      debugPrint('❌ Invalid truck ID: $truckId (must be 1-100)');
      throw Exception('Truck ID must be between 1 and 100');
    }
    
    try {
      // Run as a transaction to ensure atomicity
      return await _firestore.runTransaction<bool>((transaction) async {
        // 1. Check if user already owns a truck
        final userRef = _firestore.collection('users').doc(userId);
        final userSnapshot = await transaction.get(userRef);
        
        if (!userSnapshot.exists) {
          throw Exception('User document does not exist');
        }
        
        final existingTruckId = userSnapshot.data()?['ownedTruckId'] as int?;
        if (existingTruckId != null) {
          debugPrint('❌ User already owns truck #$existingTruckId');
          throw Exception('이미 트럭을 소유하고 있습니다 (트럭 #$existingTruckId)');
        }
        
        // 2. Check if truck is available
        final truckRef = _firestore.collection('trucks').doc('$truckId');
        final truckSnapshot = await transaction.get(truckRef);
        
        if (truckSnapshot.exists) {
          final currentOwnerId = truckSnapshot.data()?['ownerId'] as String?;
          if (currentOwnerId != null && currentOwnerId.isNotEmpty) {
            debugPrint('❌ Truck #$truckId is already owned by $currentOwnerId');
            throw Exception('이 트럭은 이미 다른 사장님이 소유하고 있습니다');
          }
        }
        
        // 3. Claim the truck
        transaction.set(
          truckRef,
          {
            'id': '$truckId',
            'ownerId': userId,
            'ownerEmail': userEmail,
            'driverName': userName,
            'claimedAt': FieldValue.serverTimestamp(),
            'status': 'maintenance', // Initial status
            'latitude': 37.5665, // Default Seoul coordinates
            'longitude': 126.9780,
            // Default values for new trucks
            'truckNumber': '서울 $truckId호',
            'foodType': '미정',
            'locationDescription': '위치 설정 필요',
            'menus': [],
          },
          SetOptions(merge: true),
        );
        
        // 4. Update user document
        transaction.update(userRef, {
          'ownedTruckId': truckId,
          'role': 'owner',
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        debugPrint('✅ Truck #$truckId successfully claimed by $userId');
        return true;
      });
    } catch (e) {
      debugPrint('❌ Error claiming truck: $e');
      rethrow;
    }
  }

  /// Release truck ownership (admin function)
  Future<void> releaseTruck(int truckId) async {
    debugPrint('🚛 TruckOwnershipService: Releasing truck #$truckId');
    
    try {
      // Get current owner
      final truckDoc = await _firestore.collection('trucks').doc('$truckId').get();
      final ownerId = truckDoc.data()?['ownerId'] as String?;
      
      if (ownerId == null) {
        debugPrint('   Truck #$truckId is not owned by anyone');
        return;
      }
      
      // Run as transaction
      await _firestore.runTransaction((transaction) async {
        // Update truck document
        final truckRef = _firestore.collection('trucks').doc('$truckId');
        transaction.update(truckRef, {
          'ownerId': FieldValue.delete(),
          'ownerEmail': FieldValue.delete(),
          'releasedAt': FieldValue.serverTimestamp(),
        });
        
        // Update user document
        final userRef = _firestore.collection('users').doc(ownerId);
        transaction.update(userRef, {
          'ownedTruckId': null,
          'role': 'customer',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      
      debugPrint('✅ Truck #$truckId released');
    } catch (e) {
      debugPrint('❌ Error releasing truck: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════

  /// Get ownership statistics
  Future<Map<String, int>> getOwnershipStats() async {
    try {
      final trucksSnapshot = await _firestore.collection('trucks').get();
      
      int occupied = 0;
      int available = 0;
      
      for (int i = 1; i <= 100; i++) {
        final truckDoc = trucksSnapshot.docs.firstWhere(
          (doc) => doc.id == '$i',
          orElse: () => throw StateError('Not found'),
        );
        
        try {
          final ownerId = truckDoc.data()['ownerId'] as String?;
          if (ownerId != null && ownerId.isNotEmpty) {
            occupied++;
          } else {
            available++;
          }
        } catch (e) {
          available++;
        }
      }
      
      return {
        'total': 100,
        'occupied': occupied,
        'available': available,
      };
    } catch (e) {
      debugPrint('❌ Error getting ownership stats: $e');
      return {
        'total': 100,
        'occupied': 0,
        'available': 100,
      };
    }
  }
}





