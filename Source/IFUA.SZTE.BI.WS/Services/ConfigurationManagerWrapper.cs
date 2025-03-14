using System.Configuration;

namespace IFUA.SZTE.BI.Services
{
    public class ConfigurationManagerWrapper : IConfigurationManager
    {
        public string GetAppSetting(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        public string GetConnectionString(string name)
        {
            return ConfigurationManager.ConnectionStrings[name]?.ConnectionString;
        }

        public string this[string key] => GetAppSetting(key);
    }
}