# 🔥 Firebase Authentication 설정 가이드

## ❌ 현재 에러
```
[firebase_auth/configuration-not-found] Error
```

이 에러는 Firebase Console에서 Email/Password 인증이 활성화되지 않았기 때문에 발생합니다.

## ✅ 해결 방법

### 1단계: Firebase Console 접속

1. 브라우저에서 [Firebase Console](https://console.firebase.google.com/) 열기
2. 프로젝트 선택: **truck-tracker-fa0b0**

### 2단계: Authentication 활성화

1. 왼쪽 메뉴에서 **"Build"** → **"Authentication"** 클릭
2. **"Get started"** 버튼 클릭 (처음이라면)
3. **"Sign-in method"** 탭 클릭

### 3단계: Email/Password 인증 활성화

1. "Sign-in providers" 목록에서 **"Email/Password"** 찾기
2. 오른쪽 끝의 **연필 아이콘(편집)** 클릭
3. **"Enable"** 스위치를 **ON**으로 전환
4. "Email link (passwordless sign-in)"은 **OFF**로 유지 (선택사항)
5. **"Save"** 버튼 클릭

### 4단계: 설정 확인

완료하면 Sign-in providers 목록에서:
- ✅ Email/Password 옆에 **"Enabled"** 표시되어야 함

## 🔄 앱에서 다시 테스트

Firebase Console 설정 후:

1. Chrome의 Flutter 앱으로 돌아가기
2. **Hot Restart** 실행:
   - 터미널에서 `R` 키 입력

   또는

   - 앱 완전 종료 후 재실행:
   ```bash
   # 현재 실행 중인 앱 종료 (q 키)
   # 그 다음 다시 실행
   flutter run -d chrome
   ```

3. 회원가입 다시 시도:
   - 이메일: test@test.com
   - 비밀번호: password123
   - 체크박스 2개 체크
   - "회원가입" 버튼 클릭

## 📊 예상 성공 로그

설정이 완료되면 콘솔에 다음과 같은 로그가 나타납니다:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔐 LoginScreen: _handleEmailAuth called
   isLogin: false
   email: test@test.com
   password length: 11
   _isLoading: false
   _agreedToTerms: true
   _agreedToPrivacy: true
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📧 Attempting email sign up...
🔐 AuthService: Signing up with email: test@test.com
✅ AuthService: Email sign up successful!
   User ID: xxxxxxxxxxxxxxxxxxxxxx
   Email: test@test.com
✅ User document created in Firestore
   Collection: users/xxxxxxxxxxxxxxxxxxxxxx
🔔 Saving FCM token for user: xxxxxxxxxxxxxxxxxxxxxx
✅ FCM token saved
✅ Auth completed - AuthWrapper will handle navigation
```

그 다음 자동으로 메인 화면(지도)으로 이동합니다.

## 🔍 추가 확인 사항

### Firestore 데이터베이스 확인

회원가입 성공 후 Firestore에 사용자 데이터가 저장되어야 합니다:

1. Firebase Console → **Firestore Database**
2. `users` 컬렉션 확인
3. 새로 생성된 문서(사용자 UID) 확인:
   ```
   {
     "uid": "xxxxxxxxxx",
     "email": "test@test.com",
     "displayName": "test",
     "role": "customer",
     "ownedTruckId": null,
     "createdAt": [timestamp],
     "updatedAt": [timestamp]
   }
   ```

## 🚨 Firestore 데이터베이스가 없다면

Firestore도 활성화해야 합니다:

1. Firebase Console → **Firestore Database**
2. **"Create database"** 클릭
3. **"Start in test mode"** 선택 (개발 중이므로)
4. Location: **asia-northeast3 (Seoul)** 추천
5. **"Enable"** 클릭

### Firestore 보안 규칙 (테스트 모드)

개발 중에는 다음 규칙 사용:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 테스트 모드: 모든 읽기/쓰기 허용 (개발용)
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **경고**: 이 규칙은 개발용입니다. 프로덕션에서는 적절한 보안 규칙을 설정해야 합니다.

## 📸 스크린샷 가이드

### Firebase Authentication 활성화 화면
```
Firebase Console
├─ truck-tracker-fa0b0
   ├─ Build
      ├─ Authentication
         ├─ Sign-in method
            └─ Email/Password ✅ Enabled
```

## 🎯 체크리스트

설정 완료 확인:

- [ ] Firebase Console 접속 성공
- [ ] truck-tracker-fa0b0 프로젝트 확인
- [ ] Authentication 활성화
- [ ] Email/Password 인증 방법 활성화됨
- [ ] Firestore Database 생성됨 (필요시)
- [ ] 앱 재시작 (Hot Restart)
- [ ] 회원가입 성공 로그 확인
- [ ] Firestore에서 사용자 문서 생성 확인

## 💡 팁

- **Hot Restart (R)**: 전체 앱 재시작 (상태 초기화)
- **Hot Reload (r)**: 코드 변경만 반영 (상태 유지)
- **Full Restart (q → flutter run)**: 완전 재빌드

Firebase 설정은 Hot Restart만으로도 즉시 반영됩니다!

## 🆘 문제 지속 시

다음 명령어로 완전 재시작:

```bash
# 현재 앱 종료 (터미널에서 q 키)
# 캐시 클리어 후 재실행
flutter clean
flutter pub get
flutter run -d chrome
```

---

설정 후에도 문제가 계속되면 에러 메시지를 알려주세요!
