@echo off
setlocal enabledelayedexpansion

:: Define available versions
set "versions=v0,v512,v770,v1025"

:: Display version options
echo Select a version:
for %%v in (%versions%) do (
    echo %%v
)

:: User input for version selection
set /p userVersion="Enter your chosen version: "

:: Validate version choice
echo %versions% | findstr /i /c:"%userVersion%" >nul
if errorlevel 1 (
    echo Invalid version selected. Exiting...
    exit /b
)

:: Display Dolphin/Real Wii options
echo.
echo Choose an emulator:
echo 1. Dolphin
echo 2. Real Wii
set /p userChoice="Enter 1 or 2: "

if "%userChoice%"=="1" (
    echo You selected Dolphin.
    set "ipAddress=127.0.0.1"
) else if "%userChoice%"=="2" (
    echo You selected Real Wii.
    set /p ipAddress="Please enter the IP address of the Real Wii (or press F12 for ipconfig): "
    if /i "!ipAddress!"=="F12" (
        echo.
        echo Running ipconfig to find your IP address...
        ipconfig
        echo.
        set /p ipAddress="Please enter the IP address of the Real Wii: "
    )
) else (
    echo Invalid choice. Exiting...
    exit /b
)

:: Unpack the .wad file using Sharpii.exe
set "wadFile=%userVersion%.wad"
set "outputDir=temp"

echo.
echo Unpacking %wadFile% using Sharpii.exe...
Sharpii.exe WAD -u "%wadFile%" "%outputDir%" >NUL

if errorlevel 1 (
    echo Failed to unpack %wadFile%. Please check if Sharpii.exe is available and try again.
    exit /b
)

:: Define the patcher location
set "patcherLocation=C:\Viinoma"  :: Change this to your actual patcher location

:: Copy 00000001.app from the output directory to the patcher location
echo.
echo Copying 00000001.app from %outputDir% to %patcherLocation%...
copy "%outputDir%\00000001.app" "%patcherLocation%\" >NUL

if errorlevel 1 (
    echo Failed to copy 00000001.app to %patcherLocation%. Please check the path and try again.
    exit /b
)

:: Run lzx command for specified versions
if "%userVersion%"=="v0" (
    echo.
    echo Running lzx for version v0...
    lzx -d "%patcherLocation%\00000001.app" "%patcherLocation%\00000001.app"
) else if "%userVersion%"=="v512" (
    echo.
    echo Running lzx for version v512...
    lzx -d "%patcherLocation%\00000001.app" "%patcherLocation%\00000001.app"
) else if "%userVersion%"=="v770" (
    echo.
    echo Running lzx for version v770...
    lzx -d "%patcherLocation%\00000001.app" "%patcherLocation%\00000001.app"
) else if "%userVersion%"=="v1025" (
    echo.
    echo Running lzx for version v1025...
    lzx -d "%patcherLocation%\00000001.app" "%patcherLocation%\00000001.app"
) else (
    echo Invalid version selected for lzx. Exiting...
    exit /b
)

:: Open HxD with the unpacked .wad file
echo.
echo Launching HxD to display information...
start "HxD" "C:\viinoma\HxD.exe" "C:\viinoma\00000001.app" 

:: Display instructions for the user in HxD
echo.
echo After HxD opens, follow these instructions:
echo 1. Locate the URL .wapp.wii.com in the file.
echo 2. If your chosen version is v770 or v0/v512, replace the URL with the new one as needed.if you use dolphin you can set 127.0.0.1
echo 3. For version v770, replace %sconf/first.bin with %sv770/first.bin.
echo 4. For versions v0/v512, replace %sconf/first.bin with %sv512/first.bin
echo 5. For v1025, replace https://originalurl/conf/first.bin with http://Newurl/v1025/first.bin
echo 6. Remplace .img to .jpg on file,and do for beacon %sbeacon/01

echo.
echo After you have made the changes in HxD, close the HxD application.

:: Wait for HxD to close
:wait_for_HxD
tasklist /FI "IMAGENAME eq HxD.exe" 2>NUL | find /I /N "HxD.exe">NUL
if "%ERRORLEVEL%"=="0" (
    timeout /t 5 >nul
    goto wait_for_HxD
)

:: Run lzx -evb command
echo Running lzx -evb on 00000001.app...
lzx -evb "%patcherLocation%\00000001.app" "%patcherLocation%\00000001.app"

if errorlevel 1 (
    echo Failed to run lzx -evb. Please check if lzx is available and try again.
    exit /b
)

:: Run Sharpii.exe to pack the .wad file
echo.
echo Packing the .wad file using Sharpii.exe...
Sharpii.exe WAD -p "%outputDir%" "%userVersion%_patched.wad" >NUL

if errorlevel 1 (
    echo Failed to pack the .wad file. Please check if Sharpii.exe is available and try again.
    exit /b
)

:: Display the summary of choices and completion message
echo.
echo You have selected version: %userVersion%
echo Emulator: %userChoice% (IP Address: %ipAddress%)
echo Unpacking, copying, lzx operation, HxD launch, and final operations completed successfully!

echo Script completed. Press any key to exit.
pause >nul
exit /b
