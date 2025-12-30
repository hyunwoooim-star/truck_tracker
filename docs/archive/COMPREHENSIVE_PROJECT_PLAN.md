# Truck Tracker 종합 프로젝트 플랜

**작성일**: 2025-12-28
**작성자**: Claude Opus 4.5
**상태**: 프로덕션 준비 90% | 웹 배포 블로킹

---

## 1. 현재 상황 분석

### 1.1 프로젝트 현황 요약

| 항목 | 상태 | 비고 |
|------|------|------|
| **Flutter 버전** | 3.38.5 stable | 2025-12-11 릴리스 |
| **Phase 완료** | 1-13, 15 ✅ | Phase 14 (결제) 계획만 |
| **Cloud Functions** | 5개 구현 완료 | 배포 대기 (Firebase CLI 필요) |
| **웹 빌드** | 🔴 실패 | ShaderCompilerException |
| **Android/iOS** | ✅ 정상 | 빌드/실행 가능 |
| **테스트 커버리지** | ~47개 | 목표 60% 미달 |

### 1.2 기술 스택

```
Frontend: Flutter 3.38.5 + Dart 3.10.4
State: Riverpod 2.6.1 + Freezed 2.5.7
Backend: Firebase (Firestore, Auth, FCM, Storage, Functions)
Maps: Google Maps Flutter 2.9.0
```

---

## 2. 문제점 분석

### 2.1 🔴 Critical: 웹 빌드 실패

**증상**:
```
ShaderCompilerException: Shader compilation of "ink_sparkle.frag"
failed with exit code -1073741819
```

**원인 분석**:
1. **Impeller 셰이더 컴파일러 버그**: Flutter 3.38.x의 impellerc.exe가 Windows에서 크래시
2. **Exit Code -1073741819** = 0xC0000005 = Access Violation (메모리 접근 위반)
3. **Material 3 ink_sparkle 효과**가 웹 빌드 시 Impeller로 컴파일 시도

**현재 시도된 해결책** (실패):
- ❌ `useMaterial3: false` → 여전히 셰이더 컴파일 시도
- ❌ `NoSplash.splashFactory` → 여전히 실패
- ❌ `canvasKitBaseUrl` 설정 → 불완전 (renderer 미지정)

**해결 방안 (우선순위순)**:

#### Solution A: CanvasKit 렌더러 강제 지정 (95% 성공률)
```html
<!-- web/index.html에 추가 -->
<script>
  window.flutterConfiguration = {
    renderer: "canvaskit",  // ← 이 줄이 핵심!
    canvasKitBaseUrl: "https://www.gstatic.com/flutter-canvaskit/..."
  };
</script>
```

```bash
# 빌드 명령어
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
```

#### Solution B: HTML 렌더러 사용 (90% 성공률, 기능 제한)
```bash
flutter build web --release --web-renderer html
```
- ⚠️ Google Maps 렌더링 이슈 가능
- ⚠️ 일부 그래픽 효과 제한

#### Solution C: Flutter 다운그레이드 (70% 성공률)
```bash
# Flutter 3.24.x로 다운그레이드
flutter downgrade 3.24.5
flutter clean && flutter pub get
flutter build web --release
```
- ⚠️ 의존성 충돌 가능
- ⚠️ 새 기능 사용 불가

#### Solution D: Material 3 완전 비활성화 (60% 성공률)
```dart
// lib/core/themes/app_theme.dart
ThemeData(
  useMaterial3: false,  // Material 2로 폴백
  splashFactory: InkSplash.splashFactory,  // 기본 스플래시
)
```

---

### 2.2 🟡 High: dart:html 호환성 문제

**증상** (빌드 로그):
```
package:truck_tracker/features/owner_dashboard/presentation/analytics_screen.dart
dart:html unsupported (WASM 비호환)
```

**원인**: `analytics_screen.dart`에서 `dart:html` 직접 사용

**해결 방안**:
```dart
// 조건부 import 사용
import 'stub_html.dart'
    if (dart.library.html) 'dart:html' as html;

// 또는 universal_html 패키지 사용
import 'package:universal_html/html.dart' as html;
```

---

### 2.3 🟡 High: Cloud Functions 미배포

**현황**:
- 5개 함수 구현 완료 (index.js에 코드 존재)
- Firebase CLI 미설치로 배포 불가

**구현된 함수**:
1. `createCustomToken` - 소셜 로그인용
2. `notifyTruckOpening` - 트럭 영업 시작 알림
3. `notifyOrderStatus` - 주문 상태 변경 알림
4. `notifyCouponCreated` - 쿠폰 발행 알림
5. `notifyChatMessage` - 채팅 메시지 알림
6. `notifyNearbyTrucks` - 근처 트럭 알림

**해결 방안**:
```bash
npm install -g firebase-tools
firebase login
cd functions && npm install
firebase deploy --only functions
```

---

### 2.4 🟢 Medium: 테스트 의존성 비활성화

**현황** (pubspec.yaml):
```yaml
# 주석 처리됨
# fake_cloud_firestore: ^3.0.3
# firebase_auth_mocks: ^0.14.1
```

**영향**: 단위 테스트 작성 제한

