CREATE VIEW [dm].[Clinic] AS 
SELECT [ClinicKey] AS [Klinika kulcs]
, [ClinicID] AS [Klinika azonosító]
, [ClinicName] AS [Klinika megnevezése]
, [ClinicControllingID] AS [Klinika kontrolling azonosítója]
, [ClinicDepartmentID] AS [Klinikai osztály kódja]
, [ClinicDepartmentName] AS [Klinikai osztály típusa]
, [ETLSessionID] AS [ETL betöltési ID]
FROM dm.DimClinic
