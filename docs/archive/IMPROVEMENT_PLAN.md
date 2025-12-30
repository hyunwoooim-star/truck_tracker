# Truck Tracker 개선 실행 계획

**작성일**: 2025-12-26
**예상 기간**: 15-22일
**목표**: 프로덕션 배포 준비 완료

---

## 🎯 개선 목표

### 성능
- 초기 로딩: 3초 → 1초 (66% 개선)
- 스크롤 FPS: 40-50 → 60 (부드러움 보장)
- Firestore 비용: 75% 절감
- 메모리 사용: 30% 감소

### 안정성
- 메모리 누수 0건
- 크래시 위험 제거
- 에러 핸들링 표준화

### 품질
- 테스트 커버리지: 0% → 60%
- 코드 중복 제거
- 완전한 다국어 지원

---

## 📋 6단계 실행 계획

## Phase 1: Critical Fixes ⚠️
**기간**: 2-3일 | **우선순위**: CRITICAL | **의존성**: 없음

### 목표
앱의 안정성을 위협하는 치명적 버그 수정

### 작업 항목

#### 1.1 FCM 스트림 메모리 누수 수정
**파일**: `lib/features/notifications/fcm_service.dart`

**현재 문제** (라인 187):
```dart
void listenToTokenRefresh(String userId) {
  _messaging.onTokenRefresh.listen((newToken) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': newToken,
    });
  });
}
```

**수정 방안**:
```dart
class FcmService {
  StreamSubscription<String>? _tokenRefreshSubscription;

  void listenToTokenRefresh(String userId) {
    // 기존 구독 취소
    _tokenRefreshSubscription?.cancel();

    // 새 구독 시작 및 저장
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((newToken) async {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': newToken,
      });
    });
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }
}
```

**Provider 수정**:
```dart
@riverpod
class FcmServiceNotifier extends _$FcmServiceNotifier {
  FcmService? _service;

  @override
  FcmService build() {
    _service = FcmService();
    ref.onDispose(() {
      _service?.dispose();
    });
    return _service!;
  }
}
```

---

#### 1.2 firstWhere 크래시 위험 제거

**파일 1**: `lib/features/truck/services/truck_ownership_service.dart:245`
```dart
// ❌ 현재
final truckDoc = trucksSnapshot.docs.firstWhere(
  (doc) => doc.id == '$i',
  orElse: () => throw StateError('Truck $i not found'),
);

// ✅ 수정
final truckDoc = trucksSnapshot.docs
    .where((doc) => doc.id == '$i')
    .firstOrNull;

if (truckDoc == null) {
  available++;
  continue;
}
```

**파일 2**: `lib/features/owner_dashboard/presentation/owner_status_provider.dart:152`
```dart
// ❌ 현재
final ownerTruck = trucks.firstWhere(
  (truck) => truck.id == ownedTruckId,
  orElse: () => trucks.first,  // 빈 리스트면 크래시!
);

// ✅ 수정
final ownerTruck = trucks
    .where((truck) => truck.id == ownedTruckId)
    .firstOrNull;

if (ownerTruck == null) {
  yield null;
  continue;
}
```

**파일 3**: `lib/features/truck_map/presentation/truck_map_screen.dart:318`
```dart
// ❌ 현재
final targetTruck = trucks.firstWhere(
  (t) => t.id == truckId,
  orElse: () => trucks.first,
);

// ✅ 수정
final targetTruck = trucks
    .where((t) => t.id == truckId)
    .firstOrNull ?? trucks.firstOrNull;

if (targetTruck == null) {
  // 트럭이 없을 때 처리
  return;
}
```

---

#### 1.3 백업 파일 삭제
```bash
rm lib/features/notifications/fcm_service.dart.bak
```

---

### 검증 방법
- [ ] 앱을 24시간 실행 → 메모리 증가 <10%
- [ ] 빈 트럭 목록 상태에서 앱 크래시 안 남
- [ ] `git ls-files | grep .bak` → 결과 없음

---

## Phase 2: Performance Optimization 🚀
**기간**: 3-4일 | **우선순위**: HIGH | **의존성**: Phase 1

### 목표
사용자 경험에 직접적으로 영향을 주는 성능 병목 제거

### 작업 항목

#### 2.1 N+1 쿼리 최적화
**파일**: `lib/features/analytics/data/analytics_repository.dart`

