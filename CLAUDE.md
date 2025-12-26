# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Truck Tracker is a Flutter-based real-time food truck tracking application with a "Baemin-style" design. The app supports two user roles: **customers** who track trucks, and **owners** who manage their trucks.

## Development Commands

### Building and Running
```bash
# Run the app in development mode
flutter run -d chrome  # For web
flutter run            # For default device

# Build for production
flutter build web
flutter build apk      # Android
flutter build ios      # iOS

# Clean build artifacts
flutter clean
flutter pub get
```

### Code Generation
The project uses `freezed`, `riverpod_generator`, and `json_serializable` for code generation:

```bash
# Generate all code (models, providers, serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

**IMPORTANT**: After modifying any file with `@freezed`, `@riverpod`, or `@JsonSerializable` annotations, you **must** run build_runner.

### Testing and Linting
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Analyze code for issues
flutter analyze
```

## Architecture

### Tech Stack
- **Framework**: Flutter (Dart 3.10.4+)
- **State Management**: Riverpod 2.6.1 with `@riverpod` generator annotations
- **Backend**: Firebase (Firestore, Auth, Storage)
- **Architecture Pattern**: Feature-based Clean Architecture (data/domain/presentation layers)
- **Immutability**: Freezed for all domain models
- **Maps**: Google Maps Flutter
- **Location**: Geolocator for GPS tracking

### Project Structure

```
lib/
├── core/
│   ├── themes/          # AppTheme (Electric Blue + Midnight Charcoal)
│   ├── constants/       # App-wide constants
│   └── network_client/  # Shared network configuration
├── features/
│   ├── auth/            # Firebase Authentication (email, Google prepared)
│   ├── truck_list/      # Customer view: Browse trucks
│   ├── truck_map/       # Real-time map with truck markers
│   ├── truck_detail/    # Truck details, menu, reviews
│   ├── owner_dashboard/ # Owner view: Manage truck status, schedule
│   ├── favorite/        # Favorite trucks management
│   ├── location/        # GPS location services
│   ├── review/          # Review system
│   ├── schedule/        # Daily schedule management
│   ├── analytics/       # Owner analytics
│   └── storage/         # Firebase Storage (image uploads)
├── firebase_options.dart
└── main.dart
```

### Feature Structure (Clean Architecture)
Each feature follows this pattern:
```
features/<feature_name>/
├── data/
│   └── *_repository.dart    # Firestore data access
├── domain/
│   └── *.dart               # Freezed models, business logic
└── presentation/
    ├── *_provider.dart      # Riverpod state management
    └── *_screen.dart        # UI widgets
```

## Key Architectural Patterns

### 1. Firestore Real-Time Sync
The app uses Firestore **streams** (not snapshots) for real-time updates:
- `TruckRepository.watchTrucks()` returns `Stream<List<Truck>>`
- Providers consume streams using `@riverpod Stream<T>` pattern
- Map markers update automatically when truck location/status changes in Firestore

**Critical**: Truck status changes (`onRoute`, `resting`, `maintenance`) must update Firestore to reflect on all connected clients in real-time.

### 2. Authentication Flow
- Entry point: `AuthWrapper` in `main.dart`
- Checks if user is authenticated → Yes/No
- If authenticated, checks `users/{uid}.ownedTruckId` in Firestore
  - Has `ownedTruckId` → Navigate to `OwnerDashboardScreen`
  - No `ownedTruckId` → Navigate to `TruckListScreen` (customer)
- If not authenticated → Show `LoginScreen`

### 3. Freezed Models
All domain models use Freezed for immutability:
```dart
@freezed
class Truck with _$Truck {
  const Truck._();
  const factory Truck({...}) = _Truck;

  // Custom methods for Firestore
  factory Truck.fromFirestore(DocumentSnapshot doc) {...}
  Map<String, dynamic> toFirestore() {...}
}
```

**Pattern**: Always include `fromFirestore()` and `toFirestore()` methods for Firestore integration.

### 4. Riverpod Providers with @riverpod
This project uses **Riverpod Generator** (`@riverpod` annotations), NOT manual provider declarations:

```dart
// Stream provider for Firestore real-time data
@riverpod
Stream<List<Truck>> firestoreTruckStream(FirestoreTruckStreamRef ref) {
  final repository = ref.watch(truckRepositoryProvider);
  return repository.watchTrucks();
}

// Notifier for state management
@riverpod
class TruckFilterNotifier extends AutoDisposeNotifier<TruckFilterState> {
  @override
  TruckFilterState build() => const TruckFilterState();

  void setSelectedTag(String tag) {
    state = state.copyWith(selectedTag: tag);
  }
}
```

