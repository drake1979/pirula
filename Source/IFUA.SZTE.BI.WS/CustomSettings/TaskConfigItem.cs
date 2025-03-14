using System.Xml.Serialization;

namespace IFUA.SZTE.BI.CustomSettings
{
    [XmlType("TaskItem")]
    public class TaskConfigItem
    {
        public string TaskName { get; set; }
        public bool RunTask { get; set; } = true;
    }
}