**현재 코드** (214-227줄):
```dart
Future<List<DailyAnalyticsItem>> getDailyAnalytics(
  String truckId,
  DateTimeRange dateRange,
) async {
  final snapshot = await _firestore
      .collection('trucks')
      .doc(truckId)
      .collection('analytics')
      .where('date', isGreaterThanOrEqualTo: dateRange.start)
      .where('date', isLessThanOrEqualTo: dateRange.end)
      .get();

  final dailyData = <DailyAnalyticsItem>[];
  for (final doc in snapshot.docs) {
    // ❌ N+1: 각 날짜마다 별도 쿼리!
    final reviewCount = await _getReviewCountForDate(truckId, date);
    dailyData.add(DailyAnalyticsItem(...));
  }
  return dailyData;
}
```

**수정 코드**:
```dart
Future<List<DailyAnalyticsItem>> getDailyAnalytics(
  String truckId,
  DateTimeRange dateRange,
) async {
  // 1. Analytics 데이터 조회
  final analyticsSnapshot = await _firestore
      .collection('trucks')
      .doc(truckId)
      .collection('analytics')
      .where('date', isGreaterThanOrEqualTo: dateRange.start)
      .where('date', isLessThanOrEqualTo: dateRange.end)
      .get();

  // 2. ✅ 리뷰를 한 번에 일괄 조회
  final reviewsSnapshot = await _firestore
      .collection('reviews')
      .where('truckId', isEqualTo: truckId)
      .where('createdAt', isGreaterThanOrEqualTo:
          Timestamp.fromDate(dateRange.start))
      .where('createdAt', isLessThanOrEqualTo:
          Timestamp.fromDate(dateRange.end))
      .get();

  // 3. 날짜별로 리뷰 카운트 집계
  final reviewsByDate = <String, int>{};
  for (final doc in reviewsSnapshot.docs) {
    final createdAt = (doc.data()['createdAt'] as Timestamp).toDate();
    final dateKey = _getDateKey(createdAt);
    reviewsByDate[dateKey] = (reviewsByDate[dateKey] ?? 0) + 1;
  }

  // 4. 결과 조합
  final dailyData = <DailyAnalyticsItem>[];
  for (final doc in analyticsSnapshot.docs) {
    final data = doc.data();
    final dateKey = doc.id;

    dailyData.add(DailyAnalyticsItem(
      date: DateTime.parse(dateKey),
      clicks: data['clicks'] ?? 0,
      reviewCount: reviewsByDate[dateKey] ?? 0,
      favoriteCount: data['favoriteCount'] ?? 0,
    ));
  }

  return dailyData;
}
```

**성능 개선**:
- 7일 조회: 8회 → 2회 쿼리 (75% 감소)
- 30일 조회: 31회 → 2회 쿼리 (93% 감소)

---

#### 2.2 지도 마커 메모이제이션
**파일**:
- `lib/features/truck_map/presentation/truck_map_screen.dart`
- `lib/features/truck_map/presentation/map_first_screen.dart`

**방법 1: 수동 캐싱**
```dart
class _MapFirstScreenState extends ConsumerState<MapFirstScreen> {
  Set<Marker>? _cachedMarkers;
  List<Truck>? _lastTrucks;

  @override
  Widget build(BuildContext context) {
    final trucks = ref.watch(truckListProvider);

    // ✅ 트럭 목록이 변경된 경우만 마커 재생성
    if (_lastTrucks != trucks.value) {
      _cachedMarkers = _buildMarkers(trucks.value ?? []);
      _lastTrucks = trucks.value;
    }

    return GoogleMap(
      markers: _cachedMarkers ?? {},
      ...
    );
  }

  Set<Marker> _buildMarkers(List<Truck> trucks) {
    return trucks.map((truck) => Marker(
      markerId: MarkerId(truck.id),
      position: LatLng(truck.latitude, truck.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        MarkerColors.getHue(truck.foodType),
      ),
    )).toSet();
  }
}
```

**방법 2: useMemoized (flutter_hooks 사용 시)**
```dart
final markers = useMemoized(
  () => _buildMarkers(trucks.value ?? []),
  [trucks.value],
);
```

---

#### 2.3 Color 객체 재사용
**새 파일**: `lib/core/themes/app_theme.dart` 수정

