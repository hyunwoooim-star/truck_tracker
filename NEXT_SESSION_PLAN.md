# 다음 작업 시작 가이드

> **GitHub**: https://github.com/hyunwoooim-star/truck_tracker
>
> **이 문서를 읽으면**: 어디서든 바로 작업 시작 가능

**작성일**: 2025-12-29
**현재 상태**: Riverpod 4.x 마이그레이션 진행 중

---

## 이번 세션에서 완료한 작업

### 1. SnackBarHelper 전면 적용 (11개 파일)
- login_screen.dart (5개)
- customer_checkin_screen.dart (2개)
- chat_screen.dart (1개)
- notification_settings_screen.dart (1개)
- talk_widget.dart (2개)
- user_profile_screen.dart (2개)
- schedule_management_screen.dart (2개)
- analytics_screen.dart (2개)
- owner_dashboard_screen.dart (9개)
- truck_detail_screen.dart (9개)
- review_form_dialog.dart (3개)

**총 38개의 ScaffoldMessenger.showSnackBar -> SnackBarHelper 변환**

### 2. Riverpod 4.x 부분 마이그레이션

**완료된 작업**:
- 18개 provider 파일에서 `*Ref` → `Ref` 타입 변경
- 7개 Notifier 클래스를 `_$ClassName` 패턴으로 변경
- Provider 이름 참조 수정 (analyticsDateRangeProvider, truckDetailProvider)
- singleTruckProvider 추가
- 모든 .g.dart 파일 재생성

**커밋**: `41f8259` refactor: Partial Riverpod 4.x migration (*Ref → Ref)

---

## 남은 Riverpod/Freezed 마이그레이션 작업 (중요!)

### 1. Provider 이름 변경 필요 (81개 에러)

**변경 패턴**:
```dart
// 현재 코드
truckFilterNotifierProvider  → truckFilterProvider
sortOptionNotifierProvider   → sortOptionProvider
truckListNotifierProvider    → truckListProvider
```

**영향받는 파일**:
- truck_list_screen.dart (~20곳)
- truck_provider.dart (~5곳)
- map_first_screen.dart (~5곳)

### 2. Freezed 4.x sealed class 마이그레이션

**변경 패턴**:
```dart
// 현재 (에러 발생)
@freezed
class AppUser with _$AppUser { ... }

// 수정 필요
@freezed
sealed class AppUser with _$AppUser { ... }
```

**영향받는 모델**:
- AppUser, ChatMessage, ChatRoom, CheckIn
- Coupon, NotificationSettings, CartItem, Order
- Review, DailySchedule, TruckFollow, TalkMessage
- MenuItem, TruckDetail (총 ~15개 모델)

### 3. Order 타입 충돌 해결

`cloud_firestore_platform_interface`의 `Order`와 앱의 `Order` 클래스 충돌:
```dart
// 해결책: import alias 사용
import '../domain/order.dart' as app_order;
```

### 4. 테스트 파일 수정

- fake_cloud_firestore 패키지 추가 필요
- CartItem 필드명 변경 반영

---

## 빠른 수정 명령어

```bash
# 프로젝트 디렉토리
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"

# 현재 에러 확인
flutter analyze 2>&1 | grep -c "error -"

# Provider 이름 일괄 변경 (PowerShell)
# 한글 경로 문제로 수동 수정 권장

# build_runner 재실행
flutter pub run build_runner build --delete-conflicting-outputs

# 테스트 실행 (현재 실패할 수 있음)
flutter test
```

---

## 현재 진행 상황

| Phase | 상태 | 완료율 |
|-------|------|--------|
| Phase 16 (보안) | 완료 | 100% |
| Phase 17 (Cloud Functions) | 코드 완료 | 90% |
| Phase 18 (코드 품질) | Riverpod 마이그레이션 중 | 60% |
| Phase 19 (테스트) | 대기 중 | 30% |
| Phase 20 (문서화) | 완료 | 100% |

**전체 진행률**: 약 75% (Riverpod/Freezed 마이그레이션 필요)

---

## 프로젝트 링크

- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker
- **Firebase**: https://console.firebase.google.com/project/truck-tracker-fa0b0

---

**마지막 업데이트**: 2025-12-29
