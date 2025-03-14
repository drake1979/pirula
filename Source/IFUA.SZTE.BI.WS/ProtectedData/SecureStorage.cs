using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;

namespace IFUA.SZTE.BI.ProtectedData
{
    public class SecureStorage : IDisposable
    {
        private readonly string _secretPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ProtectedData/secrets.json");
        public Secrets GetSecrets()
        {
            Secrets secrets;

            if (File.Exists(_secretPath))
            {
                string secretsJson = File.ReadAllText(_secretPath);
                secrets = JsonConvert.DeserializeObject<Secrets>(secretsJson);
            }
            else
            {
                secrets = new Secrets();
            }

            var keys = new List<string>(secrets.Data.Keys);
            foreach (string key in keys)
                secrets.Data[key] = DecryptString(secrets.Data[key]);

            return secrets;
        }

        public void SaveSecrets(Secrets secrets)
        {
            if (secrets == null)
                secrets = new Secrets();

            var keys = new List<string>(secrets.Data.Keys);
            foreach (string key in keys)
                secrets.Data[key] = EncryptString(secrets.Data[key]);

            var secretsJson = JsonConvert.SerializeObject(secrets, Formatting.Indented);
            File.WriteAllText(_secretPath, secretsJson);
        }

        private string EncryptString(string plainData)
        {
            string secureData = null;

            if (!string.IsNullOrEmpty(plainData))
            {
                byte[] plain = Encoding.UTF8.GetBytes(plainData);
                byte[] secure = System.Security.Cryptography.ProtectedData.Protect(plain, null, DataProtectionScope.LocalMachine);
                secureData = Convert.ToBase64String(secure);
            }

            return secureData;
        }

        private string DecryptString(string secureData)
        {
            string plainData = null;

            if (!string.IsNullOrEmpty(secureData))
            {
                byte[] plain = System.Security.Cryptography.ProtectedData.Unprotect(Convert.FromBase64String(secureData), null, DataProtectionScope.LocalMachine);
                plainData = Encoding.UTF8.GetString(plain);
            }

            return plainData;
        }

        public void Dispose()
        {
        }
    }
}