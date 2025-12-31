# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 🔴 윈도우 재설치 후 해야 할 것 (2025-12-31 기록)

### 1️⃣ 프로그램 설치
```bash
# 1. Git 설치
# https://git-scm.com/download/win

# 2. Flutter 설치 (3.38.x 권장)
# https://docs.flutter.dev/get-started/install/windows

# 3. Node.js 설치 (v20 LTS)
# https://nodejs.org/

# 4. VS Code 설치
# https://code.visualstudio.com/

# 5. Claude Code 설치
npm install -g @anthropic-ai/claude-code
```

### 2️⃣ 프로젝트 클론
```bash
git clone https://github.com/hyunwoooim-star/truck_tracker.git
cd truck_tracker
flutter pub get
```

### 3️⃣ Firebase 설정
```bash
# Firebase CLI 설치 & 로그인
npm install -g firebase-tools
firebase login

# service-account-key.json 복원 (백업해둔 파일)
# 프로젝트 루트에 복사
```

### 4️⃣ 환경 변수 확인
- Flutter PATH 추가
- Android SDK PATH (Android 빌드 시)

### 5️⃣ 로그인 필요한 서비스
- [ ] GitHub (git config --global user.name / user.email)
- [ ] Firebase (`firebase login`)
- [ ] Tailscale (tailscale.com 로그인)
- [ ] VS Code Settings Sync (Microsoft/GitHub 계정)

### 📁 백업 파일 복원
- `service-account-key.json` → 프로젝트 루트에 복사

---

## 링크
- **Live**: https://truck-tracker.web.app/ (Firebase)
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

## 현재 상태 (2025-12-31)

| 항목 | 상태 |
|------|------|
| 완성도 | 100% |
| 빌드 | GitHub Actions 자동 배포 |
| flutter analyze | No issues |
| iOS Safari | Chrome 사용 안내 메시지 표시 |
| 관리자 대시보드 | ✅ 완료 |

---

## 알아야 할 것

### iOS Safari 미지원 (해결됨)
- **원인**: CanvasKit 렌더러가 iOS Safari에서 작동 안 함
- **해결**: Safari 감지 시 "Chrome 사용" 안내 메시지 표시
- **파일**: `web/index.html` (isIOSSafari 감지 로직)

### 빌드 방법
```bash
# 로컬 빌드 안됨 (Windows impellerc 버그)
# GitHub push → 자동 빌드/배포
git add . && git commit -m "message" && git push
```

### Flutter 버전
- **사용 중**: 3.38.5 (워크플로우에서)
- **HTML 렌더러**: 3.29+에서 deprecated → 사용 불가

---

## 남은 TODO

### 사용자 수동 작업
- [ ] GitHub Secrets: `KAKAO_NATIVE_APP_KEY`, `GOOGLE_MAPS_API_KEY`
- [ ] Firebase Console: Firestore 규칙, Cloud Functions 배포
  - `notifyAdminOwnerRequest`: 새 사장님 인증 요청 시 관리자 알림
  - `updateAdminStats`: 통계 자동 업데이트

### 최근 완료 (2025-12-31)
- [x] 관리자 통계 대시보드 (`admin_dashboard_screen.dart`)
- [x] 사용자 관리 화면 (`user_management_screen.dart`)
- [x] 관리자 실시간 푸시 알림 (Cloud Function + FCM 토픽)
- [x] FCM 서비스 워커 추가 (`web/firebase-messaging-sw.js`)
- [x] 사장님 승인 대기 화면 (`owner_pending_screen.dart`)
- [x] 사장님 가입 플로우 수정: 승인 전 "승인 대기 중" 표시
- [x] 웹 이미지 업로드 오류 수정 (putFile → putData)

### 선택적 기능
- [ ] **관리자 외부 알림 (텔레그램 + 이메일)** - 계획 완료, 구현 대기
  - 텔레그램 봇 만들기 (`@BotFather` → `/newbot`)
  - SendGrid 계정 생성 (무료)
  - Cloud Function 수정 후 배포
- [ ] 멤버십/구독 (Phase 6)
- [ ] AI 개인화 추천 (Phase 7)
- [ ] 오프라인 모드 (Hive)

---

## 파일 구조
```
lib/
├── core/           # 테마, 상수
├── features/       # 기능 모듈 (23개)
│   ├── admin/      # 관리자 기능
│   │   ├── data/admin_stats_repository.dart
│   │   └── presentation/
│   │       ├── admin_dashboard_screen.dart  # 메인 대시보드
│   │       ├── user_management_screen.dart  # 사용자 관리
│   │       └── widgets/admin_stats_card.dart
│   └── auth/       # 인증 기능
│       ├── data/auth_service.dart           # 로그인/회원가입
│       └── presentation/
│           ├── login_screen.dart            # 로그인/회원가입 화면
│           ├── owner_pending_screen.dart    # 사장님 승인 대기 화면
│           └── email_verification_screen.dart
├── shared/         # 공유 위젯
└── main.dart       # AuthWrapper에서 사장님 요청 상태 확인

web/index.html      # iOS Safari 감지 + 인앱브라우저 감지
firebase.json       # CDN 캐시 설정
functions/index.js  # Cloud Functions (FCM 알림)
```

---

## 참고: iOS Safari 문제 상세 (필요할 때만)

<details>
<summary>클릭하여 펼치기</summary>

### Flutter 버전별 호환성
| 버전 | HTML 렌더러 | iOS Safari |
|-----|------------|------------|
| 3.38.5 | X (exit 64) | X |
| 3.29+ | deprecated | X |
| 3.27.4 | O | SDK 충돌 |

### 시도한 해결책
1. `--web-renderer html` → exit code 64
2. Flutter 3.24.5 다운그레이드 → SDK 충돌
3. Flutter 3.27.4 → SDK 충돌
4. **최종**: Safari 사용자에게 Chrome 안내 ✅

### 관련 GitHub 이슈
- #89655: iOS 15 Safari 렌더링
- #91414: CanvasKit iOS 실패
- #163199: --web-renderer 옵션 제거

</details>

---

**마지막 업데이트**: 2025-12-31