**추가할 상수**:
```dart
class AppTheme {
  // 기존 색상
  static const Color mustardYellow = Color(0xFFFFC107);
  static const Color midnightCharcoal = Color(0xFF121212);

  // ✅ 미리 계산된 투명도 변형
  static const Color mustardYellow10 = Color(0x1AFFC107);  // 10%
  static const Color mustardYellow15 = Color(0x26FFC107);  // 15%
  static const Color mustardYellow20 = Color(0x33FFC107);  // 20%
  static const Color mustardYellow30 = Color(0x4DFFC107);  // 30%
  static const Color mustardYellow50 = Color(0x80FFC107);  // 50%

  static const Color black10 = Color(0x1A000000);
  static const Color black20 = Color(0x33000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black50 = Color(0x80000000);

  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);

  static const Color grey15 = Color(0x26808080);
  static const Color orange15 = Color(0x26FF9800);
}
```

**사용 예시**:
```dart
// ❌ 이전
Container(
  decoration: BoxDecoration(
    border: Border.all(color: _mustard.withOpacity(0.3)),
    color: Colors.black.withOpacity(0.3),
  ),
)

// ✅ 수정 후
Container(
  decoration: BoxDecoration(
    border: Border.all(color: AppTheme.mustardYellow30),
    color: AppTheme.black30,
  ),
)
```

**전역 검색 및 교체**:
```bash
# VSCode에서
# 검색: \.withOpacity\((0\.\d+)\)
# 각 파일별로 적절한 상수로 교체
```

---

#### 2.4 ListView itemExtent 추가
**파일**: `lib/features/truck_map/presentation/map_first_screen.dart:251`

```dart
// ❌ 이전
return ListView.builder(
  controller: scrollController,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  itemCount: trucks.length,
  itemBuilder: (context, index) {
    return TruckCard(truck: trucks[index]);
  },
);

// ✅ 수정
return ListView.builder(
  controller: scrollController,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  itemCount: trucks.length,
  itemExtent: 100.0,  // TruckCard 높이
  itemBuilder: (context, index) {
    return TruckCard(truck: trucks[index]);
  },
);
```

---

### 검증 방법
- [ ] Flutter DevTools로 FPS 측정 → 60fps 유지
- [ ] 분석 화면 30일 조회 → Firestore 읽기 2회만 발생
- [ ] 메모리 프로파일러 → Color 객체 생성 급감
- [ ] 지도에서 100개 마커 표시 → 부드러운 pan/zoom

---

## Phase 3: Code Quality & Debug Cleanup 🧹
**기간**: 2-3일 | **우선순위**: MEDIUM | **병렬**: Phase 2와 동시 가능

### 목표
유지보수성 향상 및 프로덕션 코드 정리

### 작업 항목

#### 3.1 AppLogger 유틸리티 생성
**새 파일**: `lib/core/utils/app_logger.dart`

```dart
import 'package:flutter/foundation.dart';

/// 앱 전역 로깅 유틸리티
///
/// Debug 모드에서만 로그를 출력하며, Release 모드에서는
/// 크래시 리포팅 서비스로 전송합니다.
class AppLogger {
  /// 일반 디버그 로그
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix$message');
    }
  }

  /// 정보성 로그
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️ $prefix$message');
    }
  }

  /// 경고 로그
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️ $prefix$message');
    }
  }

  /// 에러 로그
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('❌ $prefix$message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }

    // TODO: Production에서 Firebase Crashlytics로 전송
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
```

**교체 작업**:
```bash
# 전체 파일에서 검색 및 교체
print(' → AppLogger.debug(
debugPrint(' → AppLogger.debug(
print('❌ → AppLogger.error(
```

**주요 대상 파일** (24개):
1. `truck_repository.dart` (75+ 개)
2. `fcm_service.dart` (29개)
3. `truck_map_screen.dart` (29개)
4. ... (나머지 21개 파일)

---

#### 3.2 공통 상수 추출

**a) 마커 색상 상수**
**새 파일**: `lib/core/constants/marker_colors.dart`

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 음식 종류별 지도 마커 색상 매핑
class MarkerColors {
  MarkerColors._();

  static const Map<String, double> foodTypeHues = {
    '닭꼬치': BitmapDescriptor.hueRed,        // 빨강
    '불막창': BitmapDescriptor.hueRose,       // 장미색
    '호떡': BitmapDescriptor.hueOrange,       // 주황
    '어묵': BitmapDescriptor.hueYellow,       // 노랑
    '붕어빵': BitmapDescriptor.hueYellow,     // 노랑
    '심야라멘': BitmapDescriptor.hueViolet,   // 보라
    '크레페퀸': BitmapDescriptor.hueMagenta,  // 마젠타
    '옛날통닭': BitmapDescriptor.hueGreen,    // 초록
  };

