import '../core/utils/app_logger.dart';
import '../features/truck_list/data/truck_repository.dart';
import '../features/truck_list/domain/truck.dart';

/// Script to migrate mock data to Firestore
/// 
/// This can be called from the app or run as a standalone script
/// to populate Firestore with initial truck data.
class MockDataMigration {
  final TruckRepository _repository;

  MockDataMigration(this._repository);

  /// Mock truck data (8 diverse trucks with premium names)
  /// Truck #1 is owned by hyunwoooim@gmail.com for testing
  static final List<Truck> mockTrucks = [
    const Truck(
      id: '1',
      truckNumber: '서울 12가 3456',
      driverName: '골목식당 닭꼬치',
      status: TruckStatus.onRoute,
      foodType: '닭꼬치',
      locationDescription: '시청역 2번 출구',
      latitude: 37.5665,
      longitude: 126.9780, // 시청
      imageUrl: 'https://images.unsplash.com/photo-1532635241-17e820acc59f?w=400&fit=crop',
      ownerEmail: 'hyunwoooim@gmail.com', // 테스트용 사장님 계정
    ),
    const Truck(
      id: '2',
      truckNumber: '서울 34나 7890',
      driverName: '할매손 호떡집',
      status: TruckStatus.resting,
      foodType: '호떡',
      locationDescription: '광화문 분수대',
      latitude: 37.5700,
      longitude: 126.9820, // 광화문 인근
      imageUrl: 'https://images.unsplash.com/photo-1619871790279-d6a290068400?w=400&fit=crop',
      ownerEmail: 'owner2@example.com',
    ),
    const Truck(
      id: '3',
      truckNumber: '서울 56다 1234',
      driverName: '부산어묵 본점',
      status: TruckStatus.maintenance,
      foodType: '어묵',
      locationDescription: '명동 중앙로',
      latitude: 37.5610,
      longitude: 126.9930, // 명동 쪽
      imageUrl: 'https://images.unsplash.com/photo-1598515213685-011520970387?w=400&fit=crop',
      ownerEmail: 'owner3@example.com',
    ),
    const Truck(
      id: '4',
      truckNumber: '서울 78라 5678',
      driverName: '심야식당 라멘야',
      status: TruckStatus.onRoute,
      foodType: '심야라멘',
      locationDescription: '신촌역 3번 출구',
      latitude: 37.5580,
      longitude: 126.9368, // 신촌역
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&fit=crop',
      ownerEmail: 'owner4@example.com',
    ),
    const Truck(
      id: '5',
      truckNumber: '서울 90마 9012',
      driverName: '겨울밤 붕어빵',
      status: TruckStatus.resting,
      foodType: '붕어빵',
      locationDescription: '잠실 학원가',
      latitude: 37.5125,
      longitude: 127.1028, // 잠실
      imageUrl: 'https://images.unsplash.com/photo-1610818020073-a59407428699?w=400&fit=crop',
      ownerEmail: 'owner5@example.com',
    ),
    const Truck(
      id: '6',
      truckNumber: '서울 23바 3456',
      driverName: '청춘막창',
      status: TruckStatus.onRoute,
      foodType: '불막창',
      locationDescription: '강남역 10번 출구',
      latitude: 37.4979,
      longitude: 127.0276, // 강남역
      imageUrl: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&fit=crop',
      ownerEmail: 'owner6@example.com',
    ),
    const Truck(
      id: '7',
      truckNumber: '서울 45사 7890',
      driverName: '파리지앵 크레페',
      status: TruckStatus.onRoute,
      foodType: '크레페퀸',
      locationDescription: '홍대 놀이터',
      latitude: 37.5563,
      longitude: 126.9237, // 홍대입구역
      imageUrl: 'https://images.unsplash.com/photo-1519915212116-7cfef71f1d3e?w=400&fit=crop',
      ownerEmail: 'owner7@example.com',
    ),
    const Truck(
      id: '8',
      truckNumber: '서울 67아 1234',
      driverName: '옛날통닭 원조집',
      status: TruckStatus.resting,
      foodType: '옛날통닭',
      locationDescription: '건대 로데오거리',
      latitude: 37.5403,
      longitude: 127.0688, // 건대입구역
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400&fit=crop',
      ownerEmail: 'owner8@example.com',
    ),
  ];

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

