# Truck Tracker 운영 가이드

**버전**: 1.0.0
**대상**: 시스템 관리자, DevOps
**최종 업데이트**: 2025-12-29

---

## 목차

1. [일일 모니터링](#일일-모니터링)
2. [Firebase 관리](#firebase-관리)
3. [Cloud Functions](#cloud-functions)
4. [데이터 백업 및 복구](#데이터-백업-및-복구)
5. [보안 점검](#보안-점검)
6. [긴급 대응](#긴급-대응)
7. [성능 최적화](#성능-최적화)

---

## 일일 모니터링

### 체크리스트 (매일 오전 10시)

#### Firebase Console
- [ ] **Authentication** → Users: 신규 가입자 수 확인
- [ ] **Firestore** → Usage:
  - 읽기: < 50,000 / day (무료 할당량)
  - 쓰기: < 20,000 / day
  - 삭제: < 20,000 / day
- [ ] **Functions** → Dashboard:
  - 에러율: < 1%
  - 평균 실행 시간: < 2초
- [ ] **Hosting** → Usage:
  - 대역폭: < 10GB / month
  - 요청 수 확인

#### Google Cloud Console
- [ ] **APIs & Services** → Maps JavaScript API:
  - 사용량: < 10,000 requests / day
  - 비용: ~$0 (무료 할당량 내)
- [ ] **Billing**:
  - 이번 달 누적 비용 확인
  - 예상 비용이 $5 초과 시 알림

### 주간 점검 (매주 월요일)

- [ ] **Crashlytics**: 크래시 보고서 리뷰
- [ ] **Performance Monitoring**: 페이지 로딩 시간 확인
- [ ] **Firestore**: 인덱스 성능 확인
- [ ] **Cloud Functions**: 로그에서 에러 패턴 분석

---

## Firebase 관리

### 프로젝트 정보

**Project ID**: `truck-tracker-fa0b0`
**Region**: `us-central1`
**Firebase Console**: https://console.firebase.google.com/project/truck-tracker-fa0b0

### Authentication

#### 사용자 관리
```bash
# Firebase CLI로 사용자 목록 조회
firebase auth:export users.json --project truck-tracker-fa0b0
```

#### 의심 계정 비활성화
1. Firebase Console → Authentication → Users
2. 검색으로 사용자 찾기
3. ⋮ (More) → Disable account

#### 이메일 템플릿 관리
1. Firebase Console → Authentication → Templates
2. 비밀번호 재설정, 이메일 인증 템플릿 수정 가능

### Firestore Database

#### 데이터 구조
```
/trucks/{truckId}
  - name: string
  - ownerId: string
  - location: geopoint
  - isOpen: boolean

/orders/{orderId}
  - userId: string
  - truckId: string
  - status: string (pending, preparing, completed)
  - createdAt: timestamp

/reviews/{reviewId}
  - userId: string
  - truckId: string
  - rating: number (1-5)
  - comment: string
```

#### 인덱스 관리
- **복합 인덱스**: `firestore.indexes.json` 에 정의됨
- 배포 명령:
  ```bash
  firebase deploy --only firestore:indexes
  ```

#### Security Rules 배포
```bash
firebase deploy --only firestore:rules
```

**중요**: Rules 수정 시 반드시 테스트 후 배포!

### Storage

#### 폴더 구조
```
/reviews/{userId}/{reviewId}/photo.jpg
/trucks/{truckId}/menu/{itemId}.jpg
/trucks/{truckId}/profile.jpg
```

#### 용량 관리
- 무료 할당량: 5GB
- 현재 사용량 확인:
  ```bash
  firebase use truck-tracker-fa0b0
  firebase storage:list --bucket gs://truck-tracker-fa0b0.appspot.com
  ```

#### Storage Rules 배포
```bash
firebase deploy --only storage
```

---

## Cloud Functions

### 배포된 함수 목록

| 함수명 | Trigger | 용도 |
|--------|---------|------|
| `sendOrderNotification` | HTTPS | 새 주문 시 사장님에게 FCM 알림 |
| `sendReviewNotification` | HTTPS | 새 리뷰 시 사장님에게 FCM 알림 |
| `sendChatNotification` | HTTPS | 새 채팅 메시지 알림 |
| `updateTruckStats` | Firestore Trigger | 리뷰 추가 시 평균 별점 업데이트 |
| `scheduledCleanup` | Scheduled (Cron) | 매일 03:00 AM 오래된 데이터 정리 |

### 배포 명령어

#### 전체 배포
```bash
cd functions
npm install
firebase deploy --only functions
```

#### 특정 함수만 배포
```bash
firebase deploy --only functions:sendOrderNotification
```

### 로그 확인

#### 실시간 로그
```bash
firebase functions:log --only sendOrderNotification
```

#### 최근 100줄
```bash
firebase functions:log --limit 100
```

#### 에러만 필터링
```bash
firebase functions:log --only sendOrderNotification | grep "ERROR"
```

### 함수 URL

```
https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendOrderNotification
https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendReviewNotification
https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendChatNotification
```

### CORS 설정

**화이트리스트** (`functions/index.js:6-12`):
```javascript
const allowedOrigins = [
  'https://truck-tracker-fa0b0.web.app',
  'https://truck-tracker-fa0b0.firebaseapp.com',
  'http://localhost:3000',
  'http://localhost:5000',
];
```

**수정 시**: 코드 수정 후 재배포 필요

---

## 데이터 백업 및 복구

### 자동 백업 (Firestore)

#### 설정
1. Firebase Console → Firestore Database → Backups
2. Schedule backups:
   - **시간**: 매일 03:00 AM (KST)
   - **보관 기간**: 30일
   - **위치**: `gs://truck-tracker-backup/`

#### 수동 백업
```bash
gcloud firestore export gs://truck-tracker-backup/$(date +%Y%m%d) \
  --project=truck-tracker-fa0b0
```

### 복구

#### Firestore 복구
```bash
# 백업 목록 확인
gsutil ls gs://truck-tracker-backup/

# 특정 날짜로 복구
gcloud firestore import gs://truck-tracker-backup/20251229 \
  --project=truck-tracker-fa0b0
```

⚠️ **주의**: Import 시 기존 데이터 덮어쓰므로 신중히 진행!

### Storage 백업

#### 수동 백업
```bash
gsutil -m cp -r gs://truck-tracker-fa0b0.appspot.com gs://truck-tracker-backup/storage/$(date +%Y%m%d)
```

---

## 보안 점검

### 월간 체크리스트

- [ ] **API 키 로테이션** (3개월마다):
  - Google Maps API
  - Kakao API (필요 시)
  - Naver API (필요 시)

- [ ] **Firebase Security Rules 리뷰**:
  - Firestore Rules 테스트 실행
  - Storage Rules 테스트 실행

- [ ] **Cloud Functions CORS 검증**:
  - 허용된 origin만 접근 가능한지 확인

- [ ] **App Check 메트릭**:
  - Firebase Console → App Check → Metrics
  - 무단 요청 차단 확인

### Security Rules 테스트

#### Firestore Rules
```bash
firebase emulators:start --only firestore
# 브라우저: http://localhost:4000/firestore
# Rules Playground에서 시뮬레이션
```

#### Storage Rules
```bash
firebase emulators:start --only storage
```

### 침투 테스트

#### OWASP ZAP 스캔
```bash
# Docker로 실행
docker run -t owasp/zap2docker-stable zap-baseline.py \
  -t https://truck-tracker-fa0b0.web.app
```

---

## 긴급 대응

### 시나리오 1: 앱 크래시 급증

**증상**: Crashlytics에 크래시 보고서 폭증

**대응**:
1. **Crashlytics 확인**:
   - Firebase Console → Crashlytics
   - 가장 많은 크래시 유형 식별

2. **영향 범위 파악**:
   - 영향받는 사용자 수
   - 특정 기기/OS 버전인지 확인

3. **즉시 조치**:
   - 최근 배포 롤백 고려:
     ```bash
     firebase hosting:rollback
     ```
   - 긴급 공지 (Firebase Remote Config):
     ```
     "maintenance_mode": true
     "maintenance_message": "긴급 점검 중입니다"
     ```

4. **핫픽스 배포**:
   - 버그 수정
   - 테스트
   - `firebase deploy --only hosting`

### 시나리오 2: API 할당량 초과

**증상**: Maps API 일일 한도 도달 (10,000 requests)

**즉시 조치**:
1. **Google Cloud Console** → Quotas:
   - 할당량 증가 요청 (유료 전환 필요)

2. **임시 완화**:
   - Firestore 쿼리 limit 축소:
     ```dart
     .limit(20) // 기존 50에서 축소
     ```
   - 지도 새로고침 간격 증가

3. **장기 대책**:
   - 마커 클러스터링 구현
   - 로컬 캐싱 강화

### 시나리오 3: 보안 사고

**증상**: 무단 접근, 데이터 유출 의심

**대응**:
1. **즉시 차단**:
   - Firebase Console → Authentication → Users
   - 의심 계정 비활성화
   - IP 주소 기록

2. **로그 분석**:
   ```bash
   firebase functions:log --limit 1000 > security_audit.log
   # User-Agent, IP, 요청 패턴 분석
   ```

3. **Security Rules 강화**:
   - 의심 패턴 차단 규칙 추가
   - 재배포: `firebase deploy --only firestore:rules`

4. **사용자 통지**:
   - 영향받은 사용자 확인
   - 비밀번호 재설정 안내

### 시나리오 4: Firestore 비용 폭증

**증상**: 예상 비용 $100+ (정상: ~$5)

**원인 파악**:
```bash
# Firestore 사용량 분석
gcloud firestore operations list --project=truck-tracker-fa0b0
```

**대응**:
1. **쿼리 최적화**:
   - 불필요한 `.snapshots()` 제거
   - `.limit()` 적용 누락 확인

2. **인덱스 확인**:
   - 복합 인덱스 최적화
   - 사용하지 않는 인덱스 삭제

3. **긴급 조치**:
   - Firestore Rules에 rate limiting 추가:
     ```javascript
     allow read: if request.time > resource.data.lastRead + duration.value(1, 's');
     ```

---

## 성능 최적화

### Firestore 쿼리 최적화

#### Before (비효율)
```dart
// ❌ limit 없음 - 모든 데이터 로드
_firestore.collection('orders').where('userId', isEqualTo: userId).snapshots()
```

#### After (최적화)
```dart
// ✅ limit 적용
_firestore.collection('orders')
  .where('userId', isEqualTo: userId)
  .orderBy('createdAt', descending: true)
  .limit(50)
  .snapshots()
```

### 이미지 최적화

#### Storage Rules에 크기 제한
```
match /reviews/{userId}/{reviewId}/photo.jpg {
  allow write: if request.resource.size < 5 * 1024 * 1024 // 5MB max
              && request.resource.contentType.matches('image/.*');
}
```

#### 클라이언트 측 압축
```dart
// 업로드 전 리사이징
final resized = await FlutterImageCompress.compressWithFile(
  file.path,
  minWidth: 1024,
  minHeight: 1024,
  quality: 85,
);
```

### Cloud Functions 최적화

#### Cold Start 감소
```javascript
// 글로벌 변수로 초기화 (함수 재사용 시 스킵)
const admin = require('firebase-admin');
admin.initializeApp(); // 함수 외부에서 한 번만
```

#### Timeout 설정
```javascript
exports.myFunction = functions
  .runWith({ timeoutSeconds: 60 }) // 기본 60초
  .https.onRequest(...);
```

---

## 모니터링 대시보드

### Firebase Console 주요 지표

| 메트릭 | 정상 범위 | 경고 임계값 |
|--------|----------|-----------|
| Firestore 읽기 | < 30K/day | > 45K/day |
| Cloud Functions 에러율 | < 1% | > 5% |
| Maps API 요청 | < 8K/day | > 9.5K/day |
| Crashlytics 크래시 | < 0.5% | > 2% |
| 평균 페이지 로딩 | < 2초 | > 5초 |

### Grafana 대시보드 (선택)

Firebase 데이터를 Grafana로 시각화:
1. BigQuery Export 활성화
2. Grafana BigQuery Plugin 설치
3. 커스텀 대시보드 구성

---

## 연락처

**긴급 이슈**:
- 담당자: 현우
- GitHub Issues: https://github.com/hyunwoooim-star/truck_tracker/issues

**Firebase 지원**:
- Firebase Support: https://firebase.google.com/support

---

**문서 버전**: 1.0.0
**마지막 업데이트**: 2025-12-29

🤖 Generated with [Claude Code](https://claude.com/claude-code)
