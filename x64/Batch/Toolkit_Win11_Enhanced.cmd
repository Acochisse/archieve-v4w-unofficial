@echo off
:: Enhanced ViPER4Windows Toolkit for Windows 11 Compatibility
:: Based on original alanfox2000 toolkit with Windows 11 improvements
:: Author: Enhanced for Windows 11 compatibility

cd /d "%~dp0"
for %%a in ("%~dp0") do set parent=%%~dpa
for %%a in ("%parent:~0,-1%") do set grandparent=%%~dpa
set SetACL=%grandparent%Configurator\SetACL.exe

:: Enhanced Variables for Windows 11
set "LogFile=%temp%\ViPER4Windows_Install.log"
set "WinVer="
set "AudioSvc=AudioSrv"
set "AudioEndpoint=AudioEndpointBuilder"

title ViPER4Windows Enhanced Toolkit for Windows 11

:: Initialize log
echo [%date% %time%] ViPER4Windows Enhanced Toolkit Started > "%LogFile%"

:: Detect Windows Version
call :DetectWindowsVersion

:main_menu
cls
echo.
echo ===============================================
echo    ViPER4Windows Enhanced Toolkit for Windows 11
echo ===============================================
echo.
echo Detected: %WinVer%
echo Log File: %LogFile%
echo.
echo  01. Take Ownership of ViPER4Windows Installation Folder
echo.
echo  02. Take Ownership of Audio Registry Keys (Enhanced for Win11)
echo.
echo  03. Register ViPER4Windows.dll with Enhanced Error Handling
echo.
echo  04. Install PureSoftApps Certificates (Windows 11 Compatible)
echo.
echo  05. Restart Audio Services (Windows 11 Method)
echo.
echo  06. Check HVCI Status (Windows 11 Security Feature)
echo.
echo  07. Verify Installation Status
echo.
echo  08. Show Installation Log
echo.
echo  09. Complete Installation (Run All Steps)
echo.
echo  10. Exit
echo.
set /p choice="Enter your choice (1-10): "

if "%choice%"=="1" goto :take_ownership
if "%choice%"=="2" goto :registry_ownership
if "%choice%"=="3" goto :register_dll
if "%choice%"=="4" goto :install_certificates
if "%choice%"=="5" goto :restart_audio_services
if "%choice%"=="6" goto :check_hvci
if "%choice%"=="7" goto :verify_installation
if "%choice%"=="8" goto :show_log
if "%choice%"=="9" goto :complete_installation
if "%choice%"=="10" goto :exit
goto main_menu

:take_ownership
echo [%date% %time%] Taking ownership of installation folder >> "%LogFile%"
echo Taking ownership of ViPER4Windows installation folder...

takeown /f "%grandparent%." /r /d y > nul 2>&1
takeown /f "%grandparent%DriverComm" /r /d y > nul 2>&1

:: Enhanced for Windows 11 - Use icacls instead of deprecated cacls
icacls "%grandparent%." /grant:r administrators:F /t > nul 2>&1
icacls "%grandparent%DriverComm" /grant:r administrators:F /t > nul 2>&1
icacls "%grandparent%." /grant:r users:F /t > nul 2>&1
icacls "%grandparent%DriverComm" /grant:r users:F /t > nul 2>&1

if %errorlevel% equ 0 (
    echo [%date% %time%] Ownership taken successfully >> "%LogFile%"
    echo SUCCESS: Ownership taken successfully
) else (
    echo [%date% %time%] ERROR: Failed to take ownership - Error %errorlevel% >> "%LogFile%"
    echo ERROR: Failed to take ownership
)
pause
goto main_menu

:registry_ownership
echo [%date% %time%] Taking ownership of audio registry keys >> "%LogFile%"
echo Taking ownership of Windows Audio registry keys...

:: Enhanced registry permissions for Windows 11
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -ot reg -actn setowner -ownr "n:Administrators" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -ot reg -actn ace -ace "n:Administrators;p:full" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -ot reg -actn ace -ace "n:Users;p:full" > nul 2>&1

"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture" -ot reg -actn setowner -ownr "n:Administrators" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture" -ot reg -actn ace -ace "n:Administrators;p:full" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture" -ot reg -actn ace -ace "n:Users;p:full" > nul 2>&1

:: Additional Windows 11 audio registry keys
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" -ot reg -actn setowner -ownr "n:Administrators" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" -ot reg -actn ace -ace "n:Administrators;p:full" > nul 2>&1

if %errorlevel% equ 0 (
    echo [%date% %time%] Registry ownership configured successfully >> "%LogFile%"
    echo SUCCESS: Registry permissions configured
) else (
    echo [%date% %time%] ERROR: Failed to configure registry permissions - Error %errorlevel% >> "%LogFile%"
    echo ERROR: Failed to configure registry permissions
)
pause
goto main_menu

:register_dll
echo [%date% %time%] Registering ViPER4Windows.dll >> "%LogFile%"
echo Registering ViPER4Windows.dll...

if not exist "%parent%ViPER4Windows.dll" (
    echo [%date% %time%] ERROR: ViPER4Windows.dll not found at %parent% >> "%LogFile%"
    echo ERROR: ViPER4Windows.dll not found
    pause
    goto main_menu
)

regsvr32 /s "%parent%ViPER4Windows.dll"
if %errorlevel% equ 0 (
    echo [%date% %time%] DLL registered successfully >> "%LogFile%"
    echo SUCCESS: ViPER4Windows.dll registered successfully
) else (
    echo [%date% %time%] ERROR: Failed to register DLL - Error %errorlevel% >> "%LogFile%"
    echo ERROR: Failed to register ViPER4Windows.dll
    echo Try running as Administrator
)
pause
goto main_menu

