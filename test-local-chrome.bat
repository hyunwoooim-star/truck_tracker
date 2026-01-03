@echo off
chcp 65001 >nul
echo ================================
echo  로컬 크롬 테스트
echo ================================
echo.

REM Flutter 경로 설정
set FLUTTER_PATH=C:\Users\임현우\Downloads\flutter_windows_3.38.5-stable\flutter\bin\flutter.bat

echo 🌐 Chrome에서 앱을 실행합니다...
echo.
echo 💡 사용 팁:
echo   • r 키: 핫 리로드 (빠른 새로고침)
echo   • R 키: 핫 리스타트 (전체 재시작)
echo   • q 키: 종료
echo   • h 키: 도움말
echo.
echo 📋 테스트 체크리스트:
echo   [ ] 로그인 화면 정상 표시
echo   [ ] 지도 로드 확인
echo   [ ] 트럭 목록 표시
echo   [ ] 설정 메뉴 작동
echo   [ ] 도움말 화면 접근
echo   [ ] 개인정보 처리방침 표시
echo.
echo ⏱️  Chrome이 자동으로 열립니다...
echo.

"%FLUTTER_PATH%" run -d chrome

echo.
echo ================================
echo  테스트 종료
echo ================================
echo.
pause