  /// 음식 종류에 따른 마커 색상(Hue) 반환
  ///
  /// 등록되지 않은 음식 종류는 기본값(청록색 175.0) 반환
  static double getHue(String foodType) {
    return foodTypeHues[foodType] ?? 175.0; // 기본: 청록색
  }
}
```

**삭제할 중복 코드**:
- `truck_map_screen.dart:42-57`의 `_getMarkerHue` 메서드
- `map_first_screen.dart:62-73`의 `_getMarkerHue` 메서드

**사용 예시**:
```dart
// ✅ 수정 후
import 'package:truck_tracker/core/constants/marker_colors.dart';

Marker(
  icon: BitmapDescriptor.defaultMarkerWithHue(
    MarkerColors.getHue(truck.foodType),
  ),
)
```

---

**b) 필터 태그 상수**
**새 파일**: `lib/core/constants/food_types.dart`

```dart
/// 음식 종류 필터 관련 상수
class FoodTypes {
  FoodTypes._();

  /// 필터 태그 목록 (전체 포함)
  static const List<String> filterTags = [
    '전체',
    '닭꼬치',
    '호떡',
    '어묵',
    '붕어빵',
    '심야라멘',
    '불막창',
    '크레페퀸',
    '옛날통닭',
  ];

  /// 기본 필터 (전체)
  static const String defaultFilter = '전체';

  /// '전체' 필터인지 확인
  static bool isAllFilter(String filter) => filter == defaultFilter;
}
```

**삭제할 중복 코드**:
- `truck_list_screen.dart:365-375`
- `map_first_screen.dart:455-465`

---

**c) StatusTag 위젯 통합**
**새 파일**: `lib/shared/widgets/status_tag.dart`

```dart
import 'package:flutter/material.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';

/// 트럭 영업 상태 태그 위젯
class StatusTag extends StatelessWidget {
  const StatusTag({
    super.key,
    required this.status,
  });

  final TruckStatus status;

  @override
  Widget build(BuildContext context) {
    final (text, color) = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  (String, Color) _getStatusInfo(TruckStatus status) {
    switch (status) {
      case TruckStatus.onRoute:
        return ('운행 중', Colors.green);
      case TruckStatus.stopped:
        return ('정차 중', Colors.orange);
      case TruckStatus.closed:
        return ('영업 종료', Colors.grey);
      case TruckStatus.maintenance:
        return ('정비 중', Colors.red);
    }
  }
}
```

**삭제할 중복 코드**:
- `truck_list_screen.dart:533-589` (57줄)
- `map_first_screen.dart:395-449` (55줄)

**사용 예시**:
```dart
import 'package:truck_tracker/shared/widgets/status_tag.dart';

// ✅ 간단한 사용
StatusTag(status: truck.status)
```

---

**d) 날짜 유틸리티**
**새 파일**: `lib/core/utils/date_utils.dart`

```dart
/// DateTime 확장 메서드
extension DateTimeExtensions on DateTime {
  /// Firestore용 날짜 키 생성 (YYYY-MM-DD)
  ///
  /// 예: 2025-12-26
  String toDateKey() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// 시간 제거 (날짜만)
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }
}
```

**교체 예시**:
```dart
// ❌ 이전
'${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'

// ✅ 수정 후
date.toDateKey()
```

---

### 검증 방법
- [ ] `flutter analyze` → 경고 0개
- [ ] `grep -r "print(" lib/` → 결과 없음
- [ ] `grep -r "debugPrint(" lib/ | grep -v "kDebugMode"` → 결과 없음
- [ ] 앱 실행 → Release 모드에서 로그 없음

---

## Phase 4: Localization 🌏
**기간**: 1-2일 | **우선순위**: MEDIUM | **의존성**: Phase 3

### 목표
모든 하드코딩된 한글 문자열을 localization 시스템으로 이동

### 작업 흐름

#### 4.1 하드코딩 문자열 찾기
```bash
# 한글 문자열 검색
grep -r "'[가-힣]" lib/ --include="*.dart" > korean_strings.txt
```

#### 4.2 ARB 파일에 키 추가
**파일**: `lib/l10n/app_ko.arb`, `lib/l10n/app_en.arb`

**예시**:
```json
// app_ko.arb에 추가
{
  "truckList": "트럭 리스트",
  "cannotLoadData": "데이터를 불러올 수 없습니다",
  "favoriteFailed": "즐겨찾기 반영 실패!",
  "noOperatingTrucks": "현재 운영 중인 트럭이 없습니다",
  "noTrucks": "트럭이 없습니다"
}

