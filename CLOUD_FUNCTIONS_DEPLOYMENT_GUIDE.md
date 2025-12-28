# Cloud Functions 배포 가이드

**작성일**: 2025-12-29
**대상**: DevOps, 백엔드 개발자
**난이도**: 중급

---

## 목차

1. [사전 준비](#사전-준비)
2. [로컬 테스트](#로컬-테스트)
3. [프로덕션 배포](#프로덕션-배포)
4. [배포 후 검증](#배포-후-검증)
5. [문제 해결](#문제-해결)

---

## 사전 준비

### 1. 필수 도구 설치

```bash
# Node.js 18+ 설치 확인
node --version  # v18.0.0 이상

# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login
```

### 2. 프로젝트 초기화

```bash
cd "Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker"

# Firebase 프로젝트 선택
firebase use truck-tracker-fa0b0

# 현재 프로젝트 확인
firebase projects:list
```

### 3. Dependencies 설치

```bash
cd functions
npm install

# 보안 취약점 자동 수정
npm audit fix
```

---

## 로컬 테스트

### Emulator 실행

```bash
# 프로젝트 루트에서
firebase emulators:start --only functions

# 출력 예시:
# ✔  functions: Emulator started at http://127.0.0.1:5001
```

### 함수 테스트

#### sendOrderNotification 테스트

```bash
# curl로 테스트
curl -X POST http://127.0.0.1:5001/truck-tracker-fa0b0/us-central1/sendOrderNotification \
  -H "Content-Type: application/json" \
  -d '{
    "truckId": "test-truck-123",
    "orderId": "test-order-456",
    "userName": "테스트 사용자"
  }'

# 성공 시 응답:
# {"success": true, "message": "Notification sent"}
```

#### createCustomToken 테스트

```bash
curl -X POST http://127.0.0.1:5001/truck-tracker-fa0b0/us-central1/createCustomToken \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "kakao",
    "kakaoId": "12345",
    "email": "test@example.com",
    "displayName": "테스트"
  }'

# 성공 시 customToken 반환
```

### Firestore Trigger 테스트

#### updateTruckStats 함수

Emulator에서 Firestore에 리뷰 추가:
```javascript
// Firestore Emulator UI: http://localhost:4000/firestore
// 컬렉션: reviews
// 문서 추가:
{
  "truckId": "test-truck-123",
  "rating": 5,
  "userId": "test-user",
  "createdAt": "2025-12-29T00:00:00Z"
}

// updateTruckStats 함수가 자동 실행되어 trucks/{truckId} 업데이트
```

---

## 프로덕션 배포

### 1. 배포 전 체크리스트

- [ ] 모든 함수가 로컬에서 정상 동작 확인
- [ ] `functions/index.js`에서 CORS 화이트리스트 확인
- [ ] 환경 변수 설정 확인 (필요 시)
- [ ] `package.json` dependencies 최신 버전
- [ ] 코드 리뷰 완료

### 2. 전체 Functions 배포

```bash
# 프로젝트 루트에서
cd functions

# Dependencies 재설치 (깨끗한 배포)
rm -rf node_modules package-lock.json
npm install

# 배포 실행
firebase deploy --only functions

# 출력 예시:
# ✔  functions[sendOrderNotification(us-central1)] Successful create operation.
# ✔  functions[sendReviewNotification(us-central1)] Successful create operation.
# ✔  functions[sendChatNotification(us-central1)] Successful create operation.
# ✔  functions[updateTruckStats(us-central1)] Successful create operation.
# ✔  functions[scheduledCleanup(us-central1)] Successful create operation.
```

### 3. 특정 함수만 배포

```bash
# 하나의 함수만 배포
firebase deploy --only functions:sendOrderNotification

# 여러 함수 배포
firebase deploy --only functions:sendOrderNotification,functions:sendReviewNotification
```

### 4. 배포 완료 후 URL 확인

```bash
firebase functions:list

# 출력:
# ┌────────────────────────────┬──────────────────────────────────────────────┐
# │ Function                   │ URL                                          │
# ├────────────────────────────┼──────────────────────────────────────────────┤
# │ sendOrderNotification      │ https://us-central1-truck-tracker-fa0b0...  │
# │ sendReviewNotification     │ https://us-central1-truck-tracker-fa0b0...  │
# │ sendChatNotification       │ https://us-central1-truck-tracker-fa0b0...  │
# └────────────────────────────┴──────────────────────────────────────────────┘
```

---

## 배포 후 검증

### 1. 함수 상태 확인

```bash
# Firebase Console에서 확인
# https://console.firebase.google.com/project/truck-tracker-fa0b0/functions

# 또는 CLI로 확인
firebase functions:list
```

**확인 항목**:
- ✅ 모든 함수가 "Active" 상태
- ✅ 에러율 < 1%
- ✅ 평균 실행 시간 < 2초

### 2. 실제 요청 테스트

#### sendOrderNotification 프로덕션 테스트

```bash
curl -X POST https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendOrderNotification \
  -H "Content-Type: application/json" \
  -H "Origin: https://truck-tracker-fa0b0.web.app" \
  -d '{
    "truckId": "real-truck-id",
    "orderId": "real-order-id",
    "userName": "실제 사용자"
  }'

# 성공 시:
# {"success": true, "message": "Notification sent"}
```

#### CORS 검증

```bash
# 허용되지 않은 origin에서 요청 시 차단 확인
curl -X POST https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendOrderNotification \
  -H "Origin: https://malicious-site.com" \
  -d '{}'

# 예상 응답: CORS error (Access-Control-Allow-Origin: null)
```

### 3. 로그 모니터링

```bash
# 실시간 로그 스트림
firebase functions:log --only sendOrderNotification

# 최근 50줄
firebase functions:log --limit 50

# 에러만 필터링
firebase functions:log | grep "Error"
```

**정상 로그 예시**:
```
2025-12-29T12:34:56.789Z Function execution started
2025-12-29T12:34:56.890Z Sending notification to token: eyJhbGc...
2025-12-29T12:34:57.100Z Notification sent successfully
2025-12-29T12:34:57.123Z Function execution took 334 ms, finished with status: 'ok'
```

---

## 함수별 상세 가이드

### sendOrderNotification

**Trigger**: HTTP Request
**용도**: 새 주문 발생 시 사장님에게 FCM 푸시 알림 전송

**Request Body**:
```json
{
  "truckId": "string",
  "orderId": "string",
  "userName": "string"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Notification sent"
}
```

**통합 방법** (Flutter):
```dart
// lib/features/order/data/order_repository.dart
Future<void> placeOrder(Order order) async {
  // 1. Firestore에 주문 저장
  await _firestore.collection('orders').add(order.toFirestore());

  // 2. Cloud Function 호출하여 알림 전송
  final response = await http.post(
    Uri.parse('https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendOrderNotification'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'truckId': order.truckId,
      'orderId': order.id,
      'userName': order.userName,
    }),
  );

  if (response.statusCode != 200) {
    AppLogger.error('Failed to send notification');
  }
}
```

---

### sendReviewNotification

**Trigger**: HTTP Request
**용도**: 새 리뷰 작성 시 사장님에게 알림

**Request Body**:
```json
{
  "truckId": "string",
  "reviewId": "string",
  "userName": "string",
  "rating": 5
}
```

---

### updateTruckStats

**Trigger**: Firestore (`reviews` 컬렉션에 문서 추가)
**용도**: 리뷰 추가 시 트럭의 평균 별점 자동 업데이트

**동작**:
1. 리뷰 추가 감지
2. 해당 트럭의 모든 리뷰 조회
3. 평균 별점 계산
4. `trucks/{truckId}` 문서 업데이트

**검증**:
```bash
# Firestore에 리뷰 추가 후 trucks 컬렉션 확인
# averageRating, reviewCount 필드가 자동 업데이트되어야 함
```

---

### scheduledCleanup

**Trigger**: Scheduled (Cron)
**스케줄**: 매일 03:00 AM (KST)
**용도**: 오래된 데이터 정리

**정리 대상**:
- 90일 이상 오래된 완료된 주문 (status: completed)
- 탈퇴 사용자의 개인정보
- 사용되지 않는 Storage 파일

**로그 확인**:
```bash
firebase functions:log --only scheduledCleanup
```

---

## 문제 해결

### 문제 1: 배포 실패 (Permission Denied)

**증상**:
```
Error: HTTP Error: 403, The caller does not have permission
```

**해결**:
```bash
# Firebase 재로그인
firebase logout
firebase login

# 프로젝트 권한 확인
firebase projects:list

# IAM 권한 확인 (Owner 또는 Editor 필요)
```

---

### 문제 2: 함수 실행 시 Timeout

**증상**: 함수 실행이 60초 초과로 타임아웃

**해결**:
```javascript
// functions/index.js
exports.myFunction = functions
  .runWith({
    timeoutSeconds: 300, // 5분으로 증가
    memory: '1GB', // 메모리도 증가
  })
  .https.onRequest(...);
```

---

### 문제 3: CORS 에러

**증상**:
```
Access to fetch at '...' from origin '...' has been blocked by CORS policy
```

**해결**:
```javascript
// functions/index.js
const allowedOrigins = [
  'https://truck-tracker-fa0b0.web.app',
  'https://your-custom-domain.com', // 추가
];
```

재배포:
```bash
firebase deploy --only functions
```

---

### 문제 4: 함수가 호출되지 않음

**디버깅**:
```bash
# 1. 함수 목록 확인
firebase functions:list

# 2. 로그 확인
firebase functions:log --limit 100

# 3. Firebase Console에서 확인
# https://console.firebase.google.com/project/truck-tracker-fa0b0/functions
```

**체크리스트**:
- [ ] 함수가 배포되어 있는가?
- [ ] 올바른 URL로 요청하는가?
- [ ] Request body가 올바른가?
- [ ] CORS 헤더가 포함되었는가?

---

## 배포 체크리스트

### 배포 전
- [ ] 로컬 Emulator에서 모든 함수 테스트 완료
- [ ] 코드 리뷰 완료
- [ ] CORS 화이트리스트 확인
- [ ] `package.json` dependencies 최신화
- [ ] `npm audit` 실행하여 보안 취약점 확인

### 배포 중
- [ ] `firebase deploy --only functions` 실행
- [ ] 배포 로그에서 에러 없는지 확인
- [ ] 모든 함수가 성공적으로 배포되었는지 확인

### 배포 후
- [ ] Firebase Console에서 함수 상태 확인
- [ ] 실제 요청으로 각 함수 테스트
- [ ] 로그에서 에러 없는지 모니터링 (최소 10분)
- [ ] 앱에서 실제 기능 동작 확인:
  - [ ] 주문 시 알림 전송
  - [ ] 리뷰 작성 시 알림 전송
  - [ ] 리뷰 작성 후 평균 별점 업데이트
- [ ] 배포 완료 문서화 (버전, 시간, 변경 사항)

---

## 롤백

배포 후 문제 발생 시 이전 버전으로 롤백:

```bash
# 함수 목록 및 버전 확인
gcloud functions list --project=truck-tracker-fa0b0

# 특정 버전으로 롤백 (예: sendOrderNotification)
gcloud functions deploy sendOrderNotification \
  --source=gs://gcf-sources-123456-us-central1/sendOrderNotification-v1.zip \
  --project=truck-tracker-fa0b0
```

**주의**: 수동 롤백은 복잡하므로, 가능하면 수정 후 재배포 권장

---

## 참고 자료

- [Firebase Functions 공식 문서](https://firebase.google.com/docs/functions)
- [Cloud Functions 가격](https://firebase.google.com/pricing)
- [CORS 설정 가이드](https://firebase.google.com/docs/functions/http-events#cors)

---

**문서 버전**: 1.0.0
**마지막 업데이트**: 2025-12-29

🤖 Generated with [Claude Code](https://claude.com/claude-code)
