@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cls
color 0e
title Cleaner

powershell -Command "Write-Host ''; Write-Host '   ___           __           __           ' -ForegroundColor Red; Write-Host '  / _/______ ___/ /__    ___ / /  ___  ___ ' -ForegroundColor Red; Write-Host ' / _/ __/ -_) _  / _ \  (_-</ _ \/ _ \/ _ \' -ForegroundColor Red; Write-Host '/_//_/  \__/\_,_/\___/ /___/_//_/\___/ .__/' -ForegroundColor Red; Write-Host '                                    /_/   ' -ForegroundColor Red; Write-Host ''"

echo.
echo Do you want to start? (y/n)
choice /c yn /n
if errorlevel 2 exit /b

echo.
echo Do you want to start cleaning? (y/n)
choice /c yn /n
if errorlevel 2 exit /b

echo.
echo Killing Roblox processes...
taskkill /f /im RobloxPlayerBeta.exe >nul 2>&1
taskkill /f /im RobloxPlayerInstaller.exe >nul 2>&1
taskkill /f /im Bloxstrap.exe >nul 2>&1
taskkill /f /im Fishstrap.exe >nul 2>&1
timeout /t 2 >nul

echo.
echo Cleaning appdata + temp...
del /f /s /q "%temp%\*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
rd /s /q "%LocalAppData%\Temp" >nul 2>&1

echo Removing Roblox files...
rd /s /q "%LocalAppData%\Roblox" >nul 2>&1
rd /s /q "%LocalAppData%\Temp\Roblox" >nul 2>&1
rd /s /q "%AppData%\Roblox" >nul 2>&1
rd /s /q "%AppData%\Local\Roblox" >nul 2>&1
rd /s /q "%LocalAppData%\Bloxstrap" >nul 2>&1
rd /s /q "%LocalAppData%\Fishstrap" >nul 2>&1
rd /s /q "%LocalAppData%\Temp\Fishstrap" >nul 2>&1

echo Deleting RobloxCookies.dat
for /d %%U in (C:\Users\*) do (
    if exist "%%U\AppData\Local\Roblox\LocalStorage\RobloxCookies.dat" (
        del /f /q "%%U\AppData\Local\Roblox\LocalStorage\RobloxCookies.dat" >nul 2>&1
        echo Deleted cookies for %%~nxU
    )
)

echo DNS flush
ipconfig /flushdns >nul

echo Wiping registry
reg delete "HKCU\Software\Roblox" /f >nul 2>&1
reg delete "HKCU\Software\Bloxstrap" /f >nul 2>&1
reg delete "HKCU\Software\Fishstrap" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Roblox Corporation" /f >nul 2>&1

echo Clearing prefetch...
del /f /q C:\Windows\Prefetch\ROBLOX*.pf >nul 2>&1
del /f /q C:\Windows\Prefetch\BLOXSTRAP*.pf >nul 2>&1
del /f /q C:\Windows\Prefetch\FISHSTRAP*.pf >nul 2>&1

echo Restarting explorer
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo Clearing Chrome data...

set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
set "CHROME86=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
set "CHROMELOCAL=%LocalAppData%\Google\Chrome\Application\chrome.exe"

if exist "%CHROME%" goto chrome_found
if exist "%CHROME86%" (
    set "CHROME=%CHROME86%"
    goto chrome_found
)
if exist "%CHROMELOCAL%" (
    set "CHROME=%CHROMELOCAL%"
    goto chrome_found
)

echo [ERR] Chrome wasn't found
goto skip_chrome

:chrome_found
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 2 >nul

set "CHROMEDATA=%LocalAppData%\Google\Chrome\User Data\Default"
if exist "%CHROMEDATA%\History" del /f /q "%CHROMEDATA%\History" >nul 2>&1
if exist "%CHROMEDATA%\Cookies" del /f /q "%CHROMEDATA%\Cookies" >nul 2>&1
if exist "%CHROMEDATA%\Cache" rd /s /q "%CHROMEDATA%\Cache" >nul 2>&1
if exist "%CHROMEDATA%\Code Cache" rd /s /q "%CHROMEDATA%\Code Cache" >nul 2>&1
if exist "%CHROMEDATA%\GPUCache" rd /s /q "%CHROMEDATA%\GPUCache" >nul 2>&1
if exist "%CHROMEDATA%\Download Metadata" del /f /q "%CHROMEDATA%\Download Metadata" >nul 2>&1
if exist "%CHROMEDATA%\Visited Links" del /f /q "%CHROMEDATA%\Visited Links" >nul 2>&1
echo Chrome data cleared

echo Opening Chrome incognito...
start "" "%CHROME%" --incognito

:skip_chrome

echo.
powershell -Command "Write-Host 'Restarting your PC is advised, if you do open another incognito tab.' -ForegroundColor Red"
echo.
echo Close? (y/n)
choice /c yn /n
if %errorlevel%==1 exit
