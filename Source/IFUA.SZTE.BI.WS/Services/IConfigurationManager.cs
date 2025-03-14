namespace IFUA.SZTE.BI.Services
{
    public interface IConfigurationManager
    {
        string GetAppSetting(string key);
        string GetConnectionString(string name);
        // Add other methods as needed
    }
}