@echo off
REM ========================================
REM Build Qt 6.5.3 for Maya 2025/2026
REM Run from "x64 Native Tools Command Prompt for VS 2022"
REM ========================================
REM Prerequisites:
REM - Visual Studio 2022 (MSVC) with Desktop development with C++
REM - Git in PATH
REM - Python 3.11.x with html5lib (only needed for QtWebEngine)
REM - Bison, Flex, GPerf in PATH (only needed for QtWebEngine)
REM ========================================

set "QTROOT=%USERPROFILE%\Desktop\Qt"
set "QTSRC=%QTROOT%\qt6"
set "QTBUILD=%QTROOT%\qt6-build"
set "QTINSTALL=C:\Qt\6.5.3-maya"

REM Step 0: Set up Visual Studio environment
echo Setting up Visual Studio environment...
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
if errorlevel 1 (echo ERROR: Failed to set up Visual Studio environment & pause & exit /b 1)

REM Step 1: Create root and clone if needed
echo Step 1: Create root and clone if needed
if not exist "%QTROOT%" mkdir "%QTROOT%"
if not exist "%QTSRC%" (
    cd /d "%QTROOT%"
    git clone https://code.qt.io/qt/qt5.git qt6
    if errorlevel 1 (echo ERROR: git clone failed & pause & exit /b 1)
)

REM Step 2: Switch to 6.5.3 tag
echo Step 2: Switch to 6.5.3 tag
cd /d "%QTSRC%"
git checkout 6.5.3
if errorlevel 1 (echo ERROR: failed to checkout 6.5.3 & pause & exit /b 1)

REM Step 3: Init only the submodules we need
echo Step 3: Init submodules
git submodule update --init --recursive qtbase qttools
::git submodule update --init --recursive qtbase qttools qt3d qt5compat qtdeclarative qtmultimedia qtpositioning qtremoteobjects qtscxml qtsensors qtserialbus qtserialport qtshadertools qtspeech qtsvg qtwebchannel qtwebengine qtwebsockets qtwebview
if errorlevel 1 (echo ERROR: submodule init failed & pause & exit /b 1)

REM Step 4: Wipe and recreate build dir
echo Step 4: Prepare build dir
if exist "%QTBUILD%" rmdir /s /q "%QTBUILD%"
mkdir "%QTBUILD%"
cd /d "%QTBUILD%"

REM Step 5: Configure (6.5.3's top-level wrapper works fine)
echo Step 5: Configure
call "%QTSRC%\configure.bat" -prefix "%QTINSTALL%" -opensource -confirm-license -release -nomake examples -nomake tests
if errorlevel 1 (echo ERROR: configure failed & pause & exit /b 1)

REM Step 6: Build
echo Step 6: Build
cmake --build . --parallel
if errorlevel 1 (echo ERROR: build failed & pause & exit /b 1)

REM Step 7: Install
echo Step 7: Install
cmake --install .
if errorlevel 1 (echo ERROR: install failed & pause & exit /b 1)

echo ========================================
echo Build complete! Qt installed to %QTINSTALL%
echo ========================================
pause