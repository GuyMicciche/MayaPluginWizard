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

## Building Qt (Just for fun!)
1. Download [Strawberry Perl](https://strawberryperl.com/)
2. Download [Git Bash](https://gitforwindows.org/)
3. Open `Git Bash`, cd inside any folder (ex. cd "%USERPROFILE%\Desktop\Qt"), and execute these commands to clone and initialize:
   ```bash
   # Initial cloning"
   git clone https://code.qt.io/qt/qt5.git
   cd qt5
   git checkout v5.15.2
   ```
   ```bash
   # Minimal common subset init (short download):
   perl init-repository --module-subset=qtbase,qtsvg,qtmultimedia,qttools,qtdeclarative
   ```
   ```bash
   # More comprehensive subset init (longer download):
   perl init-repository --module-subset=qtbase,qtsvg,qtmultimedia,qttools,qtserialport,qtserialbus,qtsensors,qtwebsockets,qtwebchannel,qtwebengine,qtxmlpatterns,qtnetworkauth,qtremoteobjects,qtscxml,qtspeech,qtactiveqt,qt3d,qtgamepad,qtlocation,qtdeclarative,qtquickcontrols2,qtwebview
   ```
4. Open `x64 Native Tools Command Prompt for VS 2022` and cd inside your temporary directory from step 3 (ex. cd ""%USERPROFILE%\Desktop\Qt"), and enter is command to build:
   ```bash
   # Build configuration (this will take a while)
   configure.bat -prefix C:\Qt\5.15.2-maya -opensource -confirm-license -shared -debug-and-release -platform win32-msvc -opengl desktop -nomake examples -nomake tests -no-compile-examples -mp
   ```
5. Qt will be available in `C:\Qt\5.15.2-maya`

## Related Resources

- [Maya Developer Help Center](https://help.autodesk.com/view/MAYADEV/2026/ENU/)
- [Maya API Documentation](https://help.autodesk.com/view/MAYADEV/2026/ENU/?guid=MAYA_API_REF_cpp_ref_index_html)
- [Visual Studio Extensibility Documentation](https://docs.microsoft.com/en-us/visualstudio/extensibility/)
- [VSIX extension schema 2.0 reference](https://learn.microsoft.com/en-us/visualstudio/extensibility/vsix-extension-schema-2-0-reference?view=vs-2022)
