# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 현재 상태 (2026-01-01 메가플랜 완료!)

| 항목 | 상태 |
|------|------|
| 완성도 | **100%+** (기능 완성 + 배포 완료) |
| 빌드 | **WSL Ubuntu에서 빌드** (Windows X) |
| flutter analyze | No issues |
| Cloud Functions | 10개 함수 배포 완료 |
| 배포 | https://truck-tracker-fa0b0.web.app |

---

## 링크
- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

## 2026-01-01 메가플랜 완료 보고서

### 완료된 8가지 작업

| # | 작업 | 상태 | 커밋 |
|---|------|------|------|
| 1 | 고객 온보딩 튜토리얼 (4슬라이드) | ✅ | e401bb7 |
| 2 | 즐겨찾기 Provider 버그 수정 | ✅ | fc24bfc |
| 3 | 리뷰 수정/삭제 UI 추가 | ✅ | ab13b9b |
| 4 | Talk 삭제 기능 추가 | ✅ | f2666f1 |
| 5 | 쿠폰 스캐너 (QR 스캔) 구현 | ✅ | 1df237e |
| 6 | 도움말 FAQ 섹션 추가 | ✅ | 3f47864 |
| 7 | TROUBLESHOOTING.md 작성 | ✅ | d3f9b24 |
| 8 | 빌드 & Firebase 배포 | ✅ | - |

### 신규 생성 파일
1. `lib/features/onboarding/presentation/customer_onboarding_screen.dart`
2. `lib/features/owner_dashboard/presentation/coupon_scanner_screen.dart`
3. `docs/TROUBLESHOOTING.md`

### 수정된 파일
- `lib/main.dart` - 온보딩 로직 추가
- `lib/features/favorite/presentation/favorite_provider.dart` - 버그 수정
- `lib/features/truck_detail/presentation/truck_detail_screen.dart` - 리뷰 수정/삭제
- `lib/features/talk/presentation/talk_widget.dart` - Talk 삭제
- `lib/features/owner_dashboard/presentation/owner_dashboard_screen.dart` - 쿠폰 스캐너 버튼
- `lib/features/settings/presentation/help_screen.dart` - FAQ 섹션
- `lib/l10n/app_en.arb`, `lib/l10n/app_ko.arb` - 번역 추가

---

## 🔜 다음 세션에서 할 것 (우선순위 순)

### 1. 카카오 웹 로그인 수정 (KOE205 에러)
- **현재 상태**: KOE205 "잘못된 요청" 에러
- **원인 추정**: Redirect URI 불일치 또는 콜백 페이지 라우팅 문제
- **해결 방법**: 아래 "OAuth 콜백 라우팅" 참고

### 2. 네이버 웹 로그인 수정 (동의 후 첫 화면으로 돌아감)
- **현재 상태**: 동의 화면까지는 나옴, 동의 후 첫 화면으로 돌아감
- **해결 방법**: 아래 "OAuth 콜백 라우팅" 참고

### 3. Google 웹 로그인 수정
- index.html에 Google Sign-In Client ID 설정 필요

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

---

## 빌드 방법 (필수!)

**Windows에서 직접 빌드하면 안 됨! (impellerc 크래시)**

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
├── features/       # 기능 모듈 (24개)
│   ├── admin/      # 관리자 기능
│   ├── auth/       # 인증 기능 (OAuth 포함)
│   ├── onboarding/ # 고객 온보딩 (NEW)
│   └── ...
├── shared/         # 공유 위젯
└── main.dart

docs/
├── TROUBLESHOOTING.md  # 트러블슈팅 가이드 (NEW)
└── ...

web/index.html      # iOS Safari 감지
firebase.json       # CDN 캐시 설정
functions/index.js  # Cloud Functions (10개)
```

---

**마지막 업데이트**: 2026-01-01 (메가플랜 완료)
