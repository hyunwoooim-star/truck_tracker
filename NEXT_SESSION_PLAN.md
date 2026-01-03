# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 현재 상태 (2026-01-03 최신)

| 항목 | 상태 |
|------|------|
| 완성도 | **120%** (Phase 0-4 + PC 웹 반응형 + 로딩 최적화 완성) |
| 빌드 | **WSL Ubuntu** or **GitHub Actions** |
| flutter analyze | No issues (info만) |
| Cloud Functions | 10개 함수 배포 완료 |
| 소셜 로그인 | ✅ 오버레이 버그 수정 + 엔터 키 지원 |
| 이미지 업로드 | ✅ **전체 통합 완료** (WebP 압축) |
| PC 웹 반응형 | ✅ **완성** (지도/트럭리스트 레이아웃) |
| 로딩 성능 | ✅ **6-8초 → 1-2초** (대폭 개선) |
| Sentry | ✅ 에러 모니터링 연결됨 |
| 배포 | https://truck-tracker-fa0b0.web.app |

---

## ✅ 최근 완료 작업 (2026-01-03)

### 1. 햄버거 메뉴 역할별 분리 + 설정화면 정리 ✅
- **손님/사장님/관리자** 역할별 메뉴 분리
- 설정 화면 UI 정리

### 2. PC 웹 반응형 레이아웃 ✅
- **지도/트럭리스트** PC 환경 최적화
- 반응형 디자인 완성

### 3. 소셜 로그인 개선 ✅
- **오버레이 닫힘 버그** 수정
- **엔터 키 로그인** 지원

### 4. 로그인 화면 성능 최적화 ✅
- 첫 로딩 시간: **6-8초 → 1-2초** (75% 개선)

### 5. 트럭 카드 클릭 UX ✅
```
트럭 카드 클릭 → 지도로 이동 + 해당 트럭으로 확대 (zoom 17)
                 → 바텀시트 팝업 (트럭 미리보기)
                 → [상점 보기] 버튼 → TruckDetailScreen
```

---

## 남은 작업 (선택)

| 항목 | 우선순위 | 비고 |
|------|----------|------|
| 소셜 피드 방향 결정 | 중 | 모든 사용자 vs 사장님 전용 |
| deprecated API 정리 | 낮음 | `dart:html` → `package:web` |
| 실제 사용 테스트 | 중 | 배포된 앱 테스트 |

---

## 빌드 & 배포

### WSL 수동 배포 (권장)
```bash
# 1. WSL 빌드
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker" && npx firebase-tools deploy --only hosting
```

### GitHub Actions (자동)
- `main` 브랜치에 push → 자동 빌드 & Firebase 배포

---

## 링크
- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

**마지막 업데이트**: 2026-01-03 (PC 웹 반응형 + 로딩 최적화 완성)
