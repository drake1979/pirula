using System.Collections.Generic;
using IFUA.SZTE.BI.CustomSettings;
using IFUA.SZTE.BI.Services;

namespace IFUA.SZTE.BI.Helpers
{
    public static class TaskFactory
    {
        public static List<ITaskService> GetTasks()
        {
            var tasks = new List<ITaskService>();
            var coospaceMapping = CustomSettingsHelper.GetCoospaceMapping();
            TasksConfig tasksConfig = CustomSettingsHelper.GetTasksConfig();

            // Dummy task
            if (tasksConfig.IsTaskEnabled("DummyTaskService"))
                tasks.Add(new DummyTaskService());

            // Coospace task
            if (tasksConfig.IsTaskEnabled("CoospaceTaskService"))
                tasks.Add(new CoospaceTaskService(coospaceMapping));

            // ADF task
            if (tasksConfig.IsTaskEnabled("AdfApiTaskService"))
            {
                var adfTasks = new List<AdfApiTaskService>();
                foreach (var mappingItem in coospaceMapping.MappingItems)
                    adfTasks.Add(new AdfApiTaskService(mappingItem.SourceName));

                tasks.AddRange(adfTasks);
            }

            // PowerBI task
            if (tasksConfig.IsTaskEnabled("PowerBITaskService"))
                tasks.Add(new PowerBITaskService());

            // Email task
            if (tasksConfig.IsTaskEnabled("EmailTaskService"))
                tasks.Add(new EmailTaskService());

            return tasks;
        }
    }
}
