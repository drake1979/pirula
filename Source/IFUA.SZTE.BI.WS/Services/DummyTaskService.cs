using System.Threading;
using System.Threading.Tasks;

namespace IFUA.SZTE.BI.Services
{
    public class DummyTaskService : BaseTaskService
    {
        public DummyTaskService()
        { }

        protected override async Task DoExecuteTaskAsync()
        {
            await Task.Run(() => Thread.Sleep(5000));
        }
    }
}
