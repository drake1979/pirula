CREATE VIEW [dm].[Pharmacy Receipt Title] AS 
SELECT [PharmacyReceiptTitleKey] AS [Patikai kiváltás jogcím kulcs]
, [PharmacyReceiptTitleMedivusID] AS [Patikai kiváltás jogcím Medivus azonosító]
, [PharmacyReceiptTitleName] AS [Patikai kiváltás jogcím megnevezése]
, [ETLSessionID] AS [ETL betöltési ID]
FROM dm.DimPharmacyReceiptTitle
