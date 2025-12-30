# 🌐 Web Deployment Plan - Shader Issue Resolution

**Created**: 2025-12-28
**Status**: 🔴 Blocked by ShaderCompilerException
**Priority**: High

---

## 🔍 Problem Analysis

### Current Error
```
ShaderCompilerException: Shader compilation of "ink_sparkle.frag" failed with exit code -1073741819
Path: flutter_windows_3.38.5-stable\bin\cache\artifacts\engine\windows-x64\impellerc.exe
impellerc stdout: [empty]
impellerc stderr: [empty]
```

### Root Cause
- **Flutter Version**: 3.38.5-stable (likely non-existent version - probable typo)
- **Component**: Impeller shader compiler (impellerc.exe)
- **Shader**: `ink_sparkle.frag` (Material 3 ink sparkle effect)
- **Exit Code**: -1073741819 (0xC0000005 = Access Violation in Windows)

### Why It Happens
1. **Impeller Compiler Bug**: Flutter 3.38.x is likely a non-standard version (official stable is 3.27.x as of Jan 2025)
2. **Material 3 Shaders**: `ink_sparkle.frag` is part of Material 3 ripple effects
3. **Windows-Specific**: impellerc.exe crashes during web shader compilation
4. **Web-Only Issue**: Android/iOS use different rendering paths (Skia/Impeller native)

---

## 🎯 Solution Options (Ranked by Feasibility)

### ✅ Option 1: Upgrade to Latest Stable Flutter (Recommended)

**Action**:
```bash
# Check current version
flutter --version

# Upgrade to latest stable (3.27.x or later)
flutter upgrade --force

# Clean rebuild
flutter clean
flutter pub get
flutter build web --release
```

**Pros**:
- Official stable release with bug fixes
- Better Material 3 support
- Long-term maintainability
- Active community support

**Cons**:
- May require dependency updates
- Potential breaking changes (unlikely for 3.x → 3.y)

**Success Probability**: 85%

---

### ✅ Option 2: Disable Impeller for Web (Workaround)

**Action**:
```bash
# Use CanvasKit renderer with Skia (bypasses Impeller)
flutter build web --release --web-renderer canvaskit --no-tree-shake-icons
```

**Add to `web/index.html`**:
```html
<script>
  window.flutterConfiguration = {
    renderer: "canvaskit",
  };
</script>
```

**Pros**:
- Immediate fix without version change
- Proven stable for web
- No code changes required

**Cons**:
- Larger bundle size (~2MB CanvasKit WASM)
- Slightly slower initial load
- Impeller optimizations unavailable

**Success Probability**: 95%

---

### ⚠️ Option 3: Downgrade to Flutter 3.24.x

**Action**:
```bash
# Switch to stable 3.24 channel
flutter downgrade 3.24.5

# Clean rebuild
flutter clean
flutter pub get
flutter build web --release
```

**Pros**:
- Known stable version for web
- Avoids experimental features

**Cons**:
- Outdated platform features
- May conflict with dependencies (firebase_* packages)
- Not future-proof

**Success Probability**: 70%

---

### ⚠️ Option 4: Patch Material 3 Usage

**Action**:
Remove or replace widgets using ink sparkle effects:
```dart
// In MaterialApp (lib/main.dart)
theme: ThemeData(
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory, // ← Disable ink sparkle
),
```

**Pros**:
- Surgical fix
- No Flutter version change

**Cons**:
- Removes visual effects
- User experience degradation
- May not fix all shader issues

**Success Probability**: 60%

---

## 📋 Recommended Implementation Plan

### Phase 1: Verify Flutter Version (5 min)
```bash
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"
flutter --version
flutter doctor -v
```

**Expected Output**: Confirm if version is truly 3.38.5 or misread (likely 3.27.x or 3.24.x)

---

### Phase 2: Try Option 2 First (CanvasKit Renderer) - 10 min

