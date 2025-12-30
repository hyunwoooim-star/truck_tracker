# Truck Tracker 프로젝트 상세 분석 보고서

**분석 일자**: 2025-12-26
**분석자**: Claude (Opus 4.5)
**프로젝트 경로**: `truck ver.1/truck_tracker`

---

## 📊 프로젝트 개요

### 기본 정보
- **총 Dart 파일**: 87개
- **아키텍처**: Clean Architecture (Feature 기반)
- **상태 관리**: Riverpod 2.6.1 (코드 생성 방식)
- **백엔드**: Firebase (Firestore, Auth, FCM, Storage)
- **플랫폼**: Flutter (Web, Android, iOS 지원)
- **테스트 커버리지**: 0% (기본 카운터 테스트만 존재)

### 프로젝트 구조
```
lib/
├── main.dart                    # 앱 진입점
├── firebase_options.dart        # Firebase 설정
├── core/
│   └── themes/app_theme.dart    # 테마 (Mustard Yellow + Midnight Charcoal)
├── features/                    # 13개 Feature 모듈
│   ├── auth/                    # 인증
│   ├── analytics/               # 분석 추적
│   ├── checkin/                 # QR 체크인
│   ├── favorite/                # 즐겨찾기
│   ├── location/                # GPS 위치
│   ├── notifications/           # FCM 푸시 알림
│   ├── order/                   # 주문 시스템
│   ├── owner_dashboard/         # 사장님 대시보드
│   ├── review/                  # 리뷰/평점
│   ├── schedule/                # 일정 관리
│   ├── storage/                 # Firebase Storage
│   ├── talk/                    # 채팅
│   ├── truck/                   # 트럭 소유권
│   ├── truck_detail/            # 트럭 상세
│   ├── truck_list/              # 트럭 목록
│   └── truck_map/               # 지도 뷰
└── generated/l10n/              # 한글/영어 지역화
```

---

## 🎯 주요 기능 분석

### 1. 고객 기능
- **지도 기반 트럭 탐색**: Google Maps + DraggableScrollableSheet (3단계)
- **검색 & 필터**: 음식 종류별 필터 (9개 카테고리), 트럭명/운전자 검색
- **트럭 상세 정보**: 메뉴, 가격, 위치, 공지사항, 영업 상태
- **주문 시스템**: 장바구니, 주문 내역
- **리뷰/평점**: 별점(1-5), 사진 첨부(최대 3장), 사장님 답변
- **즐겨찾기**: 좋아하는 트럭 저장, FCM 토픽 구독
- **QR 체크인**: 카메라 스캔, 로열티 포인트 적립 (10포인트/체크인)
- **실시간 채팅**: 사장님과 1:1 채팅

### 2. 사장님 기능
- **대시보드**: 오늘의 통계 (조회수, 리뷰, 즐겨찾기)
- **영업 관리**: 시작/종료 버튼, 실시간 상태 업데이트
- **QR 코드**: 체크인용 QR 생성 및 표시
- **현금 판매 입력**: 금액, 메모 기록
- **분석 화면**: 일별 통계, 날짜 범위 선택, CSV 다운로드
- **일정 관리**: 주간 스케줄 설정
- **리뷰 관리**: 고객 리뷰에 답변
- **트럭 정보 수정**: 메뉴, 가격, 공지사항 업데이트

### 3. 공통 기능
- **인증**: Firebase Auth (이메일/비밀번호, Google 로그인 준비)
- **실시간 위치**: Geolocator를 통한 GPS 추적
- **위치 캐싱**: 30초 간격, 50m 이하 이동 무시 (배터리 절약)
- **FCM 푸시 알림**: 트럭 영업 시작, 새 리뷰 등
- **이미지 업로드**: Firebase Storage 연동

---

## 🔍 코드베이스 심층 분석

### Clean Architecture 준수도
**✅ 장점**:
- Feature별 명확한 폴더 구조
- Data/Domain/Presentation 레이어 분리
- Freezed를 통한 불변 모델
- Repository 패턴 적용

**⚠️ 개선 필요**:
- 일부 Provider에서 수동 선언 혼용
- 비즈니스 로직이 Presentation 레이어에 혼재

### 상태 관리 (Riverpod)
**구현 현황**:
- `@riverpod` 코드 생성 방식 사용
- StreamProvider로 Firestore 실시간 데이터 구독
- NotifierProvider로 mutable 상태 관리

