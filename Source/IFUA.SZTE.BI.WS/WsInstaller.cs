using System.ComponentModel;
using System.Configuration.Install;
using System.ServiceProcess;

namespace IFUA.SZTE.BI
{
    [RunInstaller(true)]
    public partial class WsInstaller : System.Configuration.Install.Installer
    {
        private ServiceProcessInstaller serviceProcessInstaller;
        private ServiceInstaller serviceInstaller;

        public WsInstaller()
        {
            InitializeComponent();

            serviceProcessInstaller = new ServiceProcessInstaller();
            serviceProcessInstaller.Account = ServiceAccount.LocalService;
            serviceInstaller = new ServiceInstaller();
            serviceInstaller.ServiceName = "SZTEBIWS";
            Installers.Add(serviceProcessInstaller);
            Installers.Add(serviceInstaller);
        }
    }
}
