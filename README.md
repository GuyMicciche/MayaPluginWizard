# Maya Plugin Wizard for Visual Studio 2022/2019/2017

A Visual Studio extension that provides project templates and wizards for creating Autodesk Maya C++ plugins. This extension streamlines the process of setting up Maya plugin development environments with proper project structure and dependencies.

[![Maya Plugin Wizard](https://github.com/user-attachments/assets/2a0a8511-571b-41ea-9d8a-f9937188fcbe)](#---)
 
## Features

- **Project Templates**: Pre-configured project templates for Maya C++ plugin development
- **Wizard Integration**: Custom wizard implementation that guides users through plugin creation
- **Maya Integration**: Automatically configures Maya SDK references and build settings
- **Visual Studio Support**: Compatible with Visual Studio 2022/2019/2017



## Prerequisites

- Visual Studio 2017 or later
- Autodesk Maya (2019 or later)
- Maya DevKit installed
- .NET Framework 4.7.2 or later

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

1. Implement your plugin functionality in the generated source files
2. Build the project to create a `.mll` file
3. Copy the `.mll` file to `C:\Users\%USERNAME%\Documents\maya\2025\plug-ins` folder
4. Load the plugin in Maya using the Plug-in Manager
5. Test your plugin functionality

### Maya API Integration

The generated projects include:

- Proper Maya SDK include paths
- Maya library dependencies
- Plugin entry point functions
- Basic plugin structure following Maya conventions

### Qt Integration (2025+)
1. Find Qt version for your Maya version:
   - Maya 2026: Qt 6.5.3 (Qt comes in the [devkit](https://aps.autodesk.com/developer/overview/maya))
   - Maya 2025: Qt 6.5.3 (Qt comes in the [devkit](https://aps.autodesk.com/developer/overview/maya))
   - Maya 2024: Qt 5.15.2 (need to manually install [Qt](https://wiki.qt.io/Quick_Start:_Installing_Qt_on_Windows))
   - Maya 2023: Qt 5.15.2 (need to manually install [Qt](https://wiki.qt.io/Quick_Start:_Installing_Qt_on_Windows))
   - Maya 2022: Qt 5.15.2 (need to manually install [Qt](https://wiki.qt.io/Quick_Start:_Installing_Qt_on_Windows))
   - Maya 2020: Qt 5.12.5 (need to manually install [Qt](https://wiki.qt.io/Quick_Start:_Installing_Qt_on_Windows))
   - Maya 2019: Qt 5.12.5 (need to manually install [Qt](https://wiki.qt.io/Quick_Start:_Installing_Qt_on_Windows))
2. Get the devkit from [The Maya Developer Center](https://aps.autodesk.com/developer/overview/maya) and extract somewhere on your disk.
3. Install the **Qt Visual Studio Tools** Visual Studio extension by going to **Extensions > Manage Extensions...**
4. Go to **Extensions > Qt VS Tools > Qt Versions** and choose the `Location` where `qmake.exe` is in the devkit (`qmake.exe` will be in the `devkitBase/Qt/bin` folder) or in your Qt install location
<!-- <img src="https://github.com/user-attachments/assets/f6c910ea-9066-42b6-8911-5bff055d7b63" width="313" />
 <img src="https://github.com/user-attachments/assets/14437cae-6811-4671-8f0b-bfcce58af0f0" width="437" /> -->
 <img width="1552" height="711" alt="image" src="https://github.com/user-attachments/assets/2ca52163-3f84-4350-8551-8c453e8a13e9" />

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Maya Versions Supported
<img width="64" height="64" alt="MayaIcon" src="https://github.com/user-attachments/assets/dce4f103-adb1-4c5e-b6a6-60c6f7ddd7cf" />

- Maya 2019
- Maya 2020
- Maya 2021
- Maya 2022
- Maya 2023
- Maya 2024
- Maya 2025
- Maya 2026

## Related Resources

- [Maya Developer Help Center](https://help.autodesk.com/view/MAYADEV/2026/ENU/)
- [Maya API Documentation](https://help.autodesk.com/view/MAYADEV/2026/ENU/?guid=MAYA_API_REF_cpp_ref_index_html)
- [Visual Studio Extensibility Documentation](https://docs.microsoft.com/en-us/visualstudio/extensibility/)
- [VSIX extension schema 2.0 reference](https://learn.microsoft.com/en-us/visualstudio/extensibility/vsix-extension-schema-2-0-reference?view=vs-2022)
