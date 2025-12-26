import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

import '../../auth/presentation/auth_provider.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/presentation/truck_provider.dart';

part 'owner_status_provider.g.dart';

/// Provider that manages operating status for Owner's truck
///
/// This syncs with Firestore in real-time
@riverpod
class OwnerOperatingStatus extends AutoDisposeNotifier<bool> {
  int? _ownedTruckId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  bool build() {
    // Default to operating (true)
    // Will be updated when we load the truck data
    _loadOwnerTruckStatus();
    return true;
  }

  /// Load the owner's truck status from Firestore
  Future<void> _loadOwnerTruckStatus() async {
    try {
      final repository = ref.read(truckRepositoryProvider);

      // Get truck ID from current user
      _ownedTruckId = await ref.read(currentUserTruckIdProvider.future);

      if (_ownedTruckId == null) return;

      final truck = await repository.getTruck(_ownedTruckId.toString());
      if (truck != null) {
        // Update state based on truck status
        state = truck.status == TruckStatus.onRoute || truck.status == TruckStatus.resting;
      }
    } catch (e) {
      // If error, keep default state
    }
  }

  /// Toggle operating status and sync to Firestore
  Future<void> toggleStatus() async {
    final newStatus = !state;
    state = newStatus;

    // Update Firestore
    if (_ownedTruckId != null) {
      try {
        final repository = ref.read(truckRepositoryProvider);
        
        // Map boolean to TruckStatus
        final truckStatus = newStatus ? TruckStatus.onRoute : TruckStatus.maintenance;

        await repository.updateStatus(_ownedTruckId.toString(), truckStatus);
      } catch (e) {
        // Revert state on error
        state = !newStatus;
        rethrow;
      }
    }
  }

  /// Set specific status
  Future<void> setStatus(bool isOperating) async {
    debugPrint('');
    debugPrint('🔥🔥🔥 OWNER STATUS UPDATE TRIGGERED 🔥🔥🔥');
    debugPrint('Current state: $state');
    debugPrint('New state: $isOperating');
    debugPrint('Owned Truck ID: $_ownedTruckId');
    
    if (state == isOperating) {
      debugPrint('⚠️ State unchanged, skipping update');
      return;
    }
    
    state = isOperating;

    if (_ownedTruckId == null) {
      debugPrint('❌ ERROR: No owned truck ID! Cannot update Firestore.');
      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
      return;
    }

    try {
      debugPrint('📡 Getting repository...');
      final repository = ref.read(truckRepositoryProvider);
      
      final truckStatus = isOperating ? TruckStatus.onRoute : TruckStatus.maintenance;
      debugPrint('🔄 Updating Firestore...');
      debugPrint('   Truck ID: $_ownedTruckId');
      debugPrint('   New Status: ${truckStatus.name}');

      await repository.updateStatus(_ownedTruckId.toString(), truckStatus);

      // Send push notification if opening
      if (isOperating) {
        try {
          final truck = await repository.getTruck(_ownedTruckId.toString());
          if (truck != null) {
            // Trigger push notification (will be handled by Cloud Function)
            await _firestore.collection('notifications').add({
              'truckId': _ownedTruckId!,
              'truckName': truck.truckNumber,
              'message': '${truck.truckNumber}이 영업을 시작했습니다!',
              'type': 'truck_opening',
              'createdAt': FieldValue.serverTimestamp(),
            });
            debugPrint('📢 Push notification triggered');
          }
        } catch (e) {
          debugPrint('⚠️ Error triggering notification: $e');
        }
      }
      
      debugPrint('✅ Firestore update SUCCESS!');
      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
    } catch (e, stackTrace) {
      debugPrint('❌ ERROR updating Firestore: $e');
      debugPrint('📋 Stack trace:');
      debugPrint(stackTrace.toString().split('\n').take(5).join('\n'));
      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
      
      state = !isOperating;
      rethrow;
    }
  }
}

/// Stream provider to watch the owner's truck status in real-time
@riverpod
Stream<TruckStatus?> ownerTruckStatus(OwnerTruckStatusRef ref) async* {
  final repository = ref.watch(truckRepositoryProvider);
  
  // Get truck ID from current user
  final ownedTruckId = ref.watch(currentUserTruckIdProvider);
  
  if (ownedTruckId == null) {
    yield null; // No owned truck
    return;
  }
  
  // Watch all trucks stream and filter for owner's truck
  final allTrucksStream = repository.watchTrucks();
  
  await for (final trucks in allTrucksStream) {
    final ownerTruck = trucks.firstWhere(
      (truck) => truck.id == ownedTruckId,
      orElse: () => trucks.first, // Fallback to first truck
    );
    
    yield ownerTruck.status;
  }
}

/// Provider to get the owner's truck data
@riverpod
Stream<Truck?> ownerTruck(OwnerTruckRef ref) async* {
  final repository = ref.watch(truckRepositoryProvider);
  final userEmail = ref.watch(currentUserEmailProvider);
  
  if (userEmail.isEmpty) {
    yield null;
    return;
  }
  
  // Watch all trucks and filter by owner email
  final allTrucksStream = repository.watchTrucks();
  
  await for (final trucks in allTrucksStream) {
    final ownerTruck = trucks.where((truck) => truck.ownerEmail == userEmail).firstOrNull;
    yield ownerTruck;
  }
}

