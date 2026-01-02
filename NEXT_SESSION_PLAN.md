# Truck Tracker - 세션 시작 가이드

> **이 파일만 읽으면 됨** | 앱: 푸드트럭 위치 찾기 + 선결제 + 픽업

---

## 현재 상태 (2026-01-02 최신)

| 항목 | 상태 |
|------|------|
| 완성도 | **110%** (Phase 0-4 + 이미지 최적화 완료) |
| 빌드 | **GitHub Actions 자동 배포** (main push 시) |
| flutter analyze | No issues (info만) |
| Cloud Functions | 10개 함수 배포 완료 |
| 소셜 로그인 | ✅ 카카오/네이버/Google/이메일 모두 정상 |
| 이미지 업로드 | ✅ **전체 통합 완료** (WebP 압축) |
| 배포 | https://truck-tracker-fa0b0.web.app |

---

## ✅ 오늘 완료한 작업 (2026-01-02)

### UI/UX 개선
| 작업 | 상태 |
|------|------|
| 매출 대시보드 깜빡임 해결 (수동 새로고침) | ✅ |
| 온보딩 위치에 실제 주소 표시 (Reverse Geocoding) | ✅ |
| 검색창/tooltip 한글화 | ✅ |
| 트럭 카드 UI (음식 종류 강조) | ✅ |
| 더보기 탭 구조 개편 (3개 메뉴로 단순화) | ✅ |

### 더보기 탭 새 구조
```
더보기 탭
├── 🚚 사장님 대시보드 설정 → OwnerManagementScreen
├── 📱 기능 더보기 → OwnerFunctionsScreen (신규)
├── ⚙️ 앱 설정 → OwnerAppSettingsScreen (신규)
└── 🚪 로그아웃
```

---

## 🚧 진행 중인 작업

### 트럭 카드 클릭 → 지도 이동 + 바텀시트 (플랜 A)

**목표 UX:**
```
카드 클릭 → 지도로 이동 + 해당 트럭으로 확대 → 바텀시트 팝업
                                              ├── 트럭 미리보기 (이미지, 메뉴, 거리)
                                              └── [상점 보기] 버튼 → TruckDetailScreen
```

**구현 상태:**
- [x] TruckMapScreen imports 추가
- [ ] `_moveToTruck`에서 바텀시트 표시 로직 추가
- [ ] 트럭 미리보기 바텀시트 위젯 구현
- [ ] `bento_truck_card.dart`에서 클릭 시 TruckMapScreen으로 이동

**구현 코드 (다음 세션에서 완성):**

1. **truck_map_screen.dart** - `_moveToTruck` 수정:
```dart
Future<void> _moveToTruck(String? targetId, LatLng? targetLatLng, List trucks) async {
  if (targetId == null && targetLatLng == null) return;

  final controller = await _mapController.future;
  final target = targetLatLng ?? _initialLatLng(trucks, targetId, null) ?? const LatLng(37.5665, 126.9780);

  await controller.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: 17), // 더 줌인
    ),
  );

  // 트럭 찾아서 바텀시트 표시
  if (targetId != null && mounted) {
    final truck = trucks.cast<Truck>().where((t) => t.id == targetId).firstOrNull;
    if (truck != null) {
      _showTruckPreviewBottomSheet(truck);
    }
  }
}

void _showTruckPreviewBottomSheet(Truck truck) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => TruckPreviewBottomSheet(truck: truck),
  );
}
```

2. **TruckPreviewBottomSheet 위젯 생성:**
```dart
class TruckPreviewBottomSheet extends StatelessWidget {
  final Truck truck;
  // 이미지, 음식종류, 메뉴 미리보기, 거리, 상점 보기 버튼
}
```

3. **bento_truck_card.dart** - onTap 수정:
```dart
onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TruckMapScreen(initialTruckId: truck.id),
    ),
  );
},
```

---

## 남은 작업 (선택)

| 항목 | 우선순위 | 비고 |
|------|----------|------|
| 트럭 클릭 → 지도 이동 + 바텀시트 | **높음** | 진행 중 |
| 소셜 피드 방향 결정 | 중 | 모든 사용자 vs 사장님 전용 |
| deprecated API 정리 | 낮음 | `dart:html` → `package:web` |

---

## 빌드 & 배포

### GitHub Actions (자동)
- `main` 브랜치에 push → 자동 빌드 & Firebase 배포
- Actions 탭에서 진행 상황 확인

### 수동 배포 (WSL)
```bash
# 1. WSL 빌드
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"

# 3. Firebase 배포
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker" && npx firebase-tools deploy --only hosting
```

---

## 링크
- **Live**: https://truck-tracker-fa0b0.web.app
- **GitHub**: https://github.com/hyunwoooim-star/truck_tracker

---

**마지막 업데이트**: 2026-01-02 (더보기 탭 개편 완료, 트럭 클릭 UX 작업 중)
