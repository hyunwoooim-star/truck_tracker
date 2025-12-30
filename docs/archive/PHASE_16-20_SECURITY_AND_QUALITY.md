# Phase 16-20: Security, Quality & Production Readiness

**Created**: 2025-12-29
**Based on**: PROJECT_AUDIT_REPORT.md (2025-12-29)
**Status**: 🚀 Ready to Execute
**Overall Priority**: P0-P1 (Critical for Production)

---

## 목차

1. [Phase 16: Security Hardening (보안 강화)](#phase-16-security-hardening-보안-강화-)
2. [Phase 17: Cloud Functions Deployment](#phase-17-cloud-functions-deployment-)
3. [Phase 18: Code Quality Improvements](#phase-18-code-quality-improvements-)
4. [Phase 19: Test Coverage Expansion](#phase-19-test-coverage-expansion-)
5. [Phase 20: Documentation & Final Audit](#phase-20-documentation--final-audit-)

---

## Phase 16: Security Hardening (보안 강화) 🔒

**Priority**: P0-P1 (Critical)
**Duration**: 1-2 days
**Status**: 📋 Planned

### 목표
프로덕션 배포 전 모든 보안 취약점 제거

### 작업 항목

#### 16.1 API 키 보호 및 로테이션 (P0)

**문제점** (PROJECT_AUDIT_REPORT.md § 4.1.1):
```env
# .env 파일에 평문 노출
KAKAO_NATIVE_APP_KEY=16a3e20d6e8bff9d586a64029614a40e
NAVER_CLIENT_ID=9szh6EOxjf8b40x9ZHKH
NAVER_CLIENT_SECRET=T54J_dHgUF
```

**조치 사항**:

1. **즉시 키 로테이션**:
   - Kakao Developers Console → 새 Native App Key 발급
   - Naver Developers → Client ID/Secret 재발급
   - `.env` 파일 업데이트

2. **Firebase Remote Config로 마이그레이션**:
   ```dart
   // lib/core/config/remote_config_service.dart (신규)
   class RemoteConfigService {
     final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

     Future<void> initialize() async {
       await _remoteConfig.setConfigSettings(RemoteConfigSettings(
         fetchTimeout: const Duration(minutes: 1),
         minimumFetchInterval: const Duration(hours: 1),
       ));
       await _remoteConfig.fetchAndActivate();
     }

     String get kakaoAppKey => _remoteConfig.getString('kakao_app_key');
     String get naverClientId => _remoteConfig.getString('naver_client_id');
     String get naverClientSecret => _remoteConfig.getString('naver_client_secret');
   }
   ```

3. **Firebase Console 설정**:
   - Remote Config → Parameters 추가:
     - `kakao_app_key`: [NEW_KEY]
     - `naver_client_id`: [NEW_CLIENT_ID]
     - `naver_client_secret`: [NEW_SECRET]

4. **`.env` 파일 삭제**:
   ```bash
   git rm --cached .env
   echo ".env" >> .gitignore
   ```

**검증**:
- [ ] `.env` 파일이 Git에서 제거됨
- [ ] Remote Config에서 키 값 정상 조회
- [ ] Kakao/Naver 로그인 정상 작동 (구현 후 테스트)

---

#### 16.2 Google Maps API 키 제한 설정 (P0)

**문제점** (PROJECT_AUDIT_REPORT.md § 4.1.3):
```html
<!-- web/index.html:61 - 무제한 노출 -->
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyArKTrCQyRO-srk9hvdMevMRhOXuSF55G0"></script>
```

**조치 사항**:

1. **Google Cloud Console 설정**:
   - Navigation Menu → APIs & Services → Credentials
   - Maps API Key 클릭
   - Application restrictions:
     - HTTP referrers 선택
     - `truck-tracker-fa0b0.web.app/*` 추가
     - `truck-tracker-fa0b0.firebaseapp.com/*` 추가
     - `localhost:*/*` 추가 (개발용)
   - API restrictions:
     - "Maps JavaScript API" 선택
     - "Geocoding API" 선택 (사용 시)
     - "Places API" 선택 (사용 시)

2. **사용량 알림 설정**:
   - Quotas & Limits → Set quota
   - Daily limit: 10,000 requests (무료 한도 내)
   - Alert threshold: 80% (8,000 requests)
   - Notification email 설정

**검증**:
- [ ] 프로덕션 도메인에서 지도 정상 로딩
- [ ] localhost에서 개발 가능
- [ ] 무단 도메인에서 403 에러 발생

---

#### 16.3 테스트 버튼 제거 (P0)

**문제점** (PROJECT_AUDIT_REPORT.md § 4.2.3):
```dart
// lib/features/auth/presentation/login_screen.dart:623-674
// 인증 없이 사장님 대시보드 접근 가능
ElevatedButton(
  onPressed: () async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
    );
  },
  child: const Text('사장님 모드로 시작 (테스트)'),
)
```

**조치 사항**:

1. **조건부 렌더링 적용**:
   ```dart
   // lib/features/auth/presentation/login_screen.dart
   import 'package:flutter/foundation.dart'; // kDebugMode

   // 라인 623-674 수정
   if (kDebugMode) {
     // Owner Login Button (개발 전용)
     ElevatedButton(
       onPressed: _isLoading
           ? null
           : () async {
               AppLogger.debug('Debug: Bypassing auth for owner dashboard', tag: 'LoginScreen');
               Navigator.of(context).pushReplacement(
                 MaterialPageRoute(
                   builder: (_) => const OwnerDashboardScreen(),
                 ),
               );
             },
       child: const Text('[DEBUG ONLY] 사장님 모드 바로가기'),
     ),
   }
   ```

2. **추가 보안 검증**:
   ```dart
   // lib/features/owner_dashboard/presentation/owner_dashboard_screen.dart
   @override
   void initState() {
     super.initState();

     // 프로덕션에서 인증 검증
     if (kReleaseMode) {
       final user = ref.read(authStateProvider).value;
       if (user == null || user.role != UserRole.owner) {
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (_) => const LoginScreen()),
         );
       }
     }
   }
   ```

**검증**:
- [ ] 프로덕션 빌드에서 테스트 버튼 미표시
- [ ] 디버그 모드에서만 버튼 표시
- [ ] 사장님 대시보드 직접 접근 시 로그인 페이지로 리다이렉트

---

#### 16.4 비밀번호 검증 강화 (P1)

**문제점** (PROJECT_AUDIT_REPORT.md § 4.2.1):
```dart
// lib/features/auth/presentation/login_screen.dart:328-340
validator: (value) {
  if (value.length < 6) {
    return '비밀번호는 최소 6자 이상이어야 합니다';
  }
  // TODO: 강력한 검증 필요
  return null;
}
```

**조치 사항**:

1. **비밀번호 검증 유틸리티 생성**:
   ```dart
   // lib/core/utils/password_validator.dart (신규)
   class PasswordValidator {
     static const int minLength = 8;

     static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
     static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
     static final RegExp _digitRegex = RegExp(r'\d');
     static final RegExp _specialCharRegex = RegExp(r'[@$!%*?&]');

     /// 비밀번호 강도 검증
     /// 반환: null (유효) 또는 에러 메시지
     static String? validate(String password, {bool isSignUp = false}) {
       if (password.isEmpty) {
         return '비밀번호를 입력해주세요';
       }

       // 로그인 시에는 길이만 검증 (기존 사용자 호환성)
       if (!isSignUp) {
         if (password.length < 6) {
           return '비밀번호는 최소 6자 이상이어야 합니다';
         }
         return null;
       }

       // 회원가입 시 강력한 검증
       if (password.length < minLength) {
         return '비밀번호는 최소 $minLength자 이상이어야 합니다';
       }

       if (!_uppercaseRegex.hasMatch(password)) {
         return '비밀번호에 대문자가 포함되어야 합니다';
       }

       if (!_lowercaseRegex.hasMatch(password)) {
         return '비밀번호에 소문자가 포함되어야 합니다';
       }

       if (!_digitRegex.hasMatch(password)) {
         return '비밀번호에 숫자가 포함되어야 합니다';
       }

       if (!_specialCharRegex.hasMatch(password)) {
         return '비밀번호에 특수문자 (@\$!%*?&)가 포함되어야 합니다';
       }

       return null;
     }

     /// 비밀번호 강도 평가 (0-4)
     static int getStrength(String password) {
       int strength = 0;

       if (password.length >= minLength) strength++;
       if (_uppercaseRegex.hasMatch(password)) strength++;
       if (_lowercaseRegex.hasMatch(password)) strength++;
       if (_digitRegex.hasMatch(password)) strength++;
       if (_specialCharRegex.hasMatch(password)) strength++;

       return strength;
     }
   }
   ```

2. **LoginScreen에 적용**:
   ```dart
   // lib/features/auth/presentation/login_screen.dart:328-340
   TextFormField(
     // ...
     validator: (value) => PasswordValidator.validate(
       value ?? '',
       isSignUp: _isSignUpMode, // 상태 변수로 로그인/회원가입 구분
     ),
   )
   ```

3. **실시간 강도 표시 (선택적)**:
   ```dart
   // 비밀번호 입력 필드 아래
   if (_isSignUpMode && _passwordController.text.isNotEmpty)
     Padding(
       padding: const EdgeInsets.only(top: 8),
       child: LinearProgressIndicator(
         value: PasswordValidator.getStrength(_passwordController.text) / 5,
         color: _getStrengthColor(),
       ),
     ),
   ```

**검증**:
- [ ] 로그인 시 6자 이상만 검증 (기존 사용자 호환)
- [ ] 회원가입 시 8자 + 대소문자 + 숫자 + 특수문자 요구
- [ ] 에러 메시지가 명확하게 표시됨

---

#### 16.5 Firebase App Check 활성화 (P1)

**목적**: Firebase 리소스에 대한 무단 접근 방지

**조치 사항**:

1. **Firebase Console 설정**:
   - Project Settings → App Check
   - Web App 선택
   - reCAPTCHA Enterprise 또는 reCAPTCHA v3 선택
   - Site key 발급

2. **Flutter 앱에 통합**:
   ```yaml
   # pubspec.yaml
   dependencies:
     firebase_app_check: ^0.2.2+10
   ```

   ```dart
   // lib/main.dart
   import 'package:firebase_app_check/firebase_app_check.dart';

   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

     // App Check 활성화
     await FirebaseAppCheck.instance.activate(
       webProvider: ReCaptchaV3Provider('[SITE_KEY]'),
       androidProvider: AndroidProvider.playIntegrity,
     );

     runApp(const MyApp());
   }
   ```

3. **Firestore/Storage 규칙 강화**:
   ```
   // firestore.rules
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // App Check 검증 헬퍼
       function isAppCheckValid() {
         return request.auth.token.firebase.sign_in_provider != null ||
                request.app != null;
       }

       match /trucks/{truckId} {
         allow read: if true; // Public read
         allow write: if isAuthenticated() && isTruckOwner(truckId) && isAppCheckValid();
       }
     }
   }
   ```

**검증**:
- [ ] App Check 토큰이 요청에 포함됨 (Firebase Console → App Check → Metrics)
- [ ] 무단 스크립트 요청 차단 확인

---

#### 16.6 CORS 화이트리스트 적용 (P1)

**문제점** (PROJECT_AUDIT_REPORT.md § 4.2.2):
```javascript
// functions/index.js:6-12
res.set('Access-Control-Allow-Origin', '*'); // 모든 origin 허용
```

**조치 사항**:

```javascript
// functions/index.js
const allowedOrigins = [
  'https://truck-tracker-fa0b0.web.app',
  'https://truck-tracker-fa0b0.firebaseapp.com',
  'http://localhost:3000', // 개발용
  'http://localhost:5000', // Firebase Hosting Emulator
];

function setCorsHeaders(req, res) {
  const origin = req.headers.origin;

  if (allowedOrigins.includes(origin)) {
    res.set('Access-Control-Allow-Origin', origin);
  } else {
    res.set('Access-Control-Allow-Origin', 'null'); // 거부
  }

  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.set('Access-Control-Max-Age', '3600');
}

exports.sendOrderNotification = functions.https.onRequest((req, res) => {
  setCorsHeaders(req, res);

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  // 기존 로직...
});
```

**검증**:
- [ ] 프로덕션 도메인에서 Cloud Function 호출 성공
- [ ] 무단 도메인에서 CORS 에러 발생

---

### Phase 16 완료 기준

- [ ] 모든 API 키가 로테이션되고 안전하게 보호됨
- [ ] Google Maps API에 적절한 제한 설정 적용
- [ ] 테스트 버튼이 프로덕션에서 제거됨
- [ ] 비밀번호 검증이 강화됨
- [ ] Firebase App Check 활성화됨
- [ ] CORS 화이트리스트 적용됨
- [ ] 보안 테스트 통과 (무단 접근 시도 차단 확인)

---

## Phase 17: Cloud Functions Deployment 🚀

**Priority**: P1 (High Impact)
**Duration**: 1 day
**Status**: 📋 Planned

### 목표
5개 Cloud Functions 배포 및 FCM 통합 완료

### 작업 항목

#### 17.1 Cloud Functions 배포 준비

**현재 상태** (PROJECT_AUDIT_REPORT.md § 5.2.2):
- 5개 함수 구현 완료, 배포 대기 중
- `functions/index.js` 존재

**배포 전 체크리스트**:

1. **Dependencies 확인**:
   ```bash
   cd "Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/functions"
   npm install
   npm audit fix  # 보안 취약점 수정
   ```

2. **환경 변수 설정**:
   ```bash
   # Firebase Functions 환경 변수 설정 (필요 시)
   firebase functions:config:set someservice.key="THE API KEY"
   ```

3. **Functions 코드 검토**:
   - CORS 설정 적용 (Phase 16.6)
   - 에러 핸들링 검증
   - 로깅 추가

---

#### 17.2 Cloud Functions 배포

**배포 명령어**:
```bash
cd "Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker"
firebase deploy --only functions
```

**배포 후 확인**:
1. Firebase Console → Functions → Dashboard
2. 각 함수의 URL 확인:
   - `sendOrderNotification`
   - `sendReviewNotification`
   - `sendChatNotification`
   - `updateTruckStats`
   - `scheduledCleanup`

3. **Function URLs 기록**:
   ```markdown
   ## Cloud Function URLs (Production)
   - Order Notification: https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendOrderNotification
   - Review Notification: https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendReviewNotification
   - Chat Notification: https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/sendChatNotification
   - Stats Update: https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/updateTruckStats
   - Scheduled Cleanup: (Cron-triggered)
   ```

---

#### 17.3 FCM 통합 업데이트

**현재 TODO** (PROJECT_AUDIT_REPORT.md § 3.2):
```dart
// lib/features/notifications/fcm_service.dart:142
// TODO: Cloud Function 호출 구현 필요
```

**조치 사항**:

1. **HTTP 클라이언트 추가**:
   ```yaml
   # pubspec.yaml
   dependencies:
     http: ^1.2.0
   ```

2. **FcmService 업데이트**:
   ```dart
   // lib/features/notifications/fcm_service.dart
   import 'package:http/http.dart' as http;
   import 'dart:convert';

   class FcmService {
     static const String _functionsBaseUrl =
       'https://us-central1-truck-tracker-fa0b0.cloudfunctions.net';

     /// Cloud Function을 통해 주문 알림 전송
     Future<void> sendOrderNotification({
       required String truckId,
       required String orderId,
       required String userName,
     }) async {
       try {
         final url = Uri.parse('$_functionsBaseUrl/sendOrderNotification');
         final response = await http.post(
           url,
           headers: {'Content-Type': 'application/json'},
           body: jsonEncode({
             'truckId': truckId,
             'orderId': orderId,
             'userName': userName,
           }),
         );

         if (response.statusCode == 200) {
           AppLogger.info('Order notification sent successfully', tag: 'FcmService');
         } else {
           AppLogger.error(
             'Failed to send order notification: ${response.statusCode}',
             tag: 'FcmService',
           );
         }
       } catch (e, stackTrace) {
         AppLogger.error(
           'Error sending order notification',
           error: e,
           stackTrace: stackTrace,
           tag: 'FcmService',
         );
       }
     }

     // 리뷰, 채팅 알림도 동일 패턴으로 구현...
   }
   ```

3. **Order Repository 통합**:
   ```dart
   // lib/features/order/data/order_repository.dart
   Future<void> createOrder(Order order) async {
     try {
       await _firestore.collection('orders').doc(order.id).set(order.toFirestore());
       AppLogger.info('Order created: ${order.id}', tag: 'OrderRepository');

       // FCM 알림 전송
       final fcmService = ref.read(fcmServiceProvider);
       await fcmService.sendOrderNotification(
         truckId: order.truckId,
         orderId: order.id,
         userName: order.userName,
       );
     } catch (e) {
       // 에러 핸들링...
     }
   }
   ```

---

#### 17.4 Cloud Functions 모니터링 설정

1. **로그 확인**:
   ```bash
   firebase functions:log --only sendOrderNotification
   ```

2. **알림 설정**:
   - Firebase Console → Functions → Usage
   - Error rate > 5% 시 이메일 알림
   - Execution time > 5s 시 경고

3. **비용 모니터링**:
   - Google Cloud Console → Billing
   - Cloud Functions 일일 호출 수 확인
   - 예상 비용: ~$0 (무료 할당량 내)

---

### Phase 17 완료 기준

- [ ] 5개 Cloud Functions 배포 완료
- [ ] Function URLs 기록 및 문서화
- [ ] FCM 통합 코드 업데이트 완료
- [ ] 실제 주문/리뷰/채팅 시 알림 전송 테스트 성공
- [ ] 로그 및 모니터링 설정 완료
- [ ] 에러율 < 1%

---

## Phase 18: Code Quality Improvements 🧹

**Priority**: P1-P2
**Duration**: 2-3 days
**Status**: 📋 Planned

### 목표
코드 품질을 향상시켜 유지보수성 및 성능 개선

### 작업 항목

#### 18.1 withOpacity() 상수화 (P1)

**문제점** (PROJECT_AUDIT_REPORT.md § 6.2.1):
11개 위치에서 런타임에 `withOpacity()` 호출 → 매 빌드마다 Color 객체 생성

**위치**:
1. `chat_screen.dart:239`
2. `talk_widget.dart:269, 292`
3. `analytics_screen.dart:172, 182, 250, 556, 565`
4. `owner_dashboard_screen.dart:533, 1066`
5. `truck_list_screen.dart:396`

**조치 사항**:

1. **AppTheme에 상수 추가**:
   ```dart
   // lib/core/themes/app_theme.dart
   class AppTheme {
     // 기존 색상
     static const Color electricBlue = Color(0xFF00D4FF);
     static const Color darkNavy = Color(0xFF0A0E27);

     // 투명도 변형 (빌드 시 한 번만 계산)
     static const Color electricBlue10 = Color(0x1A00D4FF); // 10% opacity
     static const Color electricBlue20 = Color(0x3300D4FF); // 20%
     static const Color electricBlue30 = Color(0x4D00D4FF); // 30%
     static const Color electricBlue50 = Color(0x8000D4FF); // 50%

     static const Color darkNavy10 = Color(0x1A0A0E27);
     static const Color darkNavy20 = Color(0x330A0E27);

     // 유틸리티: Hex to ARGB 계산
     // opacity: 0.1 = 0x1A, 0.2 = 0x33, 0.3 = 0x4D, 0.5 = 0x80, 0.7 = 0xB3, 0.9 = 0xE6
   }
   ```

2. **각 파일 수정**:
   ```dart
   // Before (chat_screen.dart:239)
   color: AppTheme.electricBlue.withOpacity(0.3)

   // After
   color: AppTheme.electricBlue30
   ```

   ```bash
   # 일괄 수정 스크립트 (Bash)
   find lib -name "*.dart" -exec sed -i 's/AppTheme\.electricBlue\.withOpacity(0\.3)/AppTheme.electricBlue30/g' {} +
   ```

**검증**:
- [ ] 11개 위치 모두 수정 확인
- [ ] Flutter Analyzer 경고 제거 확인
- [ ] 앱 실행 시 시각적 변화 없음 (색상 동일)

---

#### 18.2 SnackBar 헬퍼 추출 (P2)

**문제점** (PROJECT_AUDIT_REPORT.md § 6.1):
여러 파일에서 동일한 SnackBar 코드 반복

**조치 사항**:

1. **헬퍼 클래스 생성**:
   ```dart
   // lib/core/utils/snackbar_helper.dart (신규)
   import 'package:flutter/material.dart';

   class SnackBarHelper {
     /// 성공 메시지 표시 (녹색)
     static void showSuccess(BuildContext context, String message) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(message),
           backgroundColor: Colors.green,
           duration: const Duration(seconds: 2),
         ),
       );
     }

     /// 에러 메시지 표시 (빨간색)
     static void showError(BuildContext context, String message) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(message),
           backgroundColor: Colors.red,
           duration: const Duration(seconds: 3),
         ),
       );
     }

     /// 정보 메시지 표시 (파란색)
     static void showInfo(BuildContext context, String message) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(message),
           backgroundColor: Colors.blue,
           duration: const Duration(seconds: 2),
         ),
       );
     }

     /// 경고 메시지 표시 (주황색)
     static void showWarning(BuildContext context, String message) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(message),
           backgroundColor: Colors.orange,
           duration: const Duration(seconds: 2),
         ),
       );
     }
   }
   ```

2. **기존 코드 리팩토링**:
   ```dart
   // Before
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('주문이 생성되었습니다'),
       backgroundColor: Colors.green,
     ),
   );

   // After
   SnackBarHelper.showSuccess(context, '주문이 생성되었습니다');
   ```

3. **일괄 적용**:
   - Grep으로 `ScaffoldMessenger.of(context).showSnackBar` 검색
   - 각 위치 수동 리팩토링 (자동화 어려움)

**검증**:
- [ ] 주요 화면에서 SnackBar 헬퍼 사용 확인
- [ ] 기능 동작 변화 없음

---

#### 18.3 AppException 활용 확대 (P2)

**문제점** (PROJECT_AUDIT_REPORT.md § 5.3):
`AppException` 클래스가 정의되어 있으나 거의 사용되지 않음

**조치 사항**:

1. **AppException 확장**:
   ```dart
   // lib/core/errors/app_exception.dart (기존 파일 수정)
   class AppException implements Exception {
     final String message;
     final String? code;
     final dynamic originalError;
     final StackTrace? stackTrace;

     AppException({
       required this.message,
       this.code,
       this.originalError,
       this.stackTrace,
     });

     @override
     String toString() => 'AppException: $message (code: $code)';

     /// 사용자 친화적 메시지
     String get userMessage {
       switch (code) {
         case 'permission-denied':
           return '접근 권한이 없습니다';
         case 'not-found':
           return '요청한 데이터를 찾을 수 없습니다';
         case 'already-exists':
           return '이미 존재하는 데이터입니다';
         case 'network-error':
           return '네트워크 연결을 확인해주세요';
         default:
           return message;
       }
     }

     // Factory constructors
     factory AppException.permissionDenied([String? detail]) => AppException(
       message: detail ?? 'Permission denied',
       code: 'permission-denied',
     );

     factory AppException.notFound([String? detail]) => AppException(
       message: detail ?? 'Resource not found',
       code: 'not-found',
     );

     factory AppException.networkError([dynamic error]) => AppException(
       message: 'Network error occurred',
       code: 'network-error',
       originalError: error,
     );
   }
   ```

2. **Repository에서 활용**:
   ```dart
   // lib/features/truck_list/data/truck_repository.dart
   Future<Truck> getTruckById(String truckId) async {
     try {
       final doc = await _firestore.collection('trucks').doc(truckId).get();

       if (!doc.exists) {
         throw AppException.notFound('Truck $truckId not found');
       }

       return Truck.fromFirestore(doc);
     } on FirebaseException catch (e) {
       if (e.code == 'permission-denied') {
         throw AppException.permissionDenied();
       }
       throw AppException(message: 'Failed to fetch truck', originalError: e);
     } catch (e, stackTrace) {
       AppLogger.error('Unexpected error', error: e, stackTrace: stackTrace);
       throw AppException(
         message: 'Unexpected error occurred',
         originalError: e,
         stackTrace: stackTrace,
       );
     }
   }
   ```

3. **UI에서 처리**:
   ```dart
   // lib/features/truck_detail/presentation/truck_detail_screen.dart
   ref.listen(truckDetailProvider(truckId), (previous, next) {
     next.whenOrNull(
       error: (error, stackTrace) {
         if (error is AppException) {
           SnackBarHelper.showError(context, error.userMessage);
         } else {
           SnackBarHelper.showError(context, '오류가 발생했습니다');
         }
       },
     );
   });
   ```

**검증**:
- [ ] 주요 Repository에서 AppException 사용
- [ ] 에러 발생 시 사용자 친화적 메시지 표시
- [ ] AppLogger에 에러 기록 확인

---

#### 18.4 Firestore 쿼리 Limit 적용 (P1)

**문제점** (PROJECT_AUDIT_REPORT.md § 6.2.2):
```dart
// BUG-001: order_repository.dart - limit 미적용
watchUserOrders() / watchTruckOrders()
```

**조치 사항**:

```dart
// lib/features/order/data/order_repository.dart
Stream<List<Order>> watchUserOrders(String userId) {
  return _firestore
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .limit(100) // 추가: 최근 100개만 조회
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
}

Stream<List<Order>> watchTruckOrders(String truckId) {
  return _firestore
      .collection('orders')
      .where('truckId', isEqualTo: truckId)
      .orderBy('createdAt', descending: true)
      .limit(50) // 추가: 최근 50개만 조회
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
}
```

**검증**:
- [ ] Firestore Console에서 쿼리 실행 확인 (limit 적용됨)
- [ ] 앱에서 주문 목록 정상 표시
- [ ] 성능 개선 확인 (대량 주문 시)

---

#### 18.5 Unused Warnings 제거 (P2)

**문제점** (PROJECT_AUDIT_REPORT.md § 5.2.1):
```dart
// BUG-002: review_repository.dart:141 - stackTrace 미사용
} catch (e, stackTrace) {
  AppLogger.error('Error adding review', error: e, tag: 'ReviewRepository');
  rethrow;
}
```

**조치 사항**:

```dart
// lib/features/review/data/review_repository.dart:141
} catch (e, stackTrace) {
  AppLogger.error(
    'Error adding review',
    error: e,
    stackTrace: stackTrace, // 추가
    tag: 'ReviewRepository',
  );
  rethrow;
}
```

**검증**:
- [ ] `flutter analyze` 실행 → Warning 0개
- [ ] 모든 catch 블록에서 stackTrace 사용 확인

---

### Phase 18 완료 기준

- [ ] withOpacity() 11개 위치 모두 상수화
- [ ] SnackBarHelper 추출 및 적용 (5개 이상 화면)
- [ ] AppException 활용 확대 (3개 이상 Repository)
- [ ] Firestore 쿼리 limit 적용
- [ ] Flutter Analyzer 경고 0개
- [ ] 코드 품질 점수 B → A-

---

## Phase 19: Test Coverage Expansion 🧪

**Priority**: P1-P2
**Duration**: 3-4 days
**Status**: 📋 Planned

### 목표
테스트 커버리지 30% → 60% 향상

### 작업 항목

#### 19.1 테스트 인프라 복원 (P1)

**문제점** (PROJECT_AUDIT_REPORT.md § 2.3):
```yaml
# pubspec.yaml - fake_cloud_firestore 주석 처리됨
dev_dependencies:
  # fake_cloud_firestore: ^2.5.2 # 주석 해제 필요
```

**조치 사항**:

1. **pubspec.yaml 수정**:
   ```yaml
   # pubspec.yaml
   dev_dependencies:
     flutter_test:
       sdk: flutter
     fake_cloud_firestore: ^2.5.2
     mockito: ^5.4.4
     build_runner: ^2.4.9
   ```

2. **Dependencies 설치**:
   ```bash
   flutter pub get
   ```

3. **테스트 실행 확인**:
   ```bash
   flutter test
   ```

**검증**:
- [ ] 기존 47개 테스트 모두 통과
- [ ] fake_cloud_firestore 정상 작동

---

#### 19.2 Auth 테스트 작성 (P1)

**목표**: 인증 흐름의 핵심 로직 테스트

**파일**: `test/unit/features/auth/auth_service_test.dart` (신규)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:truck_tracker/features/auth/data/auth_service.dart';

// Mock 클래스
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authService = AuthService(auth: mockAuth);
  });

  group('AuthService', () {
    test('로그인 성공 시 User 객체 반환', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockUser.uid).thenReturn('test-uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      final user = await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(user, isNotNull);
      expect(user!.uid, 'test-uid');
      verify(mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('로그인 실패 시 예외 발생', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act & Assert
      expect(
        () => authService.signIn(
          email: 'test@example.com',
          password: 'wrong-password',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('회원가입 성공 시 User 객체 반환', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockUser.uid).thenReturn('new-uid');
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      final user = await authService.signUp(
        email: 'new@example.com',
        password: 'StrongPass123!',
      );

      // Assert
      expect(user, isNotNull);
      expect(user!.uid, 'new-uid');
    });

    test('로그아웃 성공', () async {
      // Arrange
      when(mockAuth.signOut()).thenAnswer((_) async => {});

      // Act
      await authService.signOut();

      // Assert
      verify(mockAuth.signOut()).called(1);
    });
  });

  group('PasswordValidator', () {
    test('빈 비밀번호는 에러 반환', () {
      final result = PasswordValidator.validate('');
      expect(result, isNotNull);
      expect(result, contains('입력해주세요'));
    });

    test('6자 미만 비밀번호는 로그인 시 에러 반환', () {
      final result = PasswordValidator.validate('12345', isSignUp: false);
      expect(result, isNotNull);
      expect(result, contains('최소 6자'));
    });

    test('회원가입 시 대문자 없으면 에러', () {
      final result = PasswordValidator.validate('abcd1234!', isSignUp: true);
      expect(result, contains('대문자'));
    });

    test('회원가입 시 숫자 없으면 에러', () {
      final result = PasswordValidator.validate('Abcdefgh!', isSignUp: true);
      expect(result, contains('숫자'));
    });

    test('회원가입 시 특수문자 없으면 에러', () {
      final result = PasswordValidator.validate('Abcd1234', isSignUp: true);
      expect(result, contains('특수문자'));
    });

    test('강력한 비밀번호는 null 반환', () {
      final result = PasswordValidator.validate('StrongPass123!', isSignUp: true);
      expect(result, isNull);
    });

    test('비밀번호 강도 평가 - 약함', () {
      final strength = PasswordValidator.getStrength('abc');
      expect(strength, lessThan(3));
    });

    test('비밀번호 강도 평가 - 강함', () {
      final strength = PasswordValidator.getStrength('StrongPass123!');
      expect(strength, equals(5));
    });
  });
}
```

**검증**:
- [ ] 10개 이상 테스트 케이스 작성
- [ ] 모든 테스트 통과
- [ ] Coverage: AuthService > 80%

---

#### 19.3 Order 테스트 작성 (P1)

**목표**: 주문 생성 및 상태 변경 로직 테스트

**파일**: `test/unit/features/order/order_repository_test.dart` (신규)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:truck_tracker/features/order/data/order_repository.dart';
import 'package:truck_tracker/features/order/domain/order.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late OrderRepository orderRepository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    orderRepository = OrderRepository(firestore: fakeFirestore);
  });

  group('OrderRepository', () {
    test('주문 생성 성공', () async {
      // Arrange
      final order = Order(
        id: 'order-1',
        userId: 'user-1',
        truckId: 'truck-1',
        items: ['김밥', '라면'],
        totalPrice: 10000,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      // Act
      await orderRepository.createOrder(order);

      // Assert
      final doc = await fakeFirestore.collection('orders').doc('order-1').get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['userId'], 'user-1');
      expect(doc.data()!['totalPrice'], 10000);
    });

    test('주문 상태 변경 - pending → confirmed', () async {
      // Arrange
      await fakeFirestore.collection('orders').doc('order-1').set({
        'id': 'order-1',
        'userId': 'user-1',
        'truckId': 'truck-1',
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Act
      await orderRepository.updateOrderStatus('order-1', OrderStatus.confirmed);

      // Assert
      final doc = await fakeFirestore.collection('orders').doc('order-1').get();
      expect(doc.data()!['status'], 'confirmed');
    });

    test('존재하지 않는 주문 조회 시 null 반환', () async {
      // Act
      final order = await orderRepository.getOrderById('non-existent');

      // Assert
      expect(order, isNull);
    });

    test('사용자의 주문 목록 조회', () async {
      // Arrange
      await fakeFirestore.collection('orders').doc('order-1').set({
        'id': 'order-1',
        'userId': 'user-1',
        'status': 'pending',
      });
      await fakeFirestore.collection('orders').doc('order-2').set({
        'id': 'order-2',
        'userId': 'user-1',
        'status': 'completed',
      });
      await fakeFirestore.collection('orders').doc('order-3').set({
        'id': 'order-3',
        'userId': 'user-2',
        'status': 'pending',
      });

      // Act
      final orders = await orderRepository.getUserOrders('user-1').first;

      // Assert
      expect(orders.length, 2);
      expect(orders.every((o) => o.userId == 'user-1'), isTrue);
    });
  });
}
```

**검증**:
- [ ] 8개 이상 테스트 케이스 작성
- [ ] 모든 테스트 통과
- [ ] Coverage: OrderRepository > 70%

---

#### 19.4 Chat 테스트 작성 (P2)

**파일**: `test/unit/features/chat/chat_repository_test.dart` (신규)

테스트 항목:
- 메시지 전송
- 메시지 조회 (시간 순 정렬)
- 읽음 상태 업데이트
- 채팅방 생성

**검증**:
- [ ] 6개 이상 테스트 케이스
- [ ] Coverage > 60%

---

#### 19.5 Integration 테스트 작성 (P2)

**목표**: 주요 사용자 플로우 End-to-End 테스트

**파일**: `test/integration/user_flow_test.dart` (신규)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:truck_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('사용자 플로우 통합 테스트', () {
    testWidgets('로그인 → 트럭 목록 → 상세 → 리뷰 작성', (tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle();

      // 로그인
      await tester.enterText(find.byKey(const Key('email-field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password-field')), 'password123');
      await tester.tap(find.byKey(const Key('login-button')));
      await tester.pumpAndSettle();

      // 트럭 목록 확인
      expect(find.text('트럭 목록'), findsOneWidget);

      // 첫 번째 트럭 탭
      await tester.tap(find.byType(TruckCard).first);
      await tester.pumpAndSettle();

      // 리뷰 작성 버튼 탭
      await tester.tap(find.byKey(const Key('write-review-button')));
      await tester.pumpAndSettle();

      // 리뷰 입력
      await tester.enterText(find.byKey(const Key('review-text-field')), '맛있어요!');
      await tester.tap(find.byKey(const Key('rating-5-star')));
      await tester.tap(find.byKey(const Key('submit-review-button')));
      await tester.pumpAndSettle();

      // 성공 메시지 확인
      expect(find.text('리뷰가 등록되었습니다'), findsOneWidget);
    });
  });
}
```

**검증**:
- [ ] 3개 이상 통합 테스트 작성
- [ ] CI/CD에서 자동 실행 설정

---

### Phase 19 완료 기준

- [ ] 테스트 파일 5개 이상 추가
- [ ] 총 테스트 케이스 100개 이상
- [ ] 테스트 커버리지 60% 이상
- [ ] 모든 테스트 통과
- [ ] CI/CD 파이프라인에 테스트 통합

---

## Phase 20: Documentation & Final Audit 📝

**Priority**: P2-P3
**Duration**: 2 days
**Status**: 📋 Planned

### 목표
프로덕션 배포 전 최종 점검 및 문서화 완성

### 작업 항목

#### 20.1 API 문서 자동 생성

**도구**: dartdoc

**조치 사항**:

1. **Dartdoc 생성**:
   ```bash
   dart doc .
   ```

2. **문서 호스팅** (GitHub Pages):
   ```bash
   # docs/ 폴더를 GitHub Pages로 배포
   git add doc/api/
   git commit -m "docs: Add API documentation"
   git push

   # GitHub Settings → Pages → Source: main branch /doc folder
   ```

3. **README에 링크 추가**:
   ```markdown
   ## API Documentation
   - [Dart API Docs](https://your-username.github.io/truck-tracker/api/)
   ```

**검증**:
- [ ] API 문서 생성 확인
- [ ] 주요 클래스 문서화 완료 (80% 이상)

---

#### 20.2 사용자 가이드 작성

**파일**: `USER_GUIDE.md` (신규)

**내용**:
- 고객용 앱 사용법
- 사장님 대시보드 사용법
- FAQ
- 문제 해결 가이드

**예시**:
```markdown
# Truck Tracker 사용자 가이드

## 고객용 (Customer)

### 1. 회원가입 및 로그인
1. 앱 실행
2. "회원가입" 버튼 클릭
3. 이메일, 비밀번호 입력 (비밀번호: 최소 8자, 대소문자+숫자+특수문자)
4. "가입하기" 버튼 클릭

### 2. 트럭 찾기
- **지도 보기**: 하단 "지도" 탭 → 주변 트럭 마커 확인
- **목록 보기**: "목록" 탭 → 필터/정렬 기능 사용
- **검색**: 상단 검색창에 트럭명 또는 음식 종류 입력

### 3. 리뷰 작성
1. 트럭 상세 페이지 → "리뷰 작성" 버튼
2. 별점 선택 (1-5점)
3. 리뷰 내용 입력
4. 사진 첨부 (선택)
5. "등록" 버튼

## 사장님용 (Owner)

### 1. 대시보드 접근
- 로그인 후 자동으로 사장님 대시보드로 이동

### 2. 트럭 위치 업데이트
1. 대시보드 → "위치 업데이트" 버튼
2. 지도에서 현재 위치 선택
3. "영업 시작" / "영업 종료" 토글

### 3. 주문 관리
- Kanban 보드에서 주문 상태 드래그앤드롭으로 변경
- "접수" → "준비 중" → "완료"

## FAQ

**Q: 비밀번호를 잊어버렸어요**
A: 로그인 화면 → "비밀번호 찾기" → 이메일 입력 → 재설정 링크 수신

**Q: 리뷰를 수정하려면?**
A: 현재 리뷰 수정 기능은 지원하지 않습니다. 삭제 후 재작성 가능합니다.
```

**검증**:
- [ ] USER_GUIDE.md 작성 완료
- [ ] 스크린샷 10개 이상 포함

---

#### 20.3 운영 가이드 작성

**파일**: `OPERATIONS_GUIDE.md` (신규)

**내용**:
- Firebase Console 모니터링
- Cloud Functions 로그 확인
- 데이터 백업/복구
- 긴급 대응 절차

**예시**:
```markdown
# Operations Guide

## 일일 모니터링 체크리스트

### Firebase Console
- [ ] Authentication → Users: 신규 가입자 수 확인
- [ ] Firestore → Usage: 읽기/쓰기 횟수 확인 (일일 할당량 대비)
- [ ] Functions → Dashboard: 에러율 확인 (< 1% 유지)
- [ ] Hosting → Usage: 트래픽 확인

### Google Cloud Console
- [ ] Maps API 사용량 확인 (일일 10,000 요청 제한)
- [ ] 비용 확인 (예상 비용 초과 시 알림)

## 데이터 백업

### 자동 백업 (Firestore)
- 설정: Firebase Console → Firestore → Backups
- 스케줄: 매일 03:00 AM (KST)
- 보관 기간: 30일

### 수동 백업
```bash
gcloud firestore export gs://truck-tracker-backup/$(date +%Y%m%d)
```

## 긴급 대응

### 앱 크래시 급증
1. Firebase Crashlytics 확인
2. 최근 배포 롤백 고려
3. 핫픽스 배포

### API 할당량 초과
1. Google Cloud Console → 할당량 증가 요청
2. 임시: 쿼리 limit 축소
3. 장기: 캐싱 구현

### 보안 사고
1. Firebase Console → Authentication → Users → 의심 계정 비활성화
2. Firestore Rules 강화
3. Cloud Functions CORS 재확인
4. 로그 분석 (IP, User-Agent)
```

**검증**:
- [ ] OPERATIONS_GUIDE.md 작성 완료

---

#### 20.4 최종 보안 감사

**체크리스트**:

1. **코드 검토**:
   - [ ] `.env` 파일이 Git에 없음 (.gitignore 확인)
   - [ ] API 키가 Remote Config로 마이그레이션됨
   - [ ] 테스트 버튼이 `kDebugMode`로 보호됨

2. **Firebase 설정**:
   - [ ] Firestore Rules 배포 확인
   - [ ] Storage Rules 배포 확인
   - [ ] App Check 활성화 확인

3. **외부 API 보호**:
   - [ ] Google Maps API 제한 설정 확인
   - [ ] Cloud Functions CORS 화이트리스트 확인

4. **침투 테스트**:
   - [ ] 무단 API 호출 차단 확인
   - [ ] 권한 우회 시도 차단 확인
   - [ ] SQL Injection 방어 확인 (Firestore는 기본 방어)

**도구**:
- OWASP ZAP (웹 취약점 스캔)
- Firebase Security Rules Simulator

**검증**:
- [ ] 보안 감사 체크리스트 100% 완료
- [ ] 취약점 0건

---

#### 20.5 프로덕션 배포 체크리스트

**파일**: `DEPLOYMENT_CHECKLIST.md` (신규)

```markdown
# Production Deployment Checklist

## Pre-Deployment

### Code
- [ ] All tests passing (100%)
- [ ] Flutter analyze: 0 issues
- [ ] Code review completed
- [ ] Version bump in pubspec.yaml

### Security
- [ ] All API keys protected
- [ ] Firebase App Check enabled
- [ ] Security Rules deployed
- [ ] CORS whitelist configured

### Performance
- [ ] withOpacity() optimizations applied
- [ ] Firestore queries have limits
- [ ] Images optimized (<500KB)
- [ ] Build size < 20MB

### Documentation
- [ ] CHANGELOG.md updated
- [ ] USER_GUIDE.md reviewed
- [ ] API docs generated

## Deployment Steps

1. **Build**:
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release
   ```

2. **Test Build Locally**:
   ```bash
   firebase serve --only hosting
   ```

3. **Deploy**:
   ```bash
   firebase deploy --only hosting,firestore,storage,functions
   ```

4. **Smoke Test**:
   - [ ] Homepage loads
   - [ ] Login works
   - [ ] Truck map displays
   - [ ] Review submission works

## Post-Deployment

### Monitoring (First 24h)
- [ ] Error rate < 1% (Firebase Crashlytics)
- [ ] API usage within limits
- [ ] User feedback monitoring

### Rollback Plan
If critical issues detected:
```bash
firebase hosting:rollback
```

## Rollout Strategy

### Phase 1: Beta (10% users)
- Duration: 3 days
- Canary deployment to beta testers

### Phase 2: Gradual Rollout (50% users)
- Duration: 7 days
- Monitor metrics

### Phase 3: Full Release (100%)
- After successful Phase 2
```

**검증**:
- [ ] DEPLOYMENT_CHECKLIST.md 작성 완료
- [ ] 체크리스트 100% 완료

---

### Phase 20 완료 기준

- [ ] API 문서 생성 및 호스팅
- [ ] USER_GUIDE.md 작성 완료
- [ ] OPERATIONS_GUIDE.md 작성 완료
- [ ] 최종 보안 감사 통과
- [ ] DEPLOYMENT_CHECKLIST.md 작성 완료
- [ ] 프로덕션 배포 준비 완료

---

## 전체 Phase 요약

| Phase | 우선순위 | 기간 | 핵심 목표 |
|-------|----------|------|-----------|
| 16 | P0-P1 | 1-2일 | 보안 취약점 제거 (API 키, 테스트 버튼, 비밀번호 검증) |
| 17 | P1 | 1일 | Cloud Functions 배포, FCM 통합 완료 |
| 18 | P1-P2 | 2-3일 | 코드 품질 개선 (withOpacity, SnackBar, AppException) |
| 19 | P1-P2 | 3-4일 | 테스트 커버리지 30% → 60% |
| 20 | P2-P3 | 2일 | 문서화 완성, 최종 감사, 배포 준비 |

**총 예상 기간**: 9-12일
**최종 목표**: 프로덕션 배포 준비 완료 🚀

---

## 다음 단계

1. **Phase 16 시작**: 보안 강화 작업 착수
2. **Git 브랜치 전략**:
   ```bash
   git checkout -b phase-16-security-hardening
   ```
3. **진행 상황 추적**: 각 Phase별 GitHub Issue 생성
4. **완료 후**: PROJECT_AUDIT_REPORT.md 재감사

---

**문서 작성**: Claude Code (Opus)
**검토 필요**: 프로젝트 관리자
**다음 업데이트**: Phase 16 완료 후
