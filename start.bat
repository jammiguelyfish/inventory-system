@echo off
REM Startup script for Laundry Inventory System (Windows)

echo.
echo ============================================
echo   Laundry Inventory System - Docker Setup
echo ============================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo [OK] Docker is running
echo.

REM Stop existing containers
echo [INFO] Stopping existing containers...
docker-compose down 2>nul
echo.

REM Build images
echo [INFO] Building Docker images...
docker-compose build
echo.

REM Start services
echo [INFO] Starting services...
docker-compose up -d
echo.

REM Wait for services
echo [INFO] Waiting for services to be ready...
timeout /t 5 /nobreak >nul
echo.

REM Check status
docker-compose ps
echo.

echo ============================================
echo   Application is ready!
echo ============================================
echo.
echo   Access at: http://localhost:8080
echo.
echo   Useful commands:
echo     docker-compose logs -f    - View logs
echo     docker-compose down       - Stop services
echo     docker-compose restart    - Restart services
echo.

pause
