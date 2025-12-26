# 🔥 Firestore Setup Guide - 트럭아저씨

## ✅ Phase 1: Model Preparation (COMPLETED)

This document tracks the Firestore integration preparation for the Truck Tracker app.

---

## 📦 Dependencies Added

### Firebase Core Packages:
```yaml
dependencies:
  cloud_firestore: ^6.1.1
  firebase_auth: ^6.1.3
  firebase_core: ^4.3.0
```

**Installation**: ✅ Completed via `flutter pub add`

---

## 🏗️ Model Updates

All domain models have been updated with Firestore compatibility while maintaining existing mock data functionality.

### 1. Truck Model
**File**: `lib/features/truck_list/domain/truck.dart`

**Added Methods**:
- ✅ `fromFirestore(DocumentSnapshot doc)` - Read from Firestore
- ✅ `toFirestore()` - Write to Firestore
- ✅ `_statusFromString(String)` - Helper for enum conversion

**Features**:
- Handles document ID mapping
- Safe null handling with defaults
- Preserves existing JSON serialization
- Status enum conversion (onRoute, resting, maintenance)

**Example**:
```dart
// Read from Firestore
final truck = Truck.fromFirestore(docSnapshot);

// Write to Firestore
await trucksCollection.doc(truck.id).set(truck.toFirestore());
```

---

### 2. TruckDetail Model
**File**: `lib/features/truck_detail/domain/truck_detail.dart`

**Added Methods**:
- ✅ `fromFirestore(DocumentSnapshot doc)` - Read from Firestore
- ✅ `toFirestore()` - Write to Firestore

**Features**:
- Nested list handling (menuItems, reviews)
- Automatic sub-model deserialization
- Default values for missing fields

---

### 3. TruckReview Model
**File**: `lib/features/truck_detail/domain/truck_review.dart`

**Added Methods**:
- ✅ `fromFirestore(DocumentSnapshot doc)` - Read from Firestore
- ✅ `toFirestore()` - Write to Firestore

**Features**:
- DateTime ↔ Timestamp conversion
- Firestore Timestamp handling
- Safe date parsing with fallback

**Example**:
```dart
// Firestore stores dates as Timestamp
createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()

// Convert back to Timestamp
'createdAt': Timestamp.fromDate(createdAt)
```

---

### 4. MenuItem Model
**File**: `lib/features/truck_detail/domain/menu_item.dart`

**Status**: ✅ No changes needed
- Already has JSON serialization
- Simple structure works with Firestore
- Used as nested objects in TruckDetail

---

## 🏛️ Model Architecture

### Dual Serialization Support:
```dart
class Truck with _$Truck {
  const Truck._();  // Private constructor for custom methods
  
  // JSON (for API/Mock data)
  factory Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);
  
  // Firestore (for real-time database)
  factory Truck.fromFirestore(DocumentSnapshot doc) { ... }
  Map<String, dynamic> toFirestore() { ... }
}
```

**Benefits**:
- ✅ Mock data continues to work unchanged
- ✅ Easy migration to Firestore when ready
- ✅ No breaking changes to existing code
- ✅ Type-safe with Freezed
- ✅ Null-safe with proper defaults

---

## 🔨 Build Status

### Build Runner:
```bash
✅ Built with build_runner in 32s
✅ Wrote 16 outputs
✅ All models regenerated successfully
```

### Flutter Analyze:
```bash
✅ No errors found
⚠️ 34 deprecation warnings (cosmetic)
✅ Project builds correctly
```

**Warnings**: Only deprecation warnings about `withOpacity` → `.withValues()` (Flutter 3.31+)

---

## 📝 Firestore Data Structure (Proposed)

### Trucks Collection
```
trucks/
  ├── {truckId}/
  │   ├── truckNumber: String
  │   ├── driverName: String
  │   ├── status: String ("onRoute" | "resting" | "maintenance")
  │   ├── foodType: String
  │   ├── locationDescription: String
  │   ├── latitude: Number
  │   ├── longitude: Number
  │   ├── isFavorite: Boolean
  │   └── imageUrl: String
```

### Truck Details Subcollection
```
trucks/{truckId}/details/
  └── info/
      ├── operatingHours: String
      ├── menuItems: Array<MenuItem>
      ├── reviews: Array<TruckReview>
      ├── averageRating: Number
      └── description: String
```

---

## 🚀 Next Steps (Not Implemented Yet)

### Phase 2: Firebase Configuration
1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project: "트럭아저씨"
   - Enable Firestore Database

2. **Android Configuration**
   ```bash
   # Download google-services.json
   # Place in: android/app/google-services.json
   ```

3. **iOS Configuration**
   ```bash
   # Download GoogleService-Info.plist
   # Place in: ios/Runner/GoogleService-Info.plist
   ```

4. **Web Configuration**
   ```dart
   // Add to web/index.html
   // Firebase SDK configuration
   ```

### Phase 3: Firebase Initialization
```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

### Phase 4: Firestore Repository
Create repository layer:
```dart
class TruckRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<List<Truck>> watchTrucks() {
    return _firestore
        .collection('trucks')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Truck.fromFirestore(doc))
            .toList());
  }
  
  Future<void> updateTruck(Truck truck) async {
    await _firestore
        .collection('trucks')
        .doc(truck.id)
        .set(truck.toFirestore());
  }
}
```

### Phase 5: Real-time Updates
Replace mock provider with Firestore stream:
```dart
@riverpod
Stream<List<Truck>> truckList(TruckListRef ref) {
  final repository = ref.watch(truckRepositoryProvider);
  return repository.watchTrucks();
}
```

---

## ✅ Current Status Summary

| Task | Status | Notes |
|------|--------|-------|
| Add Firebase dependencies | ✅ | cloud_firestore, firebase_auth, firebase_core |
| Update Truck model | ✅ | fromFirestore & toFirestore methods |
| Update TruckDetail model | ✅ | With nested models support |
| Update TruckReview model | ✅ | Timestamp conversion |
| Run build_runner | ✅ | All code generated |
| Verify no breaking changes | ✅ | Mock data still works |
| Linter check | ✅ | No errors |

---

## 🎯 Migration Strategy

### Backward Compatible:
```dart
// Current (Mock Data)
final trucks = ref.watch(truckListNotifierProvider);

// Future (Firestore)
final trucks = ref.watch(firestoreTruckListProvider);
```

**The app will continue working with mock data until you're ready to switch to Firestore!**

---

## 📚 References

- [Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

---

## 🔐 Security Rules (For Future)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Trucks collection - Public read, Owner write
    match /trucks/{truckId} {
      allow read: if true;
      allow write: if request.auth != null && 
                     request.auth.uid == resource.data.ownerId;
    }
  }
}
```

---

## 📊 Testing Checklist

- [x] Models compile without errors
- [x] Existing mock data works
- [x] Build runner succeeds
- [x] No linter errors
- [x] App runs with current functionality
- [ ] Firebase project created (Next phase)
- [ ] Firestore initialized (Next phase)
- [ ] Real-time sync tested (Next phase)

---

**Status**: ✅ **READY FOR FIRESTORE INTEGRATION**

The app is now fully prepared for Firestore integration without breaking any existing functionality. Mock data continues to work perfectly while you set up Firebase.





