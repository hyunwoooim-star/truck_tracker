# 🏠 집에서 해야 할 작업 목록 (우선순위 1-10)

> **작성일**: 2025-12-30
> **목적**: Windows 제약 우회 + 미뤄둔 설정 작업 완료

---

## 1️⃣ WSL2 환경 설정 (가장 먼저!)
**이유**: Windows impellerc 버그 우회, Linux 환경에서 Flutter 안정적 빌드

```powershell
# PowerShell (관리자 권한)
wsl --install -d Ubuntu-22.04
```

**WSL 설치 후**:
```bash
# Ubuntu 터미널에서
sudo apt update && sudo apt upgrade -y

# Flutter 설치
sudo snap install flutter --classic
flutter doctor

# 프로젝트 클론
git clone https://github.com/hyunwoooim-star/truck_tracker.git
cd truck_tracker
flutter pub get
```

---

## 2️⃣ GitHub Secrets 설정 (5분)
**URL**: https://github.com/hyunwoooim-star/truck_tracker/settings/secrets/actions

| Name | Value |
|------|-------|
| `KAKAO_NATIVE_APP_KEY` | `16a3e20d6e8bff9d586a64029614a40e` |
| `GOOGLE_MAPS_API_KEY` | Google Cloud Console에서 발급 |

**설정 방법**:
1. 위 URL 접속
2. "New repository secret" 클릭
3. Name과 Value 입력 후 저장

---

## 3️⃣ 카카오 OAuth 네이티브 설정 (Android/iOS)

### Android
**파일**: `android/app/src/main/AndroidManifest.xml`

`<application>` 태그 안에 추가:
```xml
<activity android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
    android:exported="true">
    <intent-filter android:label="flutter_web_auth">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="kakao16a3e20d6e8bff9d586a64029614a40e" android:host="oauth"/>
    </intent-filter>
</activity>
```

### iOS
**파일**: `ios/Runner/Info.plist`

`<dict>` 안에 추가:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>kakao16a3e20d6e8bff9d586a64029614a40e</string>
        </array>
    </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>kakaokompassauth</string>
    <string>kakaolink</string>
    <string>kakaoplus</string>
