import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/menu_item.dart';
import '../domain/truck_detail.dart';
import '../../review/domain/review.dart';
import '../data/truck_detail_repository.dart';

part 'truck_detail_provider.g.dart';

@riverpod
TruckDetailRepository truckDetailRepository(TruckDetailRepositoryRef ref) {
  return TruckDetailRepository();
}

@riverpod
Stream<TruckDetail?> truckDetailStream(TruckDetailStreamRef ref, String truckId) {
  final repository = ref.watch(truckDetailRepositoryProvider);
  return repository.watchTruckDetail(truckId);
}

// ❌ REMOVED: Mock data provider - Use truckDetailNotifierProvider instead
// @riverpod
// Future<TruckDetail> truckDetail(TruckDetailRef ref, String truckId) async {
//   await Future.delayed(const Duration(milliseconds: 300));
//   return _getMockTruckDetail(truckId);
// }

@riverpod
class TruckDetailNotifier extends _$TruckDetailNotifier {
  @override
  Stream<TruckDetail?> build(String truckId) {
    final repository = ref.watch(truckDetailRepositoryProvider);
    return repository.watchTruckDetail(truckId);
  }

  Future<void> toggleMenuItemSoldOut(String menuItemId) async {
    final repository = ref.read(truckDetailRepositoryProvider);
    await repository.toggleMenuItemSoldOut(truckId, menuItemId);
  }
}

