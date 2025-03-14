using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
using IFUA.SZTE.BI.Helpers;

namespace IFUA.SZTE.BI.Services
{
    public class TaskServiceRunner
    {
        private readonly List<ITaskService> _taskServices;

#if DEBUG
        private readonly int _waitBetweenTasksSeconds = 5;
#else
        private readonly int _waitBetweenTasksSeconds = 60;
#endif

        public ServiceState State { get; set; } = ServiceState.Created;

        public TaskServiceRunner(List<ITaskService> taskServices)
        {
            _taskServices = taskServices;
        }

        public async Task Start(Action finishedCallback)
        {
            State = ServiceState.Started;

            try
            {
                foreach (var taskService in _taskServices)
                {
                    await taskService.Run();

                    //wait after tasks to ensure that the previous task has finished
                    await Task.Delay(_waitBetweenTasksSeconds * 1000);
                }

                foreach (var taskService in _taskServices)
                    taskService.Dispose();
            }
            catch (Exception e)
            {
                State = ServiceState.Failed;
                LogHelper.Log($"TaskServiceRunner failed: {e.Message}", EventLogEntryType.Error);

                throw;
            }

            State = ServiceState.Finished;
            finishedCallback();
        }
    }
}
