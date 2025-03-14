using System;
using System.Collections.Generic;
using System.Data;
using System.Windows.Forms;
using IFUA.SZTE.BI.ProtectedData;

namespace IFUA.SZTE.BI
{
    public partial class FrmConfig : Form
    {
        private Secrets _secrets;
        private SecureStorage _secureStorage;
        private Dictionary<string, string> _dictionary;

        public FrmConfig()
        {
            _secureStorage = new SecureStorage();

            _secrets = _secureStorage.GetSecrets();
            _dictionary = _secrets.Data;

            InitializeComponent();

            dataGridView1.DataSource = _dictionary.ToDataTable();
            dataGridView1.Columns[0].Width = (int)(dataGridView1.Width * 0.4);
            dataGridView1.Columns[1].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
        }

        private void FrmConfig_Load(object sender, EventArgs e)
        {

        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            _dictionary.UpdateFromDataTable(dataGridView1.DataSource as DataTable);
            _secrets.Data = _dictionary;

            _secureStorage.SaveSecrets(_secrets);

            this.DialogResult = DialogResult.OK;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }
    }

    public static class DictionaryExtensions
    {
        public static DataTable ToDataTable(this Dictionary<string, string> dictionary)
        {
            var dt = new DataTable();
            dt.Columns.Add("Name");
            dt.Columns.Add("Value");

            foreach (var item in dictionary)
                dt.Rows.Add(item.Key, item.Value);

            return dt;
        }
        public static void UpdateFromDataTable(this Dictionary<string, string> dictionary,
            DataTable table)
        {
            foreach (DataRow row in table.Rows)
            {
                string key = row["Name"].ToString();
                string value = row["Value"].ToString();

                dictionary[key] = value;
            }
        }
    }
}
