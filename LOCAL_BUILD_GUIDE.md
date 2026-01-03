# 로컬 빌드 & 배포 가이드

> **이 가이드대로 따라하면 로컬에서 빌드 → 테스트 → 배포까지 완료됩니다!**

---

## 🎯 빠른 시작

### 방법 1: 배치 파일 실행 (가장 쉬움)

**Windows에서 더블클릭만 하면 됩니다:**

1. `build-local.bat` - build_runner 실행 + analyze + 로컬 테스트
2. `build-wsl.sh` - WSL 웹 빌드 (Windows 빌드 버그 우회)
3. `deploy-firebase.bat` - Firebase 배포

### 방법 2: 수동 실행 (단계별 제어)

아래 단계별 가이드를 따라하세요.

---

## 📋 단계별 가이드

### 0️⃣ 사전 준비

```bash
# 프로젝트 디렉토리로 이동
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"

# 최신 코드 받기
git pull
```

---

### 1️⃣ build_runner 실행 (5분)

**필수!** `.freezed.dart`, `.g.dart` 파일 생성

```bash
"C:\Users\임현우\Downloads\flutter_windows_3.38.5-stable\flutter\bin\flutter.bat" pub run build_runner build --delete-conflicting-outputs
```

**예상 출력**:
```
[INFO] Generating build script completed, took 442ms
[INFO] Creating build script snapshot... completed, took 8.3s
[INFO] Building new asset graph... completed, took 5.1s
[INFO] Checking for updates since last build... completed, took 0.7s
[INFO] Running build completed, took 12.8s
[INFO] Succeeded after 27.0s with 123 outputs
```

---

### 2️⃣ flutter analyze (1분)

**코드 에러 확인**

```bash
"C:\Users\임현우\Downloads\flutter_windows_3.38.5-stable\flutter\bin\flutter.bat" analyze
```

**예상 출력**:
```
Analyzing truck_tracker...
No issues found! (ran in 3.2s)
```

**⚠️ 에러가 있으면**: 메시지를 복사해서 Claude에게 전달 → 바로 수정

---

### 3️⃣ 로컬 크롬 테스트 (10분)

**브라우저에서 앱 실행 & 테스트**

```bash
"C:\Users\임현우\Downloads\flutter_windows_3.38.5-stable\flutter\bin\flutter.bat" run -d chrome
```

**Chrome이 자동으로 열리고 앱이 실행됩니다!**

**테스트 체크리스트**:
- [ ] 로그인 화면이 정상 표시됨
- [ ] 지도가 정상 로드됨
- [ ] 트럭 목록이 표시됨
- [ ] 설정 > 도움말 메뉴 작동
- [ ] 설정 > 개인정보 처리방침 표시됨

**핫 리로드**:
- `r` 키: 빠른 새로고침 (코드 수정 후)
- `R` 키: 전체 재시작
- `q` 키: 종료

**⚠️ 에러가 있으면**: 콘솔 에러 메시지를 복사해서 Claude에게 전달

---

### 4️⃣ 생성된 파일 커밋 (2분)

**build_runner로 생성된 파일들을 Git에 저장**

```bash
# 변경 사항 확인
git status

# 모든 파일 스테이징
git add .

# 커밋
git commit -m "[Build] build_runner 실행 - 생성 파일 추가"

# 푸시
git push
```

**💡 Tip**: GitHub Actions가 자동으로 빌드를 다시 시도합니다!

---

### 5️⃣ WSL 웹 빌드 (10분)

**Windows에서 빌드하면 impellerc 버그로 크래시! 반드시 WSL 사용**

```bash
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"
```

**예상 출력**:
```
Compiling lib/main.dart for the Web...
Building without sound null safety
Generating main.dart.js... completed, took 45.3s
✓ Built build/web
```

**🚨 에러 발생 시**:
- `flutter: command not found` → WSL에 Flutter 설치 필요
- `impellerc crashed` → Windows에서 실행한 것! WSL에서 실행하세요

---

### 6️⃣ Windows로 복사 (1분)

**WSL 빌드 결과를 Windows 폴더로 복사**

```bash
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"
```

**확인**:
```bash
dir build\web
# index.html, flutter.js, main.dart.js 등이 있어야 함
```

---

### 7️⃣ Firebase 배포 (5분)

**프로덕션 배포!**

```bash
cd "C:\Users\임현우\Desktop\현우 작업폴더\truck_tracker\truck ver.1\truck_tracker"
npx firebase-tools deploy --only hosting
```

**예상 출력**:
```
=== Deploying to 'truck-tracker-fa0b0'...

i  deploying hosting
✔  hosting[truck-tracker-fa0b0]: file upload complete
✔  hosting[truck-tracker-fa0b0]: version finalized
✔  hosting[truck-tracker-fa0b0]: release complete

✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/truck-tracker-fa0b0/overview
Hosting URL: https://truck-tracker-fa0b0.web.app
```

**🎉 배포 완료!** https://truck-tracker-fa0b0.web.app 접속해서 확인

---

## 🚨 문제 해결

### build_runner 에러

```bash
# 캐시 삭제 후 재실행
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### WSL Flutter 설치 안 됨

```bash
# WSL Ubuntu에서 실행
wsl -d Ubuntu

# Flutter 설치 확인
flutter --version

# 없으면 설치
# https://docs.flutter.dev/get-started/install/linux
```

### Firebase 배포 실패

```bash
# Firebase 로그인 확인
npx firebase-tools login

# 프로젝트 확인
npx firebase-tools projects:list
```

---

## 📌 자주 사용하는 명령어

```bash
# Flutter 경로 (Windows)
set FLUTTER="C:\Users\임현우\Downloads\flutter_windows_3.38.5-stable\flutter\bin\flutter.bat"

# 단축 명령어
%FLUTTER% pub get                    # 패키지 설치
%FLUTTER% pub run build_runner build # 코드 생성
%FLUTTER% analyze                    # 코드 분석
%FLUTTER% run -d chrome              # 크롬에서 실행
%FLUTTER% run -d windows             # Windows 앱 실행 (대안)
```

---

## 🎯 완전 자동화 (배치 파일 사용)

**가장 쉬운 방법! 더블클릭만 하면 됩니다:**

1. **build-local.bat** 더블클릭
   - build_runner + analyze + 로컬 테스트
   - 에러 나면 중단, 성공하면 다음 단계 안내

2. **build-wsl.sh** (WSL에서 실행)
   - WSL 웹 빌드 + Windows 복사
   - 빌드 완료되면 deploy-firebase.bat 실행 안내

3. **deploy-firebase.bat** 더블클릭
   - Firebase 배포
   - 배포 완료되면 URL 표시

---

## ✅ 전체 플로우 요약

```
1. git pull
2. build-local.bat 실행 → 로컬 테스트
3. (성공하면) git add . && git commit && git push
4. wsl -d Ubuntu ./build-wsl.sh → WSL 빌드
5. deploy-firebase.bat 실행 → Firebase 배포
6. https://truck-tracker-fa0b0.web.app 확인
```

---

**마지막 업데이트**: 2026-01-03
**작성자**: Claude Code
