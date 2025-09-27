# Maya Plugin Wizard 2026 for Visual Studio

A Visual Studio extension that provides project templates and wizards for creating Autodesk Maya C++ plugins. This extension streamlines the process of setting up Maya plugin development environments with proper project structure and dependencies.

<p align="center">
  <img src="https://github.com/user-attachments/assets/350b030a-1f7a-4864-ae02-0f91bad63cfa?raw=true" alt="Maya Plugin Wizard"/>
</p>

## Features

- **Project Templates**: Pre-configured project templates for Maya C++ plugin development
- **Wizard Integration**: Custom wizard implementation that guides users through plugin creation
- **Maya Integration**: Automatically configures Maya SDK references and build settings
- **Visual Studio Support**: Compatible with Visual Studio 2019/2022

## Prerequisites

- Visual Studio 2019 or later
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
2. Go to **File > New > Project**
3. Navigate to **Visual C++ > Maya** templates
4. Select the desired Maya plugin template
5. Configure your project name and location
6. Follow the wizard prompts to configure Maya-specific settings

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
2. Open the solution in Visual Studio 2019/2022
3. Restore NuGet packages
4. Build the solution (F6)
5. Press F5 to run in experimental instance

### Project Components

- **WizardImplementation.cs**: Core wizard logic implementing `IWizard` interface
- **index.html**: Extension documentation and help content
- **stylesheet.css**: Styling for help content
- **packages.config**: NuGet package dependencies

## Maya Plugin Development

Once you've created a project using this wizard, you can:

1. Implement your plugin functionality in the generated source files
2. Build the project to create a `.mll` file
3. Load the plugin in Maya using the Plug-in Manager
4. Test your plugin functionality

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

## Maya Versions Supported

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
