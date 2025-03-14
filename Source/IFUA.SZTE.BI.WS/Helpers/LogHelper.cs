using System;
using System.Diagnostics;
using System.IO;
using IFUA.SZTE.BI.Extensions;

namespace IFUA.SZTE.BI.Helpers
{
    public static class LogHelper
    {
        public delegate void LogEventHandler(string message);
        public static event LogEventHandler LogMessage;

        public static void Log(string message, EventLogEntryType eventLogEntryType = EventLogEntryType.Information)
        {
            string appDir = AppDomain.CurrentDomain.BaseDirectory;
            string logDir = Path.Combine(appDir, "Log");

            if (!Directory.Exists(logDir))
                Directory.CreateDirectory(logDir);

            string day = DateTime.Now.ToString("yyyyMMdd");
            string logFileName = "log_" + day + ".log";
            string logPathName = Path.Combine(logDir, logFileName);

            message = $"[{DateTime.Now.TimeStamp(formatString: "yyyy.MM.dd-HH:mm:ss")}] - {message}";

            if (!File.Exists(logPathName))
                File.WriteAllText(logPathName, message + Environment.NewLine);
            else
                File.AppendAllText(logPathName, message + Environment.NewLine);

            Console.WriteLine(message);
            LogMessage?.Invoke(message);
        }
    }
}
