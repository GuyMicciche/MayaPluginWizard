@echo off
setlocal enabledelayedexpansion

REM ========================================
REM Maya userSetup.py CommandPort Auto-Setup
REM Adds command port configuration to userSetup.py
REM Works with any Maya version and handles existing files
REM ========================================

REM Check if specific version provided as argument
if not "%1"=="" (
    set "MAYA_VERSION=%1"
    echo Using specified Maya version: %MAYA_VERSION%
    goto :process_version
)

REM No argument provided - show menu
echo.
echo ========================================
echo Maya CommandPort Setup
echo ========================================
echo.
echo Available options:
echo 1. Auto-detect and setup first found Maya version
echo 2. Setup specific Maya version
echo 3. Setup ALL installed Maya versions
echo 4. Enter Maya version manually
echo.

:menu_choice
set /p "CHOICE=Enter choice (1-4): "

if "%CHOICE%"=="1" goto :auto_detect
if "%CHOICE%"=="2" goto :choose_specific
if "%CHOICE%"=="3" goto :setup_all
if "%CHOICE%"=="4" goto :manual_entry
echo Invalid choice. Please enter 1, 2, 3, or 4.
goto :menu_choice

:auto_detect
echo.
echo Auto-detecting Maya installations...
for %%v in (2026 2025 2024 2023 2022 2020 2019) do (
    if exist "%USERPROFILE%\Documents\maya\%%v" (
        set "MAYA_VERSION=%%v"
        echo Found Maya %%v installation
        goto :process_version
    )
)
echo No Maya installations found in Documents\maya\
goto :manual_entry

:choose_specific
echo.
echo Scanning for installed Maya versions...
set "FOUND_VERSIONS="
set "COUNT=0"

for %%v in (2026 2025 2024 2023 2022 2020 2019) do (
    if exist "%USERPROFILE%\Documents\maya\%%v" (
        set /a COUNT+=1
        set "VERSION_!COUNT!=%%v"
        set "FOUND_VERSIONS=!FOUND_VERSIONS! !COUNT!.Maya_%%v"
        echo !COUNT!. Maya %%v
    )
)

if %COUNT%==0 (
    echo No Maya installations found.
    goto :manual_entry
)

echo.
set /p "VERSION_CHOICE=Enter number (1-%COUNT%): "

if %VERSION_CHOICE% leq 0 goto :choose_specific
if %VERSION_CHOICE% gtr %COUNT% goto :choose_specific

call set "MAYA_VERSION=%%VERSION_%VERSION_CHOICE%%%"
goto :process_version

:setup_all
echo.
echo Setting up command ports for ALL Maya versions...
echo.

set "PROCESSED=0"
for %%v in (2026 2025 2024 2023 2022 2020 2019) do (
    if exist "%USERPROFILE%\Documents\maya\%%v" (
        echo ----------------------------------------
        echo Processing Maya %%v...
        set "MAYA_VERSION=%%v"
        call :process_version_silent
        set /a PROCESSED+=1
    )
)

if %PROCESSED%==0 (
    echo No Maya installations found.
) else (
    echo.
    echo ========================================
    echo Completed setup for %PROCESSED% Maya version(s)
    echo ========================================
)
goto :final_end

:manual_entry
echo.
set /p "MAYA_VERSION=Enter Maya version (e.g., 2025): "
goto :process_version

:process_version
call :process_version_silent
echo.
pause
goto :final_end

:process_version_silent
echo Using Maya version: %MAYA_VERSION%

REM Set paths
set "MAYA_SCRIPTS_DIR=%USERPROFILE%\Documents\maya\%MAYA_VERSION%\scripts"
set "USERSETUP_FILE=%MAYA_SCRIPTS_DIR%\userSetup.py"

REM Create scripts directory if it doesn't exist
if not exist "%MAYA_SCRIPTS_DIR%" (
    echo Creating scripts directory: %MAYA_SCRIPTS_DIR%
    mkdir "%MAYA_SCRIPTS_DIR%"
)

REM Check if userSetup.py exists
if not exist "%USERSETUP_FILE%" (
    echo Creating new userSetup.py file...
    goto :create_new_file
) else (
    echo Found existing userSetup.py, analyzing...
    goto :check_existing_file
)

