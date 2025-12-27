# FCM Cloud Functions - 배포 가이드

Truck Tracker의 Firebase Cloud Functions 배포 및 검증 가이드입니다.

## ✅ 배포 전 체크리스트

### 1. 환경 확인

```bash
# Node.js 버전 확인 (20 이상 필요)
node --version

# Firebase CLI 설치 확인
firebase --version

# Firebase CLI 미설치 시
npm install -g firebase-tools
```

### 2. Firebase 로그인

```bash
# Firebase 계정 로그인
firebase login

# 현재 프로젝트 확인
firebase projects:list

# 프로젝트 설정 확인
firebase use
# → truck-tracker-fa0b0 (default)
```

### 3. 함수 코드 검증

```bash
cd functions

# 의존성 설치
npm install

# JavaScript 문법 검증 (선택사항)
node -c index.js
```

---

## 🚀 배포 단계

### 단계 1: 프로젝트 선택

```bash
# 프로젝트 루트로 이동
cd C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker

# 프로젝트 확인
firebase use truck-tracker-fa0b0
```

### 단계 2: 함수 배포

```bash
# 모든 함수 배포
firebase deploy --only functions

# 특정 함수만 배포 (선택사항)
firebase deploy --only functions:notifyTruckOpening
firebase deploy --only functions:createCustomToken
```

**예상 출력**:
```
=== Deploying to 'truck-tracker-fa0b0'...

i  deploying functions
i  functions: ensuring required API cloudfunctions.googleapis.com is enabled...
i  functions: ensuring required API cloudbuild.googleapis.com is enabled...
✔  functions: required API cloudfunctions.googleapis.com is enabled
✔  functions: required API cloudbuild.googleapis.com is enabled
i  functions: preparing codebase default for deployment
i  functions: packaged C:\Users\...\functions (X.XX MB) for uploading
✔  functions: functions folder uploaded successfully
i  functions: creating Node.js 20 function createCustomToken(us-central1)...
i  functions: creating Node.js 20 function notifyTruckOpening(us-central1)...
✔  functions[createCustomToken(us-central1)]: Successful create operation.
✔  functions[notifyTruckOpening(us-central1)]: Successful create operation.
✔  Deploy complete!
```

### 단계 3: 배포 확인

```bash
# 배포된 함수 목록 확인
firebase functions:list
```

**예상 출력**:
```
┌────────────────────┬──────────────┬─────────────────────────────────────────────┐
│ Function Name      │ Trigger      │ Resource                                     │
├────────────────────┼──────────────┼─────────────────────────────────────────────┤
│ createCustomToken  │ https        │ us-central1-truck-tracker-fa0b0             │
│ notifyTruckOpening │ firestore    │ trucks/{truckId} onUpdate                    │
└────────────────────┴──────────────┴─────────────────────────────────────────────┘
```

---

## 🧪 배포 후 테스트

### 테스트 1: `createCustomToken` 함수

```bash
# cURL로 HTTPS 함수 테스트
curl -X POST https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/createCustomToken \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "kakao",
    "kakaoId": "test_deployment_123",
    "email": "test@deployment.com",
    "displayName": "배포 테스트 사용자"
  }'
```

**성공 응답**:
```json
{
  "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**실패 응답** (400):
```json
{
  "error": "Missing required parameters"
}
```

### 테스트 2: `notifyTruckOpening` 함수

#### 방법 1: Firebase Console에서 테스트

1. [Firebase Console](https://console.firebase.google.com/project/truck-tracker-fa0b0/firestore) 접속
2. Firestore Database → `trucks` 컬렉션 선택
3. 임의의 트럭 문서 선택
4. `isOpen` 필드를 `false` → `true`로 변경
5. Functions 로그 확인:
   ```bash
   firebase functions:log --only notifyTruckOpening
   ```

**예상 로그**:
```
2025-12-27T12:00:00.123Z - notifyTruckOpening: 🔔 Truck abc123 just opened! Sending notifications...
2025-12-27T12:00:00.456Z - notifyTruckOpening: ✅ Successfully sent message: projects/truck-tracker-fa0b0/messages/...
```

#### 방법 2: Flutter 앱에서 테스트

1. **준비**:
   - Flutter 앱 실행 (고객 앱)
   - 테스트용 트럭을 즐겨찾기에 추가
   - 앱을 백그라운드로 전환

2. **트리거**:
   - 사장님 앱에서 로그인
   - Owner Dashboard에서 "영업 시작" 버튼 클릭

3. **확인**:
   - 고객 앱에 푸시 알림 수신 확인
   - 알림 내용: "{truckNumber} is now OPEN! 🚚"

---

## 📊 모니터링

### 실시간 로그 확인

```bash
# 모든 함수 로그
firebase functions:log

