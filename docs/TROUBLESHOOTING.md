# Troubleshooting Guide

트럭아저씨 앱 개발 중 발생한 이슈와 해결 방법을 정리한 문서입니다.

---

## 1. FCM 웹 에러

### 증상
```
subscribeToTopic() is not supported on the web
```

### 원인
Firebase Cloud Messaging의 `subscribeToTopic()`은 웹 플랫폼에서 지원되지 않음.

### 해결
`kIsWeb` 체크 추가:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) return; // 웹에서는 topic subscription 스킵

await FirebaseMessaging.instance.subscribeToTopic('topic');
```

---

## 2. Firestore 인덱스 에러

### 증상
```
[cloud_firestore/failed-precondition] The query requires an index.
You can create it here: https://console.firebase.google.com/...
```

### 원인
복합 쿼리 (여러 필드 where + orderBy)에 인덱스 필요.

### 해결
**방법 1: 에러 메시지 URL 클릭**
- 에러 메시지의 링크를 클릭하면 Firebase Console에서 자동으로 인덱스 생성.

**방법 2: firestore.indexes.json 추가**
```json
{
  "indexes": [
    {
      "collectionGroup": "visits",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "truckId", "order": "ASCENDING" },
        { "fieldPath": "visitedAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

**방법 3: Firebase CLI 배포**
```bash
firebase deploy --only firestore:indexes
```

---

## 3. Google OAuth redirect_uri_mismatch

### 증상
```
Error 400: redirect_uri_mismatch
The redirect URI in the request, http://localhost:xxxx, does not match...
```

### 원인
웹에서 `signInWithRedirect` 사용 시 redirect URI 불일치.

### 해결
웹에서는 `signInWithPopup` 사용:
```dart
if (kIsWeb) {
  userCredential = await _auth.signInWithPopup(googleProvider);
} else {
  userCredential = await _auth.signInWithCredential(credential);
}
```

**Firebase Console 설정**:
1. Firebase Console > Authentication > Sign-in method > Google
2. 승인된 도메인에 `localhost`, `truck-tracker-fa0b0.web.app` 추가

---

## 4. Windows flutter build web 크래시

### 증상
```
Compiler unexpectedly exited
impellerc crashed (shader compilation)
```

### 원인
Windows에서 Flutter의 impellerc (셰이더 컴파일러) 버그.

### 해결
WSL Ubuntu에서 빌드 후 Windows로 복사:
```bash
# 1. WSL에서 빌드
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"
npx firebase-tools deploy --only hosting
```

---

## 5. git nul 파일 에러

### 증상
```
error: invalid path 'nul'
```

### 원인
Windows에서 예약된 파일명 (nul, con 등)이 git에 들어감.

### 해결
전체 add 대신 특정 파일만 add:
```bash
# 전체 add 피하기
git add lib/specific_file.dart

# 또는 폴더 단위로
git add lib/features/

# nul 파일 제거 (필요시)
git rm --cached nul
```

---

## 6. ARB 파일 단일 따옴표 에러

### 증상
```
Unmatched single quotes in ICU string
```

### 원인
ARB 파일에서 단일 따옴표(`'`)는 이스케이프 필요.

### 해결
단일 따옴표를 두 번 연속 사용:
```json
// 잘못된 예
"message": "Customer's coupon"

// 올바른 예
"message": "Customer''s coupon"
```

---

## 7. iOS Safari 빈 화면

### 증상
iOS Safari에서 Flutter 웹 앱이 빈 화면으로 표시됨.

### 원인
CanvasKit 렌더러가 iOS Safari에서 일부 버전에서 호환성 문제.

### 해결
`index.html`에 iOS Safari 감지 및 안내 메시지 추가:
```javascript
// iOS Safari 감지
var isIOS = /iPhone|iPad|iPod/.test(navigator.userAgent);
var isCriOS = /CriOS/.test(navigator.userAgent); // Chrome
var isFxiOS = /FxiOS/.test(navigator.userAgent); // Firefox
var isIOSSafari = isIOS && !isCriOS && !isFxiOS;

if (isIOSSafari) {
  // Chrome 사용 안내 표시
}
```

---

## 8. Riverpod Provider 코드 생성 에러

### 증상
```
Undefined class 'XxxRef'
The method 'xxx' isn't defined
```

### 원인
`@riverpod` 어노테이션 추가/수정 후 코드 생성 안 함.

### 해결
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 9. Flutter Test Windows 버그

### 증상
```
impellerc crashed during test execution
```

### 원인
Windows에서 Flutter test 실행 시 impellerc 셰이더 컴파일 버그.

### 해결
WSL Ubuntu에서 테스트 실행:
```bash
# 전체 테스트
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter test"

# 특정 폴더만
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && flutter test test/unit/features/truck_list/"
```

---

## 10. mobile_scanner 권한 에러

### 증상
카메라 스캐너가 작동하지 않음.

### 원인
Android/iOS 카메라 권한 미설정.

### 해결

**Android (android/app/src/main/AndroidManifest.xml)**:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
```

**iOS (ios/Runner/Info.plist)**:
```xml
<key>NSCameraUsageDescription</key>
<string>QR 코드를 스캔하기 위해 카메라 접근이 필요합니다.</string>
```

---

## 11. SharedPreferences 웹 호환성

### 증상
웹에서 SharedPreferences 값이 저장/로드되지 않음.

### 원인
웹에서는 localStorage 사용, 일부 제한 있음.

### 해결
`shared_preferences` 패키지는 웹을 자동 지원하지만, 브라우저 설정에서 localStorage가 비활성화된 경우 작동하지 않음.

```dart
try {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('key', true);
} catch (e) {
  // 웹 localStorage 오류 처리
  debugPrint('SharedPreferences error: $e');
}
```

---

## 12. Firebase Functions 배포 에러

### 증상
```
Error: Failed to load function definition from source
```

### 원인
TypeScript 컴파일 에러 또는 함수 export 문제.

### 해결
```bash
cd functions
npm run build  # TypeScript 컴파일 확인
firebase deploy --only functions
```

**주의**: Node.js 18+ 필요

---

## Quick Reference

| 에러 | 빠른 해결 |
|------|----------|
| FCM 웹 에러 | `if (kIsWeb) return;` |
| Firestore 인덱스 | 에러 URL 클릭 |
| OAuth mismatch | `signInWithPopup` 사용 |
| Windows 빌드 크래시 | WSL에서 빌드 |
| git nul 에러 | 특정 파일만 add |
| ARB 따옴표 | `''` 이스케이프 |
| iOS Safari | Chrome 사용 안내 |
| Provider 에러 | build_runner 실행 |
| Windows 테스트 | WSL에서 실행 |
