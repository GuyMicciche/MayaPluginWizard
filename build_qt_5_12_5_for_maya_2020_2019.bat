REM ========================================
REM Build Qt 5.12.5 for Maya 2024
REM ========================================
REM Prerequisites:
REM - Visual Studio 2019 or 2022 (MSVC)
REM - Strawberry Perl installed and in PATH
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

REM Step 2: Clone Qt 5.12.5 source (if not already done)
if not exist "%USERPROFILE%\Desktop\Qt\qt5" (
    cd "%USERPROFILE%\Desktop\Qt"
    git clone https://code.qt.io/qt/qt5.git qt5
)
cd "%USERPROFILE%\Desktop\Qt\qt5"
git checkout v5.12.5

REM Step 3: Initialize repositories with Maya 2020/2019 modules
:: Basic
perl init-repository --module-subset=qtbase,qttools
:: Advanced
::perl init-repository --module-subset=qtbase,qtsvg,qtmultimedia,qttools,qtserialport,qtserialbus,qtsensors,qtwebsockets,qtwebchannel,qtwebengine,qtxmlpatterns,qtnetworkauth,qtremoteobjects,qtscxml,qtspeech,qtactiveqt,qt3d,qtgamepad,qtlocation,qtdeclarative,qtquickcontrols2,qtwebview

REM Step 4: Configure Qt 5.12.5 to match Maya's build
configure.bat -prefix C:\Qt\5.12.5-maya -opensource -confirm-license -release -nomake examples -nomake tests

REM Step 5: Build Qt (this will take several hours)
nmake

REM Step 6: Install to prefix location
nmake install

REM ========================================
REM Build complete! Qt installed to:
REM C:\Qt\5.12.5-maya
REM ========================================