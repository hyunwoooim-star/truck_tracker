# 사장님 계정 설정 가이드

## 문제 해결 완료 사항

1. **AuthWrapper 개선**
   - Provider 기반으로 변경하여 안정성 향상
   - 상세한 디버그 로그 추가

2. **getOwnedTruckId 타입 처리 개선**
   - int, String 타입 모두 처리 가능
   - 상세한 로그로 문제 진단 가능

3. **로그인 후 Navigation 충돌 해결**
   - LoginScreen에서 수동 navigation 제거
   - AuthWrapper가 자동으로 처리하도록 변경

## Firestore 설정 방법

### 1. Firebase Console 접속
1. https://console.firebase.google.com 접속
2. truck_tracker 프로젝트 선택
3. Firestore Database 메뉴 선택

### 2. 사장님 계정 설정

**방법 A: 기존 계정을 사장님으로 변경**

1. Firestore Database에서 `users` 컬렉션 찾기
2. 사장님으로 설정할 사용자 문서 선택 (예: user의 uid)
3. `ownedTruckId` 필드 추가:
   ```
   필드명: ownedTruckId
   타입: number
   값: 1 (또는 trucks 컬렉션에 존재하는 트럭 ID)
   ```
4. 저장

**방법 B: 새 사장님 계정 생성**

1. 앱에서 이메일로 회원가입 (예: owner@test.com)
2. 로그인 후 Firestore Console에서 해당 사용자 문서 찾기
3. 위와 같이 `ownedTruckId` 필드 추가

### 3. trucks 컬렉션 확인

사장님 계정의 `ownedTruckId`와 매칭되는 트럭이 `trucks` 컬렉션에 있어야 합니다:

```
trucks/
  1/  (또는 다른 ID)
    - truckNumber: "트럭1호"
    - driverName: "사장님 이름"
    - foodType: "한식"
    - ownerId: "사장님 계정의 uid"
    ... 기타 필드
```

## 테스트 방법

### 1. 디버그 로그 확인

앱을 실행하면 다음과 같은 로그가 출력됩니다:

```
🔐 AuthWrapper: User logged in (uid) → Checking truck ownership
🔍 Checking owned truck ID for user: [uid]
📋 User data: {uid: ..., email: ..., ownedTruckId: 1}
🚚 Owned truck ID: 1 (type: int)
✅ AuthWrapper: User is owner → OwnerDashboardScreen
```

### 2. 예상 동작

**일반 사용자 (고객)**
- `ownedTruckId`: null
- 로그인 후 → MapFirstScreen (지도 화면)

**사장님**
- `ownedTruckId`: 1 (또는 유효한 트럭 ID)
- 로그인 후 → OwnerDashboardScreen (사장님 대시보드)

## 문제 진단

로그에서 다음을 확인하세요:

1. **User document does not exist**
   - 해결: Firebase Authentication에서 로그인 후 자동 생성됨

2. **Owned truck ID: null**
   - 해결: Firestore에서 `ownedTruckId` 필드 추가

3. **Unexpected type for ownedTruckId**
   - 해결: 필드 타입을 number로 설정

## 빠른 테스트 계정 설정

```javascript
// Firestore Console에서 실행할 수 있는 예시 데이터
{
  "uid": "사용자UID",
  "email": "owner@test.com",
  "displayName": "테스트 사장님",
  "role": "owner",
  "ownedTruckId": 1,  // ← 이 필드가 핵심!
  "createdAt": /* 현재시간 */,
  "updatedAt": /* 현재시간 */
}
```

## 추가 확인사항

1. **핸드폰 실행 문제**
   - Flutter 버전 확인: `flutter doctor`
   - 디바이스 연결 확인: `flutter devices`
   - 앱 재설치: `flutter clean && flutter run`

2. **로그 확인 방법**
   ```bash
   # Android
   flutter run -d [device-id] -v

   # iOS
   flutter run -d [device-id] -v

   # 로그만 보기
   flutter logs
   ```

3. **Firestore 보안 규칙 확인**
   - users 컬렉션에 대한 읽기/쓰기 권한 확인
   - 인증된 사용자만 접근 가능하도록 설정
