#!/bin/bash

echo "================================"
echo " WSL 웹 빌드 스크립트"
echo "================================"
echo ""

# Flutter PATH 설정
export PATH="$HOME/flutter/bin:$PATH"

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Flutter 설치 확인
echo "[1/5] Flutter 설치 확인..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter를 찾을 수 없습니다!${NC}"
    echo ""
    echo "Flutter 설치 방법:"
    echo "1. https://docs.flutter.dev/get-started/install/linux"
    echo "2. 또는:"
    echo "   git clone https://github.com/flutter/flutter.git -b stable ~/flutter"
    echo "   echo 'export PATH=\"\$HOME/flutter/bin:\$PATH\"' >> ~/.bashrc"
    echo "   source ~/.bashrc"
    echo ""
    exit 1
fi
echo -e "${GREEN}✅ Flutter 확인: $(flutter --version | head -1)${NC}"
echo ""

# 프로젝트 디렉토리로 이동
echo "[2/5] 프로젝트 디렉토리로 이동..."
cd ~/truck_tracker || {
    echo -e "${RED}❌ ~/truck_tracker 디렉토리를 찾을 수 없습니다!${NC}"
    echo ""
    echo "해결 방법:"
    echo "1. WSL에서 프로젝트를 clone:"
    echo "   cd ~"
    echo "   git clone https://github.com/hyunwoooim-star/truck_tracker.git"
    echo ""
    echo "2. 또는 Windows 디렉토리 심볼릭 링크:"
    echo "   ln -s '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker' ~/truck_tracker"
    echo ""
    exit 1
}
echo -e "${GREEN}✅ 프로젝트 디렉토리: $(pwd)${NC}"
echo ""

# Git pull
echo "[3/5] Git pull (최신 코드 받기)..."
git pull
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  경고: git pull 실패. 계속 진행합니다...${NC}"
fi
echo ""

# 웹 빌드
echo "[4/5] Flutter 웹 빌드 중..."
echo "⏱️  시간이 걸립니다 (약 1~2분)..."
echo ""
flutter build web --release
if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}❌ 웹 빌드 실패!${NC}"
    echo ""
    echo "해결 방법:"
    echo "1. flutter clean"
    echo "2. flutter pub get"
    echo "3. flutter pub run build_runner build --delete-conflicting-outputs"
    echo "4. flutter build web --release"
    echo ""
    exit 1
fi
echo -e "${GREEN}✅ 웹 빌드 완료!${NC}"
echo ""

# Windows로 복사
echo "[5/5] Windows 디렉토리로 복사 중..."
WINDOWS_PATH="/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web"

# 대상 디렉토리 확인
if [ ! -d "$WINDOWS_PATH" ]; then
    echo -e "${YELLOW}⚠️  대상 디렉토리가 없습니다. 생성합니다...${NC}"
    mkdir -p "$WINDOWS_PATH"
fi

# 복사 실행
cp -r ~/truck_tracker/build/web/* "$WINDOWS_PATH/"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Windows로 복사 완료!${NC}"
    echo ""
    echo "복사된 위치:"
    echo "  $WINDOWS_PATH"
else
    echo -e "${RED}❌ 복사 실패!${NC}"
    echo ""
    echo "수동으로 복사하세요:"
    echo "  cp -r ~/truck_tracker/build/web/* '$WINDOWS_PATH/'"
    exit 1
fi
echo ""

echo "================================"
echo " ✅ WSL 빌드 완료!"
echo "================================"
echo ""
echo "📋 다음 단계:"
echo ""
echo "[옵션 1] Firebase 배포 (Windows에서 실행)"
echo "   cd 'C:\\Users\\임현우\\Desktop\\현우 작업폴더\\truck_tracker\\truck ver.1\\truck_tracker'"
echo "   deploy-firebase.bat"
echo ""
echo "[옵션 2] 빌드 파일 확인"
echo "   explorer.exe '$WINDOWS_PATH'"
echo ""
