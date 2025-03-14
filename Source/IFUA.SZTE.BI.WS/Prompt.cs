using System.Windows.Forms;

namespace IFUA.SZTE.BI
{
    public static class Prompt
    {
        public static string ShowDialog(string text, string defaultValue)
        {
            Form prompt = new Form()
            {
                Width = 300,
                Height = 150,
                Text = text
            };
            Label textLabel = new Label() { Left = 20, Top = 20, Text = text };
            TextBox inputBox = new TextBox() { Left = 20, Top = 50, Width = 240, Text = defaultValue };
            Button confirmation = new Button() { Text = "Ok", Left = 160, Width = 100, Top = 80, DialogResult = DialogResult.OK };
            confirmation.Click += (sender, e) => { prompt.Close(); };
            prompt.Controls.Add(inputBox);
            prompt.Controls.Add(confirmation);
            prompt.Controls.Add(textLabel);
            prompt.AcceptButton = confirmation;

            return prompt.ShowDialog() == DialogResult.OK ? inputBox.Text : defaultValue;
        }
    }
}