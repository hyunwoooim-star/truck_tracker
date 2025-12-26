# 🚀 고급 기능 구현 로드맵

## 📋 **요청된 기능**

### **6. 단골 즐겨찾기 & 푸시 알림**
- 사용자가 트럭 즐겨찾기
- 사장님 영업 시작 시 푸시 알림
- FCM 통합

### **7. 주간 영업 일정표**
- 월~일 요일별 영업 장소
- 오늘의 영업 장소 표시
- 이번 주 일정 표시

### **8. 거리순 필터링 & 검색**
- 현재 위치 기준 정렬
- 가까운 순 표시
- 카테고리별 필터

### **9. 사장님 통계 대시보드**
- 트럭 클릭 횟수
- 리뷰 개수
- 즐겨찾기 수
- 그래프 시각화

---

## 🎯 **구현 계획**

### **Phase 1: 거리순 필터링** (1-1.5시간)

#### **1.1 현재 위치 가져오기**
```dart
// lib/features/location/location_service.dart
class LocationService {
  Future<Position?> getCurrentPosition()
  Stream<Position> watchPosition()
  double calculateDistance(lat1, lng1, lat2, lng2)
}
```

#### **1.2 거리 계산 Provider**
```dart
@riverpod
Future<List<TruckWithDistance>> trucksWithDistance(ref) {
  // Get user location
  // Calculate distance for each truck
  // Return sorted list
}
```

#### **1.3 UI 업데이트**
- 리스트에 거리 표시 (예: "350m")
- "가까운 순" 정렬 버튼
- 위치 권한 요청 UI

---

### **Phase 2: 즐겨찾기 시스템** (2-3시간)

#### **2.1 Firestore 구조**
```
favorites (collection)
  ├─ {userId}_{truckId} (document ID)
      ├─ userId: string
      ├─ truckId: string
      ├─ createdAt: Timestamp
      └─ fcmToken: string? (for push)

users (collection) - 업데이트
  └─ fcmToken: string?
```

#### **2.2 Favorite Repository**
```dart
class FavoriteRepository {
  Future<void> addFavorite(userId, truckId)
  Future<void> removeFavorite(userId, truckId)
  Stream<List<String>> watchUserFavorites(userId)
  Stream<List<String>> watchTruckFavorites(truckId)
  Future<int> getFavoriteCount(truckId)
  Future<bool> isFavorite(userId, truckId)
}
```

#### **2.3 UI 통합**
- 트럭 리스트에 하트 아이콘
- 트럭 상세에 즐겨찾기 버튼
- 즐겨찾기 목록 화면
- 애니메이션 효과

---

### **Phase 3: FCM 푸시 알림** (1.5-2시간)

#### **3.1 패키지 설치**
```yaml
dependencies:
  firebase_messaging: latest
  flutter_local_notifications: latest
```

#### **3.2 FCM Service**
```dart
class FCMService {
  Future<void> initialize()
  Future<String?> getToken()
  Future<void> requestPermission()
  Stream<RemoteMessage> onMessage
  Future<void> sendNotification(List<String> tokens, message)
}
```

#### **3.3 알림 로직**
```dart
// 사장님이 영업 시작 시:
1. Get truck favorites (userId list)
2. Get FCM tokens for each user
3. Send push notification: "자주 가는 [트럭이름]이 영업을 시작했어요!"
```

#### **3.4 Cloud Functions** (선택)
```javascript
// functions/index.js
exports.notifyFavorites = functions.firestore
  .document('trucks/{truckId}')
  .onUpdate((change, context) => {
    // If status changed to 'onRoute'
    // Get favorites
    // Send FCM
  });
```

---

### **Phase 4: 주간 일정표** (1.5-2시간)

#### **4.1 데이터 구조**
```dart
// Truck 모델 확장
class Truck {
  // ... 기존 필드
  Map<String, DailySchedule>? weeklySchedule;
  // Key: 'monday', 'tuesday', ..., 'sunday'
}

class DailySchedule {
  bool isOpen;
  String location;
  String? startTime; // "18:00"
  String? endTime;   // "23:00"
  LatLng? coordinates;
}
```

#### **4.2 일정 입력 UI**
```dart
// OwnerDashboardScreen
- 주간 일정표 탭
- 요일별 입력 폼
- 장소 검색 (Google Places API)
- 시간 선택 (TimePicker)
```

#### **4.3 일정 표시**
```dart
// TruckDetailScreen
- "오늘의 영업 장소" 섹션
- "이번 주 일정" 캘린더 뷰
- 영업 중/준비 중 상태
```

---

### **Phase 5: 통계 대시보드** (1.5-2시간)

#### **5.1 Analytics Collection**
```
truck_analytics (collection)
  ├─ {truckId} (document)
      ├─ viewCount: number
      ├─ favoriteCount: number
      ├─ reviewCount: number
      ├─ dailyViews: Map<date, count>
      ├─ weeklyViews: Map<week, count>
      └─ lastUpdated: Timestamp

truck_events (collection) - 이벤트 로깅
  ├─ {eventId} (auto-generated)
      ├─ truckId: string
      ├─ eventType: 'view'|'favorite'|'review'
      ├─ userId: string
      ├─ timestamp: Timestamp
```

