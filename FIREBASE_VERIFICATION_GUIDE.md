# Firebase Cloud Functions 배포 상태 확인 가이드

## 🔍 1단계: Firebase Console에서 배포 상태 확인

### 방법 1: Functions 페이지에서 확인

1. **Firebase Console 접속**
   - URL: https://console.firebase.google.com/project/truck-tracker-fa0b0/functions
   - Google 계정으로 로그인

2. **Functions 메뉴 확인**
   - 좌측 메뉴에서 **"Functions"** 클릭
   - 또는 직접 링크: https://console.firebase.google.com/project/truck-tracker-fa0b0/functions/list

3. **배포된 함수 목록 확인**

   **예상되는 함수 2개**:

   ✅ **createCustomToken**
   - Type: HTTPS
   - Region: us-central1
   - Runtime: Node.js 20
   - URL: `https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/createCustomToken`

   ✅ **notifyTruckOpening**
   - Type: Firestore Trigger
   - Region: us-central1
   - Runtime: Node.js 20
   - Trigger: `trucks/{truckId}` onUpdate

4. **배포 상태 확인**
   - 각 함수 옆에 **초록색 체크 표시** 또는 **"Active"** 상태 확인
   - 빨간색 에러 표시가 있다면 배포 실패

### 방법 2: Firestore 데이터베이스에서 간접 확인

1. **Firestore Database 접속**
   - URL: https://console.firebase.google.com/project/truck-tracker-fa0b0/firestore

2. **`trucks` 컬렉션 확인**
   - 트럭 문서가 존재하는지 확인
   - 임의의 트럭 문서에서 `isOpen` 필드 확인

3. **테스트 트리거**
   - 트럭 문서의 `isOpen` 필드를 `false` → `true`로 변경
   - **Functions → Logs** 메뉴로 이동
   - `notifyTruckOpening` 함수 실행 로그 확인

**예상 로그**:
```
🔔 Truck abc123 just opened! Sending notifications...
✅ Successfully sent message: projects/truck-tracker-fa0b0/messages/...
```

---

## 🚀 2단계: Flutter 앱 실행

### 사용 가능한 플랫폼

현재 사용 가능한 디바이스:
- ✅ **Windows Desktop** (FCM 알림 제한적)
- ✅ **Chrome Web** (FCM 알림 제한적)
- ⚠️ **Android 에뮬레이터** (권장 - FCM 알림 완전 지원)
- ⚠️ **iOS 시뮬레이터** (권장 - FCM 알림 완전 지원)

### Chrome에서 실행 (빠른 테스트)

```bash
cd C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker

# Chrome으로 실행
flutter run -d chrome
```

**참고**: 웹에서는 FCM 푸시 알림이 제한적으로 동작합니다. 전체 테스트를 위해서는 Android/iOS 에뮬레이터 사용을 권장합니다.

### Android 에뮬레이터에서 실행 (권장)

#### 에뮬레이터 설치 확인

```bash
# 사용 가능한 에뮬레이터 목록
flutter emulators

# 에뮬레이터 시작 (있는 경우)
flutter emulators --launch <emulator_id>
```

#### Android Studio가 없는 경우

1. Android Studio 설치: https://developer.android.com/studio
2. Android SDK 설치
3. AVD Manager에서 에뮬레이터 생성
4. Flutter에서 인식 확인: `flutter devices`

#### 에뮬레이터에서 앱 실행

```bash
# 에뮬레이터 시작 후
flutter run
```

---

## 📱 3단계: 푸시 알림 실제 테스트

### 전제 조건

- ✅ Android 에뮬레이터 또는 실제 Android 디바이스
- ✅ 고객 앱과 사장님 앱 모두 실행 가능
- ✅ Firebase Functions가 배포되어 있어야 함

### 테스트 시나리오

#### **시나리오 1: 기본 푸시 알림 플로우**

1. **고객 앱 준비**
   ```bash
   # 고객 앱 실행 (Chrome 또는 에뮬레이터)
   flutter run -d chrome
   # 또는
   flutter run
   ```

2. **고객 앱에서 즐겨찾기 추가**
   - 앱에서 로그인
   - 지도 또는 트럭 리스트에서 트럭 선택
   - ⭐ 즐겨찾기 버튼 클릭
   - **확인**: fcm_service.dart:164에서 `subscribeToTopic('truck_{truckId}')` 실행됨

3. **앱을 백그라운드로 전환**
   - Android: 홈 버튼 클릭
   - Chrome: 다른 탭으로 이동

4. **사장님 앱에서 영업 시작**
   - 사장님 계정으로 로그인
   - Owner Dashboard에서 "영업 시작" 버튼 클릭
   - **확인**: Firestore `trucks/{truckId}` 문서의 `isOpen: true` 업데이트

5. **Cloud Function 트리거 확인**
   - Firebase Console → Functions → Logs
   - `notifyTruckOpening` 실행 로그 확인
   ```
   🔔 Truck abc123 just opened! Sending notifications...
   ✅ Successfully sent message: ...
   ```