</array>
```

---

## 4️⃣ 네이버 OAuth 설정
**네이버 개발자 센터**: https://developers.naver.com/apps

1. 애플리케이션 등록
2. **사용 API**: 네이버 로그인 선택
3. **서비스 환경**: Android, iOS 추가
4. **Android 패키지명**: `com.example.truck_tracker`
5. **iOS Bundle ID**: `com.example.truckTracker`
6. Client ID, Client Secret 발급
7. 코드에 적용 (추후 안내)

---

## 5️⃣ Google Maps API 키 발급
**URL**: https://console.cloud.google.com/apis/credentials

1. 프로젝트: `truck-tracker-fa0b0` 선택
2. **사용자 인증 정보** → **사용자 인증 정보 만들기** → **API 키**
3. **라이브러리**에서 활성화:
   - Directions API
   - Maps JavaScript API (웹용)
4. 발급받은 키를 GitHub Secrets에 `GOOGLE_MAPS_API_KEY`로 추가

---

## 6️⃣ Firebase Console 작업

### Firestore 규칙 배포
**URL**: https://console.firebase.google.com/project/truck-tracker-fa0b0/firestore/rules

1. 위 URL 접속
2. 프로젝트의 `firestore.rules` 파일 내용 전체 복사
3. Firebase Console에 붙여넣기
4. **게시** 버튼 클릭

### Cloud Functions 배포 (WSL에서)
```bash
cd ~/truck_tracker/functions
npm install
firebase login
firebase deploy --only functions
```

**배포되는 함수 6개**:
- createCustomToken (카카오/네이버 인증)
- notifyTruckOpening (영업 시작 알림)
- notifyOrderStatus (주문 상태 알림)
- notifyCouponCreated (쿠폰 발행 알림)
- notifyChatMessage (채팅 알림)
- notifyNearbyTrucks (근처 트럭 알림)

---

## 7️⃣ 앱 아이콘 생성

### DALL-E / Midjourney 프롬프트
```
Minimalist app icon, food truck silhouette, Toss blue (#3182F6) gradient,
clean geometric design, white background, no text, iOS style, 1024x1024
```

### 아이콘 적용 방법
**Android**:
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

**iOS**:
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` 폴더
- 다양한 크기 필요 (1024x1024 원본에서 리사이즈)

**추천 도구**: https://appicon.co/ (원본 업로드하면 자동 리사이즈)

---

## 8️⃣ 로컬 빌드 테스트 (WSL에서)

```bash
# 프로젝트 폴더로 이동
cd ~/truck_tracker

# 의존성 설치
flutter pub get

# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 웹 빌드
flutter build web --release

# Android APK 빌드
flutter build apk --release

# Android App Bundle (Play Store용)
flutter build appbundle --release
```

---

## 9️⃣ 프로덕션 키 (실제 수익화 시)

| 서비스 | 콘솔 URL | 적용 파일 |
|--------|----------|----------|
| TossPayments | https://developers.tosspayments.com | `lib/features/payment/data/payment_repository.dart` (19-20줄) |
| AdMob | https://admob.google.com | `lib/features/ads/data/ad_service.dart` (25-30줄) |

**현재 상태**: 테스트 키만 적용됨 (실제 결제/광고 수익 X)

---

## 🔟 실기기 테스트

### Android
1. 휴대폰 설정 → 개발자 옵션 → USB 디버깅 활성화
2. USB 연결
3. `flutter devices`로 기기 확인
4. `flutter run`

### iOS (Mac 필요)
1. Xcode 설치
2. `open ios/Runner.xcworkspace`
3. 팀/인증서 설정
4. 실기기 연결 후 Run

### 웹 (이미 배포됨)
- **Live URL**: https://hyunwoooim-star.github.io/truck_tracker/

---

## 📋 체크리스트 (2025-12-30 23:00 업데이트)

```
✅ 1. WSL1 + Ubuntu 22.04 설치 (WSL2는 Windows 버전 미지원)
✅ 2. WSL에 Flutter 설치 (수동 설치 - snap 미지원)
✅ 3. 프로젝트 클론 및 환경 확인
❌ 4. SSH/Tailscale 원격 접속 (WSL1 한계로 불가 → AnyDesk 권장)
⚠️ 5. social_feed 모듈 에러 수정 필요 (9개 에러)
□ 6. GitHub Secrets 설정 (KAKAO_NATIVE_APP_KEY)
□ 7. GitHub Secrets 설정 (GOOGLE_MAPS_API_KEY)
□ 8. 카카오 OAuth - AndroidManifest.xml 설정
□ 9. 카카오 OAuth - Info.plist 설정
□ 10. 네이버 개발자 센터 앱 등록
□ 11. Google Cloud - Directions API 활성화
□ 12. Firebase - Firestore 규칙 배포
□ 13. Firebase - Cloud Functions 배포
□ 14. 앱 아이콘 생성 (DALL-E/Midjourney)
□ 15. 앱 아이콘 적용 (Android/iOS)
□ 16. 로컬 빌드 테스트 (flutter test)
□ 17. 로컬 빌드 테스트 (flutter build web)
□ 18. 프로덕션 키 적용 (TossPayments) - 선택
□ 19. 프로덕션 키 적용 (AdMob) - 선택
```

---

## 📝 WSL 환경 정보

| 항목 | 값 |
|------|-----|
| Windows 버전 | 10.0.18362 (Version 1903) |
| WSL 버전 | WSL1 (WSL2 미지원) |
| Ubuntu 버전 | 22.04.5 LTS |
| Flutter 버전 | 3.38.5 (stable) |
| Flutter 경로 | `~/flutter/bin` |
| 프로젝트 경로 | `~/truck_tracker` |
| 사용자명 | hyunwoo |

### WSL 시작 명령어
```bash
cd ~/truck_tracker
flutter pub get
flutter analyze
```

### WSL1 한계
- systemd 미지원 → snap, systemctl 불가
- TUN 모듈 없음 → Tailscale, VPN 불가
- SSH 접속 어려움 → AnyDesk 권장

---

## 🔗 주요 링크

| 항목 | URL |
|------|-----|
| Live Site | https://hyunwoooim-star.github.io/truck_tracker/ |
| GitHub Repo | https://github.com/hyunwoooim-star/truck_tracker |
| GitHub Secrets | https://github.com/hyunwoooim-star/truck_tracker/settings/secrets/actions |
| Firebase Console | https://console.firebase.google.com/project/truck-tracker-fa0b0 |
| Firestore Rules | https://console.firebase.google.com/project/truck-tracker-fa0b0/firestore/rules |
| Google Cloud Console | https://console.cloud.google.com |
| 카카오 개발자 | https://developers.kakao.com |
| 네이버 개발자 | https://developers.naver.com |

---

**마지막 업데이트**: 2025-12-30