**IMPORTANT**: After creating/modifying `@riverpod` providers, run `build_runner` to generate `.g.dart` files.

### 5. Location-Based Features
- `LocationService` provides GPS position using Geolocator
- `filteredTrucksWithDistance` provider enriches trucks with distance calculations
- Distance is calculated using Haversine formula in `LocationService.calculateDistance()`
- Trucks can be sorted by distance, name, or rating (via `SortOptionNotifier`)

## Firebase Integration

### Collections Structure
```
trucks/
  {truckId}/
    - truckNumber: string
    - driverName: string
    - status: enum (onRoute|resting|maintenance)
    - foodType: string
    - latitude: number
    - longitude: number
    - ownerEmail: string
    - menuItems: array

users/
  {userId}/
    - uid: string
    - email: string
    - displayName: string
    - role: string (customer|owner)
    - ownedTruckId: number? (null for customers)
```

### Real-Time Updates Pattern
1. Owner changes truck status in `OwnerDashboardScreen`
2. Calls `TruckRepository.updateStatus(truckId, newStatus)`
3. Updates Firestore: `trucks/{truckId}.status = newStatus`
4. Firestore triggers snapshot listeners
5. `firestoreTruckStreamProvider` emits new truck list
6. UI (map markers, truck cards) auto-updates via `ref.watch()`

### Firebase Services
- **Auth**: `lib/features/auth/data/auth_service.dart`
- **Storage**: `lib/features/storage/image_upload_service.dart` (for truck/menu photos)
- **Firestore**: Each feature has its own repository (e.g., `TruckRepository`, `ReviewRepository`)

## UI/UX Guidelines

### Theme
- **Primary Color**: Electric Blue (`#00D4FF`) - referenced as `AppTheme.electricBlue` or legacy `AppTheme.baeminMint`
- **Background**: Midnight Charcoal (`#1A1A1A`) - `AppTheme.midnightCharcoal`
- **Design**: Dark theme with high contrast, hip and clean aesthetic

### Performance Optimization
From `.cursorrules.md`:
1. **Use `const` constructors** wherever possible for static widgets
2. **List optimization**: Use `ListView.builder` with `itemExtent` or `prototypeItem`
3. **Map performance**: Wrap map markers in `RepaintBoundary` to isolate repaints
4. **Optimistic UI**: Status changes should update UI immediately, then sync with Firestore

### Common Patterns
- Loading states: Use `AsyncValue.when()` for data/loading/error states
- Optimistic updates: Update local state first, rollback on error (see `TruckListNotifier.toggleFavorite()`)
- Real-time indicators: Show connection status for Firestore streams

## Common Development Tasks

### Adding a New Feature
1. Create feature directory: `lib/features/<feature_name>/`
2. Add domain models with Freezed: `domain/*.dart`
3. Create repository for data access: `data/*_repository.dart`
4. Build providers with `@riverpod`: `presentation/*_provider.dart`
5. Implement UI screens: `presentation/*_screen.dart`
6. Run `build_runner build` to generate code

### Modifying Truck Model
If you add fields to `Truck`:
1. Update `lib/features/truck_list/domain/truck.dart`
2. Update `fromFirestore()` and `toFirestore()` methods
3. Run `build_runner build --delete-conflicting-outputs`
4. Update Firestore security rules if needed
5. Migrate existing Firestore data if breaking change

### Debugging Firestore Sync
The repository has extensive logging:
- `TruckRepository.watchTrucks()` logs every snapshot received
- `TruckRepository.updateStatus()` logs before/after Firestore calls
- Providers log when they receive/emit data

Check console for these markers:
- `🔥` = Firestore operations
- `📡` = Stream emissions
- `🔍` = Filtering operations
- `📍` = Location calculations
- `✅` = Success, `❌` = Errors

## Known Constraints

### Authentication Methods
- **Implemented**: Email/Password
- **Prepared but not functional**: Google Sign-In (requires web configuration), Kakao, Naver
- Check `auth_service.dart` for implementation status

### Web Platform
- Currently configured for web deployment via Firebase Hosting
- Google Maps requires API key configuration
- Location permissions handled differently on web vs mobile

## Important Notes

1. **Never skip build_runner**: Generated files (`.freezed.dart`, `.g.dart`) are required for compilation
2. **Firestore is the source of truth**: All real-time features depend on Firestore streams, not local state
3. **Owner identification**: Owners are identified by `users/{uid}.ownedTruckId`, NOT by a role field alone
4. **Real-time sync**: Status changes must go through Firestore, not just local state, for multi-device sync
5. **Image uploads**: Use `ImageUploadService` for Firebase Storage operations
6. **GPS permissions**: Request location permissions appropriately per platform (see `LocationService`)
