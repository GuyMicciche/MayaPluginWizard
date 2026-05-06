REM ========================================
REM Build Qt 6.8.3 for Maya 2027
REM ========================================
REM Prerequisites:
REM - Visual Studio 2022 (MSVC)
REM - Strawberry Perl installed and in PATH
REM - Ninja build system in PATH (to build with cmake)
REM - Python 3.11.x with html5lib (only needed for QtWebEngine)
REM - Bison, Flex, GPerf in PATH (only needed for QtWebEngine)
REM ========================================

REM Step 0: Create Qt folder on desktop if it doesn't exist
if not exist "%USERPROFILE%\Desktop\Qt" (
    echo Creating Qt folder on desktop...
    mkdir "%USERPROFILE%\Desktop\Qt"
)

REM Step 1: Set up Visual Studio environment
echo Setting up Visual Studio environment...
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
if errorlevel 1 (
    echo ERROR: Failed to set up Visual Studio environment
    pause
    exit /b 1
)

REM Step 2: Clone Qt 6.8.3 source (if not already done)
if not exist "%USERPROFILE%\Desktop\Qt\qt6" (
    cd "%USERPROFILE%\Desktop\Qt"
    git clone https://code.qt.io/qt/qt5.git qt6
)
cd "%USERPROFILE%\Desktop\Qt\qt6"
git switch 6.8.3

REM Step 3: Create separate build directory (IMPORTANT!)
cd "%USERPROFILE%\Desktop\Qt"
if not exist "qt6-build" mkdir qt6-build
cd qt6-build

REM Step 4: Initialize repositories with Maya 2027 modules
cd ..\qt6
:: Basic
perl init-repository --module-subset=qtbase,qttools
:: Advanced
::perl init-repository --module-subset=qtbase,qttools,qt3d,qt5compat,qtdeclarative,qtmultimedia,qtpositioning,qtremoteobjects,qtscxml,qtsensors,qtserialbus,qtserialport,qtshadertools,qtspeech,qtsvg,qtwebchannel,qtwebengine,qtwebsockets,qtwebview
cd ..\qt6-build

REM Step 5: Configure Qt 6.8.3 from build directory
call ..\qt6\configure.bat -prefix C:\Qt\6.8.3-maya -opensource -confirm-license -release -nomake examples -nomake tests

REM Step 6: Build Qt (this will take several hours)
cmake --build . --parallel

REM Step 7: Install to prefix location
cmake --install .

REM ========================================
REM Build complete! Qt installed to:
REM C:\Qt\6.8.3-maya
REM ========================================