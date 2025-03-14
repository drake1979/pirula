CREATE VIEW [dm].[Pharmacy] AS 
SELECT [PharmacyKey] AS [Patika kulcs]
, [PharmacyID] AS [Patika üzleti azonosító]
, [PharmacyName] AS [Patikai megnevezése]
, [ETLSessionID] AS [ETL betöltési ID]
FROM dm.DimPharmacy
