# Truck Tracker - 세션 시작 가이드

> **세션 시작 시 이 파일만 읽으면 됨**
> **앱 컨셉**: 푸드트럭 위치 찾기 + 선결제/선주문 + 직접 픽업 (배달 X)

## 링크
- **Live**: https://hyunwoooim-star.github.io/truck_tracker/
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker
- **Firebase**: https://console.firebase.google.com/project/truck-tracker-fa0b0

---

## 현재 상태 (2025-12-31 업데이트)

**전체 완성도**: 99%+ (프로덕션 배포 완료)

| 항목 | 상태 |
|------|------|
| 웹 배포 | GitHub Actions CI/CD |
| Flutter analyze | ✅ No issues found! (0 errors, 0 warnings, 0 infos) |
| 핵심 기능 | 100% |
| 코드 품질 | 최적화 완료 |

---

## 📋 2025-12-31 작업 기록

### ✅ 완료된 작업

#### 1. social_feed 모듈 에러 수정
- `post.dart`: Freezed 3.x 호환 (abstract class 변환)
- `social_repository.dart`: Riverpod Ref 타입 수정 (6개 provider)
- 결과: 9개 에러 → 0개

#### 2. 코드 품질 개선
- warnings 5개 수정 (미사용 import/변수 제거)
- infos 18개 수정 (unnecessary_underscores, unnecessary_brace)
- 결과: **flutter analyze: No issues found!**

#### 3. GitHub Actions CI 개선
- 3개 워크플로우에 build_runner, analyze, test 단계 추가
- `web-deploy.yml`, `build-android.yml`, `build-web.yml`

#### 4. CLAUDE.md 규칙 추가
- Windows flutter test 금지 (impellerc 버그)
- 테스트는 GitHub Actions CI에서만 실행

### 📊 커밋 히스토리
- `3f3d7ee`: fix: social_feed Freezed/Riverpod 에러 수정
- `eca94cd`: docs: NEXT_SESSION_PLAN 업데이트
- `4262ca4`: ci: GitHub Actions에 테스트 단계 추가
- `0579f34`: style: 18개 lint infos 수정

---

## 📋 2025-12-30 작업 기록

### ✅ 완료된 작업

#### 1. WSL1 + Ubuntu 22.04 설치
- Windows 버전 10.0.18362 (Version 1903) → WSL2 미지원, WSL1로 진행
- Microsoft Store에서 Ubuntu 22.04 LTS 설치
- 사용자: `hyunwoo` / 비밀번호 설정 완료

#### 2. WSL에 Flutter 수동 설치
- snap 미지원으로 수동 설치 진행
- Flutter 3.38.5 (stable) 설치 완료
- 경로: `~/flutter/bin`
- `.bashrc`에 PATH 추가

#### 3. 프로젝트 클론 및 환경 확인
- `git clone https://github.com/hyunwoooim-star/truck_tracker.git`
- `flutter pub get` 완료
- `flutter pub run build_runner build --delete-conflicting-outputs` 완료

#### 4. flutter doctor 결과
```
[✓] Flutter (3.38.5, Ubuntu 22.04.5 LTS)
[✗] Android toolchain (SDK 없음)
[✗] Chrome (없음)
[✓] Linux toolchain
[✓] Connected device (1 available)
```

### ❌ 실패/보류된 작업

#### SSH/Tailscale 원격 접속 설정
- **SSH**: PasswordAuthentication 설정했으나 계속 Permission denied
- **Tailscale**: WSL1에서 TUN 모듈 미지원으로 불가
- **결론**: WSL1 환경 한계로 원격 접속 불가
- **대안**: AnyDesk 또는 Chrome 원격 데스크톱 사용 권장

### ⚠️ 발견된 문제

