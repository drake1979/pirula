using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace IFUA.SZTE.BI
{
    /// <summary>
    /// MSSQL adatelérés
    /// </summary>
    public class SqlAccess : IDisposable
    {
        private readonly string _connectionString;
        private readonly int _commandTimeout = 3600;

        /// <summary>
        /// Konstruktor
        /// </summary>
        /// <remarks>
        /// Külső rendszerek eléréséhez
        /// </remarks>
        /// <param name="connectionString">Connection String</param>
        /// <param name="commandTimeout">Command timeout</param>
        public SqlAccess(string connectionString, int commandTimeout)
        {
            _connectionString = connectionString;
            _commandTimeout = commandTimeout;
        }

        /// <summary>
        /// Ad-hoc SQL utasítás végrehajtása
        /// </summary>
        /// <param name="query">SQL utasítás</param>
        public void ExecuteNonQuery(string query)
        {
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandTimeout = _commandTimeout;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Ad-hoc SQL utasítás végrehajtása
        /// </summary>
        /// <param name="query">SQL utasítás</param>
        /// <returns>Eredmény <see cref="System.Data.DataTable"/> példányban</returns>
        public DataTable ExecuteQuery(string query)
        {
            DataTable dt;

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.CommandTimeout = this._commandTimeout;
                    dt = new DataTable();

                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }

        /// <summary>
        /// T-SQL tárolt eljárás végrehajtása
        /// </summary>
        /// <param name="spName">Tárolt eljárás neve</param>
        /// <param name="parameters">Tárolt eljárás paraméterei</param>
        public void ExecuteStoredProcedure(string spName, List<SqlParameter> parameters)
        {
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(spName, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parameters != null)
                    {
                        foreach (SqlParameter parameter in parameters)
                        {
                            cmd.Parameters.Add(parameter);
                        }
                    }
                    cmd.CommandTimeout = _commandTimeout;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// T-SQL tárolt eljárás végrehajtása
        /// </summary>
        /// <param name="spName">Tárolt eljárás neve</param>
        /// <returns>Eredmény <see cref="System.Data.DataTable"/> példányban</returns>
        public DataTable LoadDataTable(string spName)
        {
            return LoadDataTable(spName, null);
        }

        /// <summary>
        /// T-SQL tárolt eljárás végrehajtása
        /// </summary>
        /// <param name="spName">Tárolt eljárás neve</param>
        /// <param name="parameters">Tárolt eljárás paraméterei</param>
        /// <returns>Eredmény <see cref="System.Data.DataTable"/> példányban</returns>
        public DataTable LoadDataTable(string spName, List<SqlParameter> parameters)
        {
            return LoadDataTable(spName, null, parameters);
        }

        /// <summary>
        /// T-SQL tárolt eljárás végrehajtása
        /// </summary>
        /// <param name="spName">Tárolt eljárás neve</param>
        /// <param name="tableName">Tábla neve, ha NULL, akkor az SP neve lesz a neve.</param>
        /// <param name="parameters">Tárolt eljárás paraméterei</param>
        /// <returns>Eredmény <see cref="System.Data.DataTable"/> példányban</returns>
        public DataTable LoadDataTable(string spName, string tableName, List<SqlParameter> parameters)
        {
            DataTable retDataTable;

            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(spName, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parameters != null)
                    {
                        foreach (SqlParameter parameter in parameters)
                        {
                            cmd.Parameters.Add(parameter);
                        }
                    }
                    cmd.CommandTimeout = _commandTimeout;
                    conn.Open();

                    SqlDataReader dataReader = cmd.ExecuteReader();
                    retDataTable = new DataTable(tableName == null ? spName : tableName);
                    retDataTable.Load(dataReader);
                }
            }

            return retDataTable;
        }

        /// <summary>
        /// Visszaad egy a kapcsolat példányt a Connection String alapján.
        /// </summary>
        /// <returns></returns>
        private SqlConnection GetConnection()
        {
            return new SqlConnection(_connectionString);
        }//func GetConnection

        #region ADO.NET Helper

        /// <summary>
        /// SqlParameter érték kiolvasása - string
        /// </summary>
        /// <param name="sqlParam"></param>
        /// <returns></returns>
        public string GetSqlParameterStringValue(SqlParameter sqlParam)
        {
            string value = null;
            if (sqlParam.Value != null && sqlParam.Value != DBNull.Value)
            {
                value = sqlParam.Value.ToString();
            }
            return value;
        }

        /// <summary>
        /// SqlParameter érték kiolvasása - int
        /// </summary>
        /// <param name="sqlParam"></param>
        /// <returns></returns>
        public int? GetSqlParameterIntValue(SqlParameter sqlParam)
        {
            int? value = null;
            if (sqlParam.Value != null && sqlParam.Value != DBNull.Value)
            {
                value = Int32.Parse(sqlParam.Value.ToString());
            }
            return value;
        }

        /// <summary>
        /// SqlParameter érték kiolvasása - DateTime
        /// </summary>
        /// <param name="sqlParam"></param>
        /// <returns></returns>
        public DateTime? GetSqlParameterDateTimeValue(SqlParameter sqlParam)
        {
            DateTime? value = null;
            if (sqlParam.Value != null && sqlParam.Value != DBNull.Value)
            {
                value = DateTime.Parse(sqlParam.Value.ToString());
            }

            return value;
        }

        /// <summary>
        /// SqlParameter érték kiolvasása - bool
        /// </summary>
        /// <param name="sqlParam"></param>
        /// <returns></returns>
        public bool? GetSqlParameterBooleanValue(SqlParameter sqlParam)
        {
            bool? value = null;
            if (sqlParam.Value != null && sqlParam.Value != DBNull.Value)
            {
                value = bool.Parse(sqlParam.Value.ToString());
            }
            return value;
        }

        #endregion

        /// <summary>
        /// GC
        /// </summary>
        public void Dispose()
        {
        }
    }
}