:install_certificates
echo [%date% %time%] Installing PureSoftApps certificates >> "%LogFile%"
echo Installing PureSoftApps certificates for Windows 11...

call ImportCertificate.cmd > nul 2>&1
if %errorlevel% equ 0 (
    echo [%date% %time%] Certificates installed successfully >> "%LogFile%"
    echo SUCCESS: Certificates installed successfully
) else (
    echo [%date% %time%] ERROR: Failed to install certificates - Error %errorlevel% >> "%LogFile%"
    echo ERROR: Failed to install certificates
)
pause
goto main_menu

:restart_audio_services
echo [%date% %time%] Restarting audio services >> "%LogFile%"
echo Restarting Windows Audio services...

echo Stopping audio services...
net stop %AudioEndpoint% > nul 2>&1
net stop %AudioSvc% > nul 2>&1

timeout /t 3 > nul

echo Starting audio services...
net start %AudioSvc% > nul 2>&1
net start %AudioEndpoint% > nul 2>&1

if %errorlevel% equ 0 (
    echo [%date% %time%] Audio services restarted successfully >> "%LogFile%"
    echo SUCCESS: Audio services restarted
) else (
    echo [%date% %time%] WARNING: Audio services restart may have failed >> "%LogFile%"
    echo WARNING: Check Services.msc if audio issues persist
)
pause
goto main_menu

:check_hvci
echo [%date% %time%] Checking HVCI status >> "%LogFile%"
echo Checking Windows 11 HVCI (Hypervisor-protected Code Integrity) status...

:: Check if HVCI is enabled
reg query "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled 2>nul | find "0x1" > nul
if %errorlevel% equ 0 (
    echo [%date% %time%] HVCI is ENABLED - may block unsigned drivers >> "%LogFile%"
    echo WARNING: HVCI is ENABLED
    echo This may prevent ViPER4Windows from working properly.
    echo Consider disabling Core Isolation in Windows Security.
) else (
    echo [%date% %time%] HVCI is disabled or not found >> "%LogFile%"
    echo HVCI Status: Disabled or not configured (Good for ViPER4Windows)
)
pause
goto main_menu

:verify_installation
echo [%date% %time%] Verifying installation >> "%LogFile%"
echo Verifying ViPER4Windows installation...

echo Checking files...
if exist "%parent%ViPER4Windows.dll" (
    echo ✓ ViPER4Windows.dll found
) else (
    echo ✗ ViPER4Windows.dll missing
)

if exist "%parent%ViPER4WindowsCtrlPanel.exe" (
    echo ✓ Control Panel found
) else (
    echo ✗ Control Panel missing
)

echo Checking registry...
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Audio registry accessible
) else (
    echo ✗ Audio registry not accessible
)

echo Checking certificates...
certutil -store "TrustedPublisher" | find "PureSoftApps" > nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ PureSoftApps certificates installed
) else (
    echo ✗ PureSoftApps certificates missing
)

pause
goto main_menu

:complete_installation
echo [%date% %time%] Starting complete installation >> "%LogFile%"
echo Running complete ViPER4Windows installation...
echo.

echo Step 1/5: Taking ownership...
call :take_ownership_silent

echo Step 2/5: Configuring registry...
call :registry_ownership_silent

echo Step 3/5: Installing certificates...
call :install_certificates_silent

echo Step 4/5: Registering DLL...
call :register_dll_silent

echo Step 5/5: Restarting audio services...
call :restart_audio_services_silent

echo.
echo [%date% %time%] Complete installation finished >> "%LogFile%"
echo Complete installation finished!
echo Check the log file for any errors: %LogFile%
pause
goto main_menu

:show_log
echo Current installation log:
echo ========================
type "%LogFile%" 2>nul || echo Log file not found
echo ========================
pause
goto main_menu

:DetectWindowsVersion
for /f "tokens=2 delims=[]" %%i in ('ver') do set WinVer=%%i
if "%WinVer%"=="" set WinVer=Unknown Windows Version
echo [%date% %time%] Detected Windows version: %WinVer% >> "%LogFile%"
goto :eof

:: Silent versions for complete installation
:take_ownership_silent
takeown /f "%grandparent%." /r /d y > nul 2>&1
takeown /f "%grandparent%DriverComm" /r /d y > nul 2>&1
icacls "%grandparent%." /grant:r administrators:F /t > nul 2>&1
icacls "%grandparent%DriverComm" /grant:r administrators:F /t > nul 2>&1
icacls "%grandparent%." /grant:r users:F /t > nul 2>&1
icacls "%grandparent%DriverComm" /grant:r users:F /t > nul 2>&1
goto :eof

:registry_ownership_silent
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -ot reg -actn setowner -ownr "n:Administrators" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -ot reg -actn ace -ace "n:Administrators;p:full" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" -ot reg -actn ace -ace "n:Users;p:full" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture" -ot reg -actn setowner -ownr "n:Administrators" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture" -ot reg -actn ace -ace "n:Administrators;p:full" > nul 2>&1
"%SetACL%" -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture" -ot reg -actn ace -ace "n:Users;p:full" > nul 2>&1
goto :eof

:install_certificates_silent
call ImportCertificate.cmd > nul 2>&1
goto :eof

:register_dll_silent
regsvr32 /s "%parent%ViPER4Windows.dll" > nul 2>&1
goto :eof

:restart_audio_services_silent
net stop %AudioEndpoint% > nul 2>&1
net stop %AudioSvc% > nul 2>&1
timeout /t 3 > nul
net start %AudioSvc% > nul 2>&1
net start %AudioEndpoint% > nul 2>&1
goto :eof

:exit
echo [%date% %time%] Toolkit exited >> "%LogFile%"
echo Exiting toolkit...
goto :eof
