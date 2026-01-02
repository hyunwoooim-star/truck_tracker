# Claude Web 컨텍스트 (복사해서 붙여넣기)

아래 내용을 Claude 웹에 붙여넣으면 바로 이어서 작업 가능

---

## 프로젝트 개요

**Truck Tracker** - 푸드트럭 위치 찾기 + 선결제 + 픽업 앱
- **기술스택**: Flutter Web + Firebase (Firestore, Auth, Storage, Functions)
- **배포**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

## 현재 상태 (2026-01-02)

| 항목 | 상태 |
|------|------|
| 완성도 | 110% (Phase 0-4 완료) |
| 소셜 로그인 | ✅ 카카오/네이버/Google/이메일 |
| 이미지 업로드 | ✅ WebP 압축 통합 완료 |
| Cloud Functions | 10개 배포 완료 |

---

## 오늘 완료한 작업

### 이미지 업로드 ImageUploadService 통합
모든 이미지 업로드를 중앙 서비스로 통합, WebP 압축 적용

수정된 파일:
- `lib/features/owner_dashboard/presentation/menu_management_screen.dart`
- `lib/features/owner_dashboard/presentation/widgets/menu_management_tab.dart`
- `lib/features/owner_dashboard/presentation/owner_dashboard_screen.dart`
- `lib/features/auth/data/auth_service.dart`
- `lib/features/chat/data/chat_repository.dart`
- `lib/features/social_feed/presentation/create_post_screen.dart`
- `lib/features/storage/image_upload_service.dart` (chat, socialPost 타입 추가)

---

## 고민 중인 사항

### 소셜 피드 기능 (`lib/features/social_feed/`)
현재: 인스타그램 스타일 피드 (모든 사용자용)

선택지:
1. **모든 사용자** - 고객+사장님이 음식 사진/후기 공유
2. **사장님 전용 커뮤니티** - 사장님들끼리 정보 공유
3. **사용 안 함** - 기능 비활성화

---

## 주요 파일 구조

```
lib/
├── core/           # 테마, 상수, 유틸
├── features/
│   ├── auth/       # 로그인 (카카오/네이버/구글/이메일)
│   ├── truck_map/  # 지도 화면
│   ├── truck_list/ # 트럭 목록
│   ├── owner_dashboard/  # 사장님 대시보드
│   ├── order/      # 주문 시스템
│   ├── social_feed/  # 소셜 피드 (고민 중)
│   ├── storage/    # ImageUploadService
│   └── ...
├── shared/         # 공유 위젯
└── main.dart
```

---

## 빌드 & 배포 (WSL 필수)

```bash
# 1. WSL 빌드
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker" && npx firebase-tools deploy --only hosting
```

---

## 다음 할 일

1. 소셜 피드 방향 결정
2. 이미지 업로드 실제 테스트
3. (선택) deprecated API 정리

---

**이 내용을 Claude 웹에 붙여넣고 "이어서 작업해줘" 라고 말하면 됨**