:create_new_file
REM Create a new userSetup.py with command ports
(
echo # userSetup.py
echo import maya.cmds as cmds
echo.
echo # Command ports for external communication
echo cmds.commandPort^(name=":20200", sourceType="mel"^)
echo cmds.commandPort^(name=":20201", sourceType="python"^)
echo.
) > "%USERSETUP_FILE%"

echo Successfully created userSetup.py with command ports
goto :end_process

:check_existing_file
REM Check what already exists in the file
set "HAS_CMDS_IMPORT=0"
set "HAS_MEL_PORT=0"
set "HAS_PYTHON_PORT=0"

REM Read file and check for existing content
for /f "usebackq delims=" %%a in ("%USERSETUP_FILE%") do (
    set "LINE=%%a"
    
    REM Check for maya.cmds import (specific valid forms only)
    echo !LINE! | findstr /i /r /c:"^[ 	]*import[ 	][ 	]*maya\.cmds[ 	][ 	]*as[ 	][ 	]*cmds" >nul && set "HAS_CMDS_IMPORT=1"
    echo !LINE! | findstr /i /r /c:"^[ 	]*from[ 	][ 	]*maya[ 	][ 	]*import[ 	][ 	]*cmds" >nul && set "HAS_CMDS_IMPORT=1"
    
    REM Check for specific command ports
    echo !LINE! | findstr /c:"20200" | findstr /c:"mel" >nul && set "HAS_MEL_PORT=1"
    echo !LINE! | findstr /c:"20201" | findstr /c:"python" >nul && set "HAS_PYTHON_PORT=1"
)

REM Report what was found
echo Analysis results:
if %HAS_CMDS_IMPORT%==1 (echo   - maya.cmds import: FOUND) else (echo   - maya.cmds import: MISSING)
if %HAS_MEL_PORT%==1 (echo   - MEL port :20200: FOUND) else (echo   - MEL port :20200: MISSING)
if %HAS_PYTHON_PORT%==1 (echo   - Python port :20201: FOUND) else (echo   - Python port :20201: MISSING)

REM Check if everything is already configured
if %HAS_CMDS_IMPORT%==1 if %HAS_MEL_PORT%==1 if %HAS_PYTHON_PORT%==1 (
    echo.
    echo All command port configuration already exists!
    echo No changes needed.
    goto :end_process
)

REM Backup original file
copy "%USERSETUP_FILE%" "%USERSETUP_FILE%.backup" >nul
echo Created backup: %USERSETUP_FILE%.backup

REM Append missing components to the file
echo.
echo Adding missing components...

REM Add maya.cmds import if missing
if %HAS_CMDS_IMPORT%==0 (
    echo Adding maya.cmds import at the top...
    (
        echo import maya.cmds as cmds
        type "%USERSETUP_FILE%"
    ) > "%USERSETUP_FILE%.tmp"
    move /Y "%USERSETUP_FILE%.tmp" "%USERSETUP_FILE%" >nul
    echo Added: maya.cmds import
)


REM Add command ports section if any are missing
if %HAS_MEL_PORT%==0 (
    if %HAS_PYTHON_PORT%==0 (
        REM Add header comment if adding both ports
        echo. >> "%USERSETUP_FILE%"
        echo # Command ports for external communication >> "%USERSETUP_FILE%"
    )
)

REM Add MEL port if missing
if %HAS_MEL_PORT%==0 (
    echo cmds.commandPort^(name=":20200", sourceType="mel"^) >> "%USERSETUP_FILE%"
    echo Added: MEL command port :20200
)

REM Add Python port if missing
if %HAS_PYTHON_PORT%==0 (
    echo cmds.commandPort^(name=":20201", sourceType="python"^) >> "%USERSETUP_FILE%"
    echo Added: Python command port :20201
)

echo Successfully updated userSetup.py

:end_process
echo.
echo Command port setup complete for Maya %MAYA_VERSION%
echo Location: %USERSETUP_FILE%
echo.
echo Command ports configured:
echo   MEL: :20200
echo   Python: :20201
echo.
exit /b

:final_end
echo You can now connect to Maya using these ports:
echo   MEL commands: telnet localhost 20200
echo   Python commands: telnet localhost 20201
echo ========================================