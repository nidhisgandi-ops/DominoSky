@echo off
echo ========================================
echo   DOMINO SKY - Flight Disruption Simulator
echo ========================================
echo.

REM Find Python 3.11 (preferred) or fallback to py launcher
set PY311=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python311\python.exe
set PYFALLBACK=py

if exist "%PY311%" (
    set PYEXE=%PY311%
) else (
    set PYEXE=%PYFALLBACK%
)

echo Using Python: %PYEXE%
echo.

echo Starting Backend (FastAPI) on port 8000...
start "Domino Sky - Backend" cmd /k ""%PYEXE%" "%~dp0backend\main.py""

echo Waiting for backend to start...
timeout /t 4 /nobreak > nul

echo Starting Frontend (Vite + React) on port 5173...
start "Domino Sky - Frontend" cmd /k "cd /d "%~dp0frontend" && npm run dev"

echo.
echo ========================================
echo   Backend:  http://localhost:8000
echo   Frontend: http://localhost:5173
echo   API Docs: http://localhost:8000/docs
echo ========================================
echo.
echo Opening browser in 6 seconds...
timeout /t 6 /nobreak > nul
start http://localhost:5173
