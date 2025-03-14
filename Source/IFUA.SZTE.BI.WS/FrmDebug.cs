using System;
using System.Threading.Tasks;
using System.Windows.Forms;
using IFUA.SZTE.BI.Helpers;
using IFUA.SZTE.BI.Services;
using TaskFactory = IFUA.SZTE.BI.Helpers.TaskFactory;

namespace IFUA.SZTE.BI
{
    public partial class FrmDebug : Form
    {

        private TaskServiceRunner _taskServiceRunner;

        public FrmDebug()
        {
            InitializeComponent();

            btnStart.Enabled = true;
            btnStop.Enabled = false;

            LogHelper.LogMessage += Logger_LogMessage;
        }

        private void InitTaskRunner()
        {
            var tasks = TaskFactory.GetTasks();
            _taskServiceRunner = new TaskServiceRunner(tasks);
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            InitTaskRunner();
            Task.Run(StartService);

            btnStart.Enabled = false;
            btnStop.Enabled = true;
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            btnStart.Enabled = true;
            btnStop.Enabled = false;
        }

        private async Task StartService()
        {
            await _taskServiceRunner.Start(TaskRunnerFinished);
        }

        private void TaskRunnerFinished()
        {
            _taskServiceRunner = null;

            Task.Run(() =>
            {
                if (btnStart.InvokeRequired)
                    btnStart.Invoke(new Action(() => btnStart.Enabled = true));
                else
                    btnStart.Enabled = true;  // If already on UI thread (just a safety check)

                if (btnStop.InvokeRequired)
                    btnStop.Invoke(new Action(() => btnStop.Enabled = false));
                else
                    btnStop.Enabled = false;  // If already on UI thread (just a safety check)
            });
        }

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }

            base.Dispose(disposing);
        }

        private void configureToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (var frmConfig = new FrmConfig())
            {
                frmConfig.ShowDialog();
            }
        }

        private void Logger_LogMessage(string message)
        {
            // Ensure the update happens on the UI thread
            if (richTextBox1.InvokeRequired)
            {
                // Invoke required since we're updating a UI control from a non-UI thread
                richTextBox1.Invoke(new Action(() => AppendTextToRichTextBox(message)));
            }
            else
            {
                AppendTextToRichTextBox(message);
            }
        }

        // Helper method to append the text to RichTextBox
        private void AppendTextToRichTextBox(string message)
        {
            richTextBox1.AppendText(message + Environment.NewLine);
            richTextBox1.ScrollToCaret(); // Auto-scroll to the bottom
        }

        private void editAppconfigToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ConfigEditorForm configEditor = new ConfigEditorForm();
            configEditor.ShowDialog(); // Open the editor as a modal window
        }
    }
}
