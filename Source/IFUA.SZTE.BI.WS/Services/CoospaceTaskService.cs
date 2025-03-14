using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using IFUA.SZTE.BI.CustomSettings;
using IFUA.SZTE.BI.Extensions;
using IFUA.SZTE.BI.Helpers;
using WebDav;

namespace IFUA.SZTE.BI.Services
{
    public class CoospaceTaskService : BaseTaskService, ITaskService, IDisposable
    {
        private string _dbConnectionString;
        private int _dbSqlCommandTimeoutSec = 3600;
        private string _coospaceServiceWebdavCredentialUserName;
        private string _coospaceServiceWebdavCredentialPassword;
        private readonly CoospaceMapping _coospaceMapping;

        public CoospaceTaskService(CoospaceMapping coospaceMapping)
        {
            _coospaceMapping = coospaceMapping;
        }

        public CoospaceTaskService()
        {
            _coospaceMapping = CustomSettingsHelper.GetCoospaceMapping();
        }

        public new virtual async Task Run()
        {
            InitService();
            await ExecuteTask();
            Console.WriteLine($"Async operation completed successfully for Task: {this.GetType().Name}");
        }

        public async Task ExecuteTask()
        {
            var sw = new Stopwatch();
            sw.Start();

            int retryCount = 3;
            int trialAttempt = 1;
            while (trialAttempt <= retryCount)
            {
                if (await TryRunTask(trialAttempt))
                    break;

                trialAttempt++;
            }

            sw.Stop();
            LogHelper.Log($"Task {GetType().Name} finished. Runtime: {sw.Elapsed}");
        }

        private async Task<bool> TryRunTask(int trialAttempt)
        {
            try
            {
                InitService();
                await DoExecuteTaskAsync().ConfigureAwait(false);

                return true;
            }
            catch (Exception e)
            {
                LogHelper.Log($"Task {GetType().Name} threw an error {e.Message} at retry attempt {trialAttempt}.");
                return false;
            }
        }

        private void InitService()
        {
            _dbConnectionString = Config["DB_CONNECTIONSTRING"].Replace("@PASSWORD", Secrets.Data["DB"]);
            _dbSqlCommandTimeoutSec = int.Parse(Config["DB_SQLCOMMANDTIMEOUT_SEC"]);

            _coospaceServiceWebdavCredentialUserName = Config["COOSPACESERVICE_WEBDAV_CREDENTIAL_USERNAME"];
            _coospaceServiceWebdavCredentialPassword = Secrets.Data["Coospace"];
        }

        protected override async Task DoExecuteTaskAsync()
        {
            var timestamp = DateTime.Now.TimeStamp();

            //coospaceMapping felovasás
            LogHelper.Log($"Coospace import started at: {timestamp}", EventLogEntryType.Information);

            //lekérdezzük az állományokat
            DataTable dtImportFiles = null;
            DataTable dtPharmacies = null;
            using (var access = new SqlAccess(_dbConnectionString, _dbSqlCommandTimeoutSec))
            {
                dtImportFiles = access.LoadDataTable("[etl].[usp_GetImportFiles]");
                dtPharmacies = access.LoadDataTable("[etl].[usp_GetDimPharmacies]");
            }

            //coospaceFiles.Clear();
            //await InitializeCoospaceFileList(COOSPACESERVICE_WEBDAV_BASEADDRESS);
            //LogHelper.Log($"Coospace files collected: {coospaceFiles.Count}", EventLogEntryType.Information);

            foreach (var cmi in _coospaceMapping.MappingItems)
            {
                if (!CheckCoospaceMappingItem(cmi))
                    continue;

                var wcp = new WebDavClientParams
                {
                    BaseAddress = new Uri(cmi.CoospaceBaseAddress),
                    Credentials = new NetworkCredential(_coospaceServiceWebdavCredentialUserName, _coospaceServiceWebdavCredentialPassword)
                };

                using (var client = new WebDavClient(wcp))
                {
                    var downloadTasks = new List<Task>();

                    var mappingCoospaceFiles = await GetCoospaceFilesAsync(client, cmi.CoospaceFolderUrl);

                    LogHelper.Log($"Syncronize {cmi.SourceName}; CoospaceFileCount: {mappingCoospaceFiles.Count}", EventLogEntryType.Information);

                    if (cmi.SourceName.ToUpper() == "MEDIVUS")
                        downloadTasks = CopyMedivusFiles(cmi.CoospaceBaseAddress, timestamp, dtImportFiles, dtPharmacies, cmi, mappingCoospaceFiles);
                    else
                        downloadTasks = CopyFiles(cmi.CoospaceBaseAddress, timestamp, dtImportFiles, cmi, mappingCoospaceFiles);

                    await Task.WhenAll(downloadTasks);
                }

                LogHelper.Log($"Folder {cmi.CoospaceFolderUrl} downloaded successfully!");
            }
        }

