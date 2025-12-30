# Truck Tracker - 세션 시작 가이드

> **세션 시작 시 이 파일만 읽으면 됨**

## 링크
- **Live**: https://hyunwoooim-star.github.io/truck_tracker/
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker
- **Firebase**: https://console.firebase.google.com/project/truck-tracker-fa0b0

---

## 현재 상태 (2025-12-30)

**전체 완성도**: 95%+ (프로덕션 배포 완료)

| 항목 | 상태 |
|------|------|
| 웹 배포 | GitHub Actions CI/CD |
| Flutter analyze | 0 issues |
| 핵심 기능 | 100% |
| 코드 품질 | 최적화 완료 |

---

## 다음 할 일 (TODO)

### 우선순위 높음
- [ ] Cloud Functions 배포 (Firebase CLI 필요)
- [ ] 테스트 버튼 제거 (login_screen.dart - kDebugMode 조건 추가)

### 우선순위 중간
- [ ] Google Sign-In 웹 설정 (web/index.html OAuth Client ID)
- [ ] 주요 Feature 테스트 추가 (auth, order, chat)

### 우선순위 낮음
- [ ] 결제 연동 (Phase 14)
- [ ] 오프라인 모드

---

## 최근 완료 작업

### 2025-12-30
- 스탬프 카드 시스템 + 방문 인증 연동
- 커스텀 트럭 마커 아이콘
- 근처 트럭 알림 (Pokemon GO 스타일)
- withOpacity() 100% 상수화 완료
- SnackBarHelper 유틸리티
- 비밀번호 검증 강화 (password_validator.dart)
- 테스트 의존성 복원 (fake_cloud_firestore)
- 문서 정리 (23개 → docs/archive/)

---

## 빌드 명령어

```bash
# 로컬에서 빌드 안됨 (impellerc 버그)
# GitHub에 push하면 자동 빌드 & 배포

git add . && git commit -m "message" && git push
```

---

## 파일 구조 (핵심만)

```
lib/
├── core/           # 테마, 상수, 유틸
├── features/       # 기능 모듈 (19개)
├── shared/         # 공유 위젯
└── main.dart

docs/archive/       # 과거 문서 (참고용)
```

---

**마지막 업데이트**: 2025-12-30 23:50
