/* Copyright 2020 Avicon */

using EnvDTE;
using Microsoft.VisualStudio.TemplateWizard;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace MayaPluginWizard
{
    public class WizardImplementation : IWizard
    {
        // This method is called before opening any item that
        // has the OpenInEditor attribute.
        public void BeforeOpeningFile(ProjectItem projectItem)
        {
        }

        public void ProjectFinishedGenerating(Project project)
        {
        }

        // This method is only called for item templates,
        // not for project templates.
        public void ProjectItemFinishedGenerating(ProjectItem projectItem)
        {
        }

        public void RunFinished()
        {
            try
            {
                string mayaVersion = GetMayaVersionFromEnvironment();
                if (string.IsNullOrEmpty(mayaVersion))
                {
                    mayaVersion = GetLatestInstalledMayaVersion();
                }

                if (string.IsNullOrEmpty(mayaVersion))
                {
                    MessageBox.Show(
                        "No Maya installation detected.\n\n" +
                        "Please install Maya and then create a new project.",
                        "Maya Setup",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                    return;
                }

                // Set environment variables if not already set
                SetMayaEnvironmentVariables(mayaVersion);

                SetupUserSetupPy(mayaVersion);

                MessageBox.Show(
                    $"Maya CommandPort setup completed for Maya {mayaVersion}!\n\n" +
                    $"✓ Created userSetup.py in Maya {mayaVersion} scripts folder\n" +
                    $"✓ Set MAYA_LOCATION environment variable\n" +
                    $"✓ Set MAYA_PLUG_IN_PATH environment variable\n\n" +
                    "Command ports: :20200 (MEL), :20201 (Python)",
                    "Setup Complete");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Setup error: {ex.Message}");
            }
        }

        private void SetMayaEnvironmentVariables(string mayaVersion)
        {
            try
            {
                string mayaLocation = $@"C:\Program Files\Autodesk\Maya{mayaVersion}";
                string mayaPluginPath = $@"%USERPROFILE%\Documents\maya\{mayaVersion}\plug-ins";

                // Check if MAYA_LOCATION is already set
                string existingMayaLocation = Environment.GetEnvironmentVariable("MAYA_LOCATION", EnvironmentVariableTarget.Machine);
                if (string.IsNullOrEmpty(existingMayaLocation))
                {
                    // Verify the Maya installation directory exists before setting
                    if (Directory.Exists(mayaLocation))
                    {
                        Environment.SetEnvironmentVariable("MAYA_LOCATION", mayaLocation, EnvironmentVariableTarget.User);
                    }
                }

                // Check if MAYA_PLUG_IN_PATH is already set
                string existingPluginPath = Environment.GetEnvironmentVariable("MAYA_PLUG_IN_PATH", EnvironmentVariableTarget.Machine);
                if (string.IsNullOrEmpty(existingPluginPath))
                {
                    Environment.SetEnvironmentVariable("MAYA_PLUG_IN_PATH", mayaPluginPath, EnvironmentVariableTarget.User);
                }
            }
            catch (Exception ex)
            {
                // Environment variable setting failed, but continue with userSetup.py creation
                MessageBox.Show(
                    $"Warning: Could not set environment variables: {ex.Message}\n\n" +
                    "You may need to set them manually:\n" +
                    $"MAYA_LOCATION = C:\\Program Files\\Autodesk\\Maya{mayaVersion}\n" +
                    $"MAYA_PLUG_IN_PATH = %USERPROFILE%\\Documents\\maya\\{mayaVersion}\\plug-ins",
                    "Environment Variables Warning");
            }
        }

        private string GetMayaVersionFromEnvironment()
        {
            string mayaLocation = Environment.GetEnvironmentVariable("MAYA_LOCATION");

            if (string.IsNullOrEmpty(mayaLocation) || !Directory.Exists(mayaLocation))
                return null;

            // Extract version from path like "C:\Program Files\Autodesk\Maya2025"
            string folderName = Path.GetFileName(mayaLocation.TrimEnd('\\'));

            var match = System.Text.RegularExpressions.Regex.Match(folderName, @"(\d{4})");
            if (match.Success)
            {
                string version = match.Groups[1].Value;

                if (int.TryParse(version, out int year) && year >= 2015 && year <= 2030)
                {
                    return version;
                }
            }

            return null;
        }

        private string GetLatestInstalledMayaVersion()
        {
            // Method 1: Check Documents\maya folder
            string mayaBasePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "maya");
            var documentVersions = new List<string>();

            if (Directory.Exists(mayaBasePath))
            {
                documentVersions = Directory.GetDirectories(mayaBasePath)
                    .Select(Path.GetFileName)
                    .Where(name => int.TryParse(name, out int year) && year >= 2015 && year <= 2030)
                    .OrderByDescending(v => int.Parse(v))
                    .ToList();
            }

            // Method 2: Check Program Files for Maya installations
            string programFiles = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
            string autodeskPath = Path.Combine(programFiles, "Autodesk");
            var installedVersions = new List<string>();

            if (Directory.Exists(autodeskPath))
            {
                var mayaDirs = Directory.GetDirectories(autodeskPath, "Maya*")
                    .Select(Path.GetFileName)
                    .Where(name => name.StartsWith("Maya", StringComparison.OrdinalIgnoreCase));

                foreach (string dir in mayaDirs)
                {
                    var match = System.Text.RegularExpressions.Regex.Match(dir, @"Maya(\d{4})");
                    if (match.Success)
                    {
                        string version = match.Groups[1].Value;
                        if (int.TryParse(version, out int year) && year >= 2015 && year <= 2030)
                        {
                            installedVersions.Add(version);
                        }
                    }
                }
            }

            // Combine and prioritize: prefer versions that exist in both locations
            var allVersions = documentVersions.Concat(installedVersions).Distinct()
                .OrderByDescending(v => int.Parse(v));

            // Prefer versions that have user directories (indicating Maya was actually run)
            var usedVersions = allVersions.Where(v => documentVersions.Contains(v));

            return usedVersions.FirstOrDefault() ?? allVersions.FirstOrDefault();
        }

        // ... keep your existing SetupUserSetupPy method unchanged

        private void SetupUserSetupPy(string mayaVersion)
        {
            string scriptsDir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                                           "maya", mayaVersion, "scripts");
            string userSetupFile = Path.Combine(scriptsDir, "userSetup.py");

            // Create scripts directory if it doesn't exist
            Directory.CreateDirectory(scriptsDir);

            if (!File.Exists(userSetupFile))
            {
                // Create new userSetup.py
                string content = @"# userSetup.py
import maya.cmds as cmds

# Command ports for external communication
cmds.commandPort(name="":20200"", sourceType=""mel"")
cmds.commandPort(name="":20201"", sourceType=""python"")
";
                File.WriteAllText(userSetupFile, content);
            }
            else
            {
                // Check and update existing file
                string content = File.ReadAllText(userSetupFile);

                bool needsImport = !System.Text.RegularExpressions.Regex.IsMatch(content,
                    @"^\s*import\s+maya\.cmds\s+as\s+cmds", System.Text.RegularExpressions.RegexOptions.Multiline);

                bool hasMelPort = content.Contains("20200") && content.Contains("mel");
                bool hasPythonPort = content.Contains("20201") && content.Contains("python");

                if (needsImport || !hasMelPort || !hasPythonPort)
                {
                    // Backup original
                    File.Copy(userSetupFile, userSetupFile + ".backup", true);

                    // Add missing components
                    var lines = new List<string>();

                    if (needsImport)
                    {
                        lines.Add("import maya.cmds as cmds");
                        lines.Add("");
                    }

                    lines.AddRange(File.ReadAllLines(userSetupFile));

                    if (!hasMelPort || !hasPythonPort)
                    {
                        lines.Add("");
                        lines.Add("# Command ports for external communication");
                        if (!hasMelPort)
                            lines.Add(@"cmds.commandPort(name="":20200"", sourceType=""mel"")");
                        if (!hasPythonPort)
                            lines.Add(@"cmds.commandPort(name="":20201"", sourceType=""python"")");
                    }

                    File.WriteAllLines(userSetupFile, lines);
                }
            }
        }

        // This method is called after the project is created.
        //public void RunFinished()
        //{
        //    try
        //    {
        //        string assemblyDir = Path.GetDirectoryName(
        //            System.Reflection.Assembly.GetExecutingAssembly().Location);

        //        // Batch file path, Add VSIX sub path if in folder, ex: Resources\Scripts\
        //        string batchPath = Path.Combine(assemblyDir, "maya_commandport_setup.bat");

        //        if (File.Exists(batchPath))
        //        {
        //            var processInfo = new ProcessStartInfo
        //            {
        //                FileName = batchPath, // Direct execution, no need for cmd.exe wrapper
        //                Arguments = "1", // Pass "1" for auto-detect option
        //                CreateNoWindow = true,
        //                UseShellExecute = false,
        //                RedirectStandardOutput = true,
        //                RedirectStandardError = true
        //            };

        //            using (var process = System.Diagnostics.Process.Start(processInfo))
        //            {
        //                process.WaitForExit();

        //                // Optional: Log output for debugging
        //                string output = process.StandardOutput.ReadToEnd();
        //                string error = process.StandardError.ReadToEnd();

        //                if (process.ExitCode != 0)
        //                {
        //                    // Only show errors, not success messages
        //                    MessageBox.Show($"Maya setup encountered an issue (Exit code: {process.ExitCode})");
        //                }
        //                // Silent success - no popup needed
        //            }
        //        }
        //        else
        //        {
        //            MessageBox.Show("Maya setup script not found: " + batchPath);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        MessageBox.Show("Error running setup: " + ex.Message);
        //    }
        //}

        public void RunStarted(object automationObject, Dictionary<string, string> replacementsDictionary,
                WizardRunKind runKind, object[] customParams)
        {
            //var assembly = System.Reflection.Assembly.GetExecutingAssembly();
            //MessageBox.Show($"Loaded: {assembly.FullName}\nLocation: {assembly.Location}");
        }

        // This method is only called for item templates,
        // not for project templates.
        public bool ShouldAddProjectItem(string filePath)
        {
            return true;
        }
    }
}