---

### 2.5 🟢 Low: 기타 이슈

| 이슈 | 심각도 | 상태 |
|------|--------|------|
| Google Sign-In Client ID 미설정 | Low | web/index.html에 TODO 주석 |
| 웹 QR 스캐너 미지원 | Low | mobile_scanner는 네이티브 전용 |
| FCM 토큰 저장 미확인 | Medium | 앱에서 토큰 저장 로직 필요 |

---

## 3. 완료된 작업 (Phase 1-15)

### Phase 1-10 (IMPROVEMENT_PLAN)
- ✅ Critical Fixes (메모리 누수, 크래시 제거)
- ✅ Performance Optimization (N+1 쿼리, 마커 캐싱)
- ✅ Code Quality (AppLogger, 상수 추출)
- ✅ Localization (한글/영어 400+ 문자열)
- ✅ Testing Infrastructure (47개 테스트)
- ✅ Production Readiness
- ✅ Advanced Features (주간 일정, 차트, 리뷰 사진)
- ✅ Order System Enhancement
- ✅ Advanced Search & Filter

### Phase 11-15 (MEGA PHASE)
- ✅ Phase 11: Social Features (팔로우 시스템)
- ✅ Phase 12: Coupon System (쿠폰 백엔드)
- ✅ Phase 13: Real-time Chat (채팅 UI 포함)
- ⏳ Phase 14: Payment Integration (계획만)
- ✅ Phase 15: Advanced Notifications (알림 설정 UI 포함)

### 추가 완료 작업
- ✅ Cloud Functions 5개 구현
- ✅ Firestore Security Rules 192줄
- ✅ 문서화 15개 마크다운 파일

---

## 4. 신규 종합 플랜

### Phase 16: 웹 배포 해결 (우선순위 1)
**목표**: 웹 빌드 성공 및 Firebase Hosting 배포
**예상 시간**: 1-2시간

#### Step 1: web/index.html 수정
```html
<script>
  window.flutterConfiguration = {
    renderer: "canvaskit",
    canvasKitBaseUrl: "https://www.gstatic.com/flutter-canvaskit/1527ae0ec577a4ef50e65f6fefcfc1326707d9bf/"
  };
</script>
```

#### Step 2: 빌드 테스트
```bash
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
```

#### Step 3: 로컬 테스트
```bash
cd build/web
python -m http.server 8000
# http://localhost:8000 접속
```

#### Step 4: Firebase 배포
```bash
firebase deploy --only hosting
```

#### Fallback: Solution B/C/D 순차 시도

---

### Phase 17: Cloud Functions 배포
**목표**: 5개 알림 함수 Firebase에 배포
**예상 시간**: 30분

```bash
# 1. Firebase CLI 설치
npm install -g firebase-tools

# 2. 로그인
firebase login

# 3. Functions 배포
cd functions
npm install
firebase deploy --only functions

# 4. 확인
firebase functions:list
```

**검증**:
- Firebase Console에서 함수 목록 확인
- 테스트 트리거로 로그 확인

---

### Phase 18: dart:html 호환성 수정
**목표**: WASM 빌드 호환성 확보
**예상 시간**: 1시간

#### analytics_screen.dart 수정
```dart
// 기존
import 'dart:html';

// 변경
import 'package:universal_html/html.dart' as html;
// 또는 조건부 import
```

**필요 패키지** (pubspec.yaml):
```yaml
dependencies:
  universal_html: ^2.2.4
```

---

### Phase 19: FCM 토큰 관리 강화
**목표**: 모든 알림 함수가 정상 동작하도록 토큰 저장 보장
**예상 시간**: 2시간

#### 토큰 저장 로직 확인/추가
```dart
// lib/features/notifications/fcm_service.dart
Future<void> saveTokenToFirestore(String userId) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'fcmToken': token});
  }
}
```

#### 위치 정보 저장 (notifyNearbyTrucks용)
```dart
// lib/features/location/location_service.dart
Future<void> saveLocationToFirestore(String userId, Position position) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({
        'lastKnownLatitude': position.latitude,
        'lastKnownLongitude': position.longitude,
        'locationUpdatedAt': FieldValue.serverTimestamp(),
      });
}
```

---

### Phase 20: 테스트 커버리지 확대
**목표**: 60% 이상 달성
**예상 시간**: 3-5일

#### 테스트 의존성 활성화
```yaml
dev_dependencies:
  fake_cloud_firestore: ^3.0.3
  firebase_auth_mocks: ^0.14.1
```

#### 우선순위 테스트 대상
1. **ChatRepository** - 새로 구현된 핵심 기능
2. **NotificationPreferencesRepository** - 알림 설정
3. **CouponRepository** - 쿠폰 검증 로직
4. **FollowRepository** - 팔로우 시스템

---

### Phase 21: CI/CD 파이프라인 구축
**목표**: 자동 빌드/테스트/배포
**예상 시간**: 1일

#### GitHub Actions 설정
```yaml
# .github/workflows/deploy.yml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.5'
      - run: flutter pub get
      - run: flutter build web --release --web-renderer canvaskit
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: truck-tracker-fa0b0
```