#### **5.2 Analytics Service**
```dart
class AnalyticsService {
  Future<void> logTruckView(truckId, userId)
  Future<void> logFavorite(truckId, userId)
  Future<void> logReview(truckId, userId)
  
  Future<TruckAnalytics> getAnalytics(truckId)
  Stream<TruckAnalytics> watchAnalytics(truckId)
}
```

#### **5.3 대시보드 UI**
```dart
// OwnerAnalyticsScreen
- 오늘의 통계 (카드 뷰)
  * 조회수: 142회
  * 즐겨찾기: 38명
  * 리뷰: 12개
  
- 주간 그래프 (fl_chart 패키지)
  * 일별 조회수 추이
  * 요일별 비교
  
- 인기 시간대 분석
- 리뷰 평균 별점 추이
```

#### **5.4 차트 라이브러리**
```yaml
dependencies:
  fl_chart: ^0.68.0
```

---

## 🏗️ **Firestore 구조 업데이트**

### **favorites**
```json
{
  "userId_truckId": {
    "userId": "abc123",
    "truckId": "1",
    "createdAt": "Timestamp",
    "fcmToken": "fcm_token_here"
  }
}
```

### **trucks** (확장)
```json
{
  "id": "1",
  "weeklySchedule": {
    "monday": {
      "isOpen": true,
      "location": "강남역 2번 출구",
      "startTime": "18:00",
      "endTime": "23:00",
      "latitude": 37.4979,
      "longitude": 127.0276
    },
    "tuesday": {
      "isOpen": true,
      "location": "홍대입구역 9번 출구",
      "startTime": "19:00",
      "endTime": "00:00",
      "latitude": 37.5563,
      "longitude": 126.9236
    }
  }
}
```

### **truck_analytics**
```json
{
  "1": {
    "viewCount": 1247,
    "favoriteCount": 38,
    "reviewCount": 12,
    "dailyViews": {
      "2024-12-23": 142,
      "2024-12-22": 156
    },
    "avgRating": 4.5,
    "lastUpdated": "Timestamp"
  }
}
```

### **truck_events** (로깅)
```json
{
  "event_abc123": {
    "truckId": "1",
    "eventType": "view",
    "userId": "user_xyz",
    "timestamp": "Timestamp",
    "metadata": {
      "source": "list|map|detail",
      "duration": 30
    }
  }
}
```

---

## 🔧 **추가 패키지**

```yaml
dependencies:
  # Push Notifications
  firebase_messaging: ^15.4.5
  flutter_local_notifications: ^18.0.1
  
  # Charts
  fl_chart: ^0.68.0
  
  # Already installed:
  geolocator: ^14.0.2 ✅
```

---

## 📱 **UI 개선**

### **TruckListScreen**
```dart
- [x] 검색바
- [x] 카테고리 필터
- [ ] 거리 표시 (350m)
- [ ] 즐겨찾기 아이콘
- [ ] "가까운 순" 정렬 버튼
```

### **TruckDetailScreen**
```dart
- [x] 트럭 정보
- [x] 메뉴 리스트
- [ ] 즐겨찾기 버튼 (상단)
- [ ] 오늘의 영업 장소
- [ ] 이번 주 일정표
- [ ] 리뷰 섹션
```

### **OwnerDashboardScreen**
```dart
- [x] 영업 시작/종료 스위치
- [x] 매출 정보 (가짜)
- [ ] 주간 일정표 편집
- [ ] 통계 대시보드 탭
  * 조회수
  * 즐겨찾기 수
  * 리뷰 평균
  * 그래프
```

---

## ⏱️ **예상 일정**

| 작업 | 시간 | 누적 |
|------|------|------|
| 거리순 필터링 | 1시간 | 1시간 |
| 즐겨찾기 백엔드 | 1시간 | 2시간 |
| 즐겨찾기 UI | 1시간 | 3시간 |
| FCM 설정 | 1시간 | 4시간 |
| 푸시 알림 로직 | 1시간 | 5시간 |
| 주간 일정표 | 2시간 | 7시간 |
| 통계 대시보드 | 2시간 | 9시간 |
| 테스트 & 배포 | 1시간 | 10시간 |

**총 예상 시간**: 약 10시간

---

## 🎯 **우선순위 전략**

### **Tier 1: 즉시 가치 (2시간)**
1. 거리순 필터링
2. 즐겨찾기 (푸시 제외)

### **Tier 2: 핵심 기능 (4시간)**
3. 주간 일정표
4. 통계 대시보드 (기본)

### **Tier 3: 고급 기능 (4시간)**
5. FCM 푸시 알림
6. 통계 그래프
7. 상세 분석

---

## 💡 **구현 시작!**

**다음 작업**: 거리순 필터링 구현 (1시간)

이후 사용자 요청에 따라 우선순위 조정 가능!





