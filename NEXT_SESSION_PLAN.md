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

### Phase 1: 기술 부채 청산 ✅ 완료
- [x] 문서 정리 완료
- [x] **Owner Dashboard 분리** (1,570줄 → 710줄, 55% 감소)
  - `owner_stats_card.dart` - 통계 카드
  - `owner_order_kanban.dart` - 칸반 보드
  - `owner_quick_actions.dart` - GPS/현금매출 버튼
  - `owner_announcement.dart` - 공지사항
  - `owner_soldout_toggles.dart` - 품절 관리
  - `owner_talk_section.dart` - 고객 대화
- [x] 테스트 파일 19 → 23개 (+4, auth/stamp_card/visit_verification/owner_dashboard)
- [x] **접근성 개선** (Semantics 라벨 추가)
  - BentoTruckCard에 전체 컨텍스트 Semantics 추가
  - 좋아요/지도 버튼에 Semantics 추가
  - 새 l10n 문자열 추가 (tapToViewDetails, ranked, operating/resting/maintenance)

### Phase 2: Cloud Functions 배포 ✅ 완료
- [x] 6개 함수 배포 완료
  - createCustomToken (카카오/네이버 인증)
  - notifyTruckOpening (영업 시작 알림)
  - notifyOrderStatus (주문 상태 알림)
  - notifyCouponCreated (쿠폰 발행 알림)
  - notifyChatMessage (채팅 알림)
  - notifyNearbyTrucks (근처 트럭 알림)

### Phase 3: UI/UX 트렌드 적용 ✅ 완료
- [x] **Bento Grid 레이아웃** (TruckListScreen 적용 완료)
  - `bento_truck_card.dart` - 3가지 크기 카드 (Large/Medium/Small)
  - `bento_truck_grid.dart` - MasonryGridView 기반 스태거드 그리드
  - 패키지: `flutter_staggered_grid_view: ^0.7.0`
- [x] **대형 이미지 + 타이포그래피** (Large 카드에 적용)
- [x] **Micro-interactions** (좋아요 버튼 애니메이션)
  - AnimatedBuilder + elasticOut curve
  - Scale 1.0 → 1.3 → 1.0 효과
- [x] **Glassmorphism 카드** (Large 카드 하단 패널)
  - BackdropFilter + ImageFilter.blur
  - 반투명 배경 + 테두리

### Phase 4: 소셜 피드 ✅ 완료
- [x] **Instagram 스타일 트럭/음식 사진 피드**
  - `lib/features/social_feed/domain/post.dart` - Freezed 모델 (Post, Comment, PostLike)
  - `lib/features/social_feed/data/social_repository.dart` - Firestore CRUD
  - `lib/features/social_feed/presentation/feed_screen.dart` - 메인 피드
  - `lib/features/social_feed/presentation/widgets/post_card.dart` - 게시물 카드
- [x] **좋아요 + 댓글**
  - 실시간 좋아요 카운트 (Firestore Transaction)
  - 댓글 Bottom Sheet (`comments_sheet.dart`)
  - 애니메이션 좋아요 버튼 (elasticOut curve)
- [x] **해시태그 검색**
  - `hashtag_search_screen.dart` - 인기 해시태그 + 검색
  - 해시태그별 게시물 필터링
  - 본문에서 자동 해시태그 추출
- [x] **게시물 작성**
  - `create_post_screen.dart` - 다중 이미지 업로드
  - Firebase Storage 연동
  - 추천 해시태그 제안

### Phase 5: 결제 연동 ✅ 완료
- [x] **TossPayments 결제 통합**
  - `lib/features/payment/domain/payment.dart` - Freezed 모델 (Payment, PaymentResult)
  - `lib/features/payment/data/payment_repository.dart` - TossPayments API 연동
  - 패키지: `tosspayments_widget_sdk_flutter: ^1.0.5`
- [x] **결제 수단 선택 화면**
  - `payment_screen.dart` - 결제 수단 선택 UI
  - 카드/토스페이/카카오페이/네이버페이/계좌이체 지원
- [x] **TossPayments WebView 결제창**
  - `toss_payment_webview.dart` - WebView 기반 결제
  - JavaScript 브릿지로 결제 결과 수신
- [x] **결제 결과 화면**
  - `payment_result_screen.dart` - 성공/실패 표시
  - 픽업 안내 메시지
- [x] **주문 플로우 통합**
  - `truck_detail_screen.dart` 수정
  - 주문 확인 → 결제 수단 선택 → 결제 → 주문 생성 → 결과 표시

### 광고 수익화 ✅ 완료
- [x] **Google AdMob 통합**
  - `lib/features/ads/data/ad_service.dart` - AdMob SDK 관리
  - 패키지: `google_mobile_ads: ^5.2.0`
  - 테스트/프로덕션 광고 ID 분리
- [x] **배너 광고 위젯**
  - `banner_ad_widget.dart` - 표준/적응형 배너
  - FeedScreen 하단에 적용
- [x] **보상형 광고**
  - `rewarded_ad_button.dart` - 광고 시청 버튼
  - 스탬프 카드에 "광고 보고 보너스 스탬프 받기" 추가
  - `addBonusStamp()` 메서드 추가
- [x] **전면 광고 (Interstitial)**
  - AdService에 구현 (화면 전환 시 사용 가능)

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

**마지막 업데이트**: 2025-12-30 (Phase 1-5 + 광고 수익화 완료 - AdMob 배너/보상형 광고)
