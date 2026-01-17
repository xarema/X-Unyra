@echo off
REM Script de démarrage pour Windows
REM Usage: run_tests.bat

echo ========================================
echo Couple App MVP - Demarrage automatique
echo ========================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Python n'est pas trouve!
    echo Installez Python 3 depuis: https://python.org
    echo.
    pause
    exit /b 1
)

echo OK Python trouve
echo.

echo Demarrage des serveurs...
echo.

REM Start Backend
echo Demarrage Backend Django (port 8000)...
cd backend
start "Backend Django" python manage.py runserver
timeout /t 2 /nobreak

REM Start Frontend
echo Demarrage Frontend Web (port 8080)...
cd ..\web
start "Frontend Web" python -m http.server 8080
timeout /t 2 /nobreak

echo.
echo ========================================
echo SERVEURS DEMARRES!
echo ========================================
echo.
echo Navigateur: http://localhost:8080
echo.
echo Identifiants de test:
echo   Alice: alice@example.com / TestPass123!
echo   Bob:   bob@example.com / TestPass123!
echo.
echo Appuyez sur ENTER pour fermer ce terminal
echo Les serveurs continueront de tourner.
echo.

pause
