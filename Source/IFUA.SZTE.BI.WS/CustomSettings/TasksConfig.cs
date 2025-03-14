using System.Collections.Generic;
using System.Xml.Serialization;

namespace IFUA.SZTE.BI.CustomSettings
{
    public class TasksConfig
    {
        [XmlArray("TaskItems")]
        public List<TaskConfigItem> TaskConfigItems { get; set; } = new List<TaskConfigItem>();

        public TasksConfig()
        {
        }

        public bool IsTaskEnabled(string taskName)
        {
            foreach (var taskConfigItem in TaskConfigItems)
            {
                if (taskConfigItem.TaskName == taskName)
                    return taskConfigItem.RunTask;
            }
            return false;
        }
    }
}