---

### Phase 22: Phase 14 결제 연동 (장기)
**목표**: 카카오페이/토스 연동
**예상 시간**: 2-3주 (PG 계약 포함)

#### 사전 준비
1. PG사 사업자 등록 및 계약
2. API 키 발급
3. 결제 모듈 구현

#### 구현 범위
- 결제 요청/승인/취소
- 결제 내역 조회
- 환불 처리

---

## 5. 실행 순서 및 우선순위

### 🔴 즉시 실행 (오늘)

| 순서 | 작업 | 예상 시간 | 의존성 |
|------|------|----------|--------|
| 1 | web/index.html 수정 | 5분 | 없음 |
| 2 | 웹 빌드 테스트 | 10분 | #1 |
| 3 | 로컬 웹 테스트 | 10분 | #2 성공 시 |
| 4 | Firebase Hosting 배포 | 5분 | #3 성공 시 |

### 🟡 단기 (1주일 내)

| 순서 | 작업 | 예상 시간 | 의존성 |
|------|------|----------|--------|
| 5 | Firebase CLI 설치 | 10분 | 없음 |
| 6 | Cloud Functions 배포 | 20분 | #5 |
| 7 | dart:html 호환성 수정 | 1시간 | 없음 |
| 8 | FCM 토큰 관리 강화 | 2시간 | #6 |

### 🟢 중기 (2주 내)

| 순서 | 작업 | 예상 시간 | 의존성 |
|------|------|----------|--------|
| 9 | 테스트 의존성 활성화 | 30분 | 없음 |
| 10 | 핵심 테스트 작성 | 3일 | #9 |
| 11 | CI/CD 파이프라인 | 1일 | #2 성공 시 |

### ⚪ 장기 (1개월+)

| 순서 | 작업 | 예상 시간 | 의존성 |
|------|------|----------|--------|
| 12 | Phase 14 결제 연동 | 2-3주 | PG 계약 |
| 13 | 성능 모니터링 | 1일 | 배포 완료 후 |
| 14 | A/B 테스팅 | 1주 | 사용자 확보 후 |

---

## 6. 성공 기준

### 웹 배포 성공 기준
- [ ] `flutter build web` 에러 없이 완료
- [ ] https://truck-tracker-fa0b0.web.app 접속 가능
- [ ] Google Maps 정상 렌더링
- [ ] 로그인/로그아웃 정상 동작
- [ ] 실시간 Firestore 업데이트 동작

### Cloud Functions 성공 기준
- [ ] Firebase Console에서 5개 함수 확인
- [ ] 트럭 영업 시작 시 알림 전송
- [ ] 주문 상태 변경 시 알림 전송
- [ ] 채팅 메시지 시 알림 전송

### 전체 프로젝트 성공 기준
- [ ] 웹/Android/iOS 모든 플랫폼 배포
- [ ] Cloud Functions 5개 정상 동작
- [ ] 테스트 커버리지 60% 이상
- [ ] 24시간 크래시 0건

---

## 7. 리스크 및 대응 방안

| 리스크 | 확률 | 영향 | 대응 방안 |
|--------|------|------|----------|
| CanvasKit도 실패 | 20% | High | HTML 렌더러 또는 Flutter 다운그레이드 |
| PG 계약 지연 | 40% | Medium | 결제 기능 후순위로 조정 |
| Firebase 비용 급증 | 30% | Medium | 쿼리 최적화, 캐싱 강화 |
| 웹 성능 저하 | 50% | Low | 코드 스플리팅, 레이지 로딩 |

---

## 8. 참고 문서

| 문서 | 용도 |
|------|------|
| **CURRENT_STATUS.md** | 현재 상태 빠른 확인 |
| **WEB_DEPLOYMENT_PLAN.md** | 웹 배포 상세 가이드 |
| **CLOUD_FUNCTIONS_DEPLOYMENT.md** | Functions 배포 가이드 |
| **IMPROVEMENT_PLAN.md** | Phase 1-10 상세 내용 |
| **PHASE_11-15_ROADMAP.md** | 소셜/쿠폰/채팅/알림 설계 |
| **CLAUDE.md** | AI 개발 워크플로우 |

---

## 9. 결론

### 현재 상태
프로젝트는 **기능적으로 90% 완성**되었으나, **웹 배포 블로킹** 상태입니다.

### 핵심 액션
1. **즉시**: web/index.html에 `renderer: "canvaskit"` 추가하여 웹 빌드 해결
2. **단기**: Cloud Functions 배포로 알림 시스템 활성화
3. **중기**: 테스트 커버리지 및 CI/CD 구축

### 예상 완료 시점
- **웹 배포**: 오늘 ~ 내일
- **Functions 배포**: 1일
- **전체 프로덕션 준비**: 1-2주

---

**작성 완료**: 2025-12-28 23:15
**다음 세션 시작 시**: Phase 16 (웹 배포 해결)부터 실행

Sources:
- [Flutter ink_sparkle.frag Issue #111378](https://github.com/flutter/flutter/issues/111378)
- [ShaderCompilerException Issue #107590](https://github.com/flutter/flutter/issues/107590)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