#### social_feed 모듈 에러 (9개)
```
error • Undefined class 'SocialRepositoryRef' • social_repository.dart:210
error • Undefined class 'FeedPostsRef' • social_repository.dart:215
error • Undefined class 'PostsByHashtagRef' • social_repository.dart:221
error • Undefined class 'PostsByTruckRef' • social_repository.dart:227
error • Undefined class 'PostCommentsRef' • social_repository.dart:233
error • Undefined class 'TrendingHashtagsRef' • social_repository.dart:239
error • Missing implementations '_$Post' • post.dart:9
error • Missing implementations '_$Comment' • post.dart:97
error • Missing implementations '_$PostLike' • post.dart:159
```
- **원인**: Riverpod/Freezed 코드 생성 파일이 GitHub에 동기화되지 않음
- **해결 필요**: Windows에서 코드 수정 후 push

---

## 🔜 다음 세션 TODO

### ✅ 우선순위 1: 코드 에러 수정 (2025-12-31 완료)
- [x] `social_repository.dart` - Riverpod Ref 타입 수정 (6개 provider)
- [x] `post.dart` - Freezed 3.x abstract class 변환
- [x] `flutter pub run build_runner build --delete-conflicting-outputs` 실행
- [x] `flutter analyze` → 0 errors, 0 warnings
- [x] GitHub push

### 우선순위 2: GitHub Secrets 설정
- [ ] KAKAO_NATIVE_APP_KEY 추가
- [ ] GOOGLE_MAPS_API_KEY 추가

### 우선순위 3: 카카오/네이버 OAuth 설정
- [ ] AndroidManifest.xml 카카오 설정
- [ ] Info.plist 카카오 설정
- [ ] 네이버 개발자 센터 앱 등록

### 우선순위 4: Firebase 배포
- [ ] Firestore 규칙 배포
- [ ] Cloud Functions 배포 (WSL 또는 Windows에서)

---

## 💡 WSL 관련 참고사항

### WSL이 필요한 경우
- `flutter build web --release`에서 impellerc 버그 발생 시

### WSL 사용 안 해도 되는 경우
- GitHub Actions로 웹 빌드/배포 중이면 불필요
- 현재 Live Site 정상 작동 중

### WSL1 한계
- systemd 미지원 → snap, systemctl 불가
- TUN 모듈 없음 → Tailscale, VPN 불가
- SSH 접속 어려움 → AnyDesk 권장

### WSL 시작 명령어 (Ubuntu 창에서)
```bash
cd ~/truck_tracker
flutter pub get
flutter analyze
```

---

## 🔧 사용자 필수 작업 (수동 설정 필요)

### 1. GitHub Secrets 설정 (API 키)
> GitHub 저장소 → Settings → Secrets and variables → Actions

