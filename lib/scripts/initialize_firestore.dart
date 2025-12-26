import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  debugPrint('🔥 Starting Firestore Initialization...');
  
  try {
    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      debugPrint('📱 Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase initialized');
    } else {
      debugPrint('✅ Firebase already initialized');
    }

    // Create repository
    final repository = TruckRepository();
    debugPrint('📦 Repository created');

    // Check if data already exists
    debugPrint('🔍 Checking for existing data...');
    final existingTrucks = await repository.getTrucks();
    
    if (existingTrucks.isNotEmpty) {
      debugPrint('⚠️  Found ${existingTrucks.length} existing trucks in Firestore');
      debugPrint('🗑️  Clearing old data...');
      await repository.deleteAllTrucks();
      debugPrint('✅ Old data cleared');
    }

    // Upload mock data
    debugPrint('📤 Uploading ${MockDataMigration.mockTrucks.length} trucks...');
    await runMockDataMigration(repository);
    
    // Verify upload
    final uploadedTrucks = await repository.getTrucks();
    debugPrint('✅ Uploaded ${uploadedTrucks.length} trucks successfully!');
    
    // Display summary
    debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🎉 FIRESTORE INITIALIZATION COMPLETE!');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
    debugPrint('📊 Summary:');
    debugPrint('   • Total trucks: ${uploadedTrucks.length}');
    debugPrint('   • Food types: ${uploadedTrucks.map((t) => t.foodType).toSet().join(', ')}');
    debugPrint('   • On route: ${uploadedTrucks.where((t) => t.status.name == 'onRoute').length}');
    debugPrint('   • Resting: ${uploadedTrucks.where((t) => t.status.name == 'resting').length}');
    debugPrint('   • Maintenance: ${uploadedTrucks.where((t) => t.status.name == 'maintenance').length}');
    debugPrint('');
    debugPrint('📍 Locations:');
    for (final truck in uploadedTrucks) {
      debugPrint('   • ${truck.truckNumber} (${truck.foodType}): ${truck.locationDescription}');
    }
    debugPrint('');
    debugPrint('✅ App is now ready to use Firestore data!');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
  } catch (e, stackTrace) {
    debugPrint('❌ ERROR during Firestore initialization:');
    debugPrint('   $e');
    debugPrint('Stack trace:');
    debugPrint('$stackTrace');
    rethrow;
  }
}

/// Quick check if Firestore has data
Future<bool> hasFirestoreData() async {
  try {
    final repository = TruckRepository();
    final trucks = await repository.getTrucks();
    return trucks.isNotEmpty;
  } catch (e) {
    debugPrint('⚠️  Error checking Firestore: $e');
    return false;
  }
}

/// Reset Firestore data (delete all and re-upload)
Future<void> resetFirestore() async {
  debugPrint('🔄 Resetting Firestore data...');
  await initializeFirestore();
}





