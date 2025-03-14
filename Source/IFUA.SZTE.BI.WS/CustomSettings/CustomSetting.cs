using System.Xml.Serialization;

namespace IFUA.SZTE.BI.CustomSettings
{
    public class CustomSetting
    {
        [XmlElement("CoospaceMapping")]
        public CoospaceMapping CoospaceMapping { get; set; } = new CoospaceMapping();

        [XmlElement("TasksConfig")]
        public TasksConfig TasksConfig { get; set; } = new TasksConfig();

        public CustomSetting()
        {
        }
    }
}
