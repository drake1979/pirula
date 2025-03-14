using System;
using System.Collections.Generic;
using System.IO;
using IFUA.SZTE.BI.CustomSettings;

namespace IFUA.SZTE.BI.Helpers
{
    public static class CustomSettingsHelper
    {
        private const string CustomSettingsFileName = "CustomSettings/CustomSettings.xml";

        public static string CustomSettingsFullPath => Path.Combine(AppDomain.CurrentDomain.BaseDirectory, CustomSettingsFileName);

        public static CustomSetting GetCustomSetting()
        {
            string coospaceMappingFilepath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, CustomSettingsFileName);

            CustomSetting customSetting = XmlSerializerHelper.DeserializeFromFile<CustomSetting>(coospaceMappingFilepath);

            return customSetting;
        }

        public static CoospaceMapping GetCoospaceMapping()
        {
            string coospaceMappingFilepath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, CustomSettingsFileName);

            CustomSetting customSetting = XmlSerializerHelper.DeserializeFromFile<CustomSetting>(coospaceMappingFilepath);

            return customSetting.CoospaceMapping;
        }

        public static TasksConfig GetTasksConfig()
        {
            string coospaceMappingFilepath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, CustomSettingsFileName);

            CustomSetting customSetting = XmlSerializerHelper.DeserializeFromFile<CustomSetting>(coospaceMappingFilepath);

            return customSetting.TasksConfig;
        }

        public static void WriteSampleSettingObject()
        {
            string sampleCustomSettingsFileName = "CustomSettings/SampleCustomSettings.xml";
            string sampleCustomSettingsFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, sampleCustomSettingsFileName);

            var customSettings = new CustomSetting
            {
                CoospaceMapping = new CoospaceMapping
                {
                    MappingItems = new List<CoospaceMappingItem>
                    {
                        new CoospaceMappingItem()
                        {
                            CoospaceBaseAddress = "baseAddress",
                            CoospaceFolderUrl = "folderUrl",
                            ImportDirectoryPath = "importDirectoryPath",
                            SourceName = "sourceName"
                        },
                        new CoospaceMappingItem()
                        {
                            CoospaceBaseAddress = "baseAddress",
                            CoospaceFolderUrl = "folderUrl",
                            ImportDirectoryPath = "importDirectoryPath",
                            SourceName = "sourceName"
                        }
                    }
                },
                TasksConfig = new TasksConfig
                {
                    TaskConfigItems = new List<TaskConfigItem>
                    {
                        new TaskConfigItem
                        {
                            RunTask = true,
                            TaskName = "taskName"
                        },
                        new TaskConfigItem
                        {
                            RunTask = true,
                            TaskName = "taskName"
                        }
                    }
                }
            };

            string xml = XmlSerializerHelper.Serialize(customSettings);
            File.WriteAllText(sampleCustomSettingsFilePath, xml);
        }
    }
}