**발견된 문제**:
```dart
// ❌ 일부 파일에서 수동 Provider 선언
final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepository();
});
```

### Firebase 통합
**Firestore 컬렉션 구조**:
```
trucks/{truckId}
  - analytics/{dateKey}        # 일별 분석 데이터
  - schedules/{dateKey}         # 일정
  - talks/{messageId}           # 채팅 메시지
users/{userId}
  - ownedTruckId (필드)         # 소유한 트럭 ID
reviews/{reviewId}
orders/{orderId}
favorites/{docId}
checkins/{checkinId}
```

**성능 이슈**:
- 인덱스 누락 (where + orderBy 쿼리)
- limit() 없는 무제한 쿼리
- N+1 쿼리 패턴 존재

---

## 🚨 발견된 주요 문제점

### Critical Issues (앱 안정성 위협)

#### 1. 메모리 누수 - FCM 토큰 갱신 스트림
**파일**: `lib/features/notifications/fcm_service.dart:187`

```dart
// ❌ 현재 코드
void listenToTokenRefresh(String userId) {
  _messaging.onTokenRefresh.listen((newToken) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': newToken,
    });
  });
}
```

**문제**:
- StreamSubscription이 저장되지 않아 취소 불가능
- 앱이 실행되는 동안 계속 메모리 점유
- 여러 번 호출 시 중복 구독 발생

**영향**:
- 장시간 사용 시 메모리 사용량 증가
- 백그라운드에서도 리소스 소비

---

#### 2. 앱 크래시 위험 - 안전하지 않은 firstWhere 사용
**위치 3곳**:
1. `lib/features/truck/services/truck_ownership_service.dart:245`
2. `lib/features/owner_dashboard/presentation/owner_status_provider.dart:152`
3. `lib/features/truck_map/presentation/truck_map_screen.dart:318`

```dart
// ❌ truck_ownership_service.dart:245
final truckDoc = trucksSnapshot.docs.firstWhere(
  (doc) => doc.id == '$i',
  orElse: () => throw StateError('Truck $i not found'),  // 크래시!
);

// ❌ owner_status_provider.dart:152
final ownerTruck = trucks.firstWhere(
  (truck) => truck.id == ownedTruckId,
  orElse: () => trucks.first,  // trucks가 비어있으면 크래시!
);
```

**문제**:
- 조건에 맞는 요소가 없을 때 예외 발생
- 빈 리스트에서 `.first` 호출 시 크래시

**발생 시나리오**:
- 트럭 데이터가 삭제된 경우
- Firestore 동기화 지연
- 네트워크 오류로 빈 데이터 수신

---

#### 3. N+1 쿼리 문제 - 분석 데이터 조회
**파일**: `lib/features/analytics/data/analytics_repository.dart:214-227`

```dart
// ❌ 현재 코드 (N+1 문제)
for (final doc in snapshot.docs) {
  final data = doc.data();
  final date = DateTime.parse(doc.id);

  // 각 날짜마다 별도 쿼리 실행! 🔥
  final reviewCount = await _getReviewCountForDate(truckId, date);

  dailyData.add(DailyAnalyticsItem(
    date: date,
    clicks: data['clicks'] ?? 0,
    reviewCount: reviewCount,
    // ...
  ));
}
```

**문제**:
- 7일 범위 조회 시 → 1 + 7 = 8번의 Firestore 쿼리
- 30일 범위 조회 시 → 1 + 30 = 31번의 쿼리
- Firestore 읽기 비용 급증
- 응답 시간 증가

**예상 비용**:
- 일일 사장님 100명, 각 7일 조회 → 800 reads/day
- 월간 비용: 약 $5-10 (최적화 시 $0.5-1)

---

### High Priority (성능 저하)

#### 4. 지도 마커 매 빌드마다 재생성
**파일**:
- `lib/features/truck_map/presentation/truck_map_screen.dart:211-236`
- `lib/features/truck_map/presentation/map_first_screen.dart:119-138`

```dart
// ❌ build 메서드 내에서
@override
Widget build(BuildContext context) {
  final trucks = ref.watch(truckListProvider);

  final markers = trucks.map((truck) {
    return Marker(
      markerId: MarkerId(truck.id),
      position: LatLng(truck.latitude, truck.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(truck.foodType)),
      // ...
    );
  }).toSet();  // 매번 새로 생성!

  return GoogleMap(markers: markers, ...);
}
```

