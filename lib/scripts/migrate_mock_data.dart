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

  /// Mock truck data (8 diverse trucks with premium branding)
  /// Truck #1 is owned by hyunwoooim@gmail.com for testing
  static final List<Truck> mockTrucks = [
    const Truck(
      id: 'truck_golmok_chicken',
      truckNumber: '서울 12가 3456',
      driverName: '골목식당 닭꼬치',
      status: TruckStatus.onRoute,
      foodType: '닭꼬치',
      locationDescription: '시청역 2번 출구',
      latitude: 37.5665,
      longitude: 126.9780,
      imageUrl: 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=800&q=80',
      ownerEmail: 'hyunwoooim@gmail.com',
    ),
    const Truck(
      id: 'truck_grandma_hotteok',
      truckNumber: '서울 34나 7890',
      driverName: '할매손 호떡',
      status: TruckStatus.resting,
      foodType: '호떡',
      locationDescription: '광화문 분수대',
      latitude: 37.5700,
      longitude: 126.9820,
      imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80',
      ownerEmail: 'owner2@example.com',
    ),
    const Truck(
      id: 'truck_busan_eomuk',
      truckNumber: '서울 56다 1234',
      driverName: '부산어묵 본점',
      status: TruckStatus.maintenance,
      foodType: '어묵',
      locationDescription: '명동 중앙로',
      latitude: 37.5610,
      longitude: 126.9930,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
      ownerEmail: 'owner3@example.com',
    ),
    const Truck(
      id: 'truck_midnight_ramen',
      truckNumber: '서울 78라 5678',
      driverName: '심야라멘',
      status: TruckStatus.onRoute,
      foodType: '라멘',
      locationDescription: '신촌역 3번 출구',
      latitude: 37.5580,
      longitude: 126.9368,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=80',
      ownerEmail: 'owner4@example.com',
    ),
    const Truck(
      id: 'truck_winter_bungeoppang',
      truckNumber: '서울 90마 9012',
      driverName: '겨울밤 붕어빵',
      status: TruckStatus.resting,
      foodType: '붕어빵',
      locationDescription: '잠실 학원가',
      latitude: 37.5125,
      longitude: 127.1028,
      imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=800&q=80',
      ownerEmail: 'owner5@example.com',
    ),
    const Truck(
      id: 'truck_youth_makchang',
      truckNumber: '서울 23바 3456',
      driverName: '청춘막창',
      status: TruckStatus.onRoute,
      foodType: '막창',
      locationDescription: '강남역 10번 출구',
      latitude: 37.4979,
      longitude: 127.0276,
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
      ownerEmail: 'owner6@example.com',
    ),
    const Truck(
      id: 'truck_paris_crepe',
      truckNumber: '서울 45사 7890',
      driverName: '파리지앵 크레페',
      status: TruckStatus.onRoute,
      foodType: '크레페',
      locationDescription: '홍대 놀이터',
      latitude: 37.5563,
      longitude: 126.9237,
      imageUrl: 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=800&q=80',
      ownerEmail: 'owner7@example.com',
    ),
    const Truck(
      id: 'truck_classic_chicken',
      truckNumber: '서울 67아 1234',
      driverName: '옛날통닭',
      status: TruckStatus.resting,
      foodType: '통닭',
      locationDescription: '건대 로데오거리',
      latitude: 37.5403,
      longitude: 127.0688,
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800&q=80',
      ownerEmail: 'owner8@example.com',
    ),
  ];

  /// Mock truck details (menus for each truck)
  static final Map<String, TruckDetail> mockTruckDetails = {
    'truck_golmok_chicken': const TruckDetail(
      truckId: 'truck_golmok_chicken',
      operatingHours: '17:00 - 23:00',
      description: '30년 경력의 노하우로 만드는 정통 닭꼬치. 특제 양념과 숯불 향이 일품입니다.',
      averageRating: 4.8,
      menuItems: [
        MenuItem(id: 'menu_1', name: '숯불 닭꼬치', price: 4000, description: '특제 양념 숯불구이'),
        MenuItem(id: 'menu_2', name: '양념 닭꼬치', price: 4500, description: '매콤달콤 양념'),
        MenuItem(id: 'menu_3', name: '치즈 닭꼬치', price: 5000, description: '모짜렐라 치즈 토핑'),
        MenuItem(id: 'menu_4', name: '콤보 세트', price: 12000, description: '닭꼬치 3종 + 음료'),
      ],
      reviews: [],
    ),
    'truck_grandma_hotteok': const TruckDetail(
      truckId: 'truck_grandma_hotteok',
      operatingHours: '10:00 - 20:00',
      description: '할머니 손맛 그대로. 겉바속촉 전통 호떡 전문점입니다.',
      averageRating: 4.7,
      menuItems: [
        MenuItem(id: 'menu_1', name: '씨앗호떡', price: 2000, description: '해바라기씨 가득'),
        MenuItem(id: 'menu_2', name: '꿀호떡', price: 2000, description: '달콤한 조청'),
        MenuItem(id: 'menu_3', name: '견과류호떡', price: 2500, description: '호두, 아몬드, 땅콩'),
        MenuItem(id: 'menu_4', name: '치즈호떡', price: 3000, description: '모짜렐라 치즈'),
      ],
      reviews: [],
    ),
    'truck_busan_eomuk': const TruckDetail(
      truckId: 'truck_busan_eomuk',
      operatingHours: '11:00 - 21:00',
      description: '부산 직송 수제어묵. 시원한 국물이 일품입니다.',
      averageRating: 4.6,
      menuItems: [
        MenuItem(id: 'menu_1', name: '모듬어묵', price: 3000, description: '어묵 5종 세트'),
        MenuItem(id: 'menu_2', name: '어묵탕', price: 5000, description: '시원한 국물 + 어묵'),
        MenuItem(id: 'menu_3', name: '치즈어묵', price: 3500, description: '치즈 속 어묵'),
        MenuItem(id: 'menu_4', name: '매운어묵', price: 3500, description: '청양고추 매운맛'),
      ],
      reviews: [],
    ),
    'truck_midnight_ramen': const TruckDetail(
      truckId: 'truck_midnight_ramen',
      operatingHours: '18:00 - 03:00',
      description: '심야에 즐기는 정통 일본 라멘. 돈코츠 육수가 일품.',
      averageRating: 4.9,
      menuItems: [
        MenuItem(id: 'menu_1', name: '돈코츠 라멘', price: 9000, description: '진한 돼지뼈 육수'),
        MenuItem(id: 'menu_2', name: '미소 라멘', price: 8500, description: '된장 베이스'),
        MenuItem(id: 'menu_3', name: '차슈동', price: 7000, description: '차슈덮밥'),
        MenuItem(id: 'menu_4', name: '교자', price: 4000, description: '군만두 5개'),
      ],
      reviews: [],
    ),
    'truck_winter_bungeoppang': const TruckDetail(
      truckId: 'truck_winter_bungeoppang',
      operatingHours: '14:00 - 22:00',
      description: '겨울의 정취를 담은 바삭한 붕어빵. 팥앙금 직접 제조.',
      averageRating: 4.5,
      menuItems: [
        MenuItem(id: 'menu_1', name: '팥붕어빵', price: 1000, description: '전통 팥앙금'),
        MenuItem(id: 'menu_2', name: '슈크림붕어빵', price: 1500, description: '달콤한 슈크림'),
        MenuItem(id: 'menu_3', name: '피자붕어빵', price: 2000, description: '치즈 & 토마토'),
        MenuItem(id: 'menu_4', name: '10마리 세트', price: 8000, description: '팥 5 + 슈크림 5'),
      ],
      reviews: [],
    ),
    'truck_youth_makchang': const TruckDetail(
      truckId: 'truck_youth_makchang',
      operatingHours: '17:00 - 01:00',
      description: '청춘의 맛, 불맛 가득 막창구이. 소주 한잔과 함께!',
      averageRating: 4.7,
      menuItems: [
        MenuItem(id: 'menu_1', name: '막창 1인분', price: 15000, description: '신선한 막창 150g'),
        MenuItem(id: 'menu_2', name: '막창 2인분', price: 28000, description: '막창 300g + 된장찌개'),
        MenuItem(id: 'menu_3', name: '소금구이', price: 16000, description: '담백한 소금맛'),
        MenuItem(id: 'menu_4', name: '주먹밥', price: 2000, description: '참기름 주먹밥'),
      ],
      reviews: [],
    ),
    'truck_paris_crepe': const TruckDetail(
      truckId: 'truck_paris_crepe',
      operatingHours: '11:00 - 22:00',
      description: '파리 정통 레시피. 바삭하고 부드러운 크레페.',
      averageRating: 4.8,
      menuItems: [
        MenuItem(id: 'menu_1', name: '누텔라 크레페', price: 5500, description: '누텔라 + 바나나'),
        MenuItem(id: 'menu_2', name: '딸기 크레페', price: 6000, description: '생딸기 + 생크림'),
        MenuItem(id: 'menu_3', name: '햄치즈 크레페', price: 6500, description: '짭짤한 식사 크레페'),
        MenuItem(id: 'menu_4', name: '아이스크림 크레페', price: 7000, description: '바닐라 아이스크림'),
      ],
      reviews: [],
    ),
    'truck_classic_chicken': const TruckDetail(
      truckId: 'truck_classic_chicken',
      operatingHours: '16:00 - 24:00',
      description: '어릴 적 그 맛 그대로. 옛날 방식 통닭 전문점.',
      averageRating: 4.6,
      menuItems: [
        MenuItem(id: 'menu_1', name: '옛날통닭', price: 18000, description: '바삭한 후라이드'),
        MenuItem(id: 'menu_2', name: '양념통닭', price: 19000, description: '달콤 매콤 양념'),
        MenuItem(id: 'menu_3', name: '반반통닭', price: 19000, description: '후라이드 + 양념'),
        MenuItem(id: 'menu_4', name: '똥집튀김', price: 8000, description: '바삭한 닭똥집'),
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

