# 🚚 Truck Tracker (트럭아저씨)

**Real-time Food Truck Tracking Application**

A Flutter-based mobile and web application for tracking food trucks in real-time, designed with a modern dark theme inspired by Baemin's aesthetic.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-00D4FF)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
- [Development](#-development)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### For Customers 👥
- 🗺️ **Real-time Map**: View all active food trucks on an interactive Google Map
- 🔍 **Smart Search**: Search by truck name, driver, food type, or location
- 🏷️ **Category Filters**: Browse trucks by food type (닭꼬치, 호떡, 어묵, etc.)
- ⭐ **Favorites**: Save your favorite trucks for quick access
- 📍 **GPS Tracking**: See distance to nearby trucks from your location
- 💬 **Reviews**: Rate and review trucks with photos
- 📱 **QR Check-in**: Scan truck QR codes to earn loyalty points
- 🔔 **Push Notifications**: Get notified when favorite trucks start operating

### For Truck Owners 🚛
- 📊 **Dashboard**: Manage truck status, schedule, and analytics
- 🟢 **Business Controls**: Start/stop business with one tap
- 📅 **Schedule Management**: Set daily operating hours and locations
- 📈 **Analytics**: Track views, clicks, reviews, and revenue
- 💵 **Cash Sale Logging**: Record cash transactions for accounting
- 🔔 **Customer Notifications**: Automatically notify followers when opening
- 💬 **Customer Chat**: Communicate with customers directly
- 📋 **Order Management**: View and manage customer orders

---

## 📱 Screenshots

> *Coming soon - Add screenshots of truck map, list view, owner dashboard*

---

## 🏗️ Architecture

### Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.x (Dart 3.10.4+) |
| **State Management** | Riverpod 2.6.1 (Generator) |
| **Backend** | Firebase (Firestore, Auth, Storage, FCM) |
| **Maps** | Google Maps Flutter |
| **Location** | Geolocator 14.0.2 |
| **Code Generation** | Freezed, Riverpod Generator, JSON Serializable |
| **Architecture Pattern** | Clean Architecture (Feature-based) |

### Project Structure

```
lib/
├── core/
│   ├── themes/              # AppTheme (Electric Blue + Dark)
│   ├── constants/           # FoodTypes, MarkerColors
│   └── utils/              # AppLogger, DateUtils
├── shared/
│   └── widgets/            # Reusable UI components
├── features/
│   ├── auth/               # Firebase Authentication
│   ├── truck_list/         # Browse trucks (Customer)
│   ├── truck_map/          # Real-time map view
│   ├── truck_detail/       # Truck details, menu, reviews
│   ├── owner_dashboard/    # Owner control panel
│   ├── favorite/           # Favorites management
│   ├── checkin/            # QR check-in system
│   ├── analytics/          # Owner analytics
│   ├── notifications/      # FCM push notifications
│   └── [13 features total]
└── main.dart
```

Each feature follows **Clean Architecture**:
```
features/<name>/
├── data/          # Repositories (Firestore access)
├── domain/        # Models (Freezed)
└── presentation/  # Providers (Riverpod) + Screens (UI)
```

### Key Patterns

1. **Real-time Sync**: Firestore streams power live updates
2. **Immutability**: All models use Freezed
3. **Code Generation**: `@riverpod` annotations for providers
4. **Performance**: Marker caching, pre-computed colors, ListView optimization
5. **Localization**: Korean + English via ARB files

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.10.4 or higher
  ```bash
  flutter --version
  ```
- **Dart SDK**: 3.10.4 or higher (included with Flutter)
- **Firebase CLI**: For Firebase configuration
  ```bash
  npm install -g firebase-tools
  ```
- **Git**: For version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/hyunwoooim-star/truck_tracker.git
   cd truck_tracker/truck\ ver.1/truck_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Freezed, Riverpod, JSON)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Firebase**
   - Create a Firebase project at [firebase.google.com](https://firebase.google.com)
   - Enable Firestore, Authentication, Storage, and Cloud Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories
   - Generate `firebase_options.dart`:
     ```bash
     flutterfire configure
     ```

5. **Set up Google Maps**
   - Get API key from [Google Cloud Console](https://console.cloud.google.com)
   - Enable Maps SDK for Android/iOS/Web
   - Add key to:
     - Android: `android/app/src/main/AndroidManifest.xml`
     - iOS: `ios/Runner/AppDelegate.swift`
     - Web: `web/index.html`

6. **Run the app**
   ```bash
   # Web
   flutter run -d chrome

   # Mobile (select device)
   flutter run

   # Specific device
   flutter devices
   flutter run -d <device-id>
   ```

---

## 💻 Development

### Common Commands

```bash
# Run in dev mode
flutter run -d chrome

# Build for production
flutter build web
flutter build apk
flutter build ios

# Clean build artifacts
flutter clean
flutter pub get

# Code generation (after modifying @freezed, @riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs

# Analyze code
flutter analyze

# Format code
dart format lib/ test/
```

### Adding a New Feature

1. Create feature directory: `lib/features/<feature_name>/`
2. Add domain models with Freezed: `domain/*.dart`
3. Create repository: `data/*_repository.dart`
4. Build providers with `@riverpod`: `presentation/*_provider.dart`
5. Implement UI: `presentation/*_screen.dart`
6. Run `build_runner build`
7. Add tests in `test/unit/features/<feature_name>/`

### Code Standards

- **Use `const` constructors** wherever possible
- **No hardcoded strings**: Use `AppLocalizations.of(context)!.key`
- **Firestore integration**: Include `fromFirestore()` and `toFirestore()` in models
- **Performance**: Cache expensive computations (markers, filters)
- **Error handling**: Use `AsyncValue.when()` for loading/error states

---

## 🧪 Testing

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/unit/core/utils/date_utils_test.dart

# With coverage report
flutter test --coverage
```

### Test Structure

```
test/
├── unit/                  # Unit tests for logic
│   ├── core/
│   │   ├── constants/    # FoodTypes, MarkerColors
│   │   └── utils/        # DateUtils
│   └── features/
│       └── [repositories, services]
├── widget/               # Widget tests
│   └── status_tag_test.dart
└── integration/          # E2E tests (future)
```

### Current Coverage

- **60+ individual tests** across 4 test files
- Coverage: Utilities, constants, shared widgets
- Target: 60%+ code coverage

---

## 📦 Deployment

### Web Deployment (Firebase Hosting)

1. **Build for web**
   ```bash
   flutter build web
   ```

2. **Deploy to Firebase Hosting**
   ```bash
   firebase deploy --only hosting
   ```

3. **Access at**: `https://<project-id>.web.app`

### Android Deployment

1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle** (for Play Store)
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Google Play Console**

### iOS Deployment

1. **Build iOS app**
   ```bash
   flutter build ios --release
   ```

2. **Open in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

3. **Archive and upload to App Store Connect**

---

## 🔐 Environment Variables

**Never commit these files**:
- `google-services.json`
- `GoogleService-Info.plist`
- `firebase_options.dart`
- `.env` files

Add them to `.gitignore` and store securely.

---

## 📊 Firestore Schema

### Collections

#### `trucks/`
```javascript
{
  truckNumber: "BM-001",
  driverName: "김사장",
  status: "onRoute",              // onRoute | resting | maintenance
  foodType: "닭꼬치",
  latitude: 37.5665,
  longitude: 126.9780,
  isOpen: true,
  announcement: "오늘 30% 할인!",
  menuItems: [{name, price, imageUrl, isSoldOut}],
  // ... timestamps
}
```

#### `users/`
```javascript
{
  uid: "firebase_uid",
  email: "user@example.com",
  displayName: "홍길동",
  role: "customer",               // customer | owner
  ownedTruckId: "1",              // null for customers
  favoriteTrucks: ["1", "3"],
  fcmToken: "...",
}
```

#### `reviews/`, `checkins/`, `analytics/{truckId}/daily/{date}`
See [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) for complete schema.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Code Review Checklist

- [ ] Code follows project style guide
- [ ] All tests pass (`flutter test`)
- [ ] No hardcoded strings (use localization)
- [ ] Generated code updated (`build_runner build`)
- [ ] Documentation updated (if API changes)
- [ ] Commit message follows convention

---

## 📚 Documentation

- **[CLAUDE.md](CLAUDE.md)**: Behavioral rules and workflow for AI development
- **[PROJECT_CONTEXT.md](PROJECT_CONTEXT.md)**: Detailed architecture and Firebase schema
- **[ANALYSIS.md](ANALYSIS.md)**: Code analysis and known issues
- **[IMPROVEMENT_PLAN.md](IMPROVEMENT_PLAN.md)**: Multi-phase improvement roadmap

---

## 🐛 Known Issues

- Google Sign-In requires additional web configuration
- Kakao/Naver login prepared but not functional
- FCM Cloud Function needs implementation (see Phase 6)

See [ANALYSIS.md](ANALYSIS.md) for complete list.

---

## 📈 Changelog

### Phase 1-6 Improvements (Dec 2025)
- ✅ **Phase 1**: Fixed memory leaks, crash risks
- ✅ **Phase 2**: N+1 query optimization, performance improvements
- ✅ **Phase 3**: Code quality cleanup, shared utilities
- ✅ **Phase 4**: Localization (Korean + English)
- ✅ **Phase 5**: Testing infrastructure (60+ tests)
- ✅ **Phase 6**: Documentation & polish

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**임현우** (Hyunwoo Im)
- GitHub: [@hyunwoooim-star](https://github.com/hyunwoooim-star)

---

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Riverpod** for clean state management
- **Firebase** for backend infrastructure
- **Claude Code** for development assistance

---

## 📞 Support

For questions or issues:
- Open an [Issue](https://github.com/hyunwoooim-star/truck_tracker/issues)
- Email: support@truckajeossi.com (placeholder)

---

**Built with ❤️ using Flutter**
