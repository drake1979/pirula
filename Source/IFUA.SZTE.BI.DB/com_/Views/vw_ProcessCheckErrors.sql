
CREATE VIEW [com].[vw_ProcessCheckErrors]
AS
SELECT 'ExcelWholesaleRefund' AS LandingTableName, ca.[ErrorDescription], COUNT(*) AS Occurrences
  FROM [landing].[ExcelWholesaleRefund] m WITH (NOLOCK)
  CROSS APPLY (
     SELECT value as ErrorDescription from  string_split(Replace(m.ErrorDescription,char(10)+Char(13),';'),';')
  ) ca
  where m.ErrorDescription is not null and ca.ErrorDescription is not null and ca.ErrorDescription <> ''
  group by ca.ErrorDescription
  having COUNT(*) > 0
UNION ALL
SELECT 'MedivusPharmacyReceipt', ca.[ErrorDescription], COUNT(*)
  FROM [landing].[MedivusPharmacyReceipt] m WITH (NOLOCK)
  CROSS APPLY (
     SELECT value as ErrorDescription from  string_split(Replace(m.ErrorDescription,char(10)+Char(13),';'),';')
  ) ca
  where m.ErrorDescription is not null and ca.ErrorDescription is not null and ca.ErrorDescription <> ''
  group by ca.ErrorDescription
  having COUNT(*) > 0
UNION ALL
SELECT 'MedsolEmsReceipt', ca.[ErrorDescription], COUNT(*)
  FROM [landing].[MedsolEmsReceipt] m WITH (NOLOCK)
  CROSS APPLY (
     SELECT value as ErrorDescription from  string_split(Replace(m.ErrorDescription,char(10)+Char(13),';'),';')
  ) ca
  where m.ErrorDescription is not null and ca.ErrorDescription is not null and ca.ErrorDescription <> ''
  group by ca.ErrorDescription
  having COUNT(*) > 0
UNION ALL
SELECT 'NaviRLS', ca.[ErrorDescription], COUNT(*)
  FROM [landing].[NaviRLS] m WITH (NOLOCK)
  CROSS APPLY (
     SELECT value as ErrorDescription from  string_split(Replace(m.ErrorDescription,char(10)+Char(13),';'),';')
  ) ca
  where m.ErrorDescription is not null and ca.ErrorDescription is not null and ca.ErrorDescription <> ''
  group by ca.ErrorDescription
  having COUNT(*) > 0
UNION ALL
SELECT 'PuphaGyogysz', ca.[ErrorDescription], COUNT(*)
  FROM [landing].[PuphaGyogysz] m WITH (NOLOCK)
  CROSS APPLY (
     SELECT value as ErrorDescription from  string_split(Replace(m.ErrorDescription,char(10)+Char(13),';'),';')
  ) ca
  where m.ErrorDescription is not null and ca.ErrorDescription is not null and ca.ErrorDescription <> ''
  group by ca.ErrorDescription
  having COUNT(*) > 0