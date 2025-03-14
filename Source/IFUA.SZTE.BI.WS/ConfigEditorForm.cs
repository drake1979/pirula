using System;
using System.Configuration;
using System.Windows.Forms;

namespace IFUA.SZTE.BI
{
    public partial class ConfigEditorForm : Form
    {
        public ConfigEditorForm()
        {
            InitializeComponent();
            LoadAppSettings();
        }

        // Load the current appSettings into the ListBox or any other control
        private void LoadAppSettings()
        {
            var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
            listBoxSettings.Items.Clear();

            foreach (var key in config.AppSettings.Settings.AllKeys)
            {
                listBoxSettings.Items.Add($"{key}={config.AppSettings.Settings[key].Value}");
            }
        }

        // Save the updated settings back to the app.config file
        private void SaveAppSettings()
        {
            var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);

            foreach (var item in listBoxSettings.Items)
            {
                var setting = item.ToString().Split('=');
                string key = setting[0];
                string value = setting[1];

                if (config.AppSettings.Settings[key] != null)
                {
                    config.AppSettings.Settings[key].Value = value;
                }
                else
                {
                    config.AppSettings.Settings.Add(key, value);
                }
            }

            config.Save(ConfigurationSaveMode.Modified);
            ConfigurationManager.RefreshSection("appSettings");
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            SaveAppSettings();
            MessageBox.Show("Settings saved successfully.");
            this.Close(); // Close the modal window after saving
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close(); // Close the modal window without saving
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (listBoxSettings.SelectedItem != null)
            {
                string selectedItem = listBoxSettings.SelectedItem.ToString();
                var setting = selectedItem.Split('=');
                string key = setting[0];
                string value = setting[1];

                // Prompt user to edit the value
                string newValue = Prompt.ShowDialog("Edit Value:", value);

                // Update the ListBox with the new value
                listBoxSettings.Items[listBoxSettings.SelectedIndex] = $"{key}={newValue}";
            }
        }
    }
}
