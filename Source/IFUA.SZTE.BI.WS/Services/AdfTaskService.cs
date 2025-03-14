using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using IFUA.SZTE.BI.Helpers;
using Microsoft.Identity.Client;

namespace IFUA.SZTE.BI.Services
{
    public class AdfTaskService : BaseTaskService
    {
        private string _source;

        public AdfTaskService(string source)
        {
            _source = source;
        }

        protected override async Task DoExecuteTaskAsync()
        {
            string clientId = Config["ADF_CLIENT_ID"];
            string clientSecret = Secrets.Data["ADFClientSecret"];
            string tenantId = Config["ADF_TENANT_ID"];
            string resourceId = Config["ADF_RESOURCE_ID"];

            string source = _source;
            LogHelper.Log($"ADF pipeline with source folder: {source} started!");

            var app = ConfidentialClientApplicationBuilder.Create(clientId)
                .WithClientSecret(clientSecret)
                .WithAuthority(new Uri($"https://login.microsoftonline.com/{tenantId}"))
                .Build();

            var scopes = new[] { $"{resourceId}/.default" };

            var result = await app.AcquireTokenForClient(scopes).ExecuteAsync();

            string accessToken = result.AccessToken;

            if (!string.IsNullOrEmpty(accessToken))
            {
                // Call method to trigger ADF pipeline with the obtained access token
                await TriggerPipelineAsync(accessToken, source);
            }
            else
            {
                LogHelper.Log("Failed to obtain access token.");
            }
        }

        private async Task TriggerPipelineAsync(string accessToken, string source, bool processEnabled = true, bool processOnError = false)
        {
            string subscriptionId = Config["ADF_SUBSCRIPTION_ID"];
            string resourceGroupName = Config["ADF_RESOURCEGROUP_NAME"];
            string dataFactoryName = Config["ADF_DATAFACTORY_NAME"];
            string pipelineName = Config["ADF_PIPELINE_NAME"];

            string apiUrl = $"https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{dataFactoryName}/pipelines/{pipelineName}/createRun?api-version=2018-06-01";

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                var parameters = new
                {
                    ProcessEnabled = processEnabled,
                    Source = source,
                    ProcessOnError = processOnError
                };

                var json = Newtonsoft.Json.JsonConvert.SerializeObject(parameters);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(apiUrl, content);

                if (response.IsSuccessStatusCode)
                {
                    LogHelper.Log("Pipeline run successfully triggered.");
                }
                else
                {
                    string errorMessage = await response.Content.ReadAsStringAsync();
                    LogHelper.Log($"Failed to trigger pipeline: {response.StatusCode}, {errorMessage}");
                }
            }
        }
    }
}
