import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/app_logger.dart';

/// Service to manage truck ownership (1-Owner-1-Truck policy)
class TruckOwnershipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════
  // TRUCK ID MANAGEMENT (1-100)
  // ═══════════════════════════════════════════════════════════

  /// Get list of available truck IDs (not owned by anyone)
  Future<List<int>> getAvailableTruckIds() async {
    AppLogger.debug('Fetching available truck IDs', tag: 'TruckOwnershipService');

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

      AppLogger.success('Available truck IDs: ${availableIds.length}/100', tag: 'TruckOwnershipService');
      AppLogger.debug('IDs: ${availableIds.take(10).join(', ')}${availableIds.length > 10 ? '...' : ''}', tag: 'TruckOwnershipService');

      return availableIds;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching available truck IDs', error: e, stackTrace: stackTrace, tag: 'TruckOwnershipService');
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
    } catch (e, stackTrace) {
      AppLogger.error('Error checking truck availability', error: e, stackTrace: stackTrace, tag: 'TruckOwnershipService');
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
        AppLogger.debug('User $userId owns truck #$ownedTruckId', tag: 'TruckOwnershipService');
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
        AppLogger.debug('Found truck ownership in trucks collection: #$truckId', tag: 'TruckOwnershipService');

        // Sync back to user document
        await _firestore.collection('users').doc(userId).update({
          'ownedTruckId': truckId,
        });

        return truckId;
      }

      AppLogger.debug('User $userId does not own any truck', tag: 'TruckOwnershipService');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user owned truck', error: e, stackTrace: stackTrace, tag: 'TruckOwnershipService');
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
    AppLogger.debug('Attempting to claim truck #$truckId for user $userId', tag: 'TruckOwnershipService');

    if (truckId < 1 || truckId > 100) {
      AppLogger.error('Invalid truck ID: $truckId (must be 1-100)', tag: 'TruckOwnershipService');
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
          AppLogger.warning('User already owns truck #$existingTruckId', tag: 'TruckOwnershipService');
          throw Exception('이미 트럭을 소유하고 있습니다 (트럭 #$existingTruckId)');
        }

        // 2. Check if truck is available
        final truckRef = _firestore.collection('trucks').doc('$truckId');
        final truckSnapshot = await transaction.get(truckRef);

        if (truckSnapshot.exists) {
          final currentOwnerId = truckSnapshot.data()?['ownerId'] as String?;
          if (currentOwnerId != null && currentOwnerId.isNotEmpty) {
            AppLogger.warning('Truck #$truckId is already owned by $currentOwnerId', tag: 'TruckOwnershipService');
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

        AppLogger.success('Truck #$truckId successfully claimed by $userId', tag: 'TruckOwnershipService');
        return true;
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error claiming truck', error: e, stackTrace: stackTrace, tag: 'TruckOwnershipService');
      rethrow;
    }
  }

  /// Release truck ownership (admin function)
  Future<void> releaseTruck(int truckId) async {
    AppLogger.debug('Releasing truck #$truckId', tag: 'TruckOwnershipService');

    try {
      // Get current owner
      final truckDoc = await _firestore.collection('trucks').doc('$truckId').get();
      final ownerId = truckDoc.data()?['ownerId'] as String?;

      if (ownerId == null) {
        AppLogger.debug('Truck #$truckId is not owned by anyone', tag: 'TruckOwnershipService');
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

      AppLogger.success('Truck #$truckId released', tag: 'TruckOwnershipService');
    } catch (e, stackTrace) {
      AppLogger.error('Error releasing truck', error: e, stackTrace: stackTrace, tag: 'TruckOwnershipService');
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
        // Use safe null-aware access instead of throwing
        final truckDoc = trucksSnapshot.docs
            .where((doc) => doc.id == '$i')
            .firstOrNull;

        if (truckDoc == null) {
          // Truck document doesn't exist, consider it available
          available++;
          continue;
        }

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
    } catch (e, stackTrace) {
      AppLogger.error('Error getting ownership stats', error: e, stackTrace: stackTrace, tag: 'TruckOwnershipService');
      return {
        'total': 100,
        'occupied': 0,
        'available': 100,
      };
    }
  }
}





