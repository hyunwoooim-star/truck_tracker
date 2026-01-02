import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_list/presentation/truck_provider.dart';

part 'owner_status_provider.g.dart';

/// Provider that manages operating status for Owner's truck
///
/// This syncs with Firestore in real-time
@riverpod
class OwnerOperatingStatus extends _$OwnerOperatingStatus {
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
    } catch (e, stackTrace) {
      // Keep default state but log the error
      AppLogger.error('Failed to load owner truck status', error: e, stackTrace: stackTrace, tag: 'OwnerStatus');
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
    AppLogger.debug('OWNER STATUS UPDATE TRIGGERED', tag: 'OwnerStatus');
    AppLogger.debug('Current state: $state', tag: 'OwnerStatus');
    AppLogger.debug('New state: $isOperating', tag: 'OwnerStatus');
    AppLogger.debug('Owned Truck ID: $_ownedTruckId', tag: 'OwnerStatus');

    if (state == isOperating) {
      AppLogger.warning('State unchanged, skipping update', tag: 'OwnerStatus');
      return;
    }

    state = isOperating;

    if (_ownedTruckId == null) {
      AppLogger.error('No owned truck ID! Cannot update Firestore.', tag: 'OwnerStatus');
      return;
    }

    try {
      AppLogger.debug('Getting repository...', tag: 'OwnerStatus');
      final repository = ref.read(truckRepositoryProvider);

      final truckStatus = isOperating ? TruckStatus.onRoute : TruckStatus.maintenance;
      AppLogger.debug('Updating Firestore...', tag: 'OwnerStatus');
      AppLogger.debug('Truck ID: $_ownedTruckId', tag: 'OwnerStatus');
      AppLogger.debug('New Status: ${truckStatus.name}', tag: 'OwnerStatus');

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
            AppLogger.debug('Push notification triggered', tag: 'OwnerStatus');
          }
        } catch (e, stackTrace) {
          // Notification is non-critical, log but don't fail the main operation
          AppLogger.warning('Error triggering notification: $e', tag: 'OwnerStatus');
          AppLogger.debug('Stack: $stackTrace', tag: 'OwnerStatus');
        }
      }

      AppLogger.success('Firestore update SUCCESS!', tag: 'OwnerStatus');
    } catch (e, stackTrace) {
      AppLogger.error('ERROR updating Firestore', error: e, stackTrace: stackTrace, tag: 'OwnerStatus');

      state = !isOperating;
      rethrow;
    }
  }
}

/// Stream provider to watch the owner's truck status in real-time
@riverpod
Stream<TruckStatus?> ownerTruckStatus(Ref ref) async* {
  final repository = ref.watch(truckRepositoryProvider);
  
  // Get truck ID from current user
  final truckIdAsync = ref.watch(currentUserTruckIdProvider);
  final ownedTruckId = truckIdAsync.value;
  
  if (ownedTruckId == null) {
    yield null; // No owned truck
    return;
  }
  
  // Watch all trucks stream and filter for owner's truck
  final allTrucksStream = repository.watchTrucks();
  
  await for (final trucks in allTrucksStream) {
    // Use safe null-aware access to find owner's truck
    final ownerTruck = trucks
        .where((truck) => truck.id == ownedTruckId.toString())
        .firstOrNull;

    if (ownerTruck == null) {
      // Owner's truck not found in list, skip this update
      continue;
    }

    yield ownerTruck.status;
  }
}

/// Provider to get the owner's truck data
/// Uses ownedTruckId from user document to find the truck
@riverpod
Stream<Truck?> ownerTruck(Ref ref) async* {
  final repository = ref.watch(truckRepositoryProvider);

  // Get truck ID from current user's ownedTruckId field - properly await it
  final ownedTruckId = await ref.watch(currentUserTruckIdProvider.future);

  AppLogger.debug('ownerTruckProvider: ownedTruckId = $ownedTruckId', tag: 'OwnerTruck');

  if (ownedTruckId == null) {
    AppLogger.warning('ownerTruckProvider: No ownedTruckId, yielding null', tag: 'OwnerTruck');
    yield null;
    return;
  }

  // Watch all trucks and filter by truck ID
  final allTrucksStream = repository.watchTrucks();

  await for (final trucks in allTrucksStream) {
    AppLogger.debug('ownerTruckProvider: Found ${trucks.length} trucks, looking for id=$ownedTruckId', tag: 'OwnerTruck');
    final ownerTruck = trucks.where((truck) => truck.id == ownedTruckId.toString()).firstOrNull;
    AppLogger.debug('ownerTruckProvider: Found truck = ${ownerTruck?.truckNumber ?? "null"}', tag: 'OwnerTruck');
    yield ownerTruck;
  }
}