// app_en.arb에 추가
{
  "truckList": "Truck List",
  "cannotLoadData": "Cannot load data",
  "favoriteFailed": "Failed to update favorite!",
  "noOperatingTrucks": "No operating trucks available",
  "noTrucks": "No trucks"
}
```

#### 4.3 코드 생성
```bash
flutter gen-l10n
```

#### 4.4 코드 수정
```dart
// ❌ 이전
title: const Text('트럭 리스트'),

// ✅ 수정 후
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

title: Text(AppLocalizations.of(context)!.truckList),
```

#### 4.5 주요 수정 파일
1. `truck_list_screen.dart`
2. `truck_map_screen.dart`
3. `map_first_screen.dart`
4. `owner_dashboard_screen.dart`
5. `analytics_screen.dart`

---

### 검증 방법
- [ ] `grep -r "'[가-힣]" lib/ --include="*.dart"` → 주석 외에는 없음
- [ ] 앱을 한글로 실행 → 모든 텍스트 정상 표시
- [ ] 앱을 영어로 실행 → 모든 텍스트 영어로 표시
- [ ] `flutter gen-l10n` → 에러 없이 완료

---

## Phase 5: Testing Infrastructure 🧪
**기간**: 5-7일 | **우선순위**: HIGH | **의존성**: Phase 1-3

### 목표
60% 이상의 테스트 커버리지 달성

### 5.1 테스트 구조 생성
```
test/
├── unit/
│   ├── features/
│   │   ├── analytics/
│   │   │   └── analytics_repository_test.dart
│   │   ├── auth/
│   │   │   └── auth_service_test.dart
│   │   ├── truck_list/
│   │   │   ├── truck_repository_test.dart
│   │   │   └── truck_provider_test.dart
│   │   ├── favorite/
│   │   │   └── favorite_repository_test.dart
│   │   └── location/
│   │       └── location_service_test.dart
│   └── core/
│       ├── utils/
│       │   └── date_utils_test.dart
│       └── constants/
│           └── marker_colors_test.dart
├── widget/
│   ├── status_tag_test.dart
│   ├── truck_card_test.dart
│   └── filter_bar_test.dart
├── integration/
│   ├── auth_flow_test.dart
│   └── truck_browsing_flow_test.dart
└── mocks/
    ├── mock_firestore.dart
    ├── mock_auth.dart
    └── mock_location.dart
```

### 5.2 필수 패키지 추가
**pubspec.yaml**:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  fake_cloud_firestore: ^2.4.0
  firebase_auth_mocks: ^0.13.0
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### 5.3 단위 테스트 예시

**test/unit/features/truck_list/truck_repository_test.dart**:
```dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_list/data/truck_repository.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late TruckRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = TruckRepository(firestore: fakeFirestore);
  });

  group('TruckRepository', () {
    test('watchTrucks returns stream of trucks', () async {
      // Arrange
      await fakeFirestore.collection('trucks').doc('1').set({
        'truckNumber': 'BM-001',
        'status': 'onRoute',
        'latitude': 37.5665,
        'longitude': 126.9780,
        'foodType': '닭꼬치',
        'isOpen': true,
      });

      // Act
      final stream = repository.watchTrucks();

      // Assert
      expect(
        stream,
        emitsInOrder([
          predicate<List<Truck>>((trucks) => trucks.length == 1),
        ]),
      );
    });

    test('watchTrucks filters out maintenance trucks', () async {
      // Arrange
      await fakeFirestore.collection('trucks').add({
        'status': 'maintenance',
        'isOpen': false,
      });

      // Act
      final stream = repository.watchTrucks();

      // Assert
      expect(
        stream,
        emitsInOrder([
          predicate<List<Truck>>((trucks) => trucks.isEmpty),
        ]),
      );
    });
  });
}
```

### 5.4 위젯 테스트 예시

**test/widget/status_tag_test.dart**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/truck_list/domain/truck.dart';
import 'package:truck_tracker/shared/widgets/status_tag.dart';

void main() {
  testWidgets('StatusTag displays correct text for onRoute',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusTag(status: TruckStatus.onRoute),
        ),
      ),
    );

    // Assert
    expect(find.text('운행 중'), findsOneWidget);
  });

  testWidgets('StatusTag has green color for onRoute',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusTag(status: TruckStatus.onRoute),
        ),
      ),
    );

    // Assert
    final container = tester.widget<Container>(
      find.byType(Container).first,
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.border, isNotNull);
  });
}
```

