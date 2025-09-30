/* Copyright 2020 Avicon */

using EnvDTE;
using Microsoft.VisualStudio.TemplateWizard;
using System;
using System.Collections.Generic;
using System.IO;

using Process = System.Diagnostics.Process;

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

        // This method is called after the project is created.
        public void RunFinished()
        {
            try
            {
                string assemblyDir = Path.GetDirectoryName(
                    System.Reflection.Assembly.GetExecutingAssembly().Location);

                // Batch file path inside Resources\Scripts
                string batchPath = Path.Combine(assemblyDir, "Resources", "Scripts", "maya_commandport_setup.bat");

                if (File.Exists(batchPath))
                {
                    var process = new Process();
                    process.StartInfo.FileName = "cmd.exe";
                    process.StartInfo.Arguments = "/c \"" + batchPath + "\"";
                    process.StartInfo.WorkingDirectory = Path.GetDirectoryName(batchPath);
                    process.StartInfo.CreateNoWindow = false; // true = silent
                    process.StartInfo.UseShellExecute = false;
                    process.Start();
                    process.WaitForExit();
                }
                else
                {
                    System.Windows.Forms.MessageBox.Show("Batch file not found: " + batchPath);
                }
            }
            catch (Exception ex)
            {
                System.Windows.Forms.MessageBox.Show("Error running setup: " + ex.Message);
            }
        }

        public void RunStarted(object automationObject, Dictionary<string, string> replacementsDictionary,
                WizardRunKind runKind, object[] customParams)
        {
        }

        // This method is only called for item templates,
        // not for project templates.
        public bool ShouldAddProjectItem(string filePath)
        {
            return true;
        }
    }
}