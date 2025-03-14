using System;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using IFUA.SZTE.BI.Helpers;

namespace IFUA.SZTE.BI.Services
{
    public class EmailTaskService : BaseTaskService, ITaskService, IDisposable
    {
        public EmailTaskService()
        {
        }

        protected override async Task DoExecuteTaskAsync()
        {
            //todo: Get from config 
            string smtpServerAddress = "localhost"; // Address of your Exchange SMTP server

            LogHelper.Log($"Sending Email task started!");

            if (!int.TryParse(Config["EMAIL_SMTP_PORT"], out var smtpPort))
                smtpPort = 25;

            // Sender and recipient email addresses
            string fromAddress = Config["EMAIL_FROM_ADDRESS"];
            string toAddress = Config["EMAIL_TO_ADDRESS"];

            // Email subject and body
            string subject = Config["EMAIL_SUBJECT_TEMPLATE"];
            string body = Config["EMAIL_BODY_TEMPLATE"];

            try
            {
                // Create a new SmtpClient instance
                using (SmtpClient smtpClient = new SmtpClient(smtpServerAddress, smtpPort))
                {
                    // Set credentials if required
                    smtpClient.Credentials = new NetworkCredential(Config["EMAIL_SMTP_USERNAME"], Secrets.Data["SmtpUserPassword"]); // Use appropriate credentials

                    // Create the email message
                    var mailMessage = new MailMessage(fromAddress, toAddress, subject, body);

                    // Optionally, set the sender address if it is different from the From address
                    // mailMessage.From = new MailAddress("sender@yourdomain.com");

                    // Send the email
                    await smtpClient.SendMailAsync(mailMessage);

                    LogHelper.Log("Email sent successfully.");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Log($"Failed to send email: {ex.Message}");
            }
        }
    }
}