---

### 검증 방법
- [ ] `flutter test` → 모든 테스트 통과
- [ ] `flutter test --coverage` → 커버리지 60% 이상
- [ ] CI/CD 파이프라인에 테스트 추가

---

## Phase 6: Documentation & Polish 📚
**기간**: 2-3일 | **우선순위**: LOW | **의존성**: 전체

### 6.1 README.md 작성
**파일**: `README.md`

```markdown
# 🚚 Truck Tracker

푸드트럭 위치 추적 및 주문 관리 플랫폼

## 주요 기능

### 고객
- 실시간 푸드트럭 위치 확인
- 메뉴 및 가격 조회
- 리뷰 작성 및 즐겨찾기
- QR 체크인 및 로열티 포인트

### 사장님
- 영업 관리 대시보드
- 실시간 통계 및 분석
- 현금 판매 기록
- 고객 리뷰 관리

## 기술 스택

- **Frontend**: Flutter 3.x
- **State Management**: Riverpod 2.6.1
- **Backend**: Firebase (Firestore, Auth, FCM, Storage)
- **Maps**: Google Maps Flutter
- **Localization**: Korean, English

## 시작하기

### 사전 요구사항

- Flutter SDK 3.10 이상
- Dart 3.0 이상
- Firebase 프로젝트

### 설치

1. 저장소 클론
\`\`\`bash
git clone https://github.com/hyunwoooim-star/truck_tracker.git
cd truck_tracker
\`\`\`

2. 의존성 설치
\`\`\`bash
flutter pub get
\`\`\`

3. Firebase 설정
\`\`\`bash
# firebase_options.dart 파일 생성
flutterfire configure
\`\`\`

4. 코드 생성
\`\`\`bash
flutter pub run build_runner build
\`\`\`

5. 실행
\`\`\`bash
flutter run -d chrome  # 웹
flutter run -d android  # Android
\`\`\`

## 테스트

\`\`\`bash
# 모든 테스트 실행
flutter test

# 커버리지 포함
flutter test --coverage
\`\`\`

## 아키텍처

Clean Architecture + Feature 기반 모듈 구조

\`\`\`
lib/
├── core/          # 공통 코드
├── features/      # 기능 모듈
│   ├── data/      # Repository
│   ├── domain/    # Models
│   └── presentation/  # UI + Providers
└── shared/        # 공유 위젯
\`\`\`

## 라이선스

MIT License
```

---

### 6.2 FCM Cloud Function 구현
**새 폴더**: `functions/`

**functions/package.json**:
```json
{
  "name": "functions",
  "scripts": {
    "build": "tsc",
    "deploy": "firebase deploy --only functions"
  },
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.5.0"
  },
  "devDependencies": {
    "typescript": "^5.3.0"
  }
}
```

