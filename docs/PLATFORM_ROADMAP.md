# 트럭아저씨 150% 완성도 로드맵

> 웹앱 → Android/iOS 네이티브 앱 확장 계획

---

## 웹앱 vs 네이티브 앱 핵심 차이점

| 기능 | 웹앱 (현재) | 네이티브 앱 | 영향도 |
|------|-------------|-------------|--------|
| **백그라운드 GPS** | ❌ 불가능 | ✅ 가능 | 🔴 매우 높음 |
| **푸시 알림** | ⚠️ 제한적 (Safari X) | ✅ 완벽 지원 | 🔴 매우 높음 |
| **오프라인 모드** | ⚠️ Service Worker 한계 | ✅ SQLite/Hive | 🟡 높음 |
| **카메라/QR** | ⚠️ 브라우저 권한 필요 | ✅ 네이티브 접근 | 🟡 높음 |
| **결제** | PG사 (토스/이니시스) | 인앱결제 + PG사 | 🟡 높음 |
| **성능** | 브라우저 의존 | 네이티브 최적화 | 🟢 중간 |
| **앱 아이콘/위젯** | ❌ 불가능 | ✅ 홈화면 위젯 | 🟢 중간 |
| **생체인증** | ⚠️ WebAuthn 제한 | ✅ 지문/Face ID | 🟢 중간 |
| **딥링크** | ⚠️ 제한적 | ✅ 완벽 지원 | 🟢 중간 |
| **배포 속도** | 즉시 | 스토어 심사 1-7일 | 🟢 중간 |

---

## 백그라운드 GPS 상세 분석 (가장 중요!)

### 현재 웹앱 한계
```
사장님이 브라우저를 닫으면 → 위치 추적 중단 → 고객에게 트럭 위치 안 보임
```

### 네이티브 앱 해결책
```dart
// Android: Foreground Service
// iOS: Background Location Updates

class BackgroundLocationService {
  // 앱이 백그라운드여도 위치 계속 추적
  // 5분마다 Firestore에 위치 업데이트
  // 배터리 최적화 (Geofencing 활용)
}
```

### 구현 필요 사항
| 플랫폼 | 필요 작업 |
|--------|-----------|
| Android | Foreground Service + 알림 표시 |
| iOS | Background Location + Info.plist 설정 |
| 공통 | 배터리 최적화 로직 |

---

## 150% 완성도 로드맵

### Phase 1: 코드 품질 강화 (현재 → 110%)
| 작업 | 설명 | 예상 시간 |
|------|------|----------|
| 테스트 커버리지 80%+ | 실패 테스트 수정, 새 테스트 추가 | - |
| 코드 리팩토링 | 중복 코드 제거, 공통 위젯 추출 | - |
| 에러 핸들링 강화 | 전역 에러 바운더리, 재시도 로직 | - |
| 로깅/모니터링 | Sentry 통합, 성능 모니터링 | - |

### Phase 2: 네이티브 기능 준비 (110% → 120%)
| 작업 | 설명 | 웹 | 앱 |
|------|------|-----|-----|
| 백그라운드 위치 서비스 | 사장님 트럭 위치 자동 추적 | ❌ | ✅ |
| 네이티브 푸시 알림 | FCM 네이티브 통합 | ⚠️ | ✅ |
| 오프라인 모드 | Hive 로컬 DB | ⚠️ | ✅ |
| 생체인증 | 지문/Face ID 로그인 | ❌ | ✅ |

### Phase 3: Android 앱 출시 (120% → 135%)
| 작업 | 설명 |
|------|------|
| Android 빌드 설정 | `android/` 폴더 설정 |
| Google Play Console 등록 | 개발자 계정, 앱 정보 |
| 백그라운드 GPS 구현 | Foreground Service |
| 인앱 결제 연동 | Google Play Billing |
| 스토어 심사 제출 | 스크린샷, 설명, 개인정보처리방침 |

### Phase 4: iOS 앱 출시 (135% → 150%)
| 작업 | 설명 |
|------|------|
| iOS 빌드 설정 | `ios/` 폴더, Xcode 설정 |
| Apple Developer 등록 | 연 $99 개발자 계정 |
| 백그라운드 GPS 구현 | Background Location |
| 인앱 결제 연동 | StoreKit |
| App Store 심사 제출 | 더 엄격한 심사 기준 |

---

## 기능별 플랫폼 구현 전략

