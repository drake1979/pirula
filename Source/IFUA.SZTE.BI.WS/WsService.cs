using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.ServiceProcess;
using System.Threading.Tasks;
using System.Timers;
using IFUA.SZTE.BI.Services;

namespace IFUA.SZTE.BI
{
    /// <summary>
    /// Windows service wrapper
    /// </summary>
    /// <seealso cref="System.ServiceProcess.ServiceBase" />
    public partial class WsService : ServiceBase
    {
#if DEBUG
        private readonly int _timerInterval = 5;
#else
        private readonly int _timerInterval = 60;
#endif

        private TaskServiceRunner _taskRunner;
        private Timer _timer;
        private readonly TimeSpan _specifiedTime;
        private readonly TimeSpan _runInterval;
        private bool _hasRunToday;
        private readonly List<ITaskService> _taskList;
        private readonly bool _dailyRun;
        private DateTime _previousRun = DateTime.MinValue;
        private ConfigurationManagerWrapper _config = new ConfigurationManagerWrapper();

        public WsService(List<ITaskService> taskList, TimeSpan dailyRunOffset, TimeSpan recurringRunInterval, bool dailyRun = true)
        {
            _taskList = taskList;
            _taskRunner = new TaskServiceRunner(_taskList);
            _dailyRun = dailyRun;

            if (_dailyRun)
                _specifiedTime = dailyRunOffset;
            else
                _runInterval = recurringRunInterval;

            //if the specified time is already passed today, then we only run if 2x the interval has not passed
            _hasRunToday = DateTime.Now.TimeOfDay > _specifiedTime && (DateTime.Now.TimeOfDay - _specifiedTime) > TimeSpan.FromSeconds(_timerInterval * 2);

            InitializeComponent();
        }

        /// <summary>
        /// When implemented in a derived class, executes when a Start command is sent to the service by the Service Control Manager (SCM) or when the operating system starts (for a service that starts automatically). Specifies actions to take when the service starts.
        /// </summary>
        /// <param name="args">Data passed by the start command.</param>
        protected override void OnStart(string[] args)
        {
            try
            {
                _timer = new Timer();
                _timer.Interval = _timerInterval * 1000;
                _timer.Elapsed += OnElapsedTime;
                _timer.Start();

                EventLog.WriteEntry($"{_config["SERVICE_NAME"]} service Started", EventLogEntryType.Information);
            }
            catch (Exception ex)
            {
                //ezt azért kell így, mert az Exception-t nem írja az EventLog-ba
                EventLog.WriteEntry($"{_config["SERVICE_NAME"]} service Start Error: {ex}", EventLogEntryType.Error);
                throw;
            }
        }

        private async void OnElapsedTime(object sender, ElapsedEventArgs e)
        {
            DateTime now = DateTime.Now;
            Debug.WriteLine("Timer elapsed and checking for tasks to run...");

            if (_dailyRun)
                await DailyRunCheck(now);
            else
                await IntervalRunCheck(now);
        }

        private async Task IntervalRunCheck(DateTime now)
        {
            if ((_previousRun + _runInterval) < now)
            {
                _previousRun = now;
                Debug.WriteLine($"Starting timed processes at {now.ToShortDateString()} - {now.ToShortTimeString()}...");
                await StartServiceClass();
                Debug.WriteLine($"Timed process finished at {DateTime.Now.ToShortDateString()} - {DateTime.Now.ToShortTimeString()} started!");
            }
            else
            {
                Debug.WriteLine("No tasks to run now.");
            }
        }

        private async Task DailyRunCheck(DateTime now)
        {
            if (now.TimeOfDay >= _specifiedTime && !_hasRunToday)
            {
                Debug.WriteLine($"Starting timed processes at {now.ToShortDateString()} - {now.ToShortTimeString()}...");
                await StartServiceClass();
                Debug.WriteLine($"Timed process finished at {DateTime.Now.ToShortDateString()} - {DateTime.Now.ToShortTimeString()} started!");

                _hasRunToday = true;
            }
            else
            {
                Debug.WriteLine("No tasks to run now.");
            }

            if (now.TimeOfDay < _specifiedTime)
            {
                _hasRunToday = false;
            }
        }

        private Task StartServiceClass()
        {
            _ = _taskRunner.Start(() =>
            {
                _taskRunner = new TaskServiceRunner(_taskList);
            });

            return Task.CompletedTask;
        }

        protected override void OnStop()
        {
            try
            {
                _timer.Stop();
                _timer.Dispose();

                EventLog.WriteEntry($"{_config["SERVICE_NAME"]} service Stopped", EventLogEntryType.Information);
            }
            catch (Exception ex)
            {
                //ezt azért kell így, mert az Exception-t nem írja az EventLog-ba
                EventLog.WriteEntry($"{_config["SERVICE_NAME"]} service Stop Error: {ex}", EventLogEntryType.Error);
                throw;
            }
        }
    }
}