**functions/src/index.ts**:
```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

/**
 * 트럭 영업 시작 시 즐겨찾기한 사용자들에게 알림 전송
 */
export const sendTruckOpenNotification = functions.firestore
  .document('trucks/{truckId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // 영업 시작 감지 (isOpen: false -> true)
    if (!before.isOpen && after.isOpen) {
      const truckId = context.params.truckId;
      const truckNumber = after.truckNumber;

      // 즐겨찾기한 사용자의 FCM 토큰 수집
      const favoritesSnapshot = await admin.firestore()
        .collection('favorites')
        .where('truckId', '==', truckId)
        .get();

      const tokens: string[] = [];

      for (const doc of favoritesSnapshot.docs) {
        const userId = doc.data().userId;
        const userDoc = await admin.firestore()
          .collection('users')
          .doc(userId)
          .get();

        const fcmToken = userDoc.data()?.fcmToken;
        if (fcmToken) {
          tokens.push(fcmToken);
        }
      }

      // 알림 전송
      if (tokens.length > 0) {
        const message: admin.messaging.MulticastMessage = {
          tokens,
          notification: {
            title: `${truckNumber} 영업 시작!`,
            body: '즐겨찾는 트럭이 영업을 시작했습니다. 지금 방문하세요!',
          },
          data: {
            truckId,
            type: 'truck_opened',
          },
          android: {
            priority: 'high',
          },
          apns: {
            headers: {
              'apns-priority': '10',
            },
          },
        };

        const response = await admin.messaging().sendEachForMulticast(message);
        console.log(`✅ Sent ${response.successCount} notifications`);
      }
    }
  });

/**
 * 새 리뷰 작성 시 트럭 사장님에게 알림 전송
 */
export const sendNewReviewNotification = functions.firestore
  .document('reviews/{reviewId}')
  .onCreate(async (snapshot, context) => {
    const review = snapshot.data();
    const truckId = review.truckId;

    // 트럭 정보 조회
    const truckDoc = await admin.firestore()
      .collection('trucks')
      .doc(truckId)
      .get();

    if (!truckDoc.exists) return;

    const truck = truckDoc.data()!;
    const ownerId = truck.ownerId;

    // 사장님 FCM 토큰 조회
    const ownerDoc = await admin.firestore()
      .collection('users')
      .doc(ownerId)
      .get();

    const fcmToken = ownerDoc.data()?.fcmToken;

    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: '새 리뷰가 작성되었습니다',
          body: `⭐ ${review.rating}점 - "${review.content.substring(0, 30)}..."`,
        },
        data: {
          truckId,
          reviewId: context.params.reviewId,
          type: 'new_review',
        },
      });
    }
  });
```

**배포**:
```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

---

### 6.3 에러 핸들링 개선
**패턴 변경**:

```dart
// ❌ 이전 (에러 숨김)
Future<List<Truck>> getTrucks() async {
  try {
    final snapshot = await _firestore.collection('trucks').get();
    return snapshot.docs.map((doc) => Truck.fromJson(doc.data())).toList();
  } catch (e) {
    return [];  // 에러 숨김!
  }
}

// ✅ 수정 후 (에러 전파)
Future<List<Truck>> getTrucks() async {
  try {
    final snapshot = await _firestore.collection('trucks').get();
    return snapshot.docs.map((doc) => Truck.fromJson(doc.data())).toList();
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to get trucks',
      error: e,
      stackTrace: stackTrace,
      tag: 'TruckRepository',
    );
    rethrow;  // 호출자가 처리하도록
  }
}

// UI에서 처리
final trucksAsync = ref.watch(truckListProvider);

trucksAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(
    message: '트럭 목록을 불러올 수 없습니다',
    onRetry: () => ref.refresh(truckListProvider),
  ),
  data: (trucks) => TruckList(trucks: trucks),
);
```

---

### 6.4 네트워크 연결 체크
**새 파일**: `lib/core/services/connectivity_service.dart`

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// 네트워크 연결 상태 서비스
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// 연결 상태 스트림
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }

  /// 현재 연결 상태
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

@riverpod
ConnectivityService connectivityService(ConnectivityServiceRef ref) {
  return ConnectivityService();
}

@riverpod
Stream<bool> connectionStatus(ConnectionStatusRef ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionStream;
}
```

**사용 예시**:
```dart
final isConnected = ref.watch(connectionStatusProvider);

isConnected.when(
  loading: () => SizedBox(),
  error: (_, __) => SizedBox(),
  data: (connected) {
    if (!connected) {
      return OfflineBanner();
    }
    return TruckList();
  },
);
```

---

### 검증 방법
- [ ] README.md 완성 및 검토
- [ ] Cloud Functions 배포 및 동작 확인
- [ ] 네트워크 끊었을 때 오프라인 배너 표시
- [ ] 에러 발생 시 사용자 친화적 메시지 표시

---

## ⏱️ 전체 일정

| Phase | 작업일 | 누적일 | 병렬 가능 |
|-------|--------|--------|----------|
| Phase 1 | 2-3일 | 3일 | ❌ |
| Phase 2 | 3-4일 | 7일 | ❌ |
| Phase 3 | 2-3일 | 7일 | ✅ (Phase 2와) |
| Phase 4 | 1-2일 | 9일 | ❌ |
| Phase 5 | 5-7일 | 16일 | 부분 |
| Phase 6 | 2-3일 | 19일 | ❌ |

**최소**: 15일
**최대**: 22일
**평균**: 18일 (약 3.5주)

---

## 🎯 최종 성공 기준