TruckDetail _getMockTruckDetail(String truckId) {
  final menuItemsMap = {
    '1': [
      const MenuItem(id: 'm1', name: '왕닭꼬치', price: 3500, description: '푸짐한 닭꼬치'),
      const MenuItem(id: 'm2', name: '닭꼬치', price: 2500, description: '기본 닭꼬치'),
      const MenuItem(id: 'm3', name: '소금구이', price: 3000, description: '소금간 닭꼬치'),
      const MenuItem(id: 'm4', name: '치즈닭꼬치', price: 4000, description: '모짜렐라 치즈 듬뿍'),
      const MenuItem(id: 'm5', name: '마늘닭꼬치', price: 3200, description: '마늘향 가득'),
      const MenuItem(id: 'm6', name: '파닭꼬치', price: 3300, description: '신선한 대파와 함께'),
      const MenuItem(id: 'm7', name: '양념닭꼬치', price: 3500, description: '달콤매콤 양념'),
      const MenuItem(id: 'm8', name: '간장닭꼬치', price: 3200, description: '고소한 간장맛'),
      const MenuItem(id: 'm9', name: '허니머스타드닭꼬치', price: 3800, description: '허니머스타드 소스'),
      const MenuItem(id: 'm10', name: '닭껍질꼬치', price: 2800, description: '바삭한 닭껍질'),
      const MenuItem(id: 'm11', name: '닭꼬치 세트 (5개)', price: 15000, description: '다양한 맛 5종'),
      const MenuItem(id: 'm12', name: '음료 (콜라/사이다)', price: 1500, description: '시원한 탄산음료'),
    ],
    '2': [
      const MenuItem(id: 'm13', name: '호떡', price: 2000, description: '달콤한 호떡'),
      const MenuItem(id: 'm14', name: '씨앗호떡', price: 2500, description: '견과류 듬뿍'),
      const MenuItem(id: 'm15', name: '야채호떡', price: 2500, description: '건강한 야채'),
      const MenuItem(id: 'm16', name: '흑당호떡', price: 3000, description: '흑당 시럽 듬뿍'),
      const MenuItem(id: 'm17', name: '치즈호떡', price: 3500, description: '쭉 늘어나는 치즈'),
      const MenuItem(id: 'm18', name: '고구마호떡', price: 2800, description: '달콤한 고구마'),
      const MenuItem(id: 'm19', name: '팥호떡', price: 2200, description: '팥앙금 가득'),
      const MenuItem(id: 'm20', name: '피자호떡', price: 3500, description: '피자맛 호떡'),
      const MenuItem(id: 'm21', name: '초코호떡', price: 3000, description: '초콜릿 듬뿍'),
      const MenuItem(id: 'm22', name: '당근호떡', price: 2500, description: '건강한 당근'),
      const MenuItem(id: 'm23', name: '호떡 세트 (3개)', price: 6000, description: '인기메뉴 3종'),
      const MenuItem(id: 'm24', name: '따뜻한 식혜', price: 2000, description: '겨울엔 식혜'),
    ],
    '3': [
      const MenuItem(id: 'm25', name: '어묵', price: 1500, description: '따뜻한 국물'),
      const MenuItem(id: 'm26', name: '특어묵', price: 2500, description: '프리미엄 어묵'),
      const MenuItem(id: 'm27', name: '치즈어묵', price: 3000, description: '치즈 토핑'),
      const MenuItem(id: 'm28', name: '모듬어묵', price: 3500, description: '다양한 어묵'),
      const MenuItem(id: 'm29', name: '야채어묵', price: 2000, description: '야채가 들어간'),
      const MenuItem(id: 'm30', name: '꽈배기어묵', price: 2200, description: '꽈배기 모양'),
      const MenuItem(id: 'm31', name: '오징어어묵', price: 2800, description: '오징어 함유'),
      const MenuItem(id: 'm32', name: '떡볶이어묵', price: 4000, description: '떡볶이와 함께'),
      const MenuItem(id: 'm33', name: '납작어묵', price: 1800, description: '납작한 어묵'),
      const MenuItem(id: 'm34', name: '사각어묵', price: 1800, description: '사각 어묵'),
      const MenuItem(id: 'm35', name: '어묵탕 (국물)', price: 2000, description: '국물만 따로'),
      const MenuItem(id: 'm36', name: '김밥', price: 3000, description: '간단한 김밥'),
    ],
    '4': [
      const MenuItem(id: 'm37', name: '돈코츠라멘', price: 8500, description: '진한 돼지뼈 육수'),
      const MenuItem(id: 'm38', name: '매콤라멘', price: 9000, description: '불닭소스 라멘'),
      const MenuItem(id: 'm39', name: '김치라멘', price: 8000, description: '한국식 김치라멘'),
      const MenuItem(id: 'm40', name: '미소라멘', price: 8500, description: '구수한 된장라멘'),
      const MenuItem(id: 'm41', name: '쇼유라멘', price: 8000, description: '간장 베이스'),
      const MenuItem(id: 'm42', name: '탄탄멘', price: 9500, description: '고소한 참깨 육수'),
      const MenuItem(id: 'm43', name: '특제라멘', price: 11000, description: '모든 토핑 포함'),
      const MenuItem(id: 'm44', name: '차슈추가', price: 3000, description: '차슈 3장'),
      const MenuItem(id: 'm45', name: '반숙계란', price: 1500, description: '반숙 계란 1개'),
      const MenuItem(id: 'm46', name: '김추가', price: 1000, description: '김 2장'),
      const MenuItem(id: 'm47', name: '교자', price: 4000, description: '군만두 5개'),
      const MenuItem(id: 'm48', name: '맥주', price: 4000, description: '아사히/기린'),
    ],
    '5': [
      const MenuItem(id: 'm49', name: '붕어빵', price: 1000, description: '팥앙금 붕어빵'),
      const MenuItem(id: 'm50', name: '크림붕어빵', price: 1500, description: '슈크림 붕어빵'),
      const MenuItem(id: 'm51', name: '피자붕어빵', price: 2000, description: '피자맛 붕어빵'),
      const MenuItem(id: 'm52', name: '초코붕어빵', price: 1500, description: '초콜릿 붕어빵'),
      const MenuItem(id: 'm53', name: '치즈붕어빵', price: 1800, description: '치즈 붕어빵'),
      const MenuItem(id: 'm54', name: '고구마붕어빵', price: 1500, description: '고구마앙금'),
      const MenuItem(id: 'm55', name: '슈크림붕어빵', price: 1500, description: '진한 슈크림'),
      const MenuItem(id: 'm56', name: '야채붕어빵', price: 1800, description: '야채가 들어간'),
      const MenuItem(id: 'm57', name: '커스터드붕어빵', price: 1500, description: '커스터드 크림'),
      const MenuItem(id: 'm58', name: '녹차붕어빵', price: 1500, description: '녹차앙금'),
      const MenuItem(id: 'm59', name: '붕어빵 세트 (5개)', price: 4500, description: '다양한 맛 5개'),
      const MenuItem(id: 'm60', name: '우유', price: 1500, description: '따뜻한 우유'),
    ],
    '6': [
      const MenuItem(id: 'm61', name: '매콤 불막창', price: 12000, description: '숯불에 구운 막창'),
      const MenuItem(id: 'm62', name: '불대창', price: 13000, description: '쫄깃한 대창'),
      const MenuItem(id: 'm63', name: '염통', price: 10000, description: '신선한 염통'),
      const MenuItem(id: 'm64', name: '곱창', price: 11000, description: '고소한 곱창'),
      const MenuItem(id: 'm65', name: '양', price: 12000, description: '쫄깃한 양'),
      const MenuItem(id: 'm66', name: '모듬세트', price: 20000, description: '막창+대창 세트'),
      const MenuItem(id: 'm67', name: '특모듬', price: 30000, description: '5종 모듬'),
      const MenuItem(id: 'm68', name: '소주', price: 4000, description: '참이슬'),
      const MenuItem(id: 'm69', name: '맥주', price: 4500, description: '카스/하이트'),
      const MenuItem(id: 'm70', name: '볶음밥', price: 3000, description: '마무리 볶음밥'),
      const MenuItem(id: 'm71', name: '쌈채소', price: 2000, description: '신선한 쌈채소'),
      const MenuItem(id: 'm72', name: '공기밥', price: 1000, description: '공기밥'),
    ],
    '7': [
      const MenuItem(id: 'm73', name: '딸기크레페', price: 5500, description: '생딸기와 휘핑크림'),
      const MenuItem(id: 'm74', name: '초코바나나크레페', price: 5000, description: '달콤 초코바나나'),
      const MenuItem(id: 'm75', name: '블루베리크레페', price: 6000, description: '상큼한 블루베리'),
      const MenuItem(id: 'm76', name: '오레오크레페', price: 5500, description: '오레오 쿠키 크럼블'),
      const MenuItem(id: 'm77', name: '망고크레페', price: 6500, description: '신선한 망고'),
      const MenuItem(id: 'm78', name: '티라미수크레페', price: 6000, description: '티라미수 크림'),
      const MenuItem(id: 'm79', name: '녹차크레페', price: 5500, description: '녹차 크림'),
      const MenuItem(id: 'm80', name: '초코칩크레페', price: 5200, description: '초코칩 듬뿍'),
      const MenuItem(id: 'm81', name: '견과류크레페', price: 6000, description: '아몬드/호두'),
      const MenuItem(id: 'm82', name: '플레인크레페', price: 4000, description: '기본 크레페'),
      const MenuItem(id: 'm83', name: '아이스크림 추가', price: 2000, description: '바닐라 아이스크림'),
      const MenuItem(id: 'm84', name: '아메리카노', price: 3000, description: '커피'),
    ],
    '8': [
      const MenuItem(id: 'm85', name: '순살치킨', price: 15000, description: '바삭한 순살'),
      const MenuItem(id: 'm86', name: '후라이드', price: 13000, description: '옛날 후라이드'),
      const MenuItem(id: 'm87', name: '양념치킨', price: 14000, description: '달콤매콤 양념'),
      const MenuItem(id: 'm88', name: '간장치킨', price: 14000, description: '간장 베이스'),
      const MenuItem(id: 'm89', name: '마늘치킨', price: 14000, description: '마늘향 가득'),
      const MenuItem(id: 'm90', name: '파닭', price: 14000, description: '대파 듬뿍'),
      const MenuItem(id: 'm91', name: '반반', price: 15000, description: '후라이드+양념'),
      const MenuItem(id: 'm92', name: '파닭반반', price: 16000, description: '파닭+양념'),
      const MenuItem(id: 'm93', name: '순살반반', price: 16000, description: '순살 반반'),
      const MenuItem(id: 'm94', name: '콜라', price: 2000, description: '콜라 1.25L'),
      const MenuItem(id: 'm95', name: '사이다', price: 2000, description: '사이다 1.25L'),
      const MenuItem(id: 'm96', name: '무/양념/소스', price: 1000, description: '추가 사이드'),
    ],
  };

  // TODO: Mock reviews removed - incompatible with Review model
  // Real reviews will come from Firestore via ReviewRepository

  final menuItems = menuItemsMap[truckId] ?? menuItemsMap['1']!;
  // TODO: Fix mock reviews to match Review model (requires truckId, userId, int rating)
  final List<Review> reviews = []; // reviewsMap[truckId] ?? reviewsMap['1']!;

  final avgRating = 4.5; // reviews.isEmpty ? 4.5 : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

  return TruckDetail(
    truckId: truckId,
    operatingHours: '18:00 ~ 23:00 종료 예정',
    menuItems: menuItems,
    reviews: reviews,
    averageRating: avgRating,
    description: '신선한 재료로 만드는 정성스러운 푸드트럭입니다.',
  );
}