6. **고객 앱에서 알림 수신 확인**
   - **Android**: 알림 센터에 푸시 알림 표시
   - **Chrome**: 브라우저 알림 (권한 허용 필요)

   **알림 내용**:
   ```
   제목: "BM-001 is now OPEN! 🚚"
   내용: "Your favorite 닭꼬치 truck is now serving at 강남역 2번 출구. Order now!"
   ```

#### **시나리오 2: 토픽 구독 해제 테스트**

1. **고객 앱에서 즐겨찾기 제거**
   - 즐겨찾기한 트럭의 ⭐ 버튼 다시 클릭
   - **확인**: fcm_service.dart:174에서 `unsubscribeFromTopic('truck_{truckId}')` 실행됨

2. **사장님 앱에서 다시 영업 시작**
   - 트럭을 한번 닫았다가 (`isOpen: false`) 다시 열기 (`isOpen: true`)

3. **고객 앱에서 알림 미수신 확인**
   - 즐겨찾기 해제했으므로 알림이 오지 않아야 정상

---

## 🐛 문제 해결

### 문제 1: Functions가 배포되지 않은 경우

**증상**: Firebase Console → Functions에 함수가 없음

**해결**: Firebase CLI로 배포

#### Node.js 설치 (필수)

1. Node.js 다운로드: https://nodejs.org/
2. LTS 버전 (20.x) 설치
3. 설치 확인:
   ```bash
   node --version  # v20.x.x 출력되어야 함
   npm --version   # 10.x.x 출력되어야 함
   ```

#### Firebase CLI 설치

```bash
# npm으로 전역 설치
npm install -g firebase-tools

# 설치 확인
firebase --version
```

#### 배포 실행

```bash
# Firebase 로그인
firebase login

# 프로젝트 확인
firebase use truck-tracker-fa0b0

# Functions 디렉토리로 이동
cd C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker\functions

# 의존성 설치
npm install

# 배포
cd ..
firebase deploy --only functions
```

**예상 출력**:
```
✔ functions[createCustomToken(us-central1)]: Successful create operation.
✔ functions[notifyTruckOpening(us-central1)]: Successful create operation.
✔ Deploy complete!
```

### 문제 2: 알림이 수신되지 않음

**확인 사항**:

1. **FCM 토큰 확인**
   - 앱 시작 시 FCM 토큰이 생성되는지 확인
   - `fcm_service.dart` 로그 확인

2. **토픽 구독 확인**
   - 즐겨찾기 추가 시 `subscribeToTopic` 로그 확인
   - Firebase Console → Cloud Messaging에서 topic 확인 (가능한 경우)

3. **알림 권한 확인**
   - Android: 앱 설정 → 알림 권한 허용
   - Chrome: 브라우저 알림 권한 허용

4. **앱 상태 확인**
   - 앱이 백그라운드 또는 종료 상태여야 알림 표시
   - 포그라운드 상태에서는 앱 내에서 처리됨

5. **Cloud Function 로그 확인**
   - Firebase Console → Functions → Logs
   - `notifyTruckOpening` 실행 여부 확인
   - 에러 메시지 확인

### 문제 3: Chrome에서 알림이 안 옴

**원인**: Chrome에서는 FCM 웹 푸시 알림 설정이 추가로 필요할 수 있습니다.

**해결**:
1. Chrome 브라우저 알림 권한 허용
2. HTTPS 환경에서만 동작 (localhost는 예외)
3. Service Worker 등록 확인

**권장**: Android/iOS 에뮬레이터에서 테스트

---

## 📊 성공 기준

### ✅ 1단계 성공
- [ ] Firebase Console에서 `createCustomToken` 함수 확인
- [ ] Firebase Console에서 `notifyTruckOpening` 함수 확인
- [ ] 두 함수 모두 "Active" 상태

### ✅ 2단계 성공
- [ ] Flutter 앱이 Chrome 또는 에뮬레이터에서 정상 실행
- [ ] 로그인 성공
- [ ] 지도/리스트에서 트럭 목록 표시

### ✅ 3단계 성공
- [ ] 고객 앱에서 즐겨찾기 추가 성공
- [ ] 사장님 앱에서 영업 시작 성공
- [ ] Firebase Functions 로그에서 `notifyTruckOpening` 실행 확인
- [ ] 고객 디바이스/에뮬레이터에서 푸시 알림 수신 확인
- [ ] 알림 내용이 올바른지 확인 (트럭 이름, 위치 등)

---

## 🔗 추가 리소스

- **Firebase Console**: https://console.firebase.google.com/project/truck-tracker-fa0b0
- **Functions 페이지**: https://console.firebase.google.com/project/truck-tracker-fa0b0/functions
- **Firestore Database**: https://console.firebase.google.com/project/truck-tracker-fa0b0/firestore
- **FCM 문서**: https://firebase.google.com/docs/cloud-messaging

---

**마지막 업데이트**: 2025-12-27
**테스트 필요 환경**: Android/iOS 에뮬레이터 권장