**Why Start Here**:
- Zero risk (no version changes)
- Fastest to test
- High success rate

**Steps**:
1. Add renderer config to `web/index.html`:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
     ...
     <script>
       window.flutterConfiguration = {
         renderer: "canvaskit",
       };
     </script>
   </head>
   ```

2. Build with explicit renderer:
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release --web-renderer canvaskit
   ```

3. Test locally:
   ```bash
   cd build/web
   python -m http.server 8000
   # Open http://localhost:8000
   ```

4. If successful → Deploy to Firebase:
   ```bash
   firebase deploy --only hosting
   ```

---

### Phase 3: If Phase 2 Fails → Upgrade Flutter (30 min)

**Steps**:
1. Backup current version:
   ```bash
   flutter --version > flutter_version_backup.txt
   ```

2. Upgrade to latest stable:
   ```bash
   flutter upgrade --force
   flutter --version  # Verify upgrade
   ```

3. Update dependencies:
   ```bash
   flutter pub upgrade
   flutter pub get
   ```

4. Regenerate code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Test build:
   ```bash
   flutter build web --release
   ```

6. Run tests:
   ```bash
   flutter test
   ```

7. If tests pass → Deploy

---

### Phase 4: If Both Fail → Disable Material 3 Effects (15 min)

**Modify `lib/main.dart`**:
```dart
MaterialApp.router(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    splashFactory: NoSplash.splashFactory, // ← Add this
  ),
  ...
)
```

**Build and test**:
```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## 🧪 Verification Checklist

After successful build:

- [ ] Web build completes without ShaderCompilerException
- [ ] Local test server shows app correctly (`python -m http.server`)
- [ ] Firebase deployment succeeds (`firebase deploy --only hosting`)
- [ ] Live site loads at: `https://truck-tracker-fa0b0.web.app`
- [ ] Critical features work:
  - [ ] Google Maps rendering
  - [ ] Authentication (Google Sign-In)
  - [ ] Firestore real-time updates
  - [ ] Image loading
  - [ ] Responsive layout (mobile/desktop)
- [ ] Performance check:
  - [ ] First Contentful Paint < 2s
  - [ ] Time to Interactive < 4s
  - [ ] No console errors in browser DevTools

---

## 📊 Known Issues (Post-Deployment)

### Web Platform Limitations (Not Blockers)
1. **Mobile Scanner**: QR scanning requires native camera API
   - **Workaround**: Show "Use mobile app for QR check-in"

2. **Geolocator**: Browser geolocation has accuracy ~10-50m
   - **Impact**: Location descriptions may be less precise

3. **Firebase Messaging (FCM)**: Web push requires HTTPS + service worker
   - **Status**: Already configured in `web/firebase-messaging-sw.js`

4. **Image Picker**: Web uses file input dialog (not native gallery)
   - **Impact**: Different UX than mobile

---

## 🚀 Next Steps

1. **Immediate** (This Session):
   - Execute Phase 1: Verify Flutter version
   - Execute Phase 2: Try CanvasKit renderer
   - Update CURRENT_STATUS.md with results

2. **Next Session** (If Needed):
   - Execute Phase 3: Upgrade Flutter if Phase 2 failed
   - Complete Phase 4: Material 3 workaround as last resort
   - Full deployment verification

3. **Future Improvements**:
   - Set up CI/CD (GitHub Actions) for automatic web builds
   - Add web-specific error tracking (Sentry)
   - Optimize bundle size (tree-shaking, code splitting)

---

## 📞 Emergency Rollback

If deployment breaks production:

```bash
# Revert to last working commit
git log --oneline -n 5  # Find last working commit
git revert <commit-hash>
git push origin main

# Redeploy previous version
firebase deploy --only hosting
```

**Previous Working State**: Phase 9 completed (Android/iOS functional)

---

**Last Updated**: 2025-12-28
**Owner**: Claude + 임현우
**Status**: Ready for Phase 1 execution