# 특정 함수 로그
firebase functions:log --only notifyTruckOpening

# 최근 N개 로그만 보기
firebase functions:log --limit 50
```

### Firebase Console 모니터링

1. [Firebase Console](https://console.firebase.google.com/project/truck-tracker-fa0b0/functions) 접속
2. **Functions** 메뉴 선택
3. 각 함수의 메트릭 확인:
   - **Invocations**: 호출 횟수
   - **Execution time**: 실행 시간
   - **Memory usage**: 메모리 사용량
   - **Errors**: 오류 발생 횟수

### 주요 메트릭

- **notifyTruckOpening**:
  - 정상: 1일 평균 10-50회 호출 (트럭 수에 따라 다름)
  - 실행 시간: 평균 200-500ms
  - 오류율: 5% 미만

- **createCustomToken**:
  - 정상: 사용자 로그인 시에만 호출
  - 실행 시간: 평균 100-300ms
  - 오류율: 1% 미만

---

## 🔧 문제 해결

### 배포 실패

#### 문제: "Permission denied" 오류

**원인**: Firebase 프로젝트 권한 부족

**해결**:
```bash
# 다시 로그인
firebase logout
firebase login

# 프로젝트 권한 확인
firebase projects:list
```

#### 문제: "Node version mismatch" 오류

**원인**: Node.js 버전 불일치 (20 이상 필요)

**해결**:
```bash
# Node 버전 확인
node --version

# nvm 사용 시
nvm install 20
nvm use 20
```

#### 문제: "ENOENT: no such file or directory" 오류

**원인**: functions 디렉토리 경로 문제

**해결**:
```bash
# 프로젝트 루트에서 실행
cd C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker

# functions 디렉토리 확인
dir functions
```

### 함수 실행 오류

#### 문제: notifyTruckOpening이 트리거되지 않음

**확인 사항**:
1. Firestore `trucks/{truckId}` 문서가 실제로 업데이트되는지 확인
2. `isOpen` 필드가 `false` → `true`로 변경되는지 확인 (이미 `true`면 트리거 안 됨)
3. 함수 로그 확인: `firebase functions:log --only notifyTruckOpening`

#### 문제: 알림이 수신되지 않음

**확인 사항**:
1. **토픽 구독 확인**:
   ```dart
   // fcm_service.dart:164
   await _messaging.subscribeToTopic('truck_$truckId');
   ```
2. **FCM 토큰 확인**: 사용자 디바이스가 유효한 FCM 토큰을 가지고 있는지
3. **알림 권한 확인**: Android/iOS에서 알림 권한이 허용되어 있는지
4. **앱 상태 확인**: Android는 백그라운드에서 알림이 지연될 수 있음

#### 문제: createCustomToken 실패 (500 오류)

**확인 사항**:
1. Firebase Admin SDK 초기화 확인 (`admin.initializeApp()`)
2. 요청 파라미터 확인 (provider, kakaoId/naverId 필수)
3. 함수 로그 확인: `firebase functions:log --only createCustomToken`

---

## 🔄 업데이트 및 재배포

### 코드 수정 후 재배포

```bash
# 1. 코드 수정
# functions/index.js 파일 편집

# 2. 재배포
firebase deploy --only functions

# 3. 로그 확인
firebase functions:log
```

### 특정 함수만 업데이트

```bash
# notifyTruckOpening만 재배포
firebase deploy --only functions:notifyTruckOpening

# createCustomToken만 재배포
firebase deploy --only functions:createCustomToken
```

### 함수 삭제

```bash
# Firebase Console에서 삭제하는 것이 권장됨
# 또는 CLI 사용:
firebase functions:delete notifyTruckOpening
firebase functions:delete createCustomToken
```

---

## 📋 배포 후 최종 체크리스트

- [ ] `firebase functions:list`로 두 함수 모두 배포 확인
- [ ] `createCustomToken` HTTPS 엔드포인트 테스트 완료
- [ ] `notifyTruckOpening` Firestore 트리거 테스트 완료
- [ ] Flutter 앱에서 실제 푸시 알림 수신 확인
- [ ] Firebase Console에서 함수 메트릭 정상 확인
- [ ] 로그에 오류 메시지 없음 확인
- [ ] 문서화 완료 (README.md, DEPLOYMENT.md)

---

## 🔗 참고 자료

- [Firebase Functions 문서](https://firebase.google.com/docs/functions)
- [FCM 문서](https://firebase.google.com/docs/cloud-messaging)
- [Firebase CLI 문서](https://firebase.google.com/docs/cli)
- [Cloud Functions for Firebase 가격](https://firebase.google.com/pricing)

---

**마지막 업데이트**: 2025-12-27
**프로젝트 ID**: truck-tracker-fa0b0
**Functions 런타임**: Node.js 20
