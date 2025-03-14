using System;
using System.Threading.Tasks;

namespace IFUA.SZTE.BI
{
    public interface ITaskService : IDisposable
    {
        Task Run();
    }
}