### 1. 백그라운드 GPS (사장님 트럭 위치)

```dart
// lib/features/location/services/background_location_service.dart

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class BackgroundLocationService {
  static Future<void> initialize() async {
    if (kIsWeb) return; // 웹에서는 스킵

    await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 50.0, // 50m 이동 시 업데이트
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      foregroundService: true,
      notification: bg.Notification(
        title: "트럭아저씨",
        text: "위치 추적 중...",
      ),
    ));
  }

  static Future<void> startTracking(String truckId) async {
    await bg.BackgroundGeolocation.start();

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      // Firestore에 위치 업데이트
      FirebaseFirestore.instance.collection('trucks').doc(truckId).update({
        'location': GeoPoint(location.coords.latitude, location.coords.longitude),
        'lastLocationUpdate': FieldValue.serverTimestamp(),
      });
    });
  }
}
```

### 2. 오프라인 모드 (Hive)

```dart
// lib/core/services/offline_service.dart

import 'package:hive_flutter/hive_flutter.dart';

class OfflineService {
  static late Box<Truck> _trucksBox;
  static late Box<StampCard> _stampCardsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TruckAdapter());
    Hive.registerAdapter(StampCardAdapter());

    _trucksBox = await Hive.openBox<Truck>('trucks');
    _stampCardsBox = await Hive.openBox<StampCard>('stampCards');
  }

  // 온라인 시 Firestore → Hive 동기화
  static Future<void> syncFromFirestore() async {
    final trucks = await FirebaseFirestore.instance.collection('trucks').get();
    for (final doc in trucks.docs) {
      _trucksBox.put(doc.id, Truck.fromFirestore(doc));
    }
  }

  // 오프라인 시 Hive에서 읽기
  static List<Truck> getTrucksOffline() {
    return _trucksBox.values.toList();
  }
}
```

### 3. 네이티브 푸시 알림

```dart
// lib/core/services/native_push_service.dart

class NativePushService {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // 웹용 FCM (제한적)
      await _initWebPush();
    } else {
      // 네이티브 FCM (완전 지원)
      await _initNativePush();
    }
  }

  static Future<void> _initNativePush() async {
    // 권한 요청
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 토픽 구독 (네이티브에서만 가능)
    await FirebaseMessaging.instance.subscribeToTopic('all_users');

    // 백그라운드 메시지 핸들러
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }
}
```

---

## 스토어 출시 체크리스트

### Google Play Store (Android)
- [ ] 개발자 계정 등록 ($25 일회성)
- [ ] 앱 서명 키 생성 (keystore)
- [ ] 앱 아이콘 (512x512)
- [ ] 스크린샷 (최소 2장)
- [ ] 기능 그래픽 (1024x500)
- [ ] 개인정보처리방침 URL
- [ ] 앱 설명 (한국어/영어)
- [ ] 연령 등급 설문
- [ ] 데이터 보안 설문

### Apple App Store (iOS)
- [ ] 개발자 계정 등록 ($99/년)
- [ ] 인증서 & 프로비저닝 프로파일
- [ ] 앱 아이콘 (1024x1024)
- [ ] 스크린샷 (6.5", 5.5" 필수)
- [ ] 개인정보처리방침 URL
- [ ] 앱 설명 (한국어/영어)
- [ ] 앱 심사 정보 (테스트 계정 등)
- [ ] 수출 규정 준수 확인

---

## 예상 일정

| Phase | 작업 | 예상 기간 |
|-------|------|----------|
| Phase 1 | 코드 품질 강화 | 1-2주 |
| Phase 2 | 네이티브 기능 준비 | 2-3주 |
| Phase 3 | Android 앱 출시 | 2-3주 |
| Phase 4 | iOS 앱 출시 | 2-3주 |
| **Total** | **150% 완성** | **7-11주** |

---

## 우선순위 정리

### 즉시 해야 할 것 (Phase 1)
1. 실패 테스트 10개 수정
2. 코드 중복 제거
3. 에러 핸들링 강화

### 앱 출시 전 필수 (Phase 2)
1. 백그라운드 GPS 서비스
2. 오프라인 모드 (Hive)
3. 네이티브 푸시 알림

### 스토어 출시 (Phase 3-4)
1. Android 먼저 (심사 빠름)
2. iOS 나중에 (심사 까다로움)

---

**작성일**: 2026-01-01
