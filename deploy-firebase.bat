@echo off
chcp 65001 >nul
echo ================================
echo  Firebase 배포 스크립트
echo ================================
echo.

REM 프로젝트 디렉토리 확인
echo [1/4] 프로젝트 디렉토리 확인...
if not exist "firebase.json" (
    echo ❌ 에러: firebase.json을 찾을 수 없습니다.
    echo 프로젝트 디렉토리에서 실행하세요.
    echo.
    echo 현재 위치: %cd%
    pause
    exit /b 1
)
echo ✅ Firebase 프로젝트 확인 완료
echo.

REM 빌드 파일 확인
echo [2/4] 빌드 파일 확인...
if not exist "build\web\index.html" (
    echo ❌ 에러: build/web/index.html을 찾을 수 없습니다.
    echo.
    echo WSL 빌드를 먼저 실행하세요:
    echo   wsl -d Ubuntu ./build-wsl.sh
    echo.
    echo 또는 수동으로:
    echo   wsl -d Ubuntu -- bash -c "cd ~/truck_tracker && flutter build web --release"
    echo   wsl -d Ubuntu -- bash -c "cp -r ~/truck_tracker/build/web/* '/mnt/c/Users/임현우/Desktop/현우 작업폴더/truck_tracker/truck ver.1/truck_tracker/build/web/'"
    echo.
    pause
    exit /b 1
)
echo ✅ 빌드 파일 확인 완료
echo.

REM 빌드 파일 목록 표시
echo [3/4] 빌드 파일 목록:
dir /B build\web | findstr /V /C:".DS_Store"
echo.

REM Firebase 배포
echo [4/4] Firebase 배포 중...
echo ⏱️  시간이 걸립니다 (약 30초~1분)...
echo.
npx firebase-tools deploy --only hosting
if errorlevel 1 (
    echo.
    echo ❌ Firebase 배포 실패!
    echo.
    echo 해결 방법:
    echo 1. Firebase 로그인 확인:
    echo    npx firebase-tools login
    echo.
    echo 2. 프로젝트 확인:
    echo    npx firebase-tools projects:list
    echo.
    echo 3. 프로젝트 선택:
    echo    npx firebase-tools use truck-tracker-fa0b0
    echo.
    pause
    exit /b 1
)

echo.
echo ================================
echo  ✅ 배포 완료!
echo ================================
echo.
echo 🌐 배포된 URL:
echo    https://truck-tracker-fa0b0.web.app
echo.
echo 📋 다음 단계:
echo 1. 브라우저에서 https://truck-tracker-fa0b0.web.app 접속
echo 2. 로그인 테스트
echo 3. 계좌이체 기능 테스트
echo 4. 도움말 메뉴 확인
echo 5. 개인정보 처리방침 확인
echo.
echo 🎉 프로덕션 배포 완료!
echo.
pause

REM 브라우저로 자동 열기 (옵션)
set /p OPEN_BROWSER="브라우저로 열까요? (Y/N): "
if /i "%OPEN_BROWSER%"=="Y" (
    start https://truck-tracker-fa0b0.web.app
)
