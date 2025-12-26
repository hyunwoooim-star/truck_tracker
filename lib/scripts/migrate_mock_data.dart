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

  /// Mock truck data (8 diverse trucks)
  /// Truck #1 is owned by hyunwoooim@gmail.com for testing
  static final List<Truck> mockTrucks = [
    const Truck(
      id: '1',
      truckNumber: 'BM-001',
      driverName: '배민 라이더 박빠름',
      status: TruckStatus.onRoute,
      foodType: '닭꼬치',
      locationDescription: '2번 출구 앞',
      latitude: 37.5665,
      longitude: 126.9780, // 시청
      imageUrl: 'https://images.unsplash.com/photo-1532635241-17e820acc59f?w=400&fit=crop',
      ownerEmail: 'hyunwoooim@gmail.com', // 🔑 테스트용 사장님 계정
    ),
    const Truck(
      id: '2',
      truckNumber: 'BM-002',
      driverName: '배민 트럭 김든든',
      status: TruckStatus.resting,
      foodType: '호떡',
      locationDescription: '공원 분수대 옆',
      latitude: 37.5700,
      longitude: 126.9820, // 광화문 인근
      imageUrl: 'https://images.unsplash.com/photo-1619871790279-d6a290068400?w=400&fit=crop',
      ownerEmail: 'owner2@example.com',
    ),
    const Truck(
      id: '3',
      truckNumber: 'BM-003',
      driverName: '배민 기사 이꼼꼼',
      status: TruckStatus.maintenance,
      foodType: '어묵',
      locationDescription: '시청 광장',
      latitude: 37.5610,
      longitude: 126.9930, // 명동 쪽
      imageUrl: 'https://images.unsplash.com/photo-1598515213685-011520970387?w=400&fit=crop',
      ownerEmail: 'owner3@example.com',
    ),
    const Truck(
      id: '4',
      truckNumber: 'BM-004',
      driverName: '배민 라이더 최쾌속',
      status: TruckStatus.onRoute,
      foodType: '심야라멘',
      locationDescription: '3번 출구 앞',
      latitude: 37.5580,
      longitude: 126.9368, // 신촌역
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&fit=crop',
      ownerEmail: 'owner4@example.com',
    ),
    const Truck(
      id: '5',
      truckNumber: 'BM-005',
      driverName: '배민 트럭 정정시',
      status: TruckStatus.resting,
      foodType: '붕어빵',
      locationDescription: '학교 후문',
      latitude: 37.5125,
      longitude: 127.1028, // 잠실
      imageUrl: 'https://images.unsplash.com/photo-1610818020073-a59407428699?w=400&fit=crop',
      ownerEmail: 'owner5@example.com',
    ),
    const Truck(
      id: '6',
      truckNumber: 'BM-006',
      driverName: '배민 라이더 조맛나',
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
      truckNumber: 'BM-007',
      driverName: '배민 트럭 윤달콤',
      status: TruckStatus.onRoute,
      foodType: '크레페퀸',
      locationDescription: '홍대 놀이터 앞',
      latitude: 37.5563,
      longitude: 126.9237, // 홍대입구역
      imageUrl: 'https://images.unsplash.com/photo-1519915212116-7cfef71f1d3e?w=400&fit=crop',
      ownerEmail: 'owner7@example.com',
    ),
    const Truck(
      id: '8',
      truckNumber: 'BM-008',
      driverName: '배민 기사 강바삭',
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

