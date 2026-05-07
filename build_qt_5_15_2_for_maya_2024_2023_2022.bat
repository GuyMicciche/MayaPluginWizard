@echo off
REM ========================================
REM Build Qt 5.15.2 for Maya 2024/2023/2022
REM Run from "x64 Native Tools Command Prompt for VS 2022"
REM ========================================
REM Prerequisites:
REM - Visual Studio 2019 or 2022 (MSVC)
REM - Git in PATH
REM - Strawberry Perl in PATH (used by syncqt.pl during build)
REM - Python 3.11.x with html5lib (only needed for QtWebEngine)
REM - Bison, Flex, GPerf in PATH (only needed for QtWebEngine)
REM ========================================

set "QTROOT=%USERPROFILE%\Desktop\Qt"
set "QTSRC=%QTROOT%\qt5"
set "QTBUILD=%QTROOT%\qt5-build"
set "QTINSTALL=C:\Qt\5.15.2-maya"

REM Step 0: Set up Visual Studio environment
echo Setting up Visual Studio environment...
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
if errorlevel 1 (echo ERROR: Failed to set up Visual Studio environment & pause & exit /b 1)

REM Step 1: Create root and clone if needed
echo Step 1: Create root and clone if needed
if not exist "%QTROOT%" mkdir "%QTROOT%"
if not exist "%QTSRC%" (
    cd /d "%QTROOT%"
    git clone https://code.qt.io/qt/qt5.git qt5
    if errorlevel 1 (echo ERROR: git clone failed & pause & exit /b 1)
)
s
REM Step 2: Switch to v5.15.2 tag
echo Step 2: Switch to v5.15.2 tag
cd /d "%QTSRC%"
git checkout v5.15.2
if errorlevel 1 (echo ERROR: failed to checkout v5.15.2 & pause & exit /b 1)

REM Step 3: Init only the submodules we need (uses perl init-repository for Qt 5.x)
echo Step 3: Init submodules
perl init-repository --module-subset=qtbase,qttools
::perl init-repository --module-subset=qtbase,qttools,qt3d,qtactiveqt,qtconnectivity,qtdeclarative,qtgamepad,qtlocation,qtmultimedia,qtremoteobjects,qtscxml,qtsensors,qtserialbus,qtserialport,qtspeech,qtsvg,qtwebchannel,qtwebengine,qtwebsockets,qtwebview,qtwinextras,qtxmlpatterns
if errorlevel 1 (echo ERROR: submodule init failed & pause & exit /b 1)

REM Step 4: Wipe and recreate build dir
echo Step 4: Prepare build dir
if exist "%QTBUILD%" rmdir /s /q "%QTBUILD%"
mkdir "%QTBUILD%"
cd /d "%QTBUILD%"

REM Step 5: Configure
echo Step 5: Configure
call "%QTSRC%\configure.bat" -prefix "%QTINSTALL%" -opensource -confirm-license -release -nomake examples -nomake tests
if errorlevel 1 (echo ERROR: configure failed & pause & exit /b 1)

REM Step 6: Build (Qt 5 uses nmake/jom, not cmake)
echo Step 6: Build
nmake
if errorlevel 1 (echo ERROR: build failed & pause & exit /b 1)

REM Step 7: Install
echo Step 7: Install
nmake install
if errorlevel 1 (echo ERROR: install failed & pause & exit /b 1)

echo ========================================
echo Build complete! Qt installed to %QTINSTALL%
echo ========================================
pause