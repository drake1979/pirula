using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using IFUA.SZTE.BI.Helpers;
using Microsoft.Azure.Management.DataFactory;
using Microsoft.Azure.Management.DataFactory.Models;
using Microsoft.Identity.Client;
using Microsoft.Rest;

namespace IFUA.SZTE.BI.Services
{
    public class AdfApiTaskService : BaseTaskService
    {
        private readonly string _source;

        public AdfApiTaskService(string source)
        {
            _source = source;
        }

        protected override async Task DoExecuteTaskAsync()
        {
            string source = _source;

            LogHelper.Log($"ADF pipeline with source folder: {source} started!");

            var accessToken = await GetAccessToken();

            int retryCount = 3;
            int currentAttempt = 0;
            PipelineRun pipelineRun;
            do
            {
                currentAttempt++;
                pipelineRun = new PipelineRun();

                LogHelper.Log($"Attempt {currentAttempt}/{retryCount} for source:{source} started...");

                pipelineRun = await RunAndWaitPipeline(accessToken, source);

                if (pipelineRun.Status != "Succeeded")
                    LogHelper.Log($"Attempt {currentAttempt}/{retryCount} for source:{source} failed.");
            }
            while (pipelineRun.Status != "Succeeded" && currentAttempt < retryCount);

            if (pipelineRun.Status == "Succeeded")
                LogHelper.Log("Pipeline completed successfully");
            else
                LogHelper.Log($"Pipeline failed with status: {pipelineRun.Status}");
        }

        private async Task<PipelineRun> RunAndWaitPipeline(string accessToken, string source)
        {
            string subscriptionId = Config["ADF_SUBSCRIPTION_ID"];
            string resourceGroupName = Config["ADF_RESOURCEGROUP_NAME"];
            string dataFactoryName = Config["ADF_DATAFACTORY_NAME"];
            string pipelineName = Config["ADF_PIPELINE_NAME"];

            var client = CreateClient(accessToken, subscriptionId);
            var parameters = new Dictionary<string, object>()
            {
                { "Source", source },
                { "ProcessEnabled", true },
                { "ProcessOnError", false }
            };

            var response = await client.Pipelines.CreateRunAsync(resourceGroupName, dataFactoryName, pipelineName, parameters: parameters);

            var runId = response.RunId;

            PipelineRun pipelineRun;
            do
            {
                await Task.Delay(TimeSpan.FromSeconds(10));

                pipelineRun = await client.PipelineRuns.GetAsync(resourceGroupName, dataFactoryName, runId);

                LogHelper.Log($"Pipeline status: {pipelineRun.Status}");
            }
            while (pipelineRun.Status != "Succeeded" && pipelineRun.Status != "Failed" && pipelineRun.Status != "Cancelled");

            return pipelineRun;
        }

        private static DataFactoryManagementClient CreateClient(string accessToken, string subscriptionId)
        {
            var cred = new TokenCredentials(accessToken);
            var client = new DataFactoryManagementClient(cred)
            {
                SubscriptionId = subscriptionId
            };
            return client;
        }

        private async Task<string> GetAccessToken()
        {
            string clientId = Config["ADF_CLIENT_ID"];
            string clientSecret = Secrets.Data["ADFClientSecret"];
            string tenantId = Config["ADF_TENANT_ID"];
            string resourceId = Config["ADF_RESOURCE_ID"];

            var app = ConfidentialClientApplicationBuilder.Create(clientId)
                .WithClientSecret(clientSecret)
                .WithAuthority(new Uri($"https://login.microsoftonline.com/{tenantId}"))
                .Build();

            var scopes = new[] { $"{resourceId}/.default" };

            var result = await app.AcquireTokenForClient(scopes).ExecuteAsync();

            string accessToken = result.AccessToken;
            return accessToken;
        }
    }
}
