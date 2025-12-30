# Truck Tracker - 세션 시작 가이드

> **세션 시작 시 이 파일만 읽으면 됨**
> **앱 컨셉**: 푸드트럭 위치 찾기 + 선결제/선주문 + 직접 픽업 (배달 X)

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

## 🚀 10단계 개선 로드맵

> 배민/요기요/쿠팡이츠 + 2025 UI/UX 트렌드 분석 기반

### Phase 1: 기술 부채 청산
- [x] 문서 정리 완료
- [x] **Owner Dashboard 분리** (1,570줄 → 710줄, 55% 감소)
  - `owner_stats_card.dart` - 통계 카드
  - `owner_order_kanban.dart` - 칸반 보드
  - `owner_quick_actions.dart` - GPS/현금매출 버튼
  - `owner_announcement.dart` - 공지사항
  - `owner_soldout_toggles.dart` - 품절 관리
  - `owner_talk_section.dart` - 고객 대화
- [x] 테스트 파일 19 → 23개 (+4, auth/stamp_card/visit_verification/owner_dashboard)
- [ ] 접근성 개선 (Semantics, 색상 대비)

### Phase 2: Cloud Functions 배포 ✅ 완료
- [x] 6개 함수 배포 완료
  - createCustomToken (카카오/네이버 인증)
  - notifyTruckOpening (영업 시작 알림)
  - notifyOrderStatus (주문 상태 알림)
  - notifyCouponCreated (쿠폰 발행 알림)
  - notifyChatMessage (채팅 알림)
  - notifyNearbyTrucks (근처 트럭 알림)

### Phase 3: UI/UX 트렌드 적용 ⬅️ 다음 진행
- [ ] Bento Grid 레이아웃 (TruckListScreen, TruckDetailScreen)
- [ ] 대형 이미지 + 타이포그래피
- [ ] Micro-interactions (좋아요 애니메이션)
- [ ] Glassmorphism 카드

### Phase 4: 소셜 피드
- [ ] Instagram 스타일 트럭/음식 사진 피드
- [ ] 좋아요 + 댓글
- [ ] 해시태그 검색

### Phase 5: 결제 연동
- [ ] TossPayments (1순위)
- [ ] KakaoPay (2순위)
- [ ] 선결제 → 픽업 플로우

### Phase 6: 멤버십/구독
- [ ] 방문 횟수 기반 등급 (실버/골드/VIP)
- [ ] 푸드트럭 패스 (월정액)

### Phase 7: AI 개인화
- [ ] 사용자 취향 기반 트럭 추천
- [ ] 시간대별/날씨별 메뉴 추천

### Phase 8: 픽업 최적화 (배달 X)
- [ ] 도보 경로 안내 (Google Maps)
- [ ] 예상 도착 시간 표시
- [ ] 픽업 준비 완료 알림

### Phase 9: 관리자 대시보드 강화
- [ ] 실시간 통계
- [ ] 매출 리포트
- [ ] 푸시 알림 발송 도구

### Phase 10: 성능 최적화
- [ ] 이미지 lazy loading
- [ ] 오프라인 모드 (Hive)
- [ ] PWA 강화

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
├── features/       # 기능 모듈 (23개)
├── shared/         # 공유 위젯
└── main.dart

docs/archive/       # 과거 문서 (참고용)
```

---

**마지막 업데이트**: 2025-12-30 (Phase 1.2, 2, 1.1 완료)
