# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 현재 상태 (2026-01-02 최신)

| 항목 | 상태 |
|------|------|
| 완성도 | **110%** (Phase 0-4 완료) |
| 빌드 | **WSL Ubuntu에서 빌드** (Windows X) |
| flutter analyze | No issues (info 10개만) |
| Cloud Functions | 10개 함수 배포 완료 |
| 소셜 로그인 | ✅ 카카오/네이버/Google/이메일 모두 정상 |
| 테스트 | 658 통과, 8 스킵, 4 실패 (async 렌더링) |
| 배포 | https://truck-tracker-fa0b0.web.app |

---

## ✅ 완료된 작업 (MAJOR_IMPROVEMENT_PLAN 기반)

### Phase 0: 즉시 수정 ✅
| 항목 | 상태 | 날짜 |
|------|------|------|
| dart:html deprecated 마이그레이션 | ✅ | 2026-01-01 |
| 구글 로그인 오버레이 버그 | ✅ | 2026-01-02 |
| 이메일 로그인 안됨 | ✅ | 2026-01-02 |

### Phase 2: 사장님 대시보드 UI 개선 ✅
| 항목 | 상태 | 날짜 |
|------|------|------|
| BottomNavigationBar 추가 | ✅ | 2026-01-01 |
| 홈 탭 구현 | ✅ | 2026-01-01 |
| 주문 탭 칸반 보드 | ✅ | 기존 구현됨 |
| 통계/더보기 탭 | ✅ | 기존 구현됨 |

### Phase 3: 사장님 온보딩 시스템 ✅
| 항목 | 상태 | 날짜 |
|------|------|------|
| 5단계 온보딩 화면 | ✅ | 2026-01-02 |
| Firestore 연동 | ✅ | 2026-01-02 |
| 진행 상태 저장 | ✅ | 2026-01-02 |

### Phase 4: 영업 승인 시스템 ✅
| 항목 | 상태 | 날짜 |
|------|------|------|
| business_approvals 컬렉션 | ✅ | 2026-01-01 |
| 관리자 승인 화면 | ✅ | 2026-01-01 |
| 사장님 대시보드 배너 | ✅ | 2026-01-01 |
| Firestore 보안 규칙 | ✅ | 2026-01-01 |

### 기타 완료 작업
| 항목 | 상태 | 파일 |
|------|------|------|
| 코드 중복 제거 | ✅ | `shared/widgets/`, `core/utils/` |
| 즐겨찾기 버그 | ✅ | `favorite_provider.dart` |
| 리뷰 수정/삭제 UI | ✅ | `truck_detail_screen.dart:1068` |
| Talk 삭제 기능 | ✅ | `talk_widget.dart:260` |
| 고객 온보딩 | ✅ | `customer_onboarding_screen.dart` |
| 도움말 FAQ | ✅ | `help_screen.dart:206` |
| 쿠폰 스캐너 (QR) | ✅ | `coupon_scanner_screen.dart` |

---

## 🔜 다음 할 것 (남은 작업)

### Phase 1: 데이터 초기화 (수동 작업)

> ⚠️ **Firebase Console에서 직접 수행 필요** (코드로 불가)

**1. Firebase Auth 정리**
- 유지: `hyunwoooim@gmail.com` (관리자)
- 삭제: 나머지 전부

**2. Firestore 컬렉션 삭제**
```
삭제할 컬렉션:
├── trucks/*
├── users/* (관리자 제외)
├── reviews/*
├── orders/*
├── favorites/*
├── follows/*
├── chatRooms/*
├── checkins/*
├── stampCards/*
├── coupons/*
├── userCoupons/*
├── notifications/*
├── owner_requests/*
├── analytics/*
├── posts/*
├── comments/*
└── notificationSettings/*
```

**3. 테스트 계정 생성 (4개)**
| 역할 | 이메일 | 비밀번호 | 트럭 |
|------|--------|----------|------|
| 관리자 | hyunwoooim@gmail.com | (기존) | - |
| 사장님1 | owner1@test.com | Test123! | 골목식당 닭꼬치 |
| 사장님2 | owner2@test.com | Test123! | 심야라멘 |
| 사장님3 | owner3@test.com | Test123! | 파리지앵 크레페 |
| 고객 | customer@test.com | Test123! | - |

---

### Phase 5: 코드 품질 개선

**1. l10n 마이그레이션** (100+ 하드코딩 문자열)
- `truck_list_screen.dart`: 8개
- `login_screen.dart`: 10개+
- `owner_dashboard_screen.dart`: 15개+
- 기타 화면들

```dart
// Before
Text('검색 조건을 변경해 보세요')

// After
Text(l10n.searchSuggestion)
```

**2. Deprecated API 수정**
| 파일 | 현재 | 변경 |
|------|------|------|
| `web_auth_helper.dart` | `dart:html` | `package:web` |

**3. 테스트 추가**
- 현재: 658개 통과, 4개 실패
- 핵심 로직 테스트 부족

---

## 링크
- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker
- **상세 계획**: `docs/MAJOR_IMPROVEMENT_PLAN.md`

---

## 빌드 방법

**Windows에서 직접 빌드하면 안 됨! (impellerc 크래시)**

```bash
# 1. WSL에서 빌드 (필수)
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker" && npx firebase-tools deploy --only hosting
```

---

## OAuth 설정값

### 카카오
| 항목 | 값 |
|------|-----|
| REST API 키 | `9b29da5ab6db839b37a65c79afe9b52e` |
| Redirect URI | `https://truck-tracker-fa0b0.web.app/kakao` |

### 네이버
| 항목 | 값 |
|------|-----|
| Client ID | `9szh6EOxjf8b40x9ZHKH` |
| Redirect URI | `https://truck-tracker-fa0b0.web.app/oauth/naver/callback` |

---

## 파일 구조
```
lib/
├── core/           # 테마, 상수
├── features/       # 기능 모듈 (24개)
├── shared/         # 공유 위젯
└── main.dart

docs/
├── MAJOR_IMPROVEMENT_PLAN.md  # 상세 개선 계획
├── TROUBLESHOOTING.md         # 트러블슈팅 가이드
└── ...
```

---

**마지막 업데이트**: 2026-01-02 (MAJOR_IMPROVEMENT_PLAN 기반 정리)