        private bool CheckCoospaceMappingItem(CoospaceMappingItem cmi)
        {
            bool valid = true;

            if (string.IsNullOrEmpty(cmi.SourceName))
            {
                LogHelper.Log($"Invalid CoospaceMappingItem in CoospaceMapping.xml: SourceName is empty", EventLogEntryType.Error);
                valid = false;
            }

            if (string.IsNullOrEmpty(cmi.ImportDirectoryPath))
            {
                LogHelper.Log($"Invalid CoospaceMappingItem in CoospaceMapping.xml: ImportDirectoryPath is empty", EventLogEntryType.Error);
                valid = false;
            }

            if (string.IsNullOrEmpty(cmi.CoospaceFolderUrl))
            {
                LogHelper.Log($"Invalid CoospaceMappingItem in CoospaceMapping.xml: CoospaceFolderUrl is empty", EventLogEntryType.Error);
                valid = false;
            }

            return valid;
        }

        private async Task<List<SourceFile>> GetCoospaceFilesAsync(WebDavClient client, string resourceUri)
        {
            var collections = new List<string>();
            var coospaceFiles = new List<SourceFile>();

            await DoGetCoospaceFileList(client, resourceUri, collections, coospaceFiles);

            return coospaceFiles;
        }

        private async Task DoGetCoospaceFileList(WebDavClient client, string resourceUri, List<string> collections, List<SourceFile> coospaceFiles)
        {
            var stack = new Stack<string>();
            stack.Push(resourceUri);

            List<string> filenames;

            while (stack.Count > 0)
            {
                filenames = new List<string>();
                var currentResourceUri = stack.Pop();
                var result = await client.Propfind(currentResourceUri);

                if (!result.IsSuccessful)
                    continue;

                foreach (var resource in result.Resources)
                {
                    if (resource.IsCollection)
                    {
                        if (resource.Uri == null || collections.Contains(resource.Uri))
                            continue;

                        string refResourceUri = HttpUtility.UrlDecode(resource.Uri).ToLower();
                        string refDirUri = HttpUtility.UrlDecode(currentResourceUri).ToLower();

                        if (refResourceUri != currentResourceUri.ToLower() &&
                            refResourceUri != refDirUri)
                        {
                            stack.Push(resource.Uri);
                        }

                        collections.Add(resource.Uri);
                    }
                    else
                    {
                        coospaceFiles.Add(
                            new SourceFile()
                            {
                                SourceSystem = GetSourceSystem(resource.Uri),
                                FileUri = resource.Uri,
                                FileName = resource.DisplayName,
                                FileNameLower = resource.DisplayName.ToLower()
                            });

                        filenames.Add(resource.DisplayName);
                    }
                }

                filenames.ForEach(Console.WriteLine);
            }
        }

        private async Task DownloadFile(string coospaceBaseAddress, SourceFile cpFile, string vmFilePath)
        {
            var wcp = new WebDavClientParams
            {
                BaseAddress = new Uri(coospaceBaseAddress),
                Credentials = new NetworkCredential(_coospaceServiceWebdavCredentialUserName, _coospaceServiceWebdavCredentialPassword)
            };

            using (var client = new WebDavClient(wcp))
            {
                using (var file = await client.GetRawFile(cpFile.FileUri))
                {
                    using (FileStream fileStream = File.Create(vmFilePath))
                    {
                        await file.Stream.CopyToAsync(fileStream);
                        await fileStream.FlushAsync();
                    }
                }
            }
        }

        private List<Task> CopyFiles(string coospaceBaseAddress, string timestamp, DataTable dtImportFiles,
            CoospaceMappingItem cmi, List<SourceFile> coospaceFiles)
        {
            //lekérdezzük az összes Coospace állományt a forrás mappából            
            List<SourceFile> vmFiles = GetSourceFiles(cmi.ImportDirectoryPath, cmi.SourceName);
            List<SourceFile> cpFiles = coospaceFiles.Where(f => f.SourceSystem == cmi.SourceName).ToList();

            var downloadTasks = new List<Task>();

            foreach (SourceFile cpFile in cpFiles)
            {
                //ellenőrizzük, hogy az állomány már a VM mappájában van-e? (csak még nem dolgoztuk fel)
                if (vmFiles.FirstOrDefault(f => f.FileNameLower == cpFile.FileNameLower) != null)
                    continue;

                //ellenőrizzük, hogy betöltöttük-e már az állományt
                if (dtImportFiles.Select(string.Format("FileName='{0}'", cpFile.FileNameLower)).Length != 0)
                    continue;

                string dirPath = Path.Combine(cmi.ImportDirectoryPath, timestamp);
                string filePath = Path.Combine(cmi.ImportDirectoryPath, timestamp, cpFile.FileName);

                if (!Directory.Exists(dirPath))
                    Directory.CreateDirectory(dirPath);

                downloadTasks.Add(DownloadFile(coospaceBaseAddress, cpFile, filePath));

                LogHelper.Log($"File copy: {cpFile.FileUri} -> {filePath}");
            }

            return downloadTasks;
        }

