# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 현재 상태 (2026-01-02 최신)

| 항목 | 상태 |
|------|------|
| 완성도 | **110%** (Phase 0-4 + 이미지 최적화 완료) |
| 빌드 | **WSL Ubuntu에서 빌드** (Windows X) |
| flutter analyze | No issues (info만) |
| Cloud Functions | 10개 함수 배포 완료 |
| 소셜 로그인 | ✅ 카카오/네이버/Google/이메일 모두 정상 |
| 이미지 업로드 | ✅ **전체 통합 완료** (WebP 압축) |
| 배포 | https://truck-tracker-fa0b0.web.app |

---

## ✅ 오늘 완료한 작업 (2026-01-02)

### 이미지 업로드 통합 ✅
모든 이미지 업로드를 `ImageUploadService`로 통합 완료

| 파일 | 용도 | 상태 |
|------|------|------|
| `menu_management_screen.dart` | 메뉴 이미지 | ✅ |
| `menu_management_tab.dart` | 메뉴 이미지 | ✅ |
| `owner_dashboard_screen.dart` | 트럭 대표 이미지 | ✅ |
| `auth_service.dart` | 사업자등록증 | ✅ |
| `chat_repository.dart` | 채팅 이미지 | ✅ |
| `create_post_screen.dart` | 소셜 포스트 | ✅ |

### ImageUploadService 확장
- 새 타입: `chat`, `socialPost`
- 새 메서드: `uploadChatImage()`, `uploadSocialPostImages()`
- 모든 이미지 WebP 압축 적용 (50-80% 용량 감소)

---

## 🤔 고민 중인 사항

### 소셜 피드 기능 (`lib/features/social_feed/`)
현재 구현됨: **인스타그램 스타일 피드** (모든 사용자용)

**선택지:**
1. **모든 사용자** - 고객+사장님이 음식 사진/후기 공유
2. **사장님 전용 커뮤니티** - 사장님들끼리 정보 공유 (위치, 행사, 노하우)
3. **사용 안 함** - 기능 비활성화

→ 밥 먹고 결정하기

---

## 남은 작업 (선택)

| 항목 | 우선순위 | 비고 |
|------|----------|------|
| 소셜 피드 방향 결정 | 중 | 위 고민 사항 |
| 실제 테스트 | 중 | 이미지 업로드 테스트 |
| deprecated API 정리 | 낮음 | `dart:html` → `package:web` |

---

## 빌드 & 배포

```bash
# 1. WSL 빌드
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker" && npx firebase-tools deploy --only hosting
```

---

## 링크
- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

**마지막 업데이트**: 2026-01-02 (이미지 업로드 통합 완료)
