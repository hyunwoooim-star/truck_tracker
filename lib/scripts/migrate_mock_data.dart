import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/app_logger.dart';
import '../features/truck_list/data/truck_repository.dart';
import '../features/truck_list/domain/truck.dart';
import '../features/truck_detail/domain/truck_detail.dart';
import '../features/truck_detail/domain/menu_item.dart';

/// Script to migrate mock data to Firestore
/// 
/// This can be called from the app or run as a standalone script
/// to populate Firestore with initial truck data.
class MockDataMigration {
  final TruckRepository _repository;

  MockDataMigration(this._repository);

  /// Test truck data (3 trucks for testing)
  ///
  /// Test Accounts:
  /// - admin: hyunwoooim@gmail.com (role: admin)
  /// - owner1: owner1@test.com → 골목식당 닭꼬치
  /// - owner2: owner2@test.com → 심야라멘
  /// - owner3: owner3@test.com → 파리지앵 크레페
  /// - customer: customer@test.com (role: user)
  static final List<Truck> mockTrucks = [
    const Truck(
      id: '1',
      truckNumber: '서울 12가 3456',
      driverName: '골목식당 닭꼬치',
      status: TruckStatus.onRoute,
      foodType: '꼬치',
      locationDescription: '시청역 2번 출구',
      latitude: 37.5662,
      longitude: 126.9779,
      imageUrl: 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=800&q=80',
      ownerEmail: 'owner1@test.com',
      announcement: '오늘은 양념 닭꼬치 할인!',
    ),
    const Truck(
      id: '2',
      truckNumber: '서울 78라 5678',
      driverName: '심야라멘',
      status: TruckStatus.resting,
      foodType: '라멘',
      locationDescription: '신촌역 3번 출구',
      latitude: 37.5579,
      longitude: 126.9392,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=80',
      ownerEmail: 'owner2@test.com',
    ),
    const Truck(
      id: '3',
      truckNumber: '서울 45사 7890',
      driverName: '파리지앵 크레페',
      status: TruckStatus.onRoute,
      foodType: '디저트',
      locationDescription: '홍대 놀이터',
      latitude: 37.5563,
      longitude: 126.9234,
      imageUrl: 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=800&q=80',
      ownerEmail: 'owner3@test.com',
    ),
  ];

  /// Truck details (menus for each truck)
  static final Map<String, TruckDetail> mockTruckDetails = {
    '1': const TruckDetail(
      truckId: '1',
      operatingHours: '17:00 - 23:00',
      description: '30년 경력의 노하우로 만드는 정통 닭꼬치. 특제 양념과 숯불 향이 일품입니다.',
      averageRating: 4.8,
      menuItems: [
        MenuItem(id: 'menu_1', name: '숯불 닭꼬치', price: 4000, description: '특제 양념 숯불구이'),
        MenuItem(id: 'menu_2', name: '양념 닭꼬치', price: 4500, description: '매콤달콤 양념'),
        MenuItem(id: 'menu_3', name: '치즈 닭꼬치', price: 5000, description: '모짜렐라 치즈 토핑'),
      ],
      reviews: [],
    ),
    '2': const TruckDetail(
      truckId: '2',
      operatingHours: '18:00 - 03:00',
      description: '심야에 즐기는 정통 일본 라멘. 돈코츠 육수가 일품.',
      averageRating: 4.9,
      menuItems: [
        MenuItem(id: 'menu_1', name: '돈코츠 라멘', price: 9000, description: '진한 돼지뼈 육수'),
        MenuItem(id: 'menu_2', name: '미소 라멘', price: 8500, description: '된장 베이스'),
        MenuItem(id: 'menu_3', name: '차슈동', price: 8000, description: '차슈덮밥'),
      ],
      reviews: [],
    ),
    '3': const TruckDetail(
      truckId: '3',
      operatingHours: '11:00 - 22:00',
      description: '파리 정통 레시피. 바삭하고 부드러운 크레페.',
      averageRating: 4.8,
      menuItems: [
        MenuItem(id: 'menu_1', name: '누텔라 크레페', price: 6000, description: '누텔라 + 바나나'),
        MenuItem(id: 'menu_2', name: '딸기 크레페', price: 6500, description: '생딸기 + 생크림'),
        MenuItem(id: 'menu_3', name: '햄치즈 크레페', price: 5500, description: '짭짤한 식사 크레페'),
      ],
      reviews: [],
    ),
  };

  /// Migrate all mock trucks to Firestore
  Future<void> migrateTrucks() async {
    try {
      AppLogger.debug('Starting migration of ${mockTrucks.length} trucks to Firestore...', tag: 'MockDataMigration');

      await _repository.addTrucksBatch(mockTrucks);

      AppLogger.success('Successfully migrated ${mockTrucks.length} trucks!', tag: 'MockDataMigration');
      AppLogger.debug('Truck IDs: ${mockTrucks.map((t) => t.id).join(', ')}', tag: 'MockDataMigration');
    } catch (e, stackTrace) {
      AppLogger.error('Error migrating trucks', error: e, stackTrace: stackTrace, tag: 'MockDataMigration');
      rethrow;
    }
  }

  /// Migrate all truck details (menus) to Firestore
  Future<void> migrateTruckDetails() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final detailsCollection = firestore.collection('truck_details');

      AppLogger.debug('Starting migration of ${mockTruckDetails.length} truck details...', tag: 'MockDataMigration');

      for (final entry in mockTruckDetails.entries) {
        await detailsCollection.doc(entry.key).set(entry.value.toFirestore());
        AppLogger.debug('Migrated details for ${entry.key}', tag: 'MockDataMigration');
      }

      AppLogger.success('Successfully migrated ${mockTruckDetails.length} truck details!', tag: 'MockDataMigration');
    } catch (e, stackTrace) {
      AppLogger.error('Error migrating truck details', error: e, stackTrace: stackTrace, tag: 'MockDataMigration');
      rethrow;
    }
  }

  /// Clear all trucks from Firestore (use with caution!)
  Future<void> clearAllTrucks() async {
    try {
      AppLogger.debug('Clearing all trucks from Firestore...', tag: 'MockDataMigration');

      await _repository.deleteAllTrucks();

      AppLogger.success('All trucks cleared!', tag: 'MockDataMigration');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing trucks', error: e, stackTrace: stackTrace, tag: 'MockDataMigration');
      rethrow;
    }
  }

  /// Reset: Clear all and re-migrate
  Future<void> resetData() async {
    try {
      AppLogger.debug('Resetting Firestore data...', tag: 'MockDataMigration');

      await clearAllTrucks();
      await migrateTrucks();

      AppLogger.success('Data reset complete!', tag: 'MockDataMigration');
    } catch (e, stackTrace) {
      AppLogger.error('Error resetting data', error: e, stackTrace: stackTrace, tag: 'MockDataMigration');
      rethrow;
    }
  }
}

/// Helper function to run migration from anywhere in the app
Future<void> runMockDataMigration(TruckRepository repository) async {
  final migration = MockDataMigration(repository);
  await migration.migrateTrucks();
}

/// Helper function to reset Firestore data
Future<void> resetFirestoreData(TruckRepository repository) async {
  final migration = MockDataMigration(repository);
  await migration.resetData();
}

