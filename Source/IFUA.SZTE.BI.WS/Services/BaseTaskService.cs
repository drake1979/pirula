using System.Diagnostics;
using System.Threading.Tasks;
using IFUA.SZTE.BI.Helpers;
using IFUA.SZTE.BI.ProtectedData;

namespace IFUA.SZTE.BI.Services
{
    public abstract class BaseTaskService : ITaskService
    {
        protected Secrets Secrets { get; private set; }
        protected ConfigurationManagerWrapper Config { get; set; }

        protected BaseTaskService()
        {
            LogHelper.Log($"Task {GetType().Name} is initializing...");
            using (var protection = new SecureStorage())
            {
                Secrets = protection.GetSecrets();
            }

            Config = new ConfigurationManagerWrapper();
        }

        protected abstract Task DoExecuteTaskAsync();

        public virtual async Task Run()
        {
            var sw = new Stopwatch();
            sw.Start();

            await DoExecuteTaskAsync().ConfigureAwait(false);

            sw.Stop();
            LogHelper.Log($"Task {GetType().Name} finished. Runtime: {sw.Elapsed}");

            LogHelper.Log($"Async operation completed successfully for Task: {this.GetType().Name}");
        }

        public virtual void Dispose()
        {
            LogHelper.Log($"Task {GetType().Name} is disposing...");
        }
    }
}