# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 현재 상태 (2026-01-01 업데이트)

| 항목 | 상태 |
|------|------|
| 완성도 | 100% |
| 빌드 | **WSL Ubuntu에서 빌드** (Windows X) |
| flutter analyze | No issues |
| Cloud Functions | ✅ 10개 함수 배포 완료 |
| 카카오 웹 로그인 | ⚠️ 테스트 필요 (KOE205 에러 확인 중) |
| 네이버 웹 로그인 | ⚠️ 테스트 필요 |

---

## 링크
- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

## 🔜 다음 세션에서 할 것 (우선순위 순)

### 1. 카카오 웹 로그인 수정 (KOE205 에러)
- **현재 상태**: KOE205 "잘못된 요청" 에러
- **원인 추정**: Redirect URI 불일치 또는 콜백 페이지 라우팅 문제
- **확인 필요**:
  - 카카오 콘솔 Redirect URI: `https://truck-tracker-fa0b0.web.app/kakao`
  - Flutter 라우터에서 `/kakao` 경로 처리하는지 확인
  - `processKakaoCallback()` 함수가 호출되는지 확인

### 2. 네이버 웹 로그인 수정 (동의 후 첫 화면으로 돌아감)
- **현재 상태**: 동의 화면까지는 나옴, 동의 후 첫 화면으로 돌아감
- **원인 추정**: 콜백 URL로 돌아온 후 코드 처리가 안 됨
- **확인 필요**:
  - Flutter 라우터에서 `/oauth/naver/callback` 경로 처리하는지 확인
  - URL 파라미터에서 `code`와 `state` 추출하는지 확인
  - `processNaverCallback()` 함수가 호출되는지 확인

### 3. Google 웹 로그인 수정
- **확인 필요**:
  - `web/index.html`에 Google Sign-In Client ID 설정
  - Firebase Console에서 Google 로그인 활성화 확인

### 4. 공통 문제: OAuth 콜백 라우팅 (Gemini 분석 결과)

#### 핵심 원인
- Flutter 웹은 기본적으로 URL에 `#`(Hash)가 붙음 (예: `.../#/kakao`)
- 카카오/네이버 Redirect URI에는 `#`이 없어서 인식 안 됨
- go_router에 콜백 경로가 등록 안 되어 있음

#### 해결 방법

**1. main.dart에 Path URL Strategy 추가**
```dart
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy(); // '#' 제거
  runApp(const MyApp());
}
```

**2. go_router에 콜백 라우트 추가**
```dart
GoRoute(
  path: '/kakao',
  builder: (context, state) {
    final code = state.uri.queryParameters['code'];
    if (code != null) {
      return SocialLoginCallbackScreen(code: code, provider: 'kakao');
    }
    return const LoginErrorScreen();
  },
),
GoRoute(
  path: '/oauth/naver/callback',
  builder: (context, state) {
    final code = state.uri.queryParameters['code'];
    final naverState = state.uri.queryParameters['state'];
    if (code != null) {
      return SocialLoginCallbackScreen(code: code, state: naverState, provider: 'naver');
    }
    return const LoginErrorScreen();
  },
),
```

**3. SocialLoginCallbackScreen 구현**
- initState에서 code를 Cloud Function으로 전송
- Custom Token 받아서 Firebase signInWithCustomToken() 호출
- 성공하면 메인 페이지로 이동

**4. 카카오 추가 확인사항**
- Client Secret ON이면 Cloud Function에서 반드시 client_secret 파라미터 보내야 함
- 테스트 중이면 Client Secret OFF로 설정하고 테스트

**5. Google 로그인 (index.html 설정)**
```html
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
<script src="https://accounts.google.com/gsi/client" async defer></script>
```

### 5. 선택적 기능 (미뤄둔 것들)
- [ ] 관리자 외부 알림 (텔레그램 + 이메일)
- [ ] 멤버십/구독 (Phase 6)
- [ ] AI 개인화 추천 (Phase 7)
- [ ] 오프라인 모드 (Hive)

---

## ✅ 2026-01-01 완료한 것

### 카카오/네이버 OAuth 설정
- [x] 카카오 개발자 콘솔 설정
  - REST API 키: `9b29da5ab6db839b37a65c79afe9b52e`
  - Client Secret: Firebase Secret 저장
  - Redirect URI: `https://truck-tracker-fa0b0.web.app/kakao`
- [x] 네이버 개발자 센터 설정
  - Client ID: `9szh6EOxjf8b40x9ZHKH`
  - Client Secret: Firebase Secret 저장
- [x] Cloud Functions 배포
  - `exchangeKakaoCode` - 카카오 웹 OAuth 토큰 교환
  - `exchangeNaverCode` - 네이버 웹 OAuth 토큰 교환

### 코드 수정
- [x] `auth_service.dart` - Kakao/Naver Client ID 수정
- [x] `functions/index.js` - Kakao/Naver Client ID 수정

---

## 빌드 방법 (필수!)

**⚠️ Windows에서 직접 빌드하면 안 됨! (impellerc 크래시)**

```bash
# 1. WSL에서 빌드 (필수)
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker" && npx firebase-tools deploy --only hosting
```

---

## OAuth 설정값 정리

### 카카오
| 항목 | 값 |
|------|-----|
| REST API 키 | `9b29da5ab6db839b37a65c79afe9b52e` |
| Client Secret | Firebase Secret (`KAKAO_CLIENT_SECRET`) |
| Redirect URI | `https://truck-tracker-fa0b0.web.app/kakao` |

### 네이버
| 항목 | 값 |
|------|-----|
| Client ID | `9szh6EOxjf8b40x9ZHKH` |
| Client Secret | Firebase Secret (`NAVER_CLIENT_SECRET`) |
| Redirect URI | `https://truck-tracker-fa0b0.web.app/oauth/naver/callback` |

---

## 파일 구조
```
lib/
├── core/           # 테마, 상수
├── features/       # 기능 모듈 (23개)
│   ├── admin/      # 관리자 기능
│   └── auth/       # 인증 기능 (OAuth 포함)
├── shared/         # 공유 위젯
└── main.dart

web/index.html      # iOS Safari 감지
firebase.json       # CDN 캐시 설정
functions/index.js  # Cloud Functions (10개)
```

---

**마지막 업데이트**: 2026-01-01 12:40
