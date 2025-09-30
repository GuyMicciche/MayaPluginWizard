REM ========================================
REM Build Qt 6.5.3 for Maya 2025/2026
REM ========================================
REM Prerequisites:
REM - Visual Studio 2019 or 2022 (MSVC)
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
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64

REM Step 2: Clone Qt 6.5.3 source (if not already done)
if not exist "%USERPROFILE%\Desktop\Qt\qt6" (
    cd "%USERPROFILE%\Desktop\Qt"
    git clone https://code.qt.io/qt/qt5.git qt6
)
cd "%USERPROFILE%\Desktop\Qt\qt6"
git switch 6.5.3

REM Step 3: Create separate build directory (IMPORTANT!)
cd "%USERPROFILE%\Desktop\Qt"
if not exist "qt6-build" mkdir qt6-build
cd qt6-build

REM Step 4: Initialize repositories with Maya 2026/2025 modules
cd ..\qt6
:: Basic
perl init-repository --module-subset=qtbase,qttools
:: Advanced
::perl init-repository --module-subset=qtbase,qtdeclarative,qtmultimedia,qttools,qtpositioning,qtserialport,qtserialbus,qtsensors,qtwebsockets,qtwebchannel,qtwebengine,qtremoteobjects,qtscxml,qtspeech,qt3d,qtshadertools,qtsvg,qt5compat
cd ..\qt6-build

REM Step 5: Configure Qt 6.5.3 from build directory
..\qt6\configure.bat -prefix C:\Qt\6.5.3-maya -opensource -confirm-license -release -nomake examples -nomake tests

REM Step 6: Build Qt (this will take several hours)
cmake --build . --parallel

REM Step 7: Install to prefix location
cmake --install .

REM ========================================
REM Build complete! Qt installed to:
REM C:\Qt\6.5.3-maya
REM ========================================