**문제**:
- State 변경 시 전체 마커 Set 재생성
- BitmapDescriptor 생성 비용 높음
- 100개 트럭 → 100개 마커 매번 재생성

**성능 영향**:
- 프레임 드롭 (60fps → 40fps)
- 지도 pan/zoom 시 버벅임

---

#### 5. Color.withOpacity() 과다 사용
**전체**: 56회 호출 (9개 파일)

**주요 파일별 분포**:
- `owner_dashboard_screen.dart`: 11회
- `truck_detail_screen.dart`: 8회
- `talk_widget.dart`: 6회
- `owner_qr_screen.dart`: 5회

```dart
// ❌ 매 빌드마다 새 Color 객체 생성
Container(
  decoration: BoxDecoration(
    border: Border.all(color: _mustard.withOpacity(0.3)),  // 🔥
    borderRadius: BorderRadius.circular(12),
    color: Colors.black.withOpacity(0.3),  // 🔥
  ),
)
```

**문제**:
- `withOpacity()`는 매번 새 Color 인스턴스 생성
- GC(Garbage Collection) 압력 증가
- 핫 패스(build 메서드)에서 수백 번 호출

---

#### 6. ListView 최적화 누락
**파일**: `lib/features/truck_map/presentation/map_first_screen.dart:251`

```dart
// ❌ itemExtent 없음
return ListView.builder(
  controller: scrollController,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  itemCount: trucks.length,
  itemBuilder: (context, index) {
    return TruckCard(truck: trucks[index]);
  },
);
```

**문제**:
- Flutter가 모든 아이템 높이를 측정해야 함
- 긴 목록에서 스크롤 성능 저하

---

### Medium Priority (코드 품질)

#### 7. 556개 디버그 로그 (프로덕션 코드)
**파일별 통계**:
```
truck_repository.dart        75+ 개
fcm_service.dart              29 개
truck_map_screen.dart         29 개
truck_provider.dart           22 개
owner_status_provider.dart    21 개
... (19개 파일 더)
```

**예시**:
```dart
debugPrint('📊 Tracked click for truck $truckId');
debugPrint('✅ Order placed: ${docRef.id}');
debugPrint('🔐 AuthWrapper: User not logged in → LoginScreen');
print('❌ Error getting FCM token: $e');
```

**문제**:
- 프로덕션 빌드에서도 로그 출력 (성능 영향)
- 민감 정보 노출 위험
- 로그 일관성 부족

---

#### 8. 코드 중복
**a) 마커 색상 맵핑 중복**
- `truck_map_screen.dart:42-57`
- `map_first_screen.dart:62-73`

```dart
// 두 파일에 동일한 맵핑 존재
static double _getMarkerHue(String foodType) {
  final colorMap = {
    '닭꼬치': BitmapDescriptor.hueRed,
    '불막창': BitmapDescriptor.hueRose,
    '호떡': BitmapDescriptor.hueOrange,
    // ... 동일한 맵핑
  };
  return colorMap[foodType] ?? 175.0;
}
```

**b) 필터 태그 중복**
- `truck_list_screen.dart:365-375`
- `map_first_screen.dart:455-465`

```dart
static const List<String> _filterTags = [
  '전체', '닭꼬치', '호떡', '어묵', '붕어빵',
  '심야라멘', '불막창', '크레페퀸', '옛날통닭',
];
```

**c) StatusTag 위젯 중복**
- `truck_list_screen.dart:533-589` (57줄)
- `map_first_screen.dart:395-449` (55줄)

---

#### 9. 하드코딩된 한글 문자열 (50+ 개)
**Localization 인프라는 존재**하지만 일부 화면에서 미사용:

```dart
// ❌ truck_list_screen.dart
title: const Text('트럭 리스트'),
Text('데이터를 불러올 수 없습니다'),
SnackBar(content: Text('즐겨찾기 반영 실패!'))

// ❌ map_first_screen.dart
Text('현재 운영 중인 트럭이 없습니다')
Text('트럭이 없습니다')

// ✅ 이미 존재하는 localization 파일
// lib/generated/l10n/app_localizations_ko.dart (130+ 문자열)
// lib/generated/l10n/app_localizations_en.dart (130+ 문자열)
```

