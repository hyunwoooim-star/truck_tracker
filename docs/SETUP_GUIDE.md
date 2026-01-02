# 개발 환경 구축 가이드

> 새 컴퓨터에서 Truck Tracker 개발 환경 세팅하기

---

## 1. 필수 설치

### 1-1. Git
```bash
# Windows
winget install Git.Git

# 설치 확인
git --version
```

### 1-2. Flutter SDK
1. https://flutter.dev/docs/get-started/install/windows 에서 다운로드
2. 압축 해제 (예: `C:\flutter`)
3. 환경변수 PATH에 추가: `C:\flutter\bin`
4. 확인:
```bash
flutter --version
flutter doctor
```

### 1-3. Node.js (Firebase CLI용)
```bash
winget install OpenJS.NodeJS.LTS

# 확인
node --version
npm --version
```

### 1-4. Firebase CLI
```bash
npm install -g firebase-tools

# 로그인
firebase login
```

### 1-5. WSL (웹 빌드용 - 필수!)
```bash
# PowerShell (관리자)
wsl --install -d Ubuntu

# 재부팅 후 Ubuntu 설정 (사용자명/비번)
```

WSL 안에서 Flutter 설치:
```bash
# Ubuntu 터미널에서
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git unzip xz-utils

# Flutter 설치
cd ~
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 확인
flutter --version
```

### 1-6. Claude Code
```bash
# npm으로 설치
npm install -g @anthropic-ai/claude-code

# 또는 직접 다운로드
# https://claude.ai/code
```

---

## 2. 프로젝트 클론

```bash
# 원하는 폴더에서
git clone https://github.com/hyunwoooim-star/truck_tracker.git
cd truck_tracker

# 의존성 설치
flutter pub get
```

---

## 3. Claude Code 권한 설정

`.claude/settings.local.json` 생성:
```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(flutter *)",
      "Bash(dart *)",
      "Bash(firebase *)",
      "Bash(npx firebase-tools *)",
      "Bash(wsl *)",
      "Bash(cd *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(rm *)",
      "Bash(mv *)",
      "Bash(start *)",
      "Bash(npm *)",
      "Bash(node *)",
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "WebFetch",
      "WebSearch"
    ],
    "deny": []
  }
}
```

---

## 4. WSL에 프로젝트 동기화

```bash
# WSL Ubuntu에서
cd ~
git clone https://github.com/hyunwoooim-star/truck_tracker.git
cd truck_tracker
flutter pub get
```

---

## 5. Firebase 프로젝트 연결

```bash
# 프로젝트 폴더에서
firebase login
firebase use truck-tracker-fa0b0
```

---

## 6. 빌드 & 배포 테스트

```bash
# 1. WSL에서 빌드
wsl -d Ubuntu -- bash -c "export PATH=\"\$HOME/flutter/bin:\$PATH\" && cd ~/truck_tracker && git pull && flutter build web --release"

# 2. Windows로 복사 (경로는 본인 환경에 맞게 수정)
wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/프로젝트경로/build/web/'"

# 3. 배포
npx firebase-tools deploy --only hosting
```

---

## 7. 개발 시작

```bash
cd truck_tracker
claude
```

그리고 말하기:
```
이어서 해줘
```

---

## 체크리스트

- [ ] Git 설치
- [ ] Flutter SDK 설치 + PATH
- [ ] Node.js 설치
- [ ] Firebase CLI 설치 + 로그인
- [ ] WSL Ubuntu 설치
- [ ] WSL에 Flutter 설치
- [ ] Claude Code 설치
- [ ] 프로젝트 클론 (Windows + WSL 둘 다)
- [ ] `.claude/settings.local.json` 생성
- [ ] `flutter pub get` 실행
- [ ] `firebase login` 완료

---

## 문제 해결

### Flutter doctor 에러
```bash
flutter doctor --android-licenses
```

### WSL 느림
```bash
# Windows Terminal 설정에서 GPU 가속 켜기
```

### Firebase 권한 에러
```bash
firebase login --reauth
```

---

**마지막 업데이트**: 2026-01-02