        private List<Task> CopyMedivusFiles(string coospaceBaseAddress, string timestamp, DataTable dtImportFiles,
            DataTable dtPharmacies, CoospaceMappingItem cmi, List<SourceFile> coospaceFiles)
        {
            List<SourceFile> vmFiles = GetSourceFiles(cmi.ImportDirectoryPath, cmi.SourceName);
            List<SourceFile> cpFiles = coospaceFiles.Where(f => f.SourceSystem == cmi.SourceName).ToList();

            var downloadTasks = new List<Task>();

            foreach (SourceFile cpFile in cpFiles)
            {
                string pharmacyFileName = null;
                string pharmacyFileNameLower = null;

                //ULTI_Oszesitett_Forgalom_Tetelek_20220916_20220917_050599_1004_1000002.CSV
                string[] ultiSiteIds = cpFile.FileName.Split('_');
                if (cpFile.FileNameLower.StartsWith("ulti_") && ultiSiteIds.Length > 7)
                {
                    string ultiSiteId = ultiSiteIds[7];
                    string pharmacyId = dtPharmacies.Select(string.Format("UltiSiteId='{0}'", ultiSiteId))[0]["PharmacyID"].ToString();

                    pharmacyFileName = $"{pharmacyId}-{cpFile.FileName}";
                    pharmacyFileNameLower = pharmacyFileName.ToLower();
                }
                else
                {
                    pharmacyFileName = cpFile.FileName;
                    pharmacyFileNameLower = cpFile.FileNameLower;
                }

                //ellenőrizzük, hogy az állomány már a VM mappájában van-e? (csak még nem dolgoztuk fel)
                if (vmFiles.FirstOrDefault(f => f.FileNameLower == pharmacyFileNameLower) != null)
                    continue;

                //ellenőrizzük, hogy betöltöttük-e már az állományt
                if (dtImportFiles.Select(string.Format("FileName='{0}'", pharmacyFileNameLower)).Length != 0)
                    continue;

                string dirPath = Path.Combine(cmi.ImportDirectoryPath, timestamp);
                string filePath = Path.Combine(cmi.ImportDirectoryPath, timestamp, pharmacyFileName);

                if (!Directory.Exists(dirPath))
                    Directory.CreateDirectory(dirPath);

                downloadTasks.Add(DownloadFile(coospaceBaseAddress, cpFile, filePath));

                LogHelper.Log($"File copy: {cpFile.FileUri} -> {filePath}");
            }

            return downloadTasks;
        }

        /// <summary>
        /// Elkészíti a állomány metaadat listá.
        /// </summary>
        private List<SourceFile> GetSourceFiles(string dirPath, string sourceSystem)
        {
            List<SourceFile> sourceFiles = new List<SourceFile>();

            if (!Directory.Exists(dirPath))
                return sourceFiles;

            List<string> files = Directory.GetFiles(dirPath, "*.*", SearchOption.AllDirectories).ToList();

            foreach (string file in files)
            {
                sourceFiles.Add(
                    new SourceFile()
                    {
                        SourceSystem = sourceSystem,
                        FileUri = file,
                        FileName = Path.GetFileName(file),
                        FileNameLower = Path.GetFileName(file).ToLower()
                    });
            }

            return sourceFiles;
        }

        /// <summary>
        /// Visszaadja a forrásrendszer nevét.
        /// </summary>
        private string GetSourceSystem(string resourceUri)
        {
            string sourceSystemName = null;

            string encResourceUri = resourceUri.ToLower();
            string decResourceUri = HttpUtility.UrlDecode(resourceUri).ToLower();

            foreach (CoospaceMappingItem cmi in _coospaceMapping.MappingItems)
            {
                string ss_url = cmi.CoospaceFolderUrl.ToLower();

                if (!string.IsNullOrEmpty(ss_url) && (encResourceUri.StartsWith(ss_url) || decResourceUri.StartsWith(ss_url)))
                {
                    sourceSystemName = cmi.SourceName;
                    break;
                }
            }

            return sourceSystemName;
        }
    }
}