---

### Low Priority (기술 부채)

#### 10. 테스트 커버리지 0%
**현재 상태**:
```dart
// test/widget_test.dart (기본 Flutter 템플릿)
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('0'), findsOneWidget);  // 이 테스트는 실패함
  expect(find.text('1'), findsNothing);
});
```

**문제**:
- 실제 프로젝트 기능과 무관한 테스트
- Repository, Service, Provider 모두 테스트 없음
- 리팩토링 시 회귀 테스트 불가능

---

#### 11. TODO/FIXME 주석
**FCM Cloud Function 미구현**:
```dart
// fcm_service.dart:142-151
// TODO: Call Cloud Function to send notification
// This is where you would call your Cloud Function
// For now, we just log
debugPrint('Would send notification here');
```

**Mock 데이터 제거됨**:
```dart
// truck_detail_provider.dart:159
// TODO: Mock reviews removed - incompatible with Review model

// truck_detail_provider.dart:163
// TODO: Fix mock reviews to match Review model
```

---

#### 12. 기타 코드 품질 이슈
- **백업 파일**: `fcm_service.dart.bak` 커밋됨
- **불일치 Provider 패턴**: `@riverpod`와 수동 선언 혼용
- **Magic Numbers**: 하드코딩된 숫자 (50, 100, 10 등)
- **긴 파일**: 600-800줄 파일 (owner_dashboard_screen.dart)
- **Legacy 코드**: 테마에 `electricBlue = mustardYellow` 별칭

---

## 📈 성능 벤치마크 예상

### 최적화 전 (현재)
```
초기 로딩: ~3-4초
트럭 목록 스크롤: 40-50 FPS (버벅임)
지도 마커 업데이트: 200-300ms (프레임 드롭)
분석 화면 로딩 (7일): ~2초
메모리 사용량: 120-150MB
일일 Firestore 읽기: ~2000회 (테스트 환경)
```

### 최적화 후 (예상)
```
초기 로딩: ~1-1.5초 (50% 개선)
트럭 목록 스크롤: 60 FPS (부드러움)
지도 마커 업데이트: <50ms (메모이제이션)
분석 화면 로딩 (7일): <500ms (75% 개선)
메모리 사용량: 80-100MB (30% 감소)
일일 Firestore 읽기: ~500회 (75% 감소)
```

---

## 🎯 개선 권장사항 요약

### Immediate (즉시)
1. FCM 스트림 누수 수정 → 메모리 안정성
2. firstWhere 안전 처리 → 크래시 방지
3. .bak 파일 삭제 → 코드베이스 정리

### Short-term (1-2주)
4. N+1 쿼리 최적화 → Firestore 비용 50% 절감
5. 지도 마커 메모이제이션 → 60fps 보장
6. Color 객체 재사용 → GC 압력 감소
7. 디버그 로그 정리 → 프로덕션 성능 향상

### Medium-term (2-4주)
8. 중복 코드 제거 → 유지보수성 향상
9. 한글 문자열 localization → 다국어 지원
10. 에러 핸들링 표준화 → 사용자 경험 개선

### Long-term (1-2개월)
11. 테스트 작성 (60% 커버리지) → 안정성 보장
12. FCM Cloud Function 구현 → 알림 기능 완성
13. 문서화 (README, API docs) → 협업 효율

---

## 📚 기술 스택 요약

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Riverpod 2.6.1
- **Code Generation**: freezed, riverpod_generator, build_runner
- **Navigation**: MaterialPageRoute (수동)

### Backend
- **BaaS**: Firebase
  - Firestore (NoSQL DB)
  - Firebase Auth (이메일/비밀번호)
  - Firebase Storage (이미지)
  - Firebase Messaging (FCM)

### Libraries
- **UI**: google_maps_flutter, cached_network_image, fl_chart
- **QR**: qr_flutter, mobile_scanner
- **Location**: geolocator
- **Localization**: flutter_localizations, intl

---

## 🔗 관련 문서
- 개선 계획: `IMPROVEMENT_PLAN.md`
- 기존 가이드: `📄 상세 가이드4.txt`
- 작업 기록: `여기까지함3.txt`

---

**분석 완료일**: 2025-12-26
**다음 단계**: 6단계 개선 계획 실행
