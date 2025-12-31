# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

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

### 선택적 기능
- [ ] 멤버십/구독 (Phase 6)
- [ ] AI 개인화 추천 (Phase 7)
- [ ] 오프라인 모드 (Hive)

---

## 파일 구조
```
lib/
├── core/           # 테마, 상수
├── features/       # 기능 모듈 (23개)
│   └── admin/      # 관리자 기능
│       ├── data/admin_stats_repository.dart
│       └── presentation/
│           ├── admin_dashboard_screen.dart  # 메인 대시보드
│           ├── user_management_screen.dart  # 사용자 관리
│           └── widgets/admin_stats_card.dart
├── shared/         # 공유 위젯
└── main.dart

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
