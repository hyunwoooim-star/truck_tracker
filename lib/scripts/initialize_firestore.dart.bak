import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_logger.dart';
import '../features/truck_list/data/migrate_mock_data.dart';
import '../features/truck_list/data/truck_repository.dart';
import '../firebase_options.dart';

/// Standalone script to initialize Firestore with mock data
/// 
/// Run this once to populate Firestore with initial truck data.
/// 
/// Usage from main app:
/// ```dart
/// await initializeFirestore();
/// ```
Future<void> initializeFirestore() async {
  AppLogger.debug('Starting Firestore Initialization...', tag: 'InitializeFirestore');

  try {
    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      AppLogger.debug('Initializing Firebase...', tag: 'InitializeFirestore');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppLogger.success('Firebase initialized', tag: 'InitializeFirestore');
    } else {
      AppLogger.debug('Firebase already initialized', tag: 'InitializeFirestore');
    }

    // Create repository
    final repository = TruckRepository();
    AppLogger.debug('Repository created', tag: 'InitializeFirestore');

    // Check if data already exists
    AppLogger.debug('Checking for existing data...', tag: 'InitializeFirestore');
    final existingTrucks = await repository.getTrucks();

    if (existingTrucks.isNotEmpty) {
      AppLogger.warning('Found ${existingTrucks.length} existing trucks in Firestore', tag: 'InitializeFirestore');
      AppLogger.debug('Clearing old data...', tag: 'InitializeFirestore');
      await repository.deleteAllTrucks();
      AppLogger.success('Old data cleared', tag: 'InitializeFirestore');
    }

    // Upload mock data
    AppLogger.debug('Uploading ${MockDataMigration.mockTrucks.length} trucks...', tag: 'InitializeFirestore');
    await runMockDataMigration(repository);

    // Verify upload
    final uploadedTrucks = await repository.getTrucks();
    AppLogger.success('Uploaded ${uploadedTrucks.length} trucks successfully!', tag: 'InitializeFirestore');
    
    // Display summary
    AppLogger.debug('', tag: 'InitializeFirestore');
    AppLogger.debug('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', tag: 'InitializeFirestore');
    AppLogger.success('FIRESTORE INITIALIZATION COMPLETE!', tag: 'InitializeFirestore');
    AppLogger.debug('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', tag: 'InitializeFirestore');
    AppLogger.debug('', tag: 'InitializeFirestore');
    AppLogger.debug('Summary:', tag: 'InitializeFirestore');
    AppLogger.debug('   • Total trucks: ${uploadedTrucks.length}', tag: 'InitializeFirestore');
    AppLogger.debug('   • Food types: ${uploadedTrucks.map((t) => t.foodType).toSet().join(', ')}', tag: 'InitializeFirestore');
    AppLogger.debug('   • On route: ${uploadedTrucks.where((t) => t.status.name == 'onRoute').length}', tag: 'InitializeFirestore');
    AppLogger.debug('   • Resting: ${uploadedTrucks.where((t) => t.status.name == 'resting').length}', tag: 'InitializeFirestore');
    AppLogger.debug('   • Maintenance: ${uploadedTrucks.where((t) => t.status.name == 'maintenance').length}', tag: 'InitializeFirestore');
    AppLogger.debug('', tag: 'InitializeFirestore');
    AppLogger.debug('Locations:', tag: 'InitializeFirestore');
    for (final truck in uploadedTrucks) {
      AppLogger.debug('   • ${truck.truckNumber} (${truck.foodType}): ${truck.locationDescription}', tag: 'InitializeFirestore');
    }
    AppLogger.debug('', tag: 'InitializeFirestore');
    AppLogger.success('App is now ready to use Firestore data!', tag: 'InitializeFirestore');
    AppLogger.debug('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', tag: 'InitializeFirestore');
    
  } catch (e, stackTrace) {
    AppLogger.error('ERROR during Firestore initialization', error: e, stackTrace: stackTrace, tag: 'InitializeFirestore');
    rethrow;
  }
}

/// Quick check if Firestore has data
Future<bool> hasFirestoreData() async {
  try {
    final repository = TruckRepository();
    final trucks = await repository.getTrucks();
    return trucks.isNotEmpty;
  } catch (e, stackTrace) {
    AppLogger.warning('Error checking Firestore', tag: 'InitializeFirestore');
    return false;
  }
}

/// Reset Firestore data (delete all and re-upload)
Future<void> resetFirestore() async {
  AppLogger.debug('Resetting Firestore data...', tag: 'InitializeFirestore');
  await initializeFirestore();
}





