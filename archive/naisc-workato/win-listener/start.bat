@echo off
REM Ripple AW listener · Windows launcher
REM Double-click this file from File Explorer to start streaming Windows
REM ActivityWatch presence into Supabase. Close the window to stop.

cd /d "%~dp0"
echo.
echo ============================================
echo  Ripple ActivityWatch listener (Windows)
echo  device_activity Supabase upsert · 30 s poll
echo ============================================
echo.

REM Sanity: Node present?
where node >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Node.js not found on PATH.
    echo Install Node.js LTS from https://nodejs.org and re-run.
    pause
    exit /b 1
)

REM Sanity: ActivityWatch reachable?
curl -s -o NUL -w "%%{http_code}" http://localhost:5600/api/0/info > "%TEMP%\aw_check.txt"
set /p AW_HTTP=<"%TEMP%\aw_check.txt"
del "%TEMP%\aw_check.txt"
if not "%AW_HTTP%"=="200" (
    echo [WARN] ActivityWatch not responding on http://localhost:5600 (got %AW_HTTP%).
    echo Start ActivityWatch first, then re-run this script.
    pause
    exit /b 1
)

echo Starting listener... press Ctrl+C to stop.
echo Log: %~dp0data\listener.log
echo.
node listener.mjs
