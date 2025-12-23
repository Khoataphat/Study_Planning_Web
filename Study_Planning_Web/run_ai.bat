@echo off
echo [INFO] Starting PlanZ AI Service...
echo.

cd /d "%~dp0"

echo [STEP 1] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python from https://www.python.org/downloads/
    pause
    exit /b
)

echo [STEP 2] Installing dependencies...
pip install flask mysql-connector-python >nul

echo [STEP 3] Launching AI Service...
echo The service is running on http://localhost:5000
echo Do not close this window while using the application.
echo.
python app.py

pause
