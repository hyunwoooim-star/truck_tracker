# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-29

### Added

#### Core Features
- Real-time truck map with Google Maps integration
- Truck list with filtering (distance, rating, operating status, food type)
- Detailed truck information with menu, reviews, and location
- Order system with cart management
- QR code check-in for loyalty points
- Review system with photo uploads

#### User Authentication
- Email/password authentication
- Google Sign-In
- Kakao Login (structure ready, requires API key)
- Naver Login (structure ready, requires API key)

#### Social Features (Phase 11)
- Follow/unfollow trucks
- Following list in user profile
- Notification when followed trucks open

#### Coupon System (Phase 12)
- Coupon model and repository
- Coupon redemption flow
- Automatic expiration handling

#### Real-time Chat (Phase 13)
- 1:1 messaging between customers and owners
- Image sharing in chat
- Read receipts
- Chat list with unread count

#### Notifications (Phase 15)
- 9 notification types with individual settings
- Push notification via FCM
- In-app notification preferences

#### Owner Dashboard
- Business status toggle (open/closed)
- Real-time order management
- Daily sales statistics
- Weekly schedule management
- Analytics with charts (sales trends, popular items)
- CSV export for reports
- Announcement updates
- Talk (public chat) with customers

#### Cloud Functions (5 Functions)
- `notifyTruckOpening`: Notify followers when truck opens
- `notifyOrderStatus`: Order status change notifications
- `notifyCouponCreated`: New coupon notifications
- `notifyChatMessage`: Chat message notifications
- `notifyNearbyTrucks`: Location-based truck alerts

### Changed

#### Phase 17-18: Code Quality Improvements
- **SnackBarHelper**: Unified snackbar utility across 11 screens
  - Consistent styling (floating, color-coded)
  - Simplified maintenance
- **PasswordValidator**: Comprehensive password validation
  - Different rules for login vs signup
  - Strength evaluation
- **OrderRepository**: Performance optimization
  - `watchUserOrders`: Limited to 100 orders
  - `watchTruckOrders`: Limited to 50 orders
- **AppTheme**: Pre-computed opacity constants
  - Replaced 6 runtime `withOpacity()` calls
  - Improved rendering performance

### Security
- Firestore security rules (192 lines)
- Password complexity requirements (8+ chars, mixed case, numbers, special chars)
- `kDebugMode` protection for test buttons
- CORS whitelist for Cloud Functions
- User input validation at all boundaries

### Documentation
- `USER_GUIDE.md`: Customer and owner manual
- `OPERATIONS_GUIDE.md`: System administrator guide
- `CLOUD_FUNCTIONS_DEPLOYMENT_GUIDE.md`: Functions deployment instructions
- `PROJECT_AUDIT_REPORT.md`: Comprehensive security audit
- `PHASE_16-20_SECURITY_AND_QUALITY.md`: Production roadmap

### Tests
- 47+ unit tests
- Widget tests for SnackBarHelper
- Order model unit tests
- Password validator tests

### Performance
- Firestore query limits prevent excessive data loading
- Pre-computed color constants
- Lazy loading for images with CachedNetworkImage
- Efficient list rendering with ListView.builder

---

## Development History

### Phase 1-10: Foundation (2025-12-26 ~ 12-27)
- Phase 1: Critical bug fixes (memory leaks, crashes)
- Phase 2: Performance optimization (queries, caching)
- Phase 3: Code quality (logging, duplicate removal)
- Phase 4: Localization (Korean/English)
- Phase 5: Testing infrastructure
- Phase 6: Documentation
- Phase 7: Production readiness
- Phase 8: Advanced features (schedules, review photos, analytics)
- Phase 9: Order system enhancement
- Phase 10: Advanced search and filter

### Phase 11-15: Social & Communication (2025-12-27 ~ 12-28)
- Phase 11: Follow system
- Phase 12: Coupon system
- Phase 13: Real-time chat
- Phase 14: Payment integration (planned)
- Phase 15: Notification preferences

### Phase 16-20: Production Polish (2025-12-28 ~ 12-29)
- Phase 16: Security hardening
- Phase 17: Cloud Functions deployment
- Phase 18: Code quality improvements
- Phase 19: Test coverage expansion
- Phase 20: Final documentation

---

**Live Site**: https://truck-tracker-fa0b0.web.app
**Repository**: https://github.com/hyunwoooim-star/truck_tracker
**Firebase Project**: truck-tracker-fa0b0
