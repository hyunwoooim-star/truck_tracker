@echo off
chcp 65001 >nul
echo ================================
echo  로컬 빌드 & 테스트 스크립트
echo ================================
echo.

REM Flutter 경로 설정
set FLUTTER_PATH=C:\Users\임현우\Downloads\flutter_windows_3.38.5-stable\flutter\bin\flutter.bat

REM 프로젝트 디렉토리 확인
echo [1/4] 프로젝트 디렉토리 확인...
if not exist "pubspec.yaml" (
    echo ❌ 에러: pubspec.yaml을 찾을 수 없습니다.
    echo 프로젝트 디렉토리에서 실행하세요.
    echo.
    echo 현재 위치: %cd%
    pause
    exit /b 1
)
echo ✅ 프로젝트 디렉토리 확인 완료
echo.

REM 최신 코드 받기
echo [2/4] Git pull (최신 코드 받기)...
git pull
if errorlevel 1 (
    echo ⚠️  경고: git pull 실패. 계속 진행합니다...
)
echo.

REM build_runner 실행
echo [3/4] build_runner 실행 중...
echo 시간이 좀 걸립니다 (약 30초~1분)
echo.
"%FLUTTER_PATH%" pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo.
    echo ❌ build_runner 실패!
    echo.
    echo 해결 방법:
    echo 1. flutter clean 실행
    echo 2. flutter pub get 실행
    echo 3. 다시 시도
    echo.
    pause
    exit /b 1
)
echo ✅ build_runner 완료
echo.

REM flutter analyze
echo [4/4] flutter analyze 실행 중...
"%FLUTTER_PATH%" analyze
if errorlevel 1 (
    echo.
    echo ⚠️  경고: analyze에서 이슈 발견!
    echo 위 메시지를 확인하고 필요하면 수정하세요.
    echo.
    pause
) else (
    echo ✅ analyze 통과!
    echo.
)

echo ================================
echo  ✅ 빌드 완료!
echo ================================
echo.
echo 📋 다음 단계:
echo.
echo [옵션 1] 로컬 크롬 테스트 (권장)
echo    flutter run -d chrome
echo    (또는 test-local-chrome.bat 실행)
echo.
echo [옵션 2] 생성된 파일 커밋
echo    git add .
echo    git commit -m "[Build] build_runner 실행"
echo    git push
echo.
echo [옵션 3] WSL 웹 빌드로 진행
echo    (WSL Ubuntu에서) ./build-wsl.sh 실행
echo.
pause