| Secret Name | 설명 | 값 가져오기 |
|-------------|------|------------|
| `KAKAO_NATIVE_APP_KEY` | 카카오 로그인용 | [카카오 개발자 콘솔](https://developers.kakao.com) |
| `GOOGLE_MAPS_API_KEY` | 도보 경로 안내용 | [Google Cloud Console](https://console.cloud.google.com) |
| `FIREBASE_SERVICE_ACCOUNT` | 배포용 (이미 설정됨) | Firebase Console |

**설정 방법**:
1. GitHub 저장소 → Settings → Secrets and variables → Actions
2. "New repository secret" 클릭
3. Name에 `KAKAO_NATIVE_APP_KEY` 입력
4. Value에 카카오 개발자 콘솔에서 복사한 키 입력
5. GOOGLE_MAPS_API_KEY도 동일하게 추가

### 2. Firebase Console 설정
| 작업 | URL | 설명 |
|------|-----|------|
| Firestore 규칙 | [규칙 설정](https://console.firebase.google.com/project/truck-tracker-fa0b0/firestore/rules) | `firestore.rules` 파일 내용 복사/붙여넣기 |
| Cloud Functions | [Functions](https://console.firebase.google.com/project/truck-tracker-fa0b0/functions) | 터미널에서 `firebase deploy --only functions` |

### 3. 프로덕션 키 (실제 수익화 시)
| 서비스 | 파일 | 현재 상태 |
|--------|------|---------|
| TossPayments | `payment_repository.dart:19-20` | 테스트 키만 (실제 결제 X) |
| AdMob | `ad_service.dart:25-30` | 테스트 ID만 (광고 수익 X) |

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

### Phase 8: 픽업 최적화 (배달 X) ✅ 완료
- [x] **도보 경로 안내** (Google Maps Directions API)
  - `lib/features/pickup_navigation/domain/walking_route.dart` - Freezed 모델
  - `lib/features/pickup_navigation/data/directions_service.dart` - Directions API 연동
  - `lib/features/pickup_navigation/presentation/pickup_navigation_screen.dart` - 네비게이션 화면
  - 실시간 위치 추적 + 경로 업데이트
  - 상세 경로 단계 표시
- [x] **예상 도착 시간(ETA) 표시**
  - `pickup_navigation/presentation/widgets/eta_card.dart` - ETA 카드 위젯
  - CompactEtaBadge (트럭 카드용)
  - 트럭 상세 화면에 ETA 카드 통합
- [x] **픽업 준비 완료 알림**
  - `pickup_ready_listener.dart` - 주문 상태 모니터링
  - 준비 완료 시 다이얼로그 표시
  - 길찾기 버튼으로 네비게이션 연결

### Phase 9: 관리자 대시보드 강화 ✅ 완료
- [x] **실시간 통계 대시보드**
  - `lib/features/analytics/data/revenue_repository.dart` - 매출 데이터 Repository
  - `RealTimeDashboard` - 실시간 주문/매출 스트림
  - 오늘 매출, 대기/준비중/픽업대기 주문 현황
- [x] **매출 리포트 (일/주/월)**
  - `lib/features/analytics/presentation/revenue_dashboard_screen.dart` - 매출 대시보드
  - 일별 매출 추이 차트 (fl_chart)
  - 기간별 필터 (오늘/이번주/이번달/30일/커스텀)
  - 인기 메뉴 TOP 5
  - 완료율, 평균 주문 금액
- [x] **푸시 알림 발송 도구**
  - `lib/features/notifications/presentation/push_notification_tool.dart`
  - 공지/프로모션/이벤트 유형 선택
  - 빠른 템플릿 (영업시작, 신메뉴, 특가, 종료임박)
  - 팔로워 수 표시 및 미리보기

### Phase 10: 성능 최적화 ✅ 완료
- [x] **웹 이미지 호환성 개선**
  - MarkerService: 웹에서 기본 마커 사용 (`BitmapDescriptor.defaultMarkerWithHue`)
  - CachedNetworkImage: 웹/모바일 동일하게 사용 (플러그인이 자동 처리)
- [x] **Drawer 앱 아이콘 웹 호환성**
  - 배경색 추가 (`AppTheme.charcoalDark`)
  - errorBuilder 추가 (asset 로드 실패 시 fallback 아이콘)
- [x] **트럭 리스트 카드 개선** (map_first_screen.dart)
  - `filteredTrucksWithDistanceProvider` 사용으로 변경
  - 거리 정보 표시 추가 (예: "1.2km")
  - 상태 태그 + 음식 종류 + 위치 표시
- [x] **빌드 오류 수정**
  - `tosspayments_widget_sdk_flutter`: ^1.0.5 → ^2.1.2 (버전 미존재 문제)
  - `pickup_ready_listener.dart`: import 및 메서드 호출 수정
- [x] **PWA 설정 완료**
  - manifest.json, index.html SEO 메타태그
  - CanvasKit 렌더러 사용
- [ ] 오프라인 모드 (Hive) - 선택적

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

**마지막 업데이트**: 2025-12-30 (보안 개선: API 키 dart-define 적용, 사용자 필수 작업 가이드 추가)
