import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_preferences_repository.dart';
import 'nearby_truck_service.dart';

/// Provider for NearbyTruckService
final nearbyTruckServiceProvider = Provider<NearbyTruckService>((ref) {
  return NearbyTruckService();
});

/// Provider to manage nearby truck monitoring based on user settings
final nearbyTruckMonitoringProvider = FutureProvider.family<void, String>((
  ref,
  userId,
) async {
  final service = ref.watch(nearbyTruckServiceProvider);
  final settingsAsync = ref.watch(notificationSettingsStreamProvider(userId));

  await settingsAsync.when(
    data: (settings) async {
      if (settings.nearbyTrucks) {
        await service.startMonitoring(
          userId: userId,
          settings: settings,
        );
      } else {
        service.stopMonitoring();
      }
    },
    loading: () async {},
    error: (e, s) async {},
  );
});

/// Provider to check if nearby monitoring is active
final isNearbyMonitoringActiveProvider = Provider<bool>((ref) {
  final service = ref.watch(nearbyTruckServiceProvider);
  return service.isMonitoring;
});

/// Provider for nearby truck count
final nearbyActiveTruckCountProvider = Provider<int>((ref) {
  final service = ref.watch(nearbyTruckServiceProvider);
  return service.activeTruckCount;
});
