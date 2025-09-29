# Maya Plugin Wizard for Visual Studio 2022/2019/2017

A Visual Studio extension that provides project templates and wizards for creating Autodesk Maya C++ plugins. This extension streamlines the process of setting up Maya plugin development environments with proper project structure and dependencies.

[![Maya Plugin Wizard](https://github.com/user-attachments/assets/2a0a8511-571b-41ea-9d8a-f9937188fcbe)](#---)
 
## Features

- **Project Templates**: Pre-configured project templates for Maya C++ plugin development
- **Wizard Integration**: Custom wizard implementation that guides users through plugin creation
- **Maya Integration**: Automatically configures Maya SDK references and build settings
- **Visual Studio Support**: Compatible with Visual Studio 2022/2019/2017

## Maya Versions Supported
<img width="64" height="64" alt="MayaIcon" src="https://github.com/user-attachments/assets/dce4f103-adb1-4c5e-b6a6-60c6f7ddd7cf" />

**Maya 2026/2025/2024/2023/2022/2020/2019**

## Prerequisites

- Visual Studio 2017 or later
- Autodesk Maya 2019 or later
- Maya DevKit installed (for more control)
- .NET Framework 4.7.2 or later
- Python 3.9 or later (to run `unload_plugin.py` and `load_plugin.py` when you build)

## Installation

1. Download the latest VSIX package from the [Releases](../../releases) page
2. Double-click the `.vsix` file to install the extension
3. Restart Visual Studio
4. The Maya plugin templates will appear under Visual C++ templates

## Usage

### Creating a New Maya Plugin Project

1. Open Visual Studio
2. Go to **File > New > Project...** (Crtl+Shift+N)
3. Navigate to **Visual C++ > Maya** templates
4. Select the desired Maya plugin template
5. Configure your project name and location
6. Follow the wizard prompts to configure Maya-specific settings
7. Set `MAYA_LOCATION` variable in System **Properties > Environment Variables... > System variables** (ex. `C:\Program Files\Autodesk\Maya2026`

### Project Structure

The wizard creates a properly structured Maya plugin project with:

```
YourPluginName/
├── Source Files/
│   ├── pluginMain.cpp
│   └── YourPlugin.cpp
├── Header Files/
│   └── YourPlugin.h
├── Resource Files/
└── packages.config
```

## Dependencies

This extension uses the following NuGet packages:

- `Microsoft.VisualStudio.Imaging.Interop.14.0.DesignTime` (v17.14.40254)
- `Microsoft.VisualStudio.Interop` (v17.14.40260)

## Development

### Building from Source

1. Clone this repository
2. Open the solution in Visual Studio 2022/2019/2017
3. Restore NuGet packages
4. To change version number, open `MayaPluginWizard.csproj` and change the PropertyGroup `VsixVersion`
5. Project templates are automatically compressed into `.zip` files on build, and saved to **MayaPluginWizard/ProjectTemplates/Maya** directory
6. To add more project templates, , put them into the **ProjectTemplates/Maya** folder and add them in the `source.extension.vsixmanifest` under Assets
7. Build the Project by selecting the `MayaPluginWizard` project in the Solution Explorer (Ctrl+B)
8. Press F5 to run in experimental instance for debugging

### Project Components

- **WizardImplementation.cs**: Core wizard logic implementing `IWizard` interface
- **index.html**: Extension documentation and help content
- **stylesheet.css**: Styling for help content
- **packages.config**: NuGet package dependencies
- **ProjectTemplates/Maya** folder contains the `.zip` files that will be included in the build.

## Maya Plugin Development

Once you've created a project using this wizard, you can:
1. Setup System variables **System Properties > Environment Variables... > System variables**
   - MAYA_LOCATION
   - MAYA_PLUG_IN_PATH
 <img width="924" height="415" alt="image" src="https://github.com/user-attachments/assets/e87ef459-f53c-494e-bdb7-d3b8b6bc0ca1" />

2. Create or modify `userSetup.py` to include:
```python
# userSetup.py
import maya.cmds as cmds

cmds.commandPort(name=":20200", sourceType="mel")
cmds.commandPort(name=":20201", sourceType="python")
```
3. Implement your plugin functionality in the generated source files
4. Add Qt libs to **Project > Properties > Linker > Input > Additional Dependencies** if you are using Qt (ex: Qt6Core.lib;Qt6Gui.lib;Qt6Widgets.lib)
5. Build the project (Ctrl+B) to create a `.mll` file
   - If you have Maya open, `unload_plugin.py` and `load_plugin.py` should create a new file, unload the plugin, and the reload it
   - Modify `unload_plugin.py` if you don't want to create a new file
6. The `.mll` file should get copied to `MAYA_PLUG_IN_PATH` if you set it up correctly. Otherwise, manually copy the `.mll` file to `%USERPROFILE%\Documents\maya\2025\plug-ins` folder
7. Load the plugin in Maya using the Plug-in Manager
8. Test your plugin functionality

### Maya API Integration

The generated projects include:
- Proper Maya SDK include paths
- Maya library dependencies
- Plugin entry point functions
- Basic plugin structure following Maya conventions

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Qt Integration (**Qt Visual Studio Tools** only) 

These steps are only necessary if you plan on using the **Qt Visual Studio Tools** in Visual Studio:
1. Note Qt version for your Maya version:
   - Maya 2026: Qt 6.5.3 (Qt comes in the [devkit](https://aps.autodesk.com/developer/overview/maya))
   - Maya 2025: Qt 6.5.3 (Qt comes in the [devkit](https://aps.autodesk.com/developer/overview/maya))
   - Maya 2024: Qt 5.15.2 (Qt in Maya directory)
   - Maya 2023: Qt 5.15.2 (Qt in Maya directory)
   - Maya 2022: Qt 5.15.2 (Qt in Maya directory)
   - Maya 2020: Qt 5.12.5 (Qt in Maya directory)
   - Maya 2019: Qt 5.12.5 (Qt in Maya directory)
2. Install the **Qt Visual Studio Tools** Visual Studio extension by going to **Extensions > Manage Extensions...**
3. Go to **Extensions > Qt VS Tools > Qt Versions** and choose the `Location` where `qmake.exe` and `qtpaths.exe` are
   - For Maya 2025+ look in the `devkitBase/Qt/bin` folder, you might have to extract `Qt.zip` to your `devkitBase` directory
   - For Maya 2024 and below, look in `C:\Program Files\Autodesk\Maya2024\bin` folder, should have both files there
4. If using the devkit (Maya 2025+), download it from [The Maya Developer Center](https://aps.autodesk.com/developer/overview/maya) and extract somewhere on your disk.
5. If installing Qt (Maya 2024 and lower), see [Installing Qt](#installing-qt)

6. Right-click on your C++ project, click **Qt > Convert to Qt/MSBuild project**
7. Now every time you compile your project Qt will handle all the Qt specific files automatically (ex: Resources.qrc, converting to moc files, etc.)

## Installing Qt
1. [Download Qt for open source use](https://www.qt.io/download-qt-installer-oss)
2. You will need to create an account.
3. In the installer when you reach **Customize**, click **Show > Archive** and dropdown to **Qt > Qt 5.15.2** and check **MSVC 2019 64-bit** (don't check the entire Qt folder. In addition, you should also check CMake, under **Qt > Build Tools > CMake** if you don't already have it. Feel free to install Qt 6.5.3 if you want to use this installer for Maya 2025+.
4. Preferred location is C:\Qt
 <!-- <img src="https://github.com/user-attachments/assets/f6c910ea-9066-42b6-8911-5bff055d7b63" width="313" />
 <img src="https://github.com/user-attachments/assets/14437cae-6811-4671-8f0b-bfcce58af0f0" width="437" /> -->
 <img width="1624" height="1090" alt="Screenshot 2025-09-28 230416" src="https://github.com/user-attachments/assets/a7617736-7adc-4dcd-abeb-4f5e8b5062d2" />
5. Click Next, Next, Next, then click Install

## Building Qt (Prerequisite download links)
1. Download [Git Bash](https://gitforwindows.org/)
2. Download [Strawberry Perl](https://strawberryperl.com/)
3. Download [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.13.1/ninja-win.zip), and add it to your PATH environment variable
4. Download [GPerf](https://sourceforge.net/projects/gnuwin32/files/gperf/3.0.1/gperf-3.0.1-bin.zip/download?use_mirror=psychz&download)
5. Download [Bison](https://sourceforge.net/projects/gnuwin32/files/bison/2.4.1/bison-2.4.1-bin.zip/download?use_mirror=gigenet)
6. [Download [Flex](https://sourceforge.net/projects/gnuwin32/files/flex/2.5.4a-1/flex-2.5.4a-1-bin.zip/download?use_mirror=pilotfiber&download)

## Qt 6.5.3 build for Maya 2026/2025
```batch
REM ========================================
REM Build Qt 6.5.3 for Maya 2025/2026
REM ========================================
REM Prerequisites:
REM - Visual Studio 2019 or 2022 (MSVC)
REM - Strawberry Perl installed and in PATH
REM - Python 3.6+ (Maya 2025 uses Python 3.11.x) with html5lib
REM - Ninja build system in PATH
REM - Bison, Flex, GPerf also in PATH
REM ========================================

REM Step 1: Set up Visual Studio environment
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64

REM Step 2: Clone Qt 6.5.3 source (if not already done)
git clone https://code.qt.io/qt/qt5.git qt6
cd qt6
git switch 6.5.3

REM Step 3: Create separate build directory (IMPORTANT!)
cd C:\Users\Guy\Desktop\Qt
mkdir qt6-build
cd qt6-build

REM Step 4: Initialize submodules (only needed once)
cd ..\qt6
perl init-repository --module-subset=qtbase,qtdeclarative,qtmultimedia,qttools,qtpositioning,qtserialport,qtserialbus,qtsensors,qtwebsockets,qtwebchannel,qtwebengine,qtremoteobjects,qtscxml,qtspeech,qt3d,qtshadertools,qtsvg,qt5compat
cd ..\qt6-build

REM Step 5: Configure Qt 6.5.3 from build directory
..\qt6\configure.bat -prefix C:\Qt\6.5.3-maya -opensource -confirm-license -shared -debug-and-release -nomake examples -nomake tests -opengl desktop

REM Step 6: Build Qt (this will take several hours)
cmake --build . --parallel

REM Step 7: Install to prefix location
cmake --install .

REM ========================================
REM Build complete! Qt installed to:
REM C:\Qt\6.5.3-maya
REM ========================================
```

## Qt 5.15.2 build for Maya 2024/2023/2022
```batch
REM ========================================
REM Build Qt 5.15.2 for Maya 2024
REM ========================================
REM Prerequisites:
REM - Visual Studio 2019 (MSVC 14.2x)
REM - Strawberry Perl installed and in PATH
REM - Python 3.10.8 (Maya 2024's Python version)
REM ========================================

REM Step 1: Set up Visual Studio environment
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64

REM Step 2: Clone Qt 5.15.2 source
git clone https://code.qt.io/qt/qt5.git qt5
cd qt5
git checkout v5.15.2

REM Step 3: Initialize repositories with Maya 2024 modules
perl init-repository --module-subset=qtbase,qtsvg,qtmultimedia,qttools,qtserialport,qtserialbus,qtsensors,qtwebsockets,qtwebchannel,qtwebengine,qtxmlpatterns,qtnetworkauth,qtremoteobjects,qtscxml,qtspeech,qtactiveqt,qt3d,qtgamepad,qtlocation,qtdeclarative,qtquickcontrols2,qtwebview

REM Step 4: Configure Qt 5.15.2 to match Maya's build
configure.bat -prefix C:\Qt\5.15.2-maya -opensource -confirm-license -shared -debug-and-release -platform win32-msvc -opengl desktop -nomake examples -nomake tests -no-compile-examples -mp

REM Step 5: Build Qt (this will take several hours)
nmake

REM Step 6: Install to prefix location
nmake install

REM ========================================
REM Build complete! Qt installed to:
REM C:\Qt\5.15.2-maya
REM ========================================
```

## Qt 6.5.3 Module Mapping (Maya 2026/2025)

| Module | Provides Include Directories |
|--------|------------------------------|
| **qtbase** | QtCore, QtGui, QtWidgets, QtNetwork, QtSql, QtTest, QtConcurrent, QtOpenGL, QtOpenGLWidgets, QtPrintSupport, QtXml, QtDBus, QtDeviceDiscoverySupport, QtFbSupport, QtFreetype, QtHarfbuzz, QtJpeg, QtPng, QtZlib |
| **qtdeclarative** | QtQml, QtQmlCore, QtQmlModels, QtQmlWorkerScript, QtQmlLocalStorage, QtQmlXmlListModel, QtQmlIntegration, QtQmlCompiler, QtQmlTypeRegistrar, QtQmlDom, QtQmlDebug, QtQuick, QtQuickWidgets, QtQuickTest, QtQuickControls2, QtQuickControls2Impl, QtQuickTemplates2, QtQuickLayouts, QtQuickParticles, QtQuickShapes, QtQuickEffects, QtQuickDialogs2, QtQuickDialogs2QuickImpl, QtQuickDialogs2Utils, QtQuickTestUtils, QtQuickControlsTestUtils, QtPacketProtocol, QtLabsAnimation, QtLabsFolderListModel, QtLabsQmlModels, QtLabsSettings, QtLabsSharedImage, QtLabsWavefrontMesh, QtExampleIcons |
| **qtmultimedia** | QtMultimedia, QtMultimediaWidgets, QtMultimediaQuick, QtSpatialAudio |
| **qttools** | QtDesigner, QtDesignerComponents, QtHelp, QtUiTools, QtUiPlugin, QtTools |
| **qtpositioning** | QtPositioning, QtPositioningQuick |
| **qtserialport** | QtSerialPort |
| **qtserialbus** | QtSerialBus |
| **qtsensors** | QtSensors, QtSensorsQuick |
| **qtwebsockets** | QtWebSockets |
| **qtwebchannel** | QtWebChannel |
| **qtwebengine** | QtWebEngineCore, QtWebEngineWidgets, QtWebEngineQuick, QtPdf, QtPdfQuick, QtPdfWidgets, QtWebView, QtWebViewQuick |
| **qtremoteobjects** | QtRemoteObjects, QtRemoteObjectsQml, QtRepParser |
| **qtscxml** | QtScxml, QtScxmlQml, QtStateMachine, QtStateMachineQml |
| **qtspeech** | QtTextToSpeech |
| **qt3d** | Qt3DCore, Qt3DRender, Qt3DInput, Qt3DLogic, Qt3DAnimation, Qt3DExtras, Qt3DQuick, Qt3DQuickAnimation, Qt3DQuickExtras, Qt3DQuickInput, Qt3DQuickRender, Qt3DQuickScene2D |
| **qtshadertools** | QtShaderTools |
| **qtsvg** | QtSvg, QtSvgWidgets |
| **qt5compat** | QtCore5Compat |

## Qt 5.15.2 Module Mapping (Maya 2024/2023/2022)

| Module | Provides Include Directories |
|--------|------------------------------|
| **qtbase** | QtCore, QtGui, QtWidgets, QtNetwork, QtSql, QtTest, QtConcurrent, QtOpenGL, QtOpenGLExtensions, QtPrintSupport, QtXml, QtDBus, QtPlatformHeaders, QtAccessibilitySupport, QtThemeSupport, QtFontDatabaseSupport, QtDeviceDiscoverySupport, QtEdidSupport, QtEventDispatcherSupport, QtFbSupport, QtPlatformCompositorSupport, QtWindowsUIAutomationSupport, QtWinExtras, QtZlib |
| **qtsvg** | QtSvg |
| **qtmultimedia** | QtMultimedia, QtMultimediaWidgets, QtMultimediaQuick |
| **qttools** | QtDesigner, QtDesignerComponents, QtHelp, QtUiTools, QtUiPlugin |
| **qtserialport** | QtSerialPort |
| **qtserialbus** | QtSerialBus |
| **qtsensors** | QtSensors |
| **qtwebsockets** | QtWebSockets |
| **qtwebchannel** | QtWebChannel |
| **qtwebengine** | QtWebEngine, QtWebEngineCore, QtWebEngineWidgets, QtPdf, QtPdfWidgets |
| **qtxmlpatterns** | QtXmlPatterns |
| **qtnetworkauth** | (OAuth support) |
| **qtremoteobjects** | QtRemoteObjects, QtRepParser |
| **qtscxml** | QtScxml |
| **qtspeech** | QtTextToSpeech |
| **qtactiveqt** | ActiveQt (Windows only) |
| **qt3d** | Qt3DCore, Qt3DRender, Qt3DInput, Qt3DLogic, Qt3DAnimation, Qt3DExtras, Qt3DQuick, Qt3DQuickAnimation, Qt3DQuickExtras, Qt3DQuickInput, Qt3DQuickRender, Qt3DQuickScene2D |
| **qtgamepad** | QtGamepad |
| **qtlocation** | QtLocation, QtPositioning, QtPositioningQuick |
| **qtdeclarative** | QtQml, QtQmlModels, QtQmlWorkerScript, QtQuick, QtQuickWidgets, QtQuickTest, QtQuickParticles, QtQuickShapes, QtPacketProtocol, QtQmlDebug |
| **qtquickcontrols2** | QtQuickControls2, QtQuickTemplates2 |
| **qtwebview** | QtWebView |

---

# How to manually setup a Visual Studio environment for Maya C++ API and Qt

## Visual Studio Suggestion

Visual Studio 2022

## Variable Definition

Set in **System Properties > Environment Variable... > System variables**:
+ $(MAYA_LOCATION) : Your Maya installation directory
+ $(MAYA_PLUG_IN_PATH) : Your Maya plug-ins directory

## Configuration

### [All Configurations]

#### General

+ Configuration Properties -> General -> General Properties -> Output Directory -> `$(Configuration)\`
+ Configuration Properties -> General -> General Properties -> Intermediate Directory -> `$(Configuration)\`
+ Configuration Properties -> General -> General Properties -> Configuration Type -> `Dynamic Library (.dll)`
+ Configuration Properties -> General -> General Properties -> C++ Language Standard -> `ISO C++17 Standard (/std:c++17)`

#### Advanced

+ Configuration Properties -> Advanced -> Advanced Properties -> Target File Extension -> `.mll`

#### C/C++

+ Configuration Properties -> C/C++ -> General -> Additional Include Directories -> [%(MAYA_LOCATION)\include](https://msdn.microsoft.com/en-us/library/hhzbb5c8(v=vs.110).aspx)
+ Configuration Properties -> C/C++ -> General -> Debug Information Format -> [ProgramDatabase (/Zi)](https://msdn.microsoft.com/en-us/library/958x11bc(v=vs.110).aspx)
+ Configuration Properties -> C/C++ -> General -> Warning Level -> [Level3 (/W3)](https://msdn.microsoft.com/en-us/library/thxezb7y(v=vs.110).aspx)
+ Configuration Properties -> C/C++ -> General -> Multi-processor Compilation -> [Yes (/MP)](https://learn.microsoft.com/en-us/previous-versions/visualstudio/visual-studio-2012/bb385193(v=vs.110))

#### Linker

+ Configuration Properties -> Linker -> General -> Additional Library Directories -> [$(MAYA_LOCATION)\lib](https://msdn.microsoft.com/en-us/library/ee855621(v=vs.110).aspx)
+ Configuration Properties -> Linker -> Input -> Additional Dependencies -> [(Fill below)](https://msdn.microsoft.com/en-us/library/1xhzskbe(v=vs.110).aspx)

Foundation.lib</br>
OpenMaya.lib</br>
OpenMayaAnim.lib `(optional)`</br>
OpenMayaFX.lib `(optional)`</br>
OpenMayaRender.lib `(optional)`</br>
OpenMayaUI.lib `(optional)`

+ Configuration Properties -> Linker -> Command Line -> Additional Options -> `/export:initializePlugin /export:uninitializePlugin`

#### Build Events

Make sure `unload_plugin.py` and `load_plugin.py` are in your project directory, with [Python](https://www.python.org/) installed (not from the  Windows Store)
+ Configuration Properties -> Build Events -> Pre-Build Event -> `python $(ProjectDir)unload_plugin.py"`
+ Configuration Properties -> Build Events -> Post-Build Event -> `copy $(TargetPath) "$(MAYA_PLUG_IN_PATH)\$(TargetName)$(TargetExt)" /b /y
python $(ProjectDir)load_plugin.py`

---

### [Release]

#### Advanced

+ Configuration Properties -> Advanced -> Advanced Properties -> Use Debug Libraries -> `Yes`

#### C/C++

+ Configuration Properties -> C/C++ -> Optimization -> Optimization -> [Maximum Optimization (Favor Speed) (/O2)](https://msdn.microsoft.com/en-us/us-en/library/8f8h5cxt(v=vs.110).aspx)  
+ Configuration Properties -> C/C++ -> Preprocessor -> Preprocessor Definitions -> [(Fill below)](https://msdn.microsoft.com/en-us/library/hhzbb5c8(v=vs.110).aspx)

NDEBUG</br>
WIN32</br>
\_WINDOWS</br>
\_USRDLL</br>
NT\_PLUGIN</br>
\_HAS\_ITERATOR\_DEBUGGING=0</br>
\_SECURE\_SCL=0</br>
\_SECURE\_SCL\_THROWS=0</br>
\_SECURE\_SCL\_DEPRECATE=0</br>
\_CRT\_SECURE\_NO\_DEPRECATE</br>
TBB\_USE\_DEBUG=0</br>
\_\_TBB\_LIB_NAME=tbb.lib</br>
REQUIRE\_IOSTREAM</br>
AW\_NEW\_IOSTREAMS</br>
Bits64\_

---

### [Debug]

#### Advanced

+ Configuration Properties -> Advanced -> Advanced Properties -> Use Debug Libraries -> `No`

#### C/C++

+ Configuration Properties -> C/C++ -> Optimization -> Optimization -> [Disabled (/Od)](https://msdn.microsoft.com/en-us/us-en/library/8f8h5cxt(v=vs.110).aspx)
+ Configuration Properties -> C/C++ -> Preprocessor -> Preprocessor Definitions -> [(Fill below)](https://msdn.microsoft.com/en-us/library/hhzbb5c8(v=vs.110).aspx)

\_DEBUG</br>
WIN32</br>
\_WINDOWS</br>
\_USRDLL</br>
NT\_PLUGIN</br>
\_HAS\_ITERATOR\_DEBUGGING=0</br>
\_SECURE\_SCL=0</br>
\_SECURE\_SCL\_THROWS=0</br>
\_SECURE\_SCL\_DEPRECATE=0</br>
\_CRT\_SECURE\_NO\_DEPRECATE</br> TBB\_USE\_DEBUG=0</br>
\_\_TBB\_LIB\_NAME=tbb.lib</br>
REQUIRE\_IOSTREAM</br>
AW\_NEW\_IOSTREAMS</br>
Bits64\_

---

## Additional Qt Project Qwerks

NOTE: **Qt Visual Studio Tools** will do all of the following by default if you convert your project into a Qt project. 

+ If your project `.h` files has a Q_OBJECT in it, then a corresponding **moc** `.cpp` file will need to be generated. Right-click your `.h` file with Q_OBJECT and select **Properties**. Go to **Configuration Properties -> General -> Item Type** and set it to `Custom Build Tool`. Click **Apply**. Then go to **Custom Build Tool -> General** and enter the following:
  - Command Line: `"$(MAYA_LOCATION)\bin\moc.exe" "%(FullPath)" -o "$(ProjectDir)moc_%(Filename).cpp"`
  - Description: `Running moc on "%(FullPath)"`
  - Outputs: `$(ProjectDir)moc_%(Filename).cpp`
+ If your project has a `Resources.qrc` in it, then a corresponding **moc** `.cpp` file will need to be generated. Right-click your `.qrc` file and select **Properties**. Go to **Configuration Properties -> General -> Item Type** and set it to `Custom Build Tool`. Click **Apply**. Then go to **Custom Build Tool -> General** and enter the following:
  - Command Line: `"$(MAYA_LOCATION)\bin\rcc.exe" -name resources "%(FullPath)" -o "%(Filename).qrc.cpp"`
  - Description: `Converting resource "%(FullPath)"`
  - Outputs: `%(Filename).qrc.cpp`
+ After the first build, you will need to import all the generated `.cpp` files once. It will always get updated on each build. Again, this is not necessary if you are using the **Qt Visual Studio Tools** extension for Visual Studio

## Related Resources

- [Maya Developer Help Center](https://help.autodesk.com/view/MAYADEV/2026/ENU/)
- [Maya API Documentation](https://help.autodesk.com/view/MAYADEV/2026/ENU/?guid=MAYA_API_REF_cpp_ref_index_html)
- [Visual Studio Extensibility Documentation](https://docs.microsoft.com/en-us/visualstudio/extensibility/)
- [VSIX extension schema 2.0 reference](https://learn.microsoft.com/en-us/visualstudio/extensibility/vsix-extension-schema-2-0-reference?view=vs-2022)
- [Building Qt 6 from Git](https://wiki.qt.io/Building_Qt_6_from_Git)
- [Building Qt 5 from Git](https://wiki.qt.io/Building_Qt_5_from_Git)