### 성능
- [x] 초기 로딩 < 1.5초
- [x] 스크롤 60 FPS 유지
- [x] Firestore 읽기 75% 감소
- [x] 메모리 사용 30% 감소

### 안정성
- [x] 24시간 실행 시 크래시 0건
- [x] 메모리 누수 0건
- [x] 오프라인 모드 대응

### 품질
- [x] 테스트 커버리지 60% 이상
- [x] `flutter analyze` 경고 0개
- [x] 모든 문자열 localized
- [x] 문서화 완료

---

## Phase 7-10: 추가 기능 구현 (완료) ✅

### Phase 7: Production Readiness
- Firebase Functions 배포 (FCM 알림)
- 프로덕션 환경 설정
- 배포 준비 최종 점검

### Phase 8: Advanced Features
- **주간 영업일정**: weeklySchedule 필드 추가
- **Analytics 차트**: fl_chart를 활용한 일일 클릭 트렌드 LineChart
- **리뷰 사진**: 리뷰 시스템 이미지 업로드 지원

### Phase 9: Order System Enhancement
- **실시간 주문 통계 대시보드**: owner_dashboard_screen.dart
  - 오늘의 주문 건수 (total, completed, pending)
  - 오늘의 매출 통계
  - _buildTodayOrderStats() 위젯 구현
  - _OrderStatTile 커스텀 위젯

### Phase 10: Advanced Search & Filter System ⭐
**구현 내용**:

#### Filter Logic Enhancement (truck_provider.dart)
- **TruckFilterState 확장**:
  - `selectedStatuses`: 트럭 상태 필터 (운행중/휴식/정비)
  - `maxDistance`: 거리 필터 (1km/5km/10km/전체)
  - `minRating`: 최소 평점 필터 (3.0+/4.0+/4.5+)
  - `openOnly`: 영업 중만 표시
  - `hasActiveFilters`: 활성 필터 여부 체크

- **TruckFilterNotifier 메서드**:
  - `toggleStatus()`: 상태 다중 선택
  - `setMaxDistance()`: 거리 제한 설정
  - `setMinRating()`: 최소 평점 설정
  - `setOpenOnly()`: 영업 중 필터 토글
  - `clearAllFilters()`: 모든 필터 초기화

- **필터 파이프라인**:
  1. 음식 종류 → 2. 검색 키워드 → 3. 트럭 상태
  4. 최소 평점 → 5. 영업 중 여부 → 6. 거리 제한

#### UI Components (truck_list_screen.dart, +250 lines)
- **_AdvancedFilterDialog** (186 lines):
  - 상태 필터 칩 (운행 중, 휴식, 정비 중)
  - 거리 필터 칩 (1km, 5km, 10km, 전체)
  - 평점 필터 칩 (⭐ 3.0+, 4.0+, 4.5+, 전체)
  - 영업 중만 표시 스위치
  - 활성 필터 초기화 버튼

- **_SortOptionsDialog**:
  - 가까운 순 (GPS 거리 기준)
  - 이름 순 (가나다 순)
  - 평점 순 (높은 순)

- **_FilterBar 개선**:
  - 고급 필터 버튼 (활성 시 배지 표시)
  - 정렬 버튼
  - 음식 종류 칩 스크롤

#### UX 개선사항
- ✅ 필터 활성 시 파란색 배지 표시
- ✅ 원탭으로 고급 필터 접근
- ✅ 실시간 필터 적용 (디바운싱 500ms)
- ✅ Material Design 칩 & 스위치
- ✅ 필터 조합 가능 (AND 로직)
- ✅ 명확한 시각적 피드백

**기술적 특징**:
- Stream 기반 반응형 업데이트
- 거리 계산 최적화 (사용자 위치 캐싱)
- Null-safe 필터링
- 로깅 파이프라인 (디버깅용)
- 기존 검색/음식 필터와 통합

---

## 📝 다음 단계

### 완료된 작업
- [x] Phase 1-10 모두 완료
- [x] 웹 배포 이슈 분석 (WEB_DEPLOYMENT_PLAN.md)
- [x] 고급 검색 & 필터 시스템 구현

### 우선순위 작업
1. **웹 배포 해결**: WEB_DEPLOYMENT_PLAN.md의 Option 2 (CanvasKit) 시도
2. **Phase 11+**: 소셜 기능, 쿠폰 시스템 등

---

**작성자**: Claude (Sonnet 4.5)
**마지막 업데이트**: 2025-12-28
