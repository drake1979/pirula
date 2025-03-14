using System;
using System.Diagnostics;
using System.Threading.Tasks;
using IFUA.SZTE.BI.Helpers;
using Microsoft.Identity.Client;
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;
using Microsoft.Rest;

namespace IFUA.SZTE.BI.Services
{
    public class PowerBITaskService : BaseTaskService, ITaskService, IDisposable
    {
        public PowerBITaskService()
        {
        }

        protected override async Task DoExecuteTaskAsync()
        {
            string clientId = Config["PBI_CLIENT_ID"];
            string clientSecret = Secrets.Data["PowerBIClientSecret"];
            string tenantId = Config["PBI_TENANT_ID"];
            string powerBiRootUrl = Config["PBI_ROOT_URL"];
            Guid workspaceId = new Guid(Config["PBI_WORKSPACE_ID"]);
            string datasetNames = Config["PBI_CSV_DATASET_NAMES"];
            var datasetNamesList = datasetNames.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries);

            var accessToken = GetAppOnlyAccessToken(clientId, clientSecret, tenantId);

            if (!string.IsNullOrEmpty(accessToken))
            {
                using (var pbiClient = GetPowerBiAppOnlyClient(accessToken, powerBiRootUrl))
                {
                    try
                    {
                        bool first = true;
                        foreach (var datasetName in datasetNamesList)
                        {
                            if (!first)
                                await Task.Delay(10000);

                            await RefreshDataSet(pbiClient, workspaceId, datasetName);
                            first = false;
                        }
                        first = true;
                    }
                    catch (Exception e)
                    {
                        LogHelper.Log($"Task {GetType().Name} failed: {e.Message}", EventLogEntryType.Error);
                    }
                }
            }
            else
            {
                LogHelper.Log("Failed to obtain access token.");
            }
        }

        private string GetAppOnlyAccessToken(string clientId, string clientSecret, string tenantId)
        {
            var appConfidential = ConfidentialClientApplicationBuilder.Create(clientId)
                .WithClientSecret(clientSecret)
                .WithAuthority(new Uri($"https://login.microsoftonline.com/{tenantId}"))
                .Build();

            string[] scopesDefault = { "https://analysis.windows.net/powerbi/api/.default" };

            var authResult = appConfidential.AcquireTokenForClient(scopesDefault).ExecuteAsync().Result;
            return authResult.AccessToken;
        }

        private PowerBIClient GetPowerBiAppOnlyClient(string accessToken, string powerBiRootUrl)
        {
            var tokenCredentials = new TokenCredentials(accessToken, "Bearer");
            return new PowerBIClient(new Uri(powerBiRootUrl), tokenCredentials);
        }

        private async Task RefreshDataSet(PowerBIClient pbiClient, Guid workspaceId, string datasetName)
        {
            LogHelper.Log($"Refreshing dataset {datasetName}...");
            Dataset ds = await GetDataset(pbiClient, workspaceId, datasetName);

            //retry 5 times if dataset is not refreshable
            for (int i = 0; i < 5 && (ds == null || !ds.IsRefreshable.HasValue || !ds.IsRefreshable.Value); i++)
            {
                ds = await GetDataset(pbiClient, workspaceId, datasetName);
                await Task.Delay(1000);
            }

            await pbiClient.Datasets.RefreshDatasetAsync(workspaceId, ds.Id);

            LogHelper.Log($"Dataset {datasetName} refreshed.");
        }

        public async Task<Dataset> GetDataset(PowerBIClient pbiClient, Guid workspaceId, string datasetName)
        {
            Dataset dataset = null;

            Datasets datasetObject = await pbiClient.Datasets.GetDatasetsInGroupAsync(workspaceId);
            var dataSets = datasetObject.Value;

            foreach (var ds in dataSets)
            {
                if (ds.Name.ToLower().Contains(datasetName.ToLower()))
                {
                    dataset = ds;
                    break;
                }
            }
            return dataset;
        }
    }
}
