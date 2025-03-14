using System;
using System.ServiceProcess;
using IFUA.SZTE.BI.Helpers;
using IFUA.SZTE.BI.Services;


namespace IFUA.SZTE.BI
{
    static class Program
    {
        /// <summary>
        /// A program futtatható Windows Forms hoszt process-ből, ha debug-olni akarod <br/>
        /// ehhez a Debug fülön a Command line arguments = debug
        /// </summary>
        static void Main(string[] args)
        {
            if (args != null && args.Length > 0 && args[0].ToLower() == "debug")
            {
                var frmDebug = new FrmDebug();
                frmDebug.ShowDialog();
            }
            else//Windows Service hoszt ág.
            {
                var config = new ConfigurationManagerWrapper();

                var tasks = TaskFactory.GetTasks();

                bool dailyRun = bool.Parse(config["RUN_DAILY"]);
                TimeSpan dailyRunOffsetTime = TimeSpan.Parse(config["DAILY_START_OFFSET_TIMESPAN"]);
                TimeSpan recurringRunInterval = TimeSpan.Parse(config["RECURRING_RUN_INTERVAL_TIMESPAN"]);

                var servicesToRun = new ServiceBase[]
                {
                    new WsService(tasks, dailyRunOffset: dailyRunOffsetTime, recurringRunInterval: recurringRunInterval, dailyRun: dailyRun)
                };

                ServiceBase.Run(servicesToRun);
            }
        }
    }
}
