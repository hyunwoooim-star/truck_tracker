# 로그인/회원가입 디버그 가이드

## 🔧 수정 완료된 내용

### 1. **Import 문제 해결**
- `TruckListScreen` import 추가
- `OwnerDashboardScreen` import 추가

### 2. **상세한 디버그 로그 추가**
회원가입/로그인 시 다음 로그가 출력됩니다:

```
🔐 LoginScreen: _handleEmailAuth called
   isLogin: false (회원가입) / true (로그인)
   email: test@example.com
📧 Attempting email sign up...
✅ Email sign up successful
🔔 Saving FCM token for user: [uid]
✅ FCM token saved
✅ Auth completed - AuthWrapper will handle navigation
```

### 3. **사장님 로그인 버튼 추가**
- 화면 하단에 "사장님으로 시작하기 (테스트)" 버튼 추가
- 파란색 테두리로 구분됨
- 클릭 시 바로 사장님 대시보드로 이동 (테스트용)

## 📱 테스트 방법

### 회원가입 테스트

1. **앱 실행**
   ```bash
   flutter run -d [device-id]
   ```

2. **로그인 화면에서:**
   - "계정이 없으신가요? 회원가입" 클릭
   - 이메일 입력 (예: test@example.com)
   - 비밀번호 입력 (6자 이상)
   - ✅ 이용약관 체크
   - ✅ 개인정보 처리방침 체크
   - "회원가입" 버튼 클릭

3. **디버그 로그 확인:**
   ```
   🔐 LoginScreen: _handleEmailAuth called
      isLogin: false
      email: test@example.com
   📧 Attempting email sign up...
   ```

4. **예상되는 결과:**
   - 성공: MapFirstScreen (지도 화면)으로 자동 이동
   - 실패: 빨간색 스낵바로 에러 메시지 표시

### 로그인 테스트

1. **로그인 화면에서:**
   - 이메일 입력 (회원가입한 이메일)
   - 비밀번호 입력
   - "로그인" 버튼 클릭

2. **디버그 로그:**
   ```
   🔐 LoginScreen: _handleEmailAuth called
      isLogin: true
      email: test@example.com
   📧 Attempting email sign in...
   ✅ Email sign in successful
   ```

### 사장님 로그인 테스트

**방법 1: 테스트 버튼 사용 (빠른 테스트)**
1. 로그인 화면에서 "사장님으로 시작하기 (테스트)" 버튼 클릭
2. 바로 사장님 대시보드로 이동

**방법 2: 실제 사장님 계정 설정**
1. 일반 계정으로 회원가입
2. Firebase Console → Firestore Database
3. `users` 컬렉션에서 해당 사용자 찾기
4. `ownedTruckId` 필드 추가: **number 타입, 값: 1**
5. 로그아웃 후 다시 로그인
6. 자동으로 사장님 대시보드로 이동

## 🐛 문제 해결

### 회원가입이 안될 때

**증상**: "회원가입" 버튼 눌러도 반응 없음

**확인사항:**
1. 디버그 로그 확인:
   ```bash
   flutter logs
   ```

2. 로그에서 찾을 내용:
   - `❌ Form validation failed` → 입력값 검증 실패
   - `❌ Legal agreements not accepted` → 약관 동의 안함
   - `❌ Auth error: [error]` → Firebase 에러

3. **자주 발생하는 에러:**
   ```
   email-already-in-use → 이미 사용중인 이메일
   weak-password → 비밀번호 6자 미만
   invalid-email → 잘못된 이메일 형식
   ```

### 로그인 후 화면 이동 안될 때

**증상**: 로그인 성공하지만 화면이 안바뀜

**해결방법:**
1. AuthWrapper 로그 확인:
   ```
   🔐 AuthWrapper: User logged in → Checking truck ownership
   🚚 AuthWrapper: Owned truck ID = null
   ✅ AuthWrapper: User is customer → MapFirstScreen
   ```

2. 로그가 안보이면:
   - 앱 재시작: `flutter run`
   - 캐시 삭제: `flutter clean && flutter run`

### Firebase 연결 문제

**증상**: 로그인/회원가입 시 오래 걸리거나 timeout

**확인사항:**
1. 인터넷 연결 확인
2. Firebase Console에서 Authentication 활성화 확인:
   - Firebase Console → Authentication → Sign-in method
   - Email/Password 활성화 확인
3. firebase_options.dart 파일 존재 확인

## 📊 디버그 로그 의미

| 로그 | 의미 |
|------|------|
| 🔐 | 인증 관련 |
| 📧 | 이메일 인증 시도 |
| ✅ | 성공 |
| ❌ | 실패/에러 |
| 🔔 | FCM 토큰 저장 |
| 🚚 | 사장님 계정 체크 |
| 👤 | 손님 모드 |

## 🔥 Firebase 설정 확인

### 1. Authentication 설정
Firebase Console → Authentication → Sign-in method
- ✅ Email/Password: 활성화됨

### 2. Firestore 데이터베이스 규칙
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3. 사용자 문서 구조 (자동 생성됨)
```javascript
users/{userId}/
  - uid: "사용자UID"
  - email: "test@example.com"
  - displayName: "사용자명"
  - role: "customer"
  - ownedTruckId: null  // 사장님: 1, 고객: null
  - createdAt: Timestamp
  - updatedAt: Timestamp
```

## 💡 팁

1. **빠른 테스트**: "둘러보기" 버튼으로 로그인 없이 앱 탐색 가능
2. **사장님 테스트**: "사장님으로 시작하기" 버튼으로 빠른 테스트
3. **로그 실시간 확인**: `flutter logs` 명령어 사용
4. **Firebase 데이터 확인**: Firebase Console → Firestore Database

## 🚨 긴급 문제 발생 시

1. 앱 완전 재시작:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Firebase 재연결 확인:
   - firebase_options.dart 삭제
   - `flutterfire configure` 재실행

3. 에러 로그 캡처:
   ```bash
   flutter run -v > debug.log 2>&1
   ```
