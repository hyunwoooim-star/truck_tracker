# PROJECT_CONTEXT.md

Truck Tracker - Real-Time Food Truck Tracking Application

---

## 📋 Project Overview

**Truck Tracker** is a Flutter-based real-time food truck tracking application with two user roles:
- **Customers**: Browse, search, and track food trucks on a map
- **Owners**: Manage truck status, schedule, analytics, and orders

**Design Language**: "Baemin-style" dark theme with Electric Blue (#00D4FF) accents

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter 3.x (Dart 3.10.4+) |
| State Management | Riverpod 2.6.1 (Generator) |
| Backend | Firebase (Firestore, Auth, Storage, FCM) |
| Architecture | Feature-based Clean Architecture |
| Immutability | Freezed 2.5.7 |
| Maps | Google Maps Flutter |
| Location | Geolocator 14.0.2 |
| Code Gen | build_runner, riverpod_generator, json_serializable |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── themes/app_theme.dart          # AppTheme (pre-computed colors)
│   ├── constants/
│   │   ├── food_types.dart            # Filter tags
│   │   └── marker_colors.dart         # Map marker hues
│   └── utils/
│       ├── app_logger.dart            # Centralized logging
│       └── date_utils.dart            # DateTime extensions
├── shared/
│   └── widgets/
│       └── status_tag.dart            # Shared UI components
├── features/
│   ├── auth/                          # Firebase Authentication
│   ├── truck_list/                    # Customer: Browse trucks
│   ├── truck_map/                     # Real-time map view
│   ├── truck_detail/                  # Truck details, menu, reviews
│   ├── owner_dashboard/               # Owner: Manage truck
│   ├── favorite/                      # Favorite trucks
│   ├── location/                      # GPS location services
│   ├── review/                        # Review system
│   ├── schedule/                      # Daily schedule
│   ├── analytics/                     # Owner analytics
│   ├── checkin/                       # QR check-in
│   ├── notifications/                 # FCM push notifications
│   └── storage/                       # Firebase Storage (images)
└── main.dart
```

### Feature Structure (Clean Architecture)
Each feature follows this pattern:
```
features/<feature_name>/
├── data/
│   └── *_repository.dart              # Firestore data access
├── domain/
│   └── *.dart                         # Freezed models
└── presentation/
    ├── *_provider.dart                # Riverpod providers
    └── *_screen.dart                  # UI screens
```

---

## 🔥 Firebase Architecture

### Firestore Collections

#### `trucks/`
```javascript
{
  truckNumber: "BM-001",               // String
  driverName: "김사장",                 // String
  status: "onRoute",                   // Enum: onRoute | resting | maintenance
  foodType: "닭꼬치",                   // String
  latitude: 37.5665,                   // Number (GeoPoint alternative)
  longitude: 126.9780,                 // Number
  ownerEmail: "owner@example.com",     // String
  imageUrl: "https://...",             // String
  locationDescription: "강남역 2번 출구", // String
  isOpen: true,                        // Boolean (영업 중 여부)
  announcement: "오늘 30% 할인!",       // String?
  menuItems: [                         // Array
    {
      name: "닭꼬치",
      price: 5000,
      imageUrl: "https://...",
      isSoldOut: false
    }
  ],
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

#### `users/`
```javascript
{
  uid: "firebase_uid",                 // String
  email: "user@example.com",           // String
  displayName: "홍길동",                // String
  role: "customer",                    // customer | owner
  ownedTruckId: "1",                   // String? (null for customers)
  favoritesTrucks: ["1", "3"],         // Array<String>
  fcmToken: "...",                     // String? (for push notifications)
  createdAt: Timestamp
}
```

#### `reviews/`
```javascript
{
  truckId: "1",                        // String
  userId: "firebase_uid",              // String
  userName: "홍길동",                   // String
  rating: 4.5,                         // Number (1-5)
  content: "맛있어요!",                 // String
  photoUrls: ["https://..."],          // Array<String>
  ownerReply: "감사합니다!",            // String?
  createdAt: Timestamp
}
```

#### `analytics/{truckId}/daily/{YYYY-MM-DD}`
```javascript
{
  date: "2025-12-27",                  // String (YYYY-MM-DD)
  clicks: 150,                         // Number
  reviews: 5,                          // Number
  favorites: 12,                       // Number
  revenue: 450000                      // Number (optional)
}
```

#### `checkins/`
```javascript
{
  userId: "firebase_uid",              // String
  truckId: "1",                        // String
  checkinDate: "2025-12-27",           // String (YYYY-MM-DD)
  points: 10,                          // Number
  createdAt: Timestamp
}
```

### Real-Time Updates Flow
1. Owner changes truck status in `OwnerDashboardScreen`
2. Calls `TruckRepository.updateStatus(truckId, newStatus)`
3. Firestore updates `trucks/{truckId}.status`
4. All clients listening to `firestoreTruckStreamProvider` receive update
5. UI auto-updates via `ref.watch()`

**Critical**: Firestore is the single source of truth. Never store state locally without syncing to Firestore.

---

## 🔐 Authentication Flow

```
App Start
    ↓
AuthWrapper (main.dart)
    ↓
User authenticated? ──No──> LoginScreen
    ↓ Yes
Check users/{uid}.ownedTruckId
    ↓
Has ownedTruckId? ──Yes──> OwnerDashboardScreen (owner mode)
    ↓ No
TruckListScreen (customer mode)
```

**Authentication Methods**:
- ✅ Email/Password (implemented)
- ⚠️ Google Sign-In (prepared, needs web config)
- ❌ Kakao, Naver (prepared but not functional)

---

## 🎨 UI/UX Guidelines

### Theme Colors
```dart
// lib/core/themes/app_theme.dart
static const Color electricBlue = Color(0xFF00D4FF);  // Primary
static const Color midnightCharcoal = Color(0xFF1A1A1A);  // Background
static const Color charcoalMedium = Color(0xFF2A2A2A);  // Card background
static const Color textPrimary = Color(0xFFFFFFFF);
static const Color textSecondary = Color(0xFFB0B0B0);
static const Color textTertiary = Color(0xFF808080);

// Pre-computed opacity variants (Phase 2 optimization)
static const Color mustardYellow15 = Color(0x26FFC107);
static const Color electricBlue15 = Color(0x2600D4FF);
// ... etc
```

### Performance Patterns
1. **Const Widgets**: Use `const` for all static widgets
2. **ListView Optimization**: Always set `itemExtent` for fixed-height items
3. **Marker Caching**: Cache Google Maps markers, rebuild only on data change
4. **Pre-computed Colors**: Use constants instead of `Color.withOpacity()` in build()

### Localization
- All UI strings use `AppLocalizations.of(context)!.key`
- ARB files: `lib/l10n/app_ko.arb` (Korean), `app_en.arb` (English)
- Generate: `flutter gen-l10n`

---

## 🧪 Development Commands

### Build & Run
```bash
# Web development
flutter run -d chrome

# Mobile (default device)
flutter run

# Production builds
flutter build web
flutter build apk
flutter build ios
```

### Code Generation
```bash
# Generate Freezed/Riverpod/JSON code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs
```

**⚠️ IMPORTANT**: Run build_runner after modifying:
- `@freezed` models
- `@riverpod` providers
- `@JsonSerializable` classes

### Testing
```bash
# All tests
flutter test

# Specific file
flutter test test/unit/features/truck_list/truck_repository_test.dart

# With coverage
flutter test --coverage
```

### Linting
```bash
flutter analyze
```

---

## 📊 Common Development Tasks

### Adding a New Feature
1. Create feature directory: `lib/features/<feature_name>/`
2. Add domain models with Freezed: `domain/*.dart`
3. Create repository: `data/*_repository.dart`
4. Build providers with `@riverpod`: `presentation/*_provider.dart`
5. Implement UI: `presentation/*_screen.dart`
6. **Run build_runner**
7. Add tests in `test/unit/features/<feature_name>/`

### Modifying Firestore Schema
1. Update domain model in `domain/*.dart`
2. Update `fromFirestore()` and `toFirestore()` methods
3. Run build_runner
4. Update Firestore security rules
5. **Migrate existing data** (write migration script if needed)
6. Update tests

### Adding Localization Strings
1. Add key to `lib/l10n/app_ko.arb` (Korean)
2. Add translation to `lib/l10n/app_en.arb` (English)
3. Run `flutter gen-l10n` (or let IDE do it)
4. Use: `AppLocalizations.of(context)!.yourKey`

---

## 🐛 Debugging

### Firestore Sync Issues
Check console for log markers:
- `🔥` = Firestore operations
- `📡` = Stream emissions
- `🔍` = Filtering operations
- `📍` = Location calculations
- `✅` = Success
- `❌` = Errors

Files to check:
- `TruckRepository.watchTrucks()` - logs every snapshot
- `TruckRepository.updateStatus()` - logs before/after updates

### Build Errors
1. `flutter clean && flutter pub get`
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. Check for missing generated files (`.g.dart`, `.freezed.dart`)
4. Verify imports

---

## 🚨 Known Constraints

1. **Web Platform**:
   - Google Maps requires API key
   - Location permissions differ from mobile
   - Currently configured for Firebase Hosting

2. **Real-Time Sync**:
   - All status changes MUST go through Firestore
   - Never update UI without syncing backend
   - Owner identification via `users/{uid}.ownedTruckId`, NOT role field

3. **Code Generation**:
   - Missing `.g.dart` files will cause compile errors
   - Always run build_runner after schema changes

---

## 📝 Recent Improvements (Phase 1-4)

### Phase 1: Critical Fixes ✅
- Fixed FCM stream memory leaks
- Replaced unsafe `firstWhere` with `firstOrNull`
- Deleted backup files

### Phase 2: Performance Optimization ✅
- Fixed N+1 queries in analytics (8→2 Firestore calls)
- Added marker memoization
- Pre-computed color constants
- Added `itemExtent` to ListViews

### Phase 3: Code Quality ✅
- Created shared utilities: AppLogger, MarkerColors, FoodTypes, StatusTag, DateUtils
- Eliminated code duplication
- Centralized constants

### Phase 4: Localization ✅
- Replaced hardcoded Korean strings with AppLocalizations
- Added 11 new localization keys
- Consolidated StatusTag widget usage

**Next**: Phase 5 (Testing Infrastructure), Phase 6 (Documentation)

---

**End of Context**
