CREATE VIEW [dm].[Pharmacy Movement Type] AS 
SELECT [PharmacyMovementTypeKey] AS [Patikai mozgásnem kulcs]
, [PharmacyMovementTypeMedivusID] AS [Patikai mozgásnem Medivus azonosító]
, [PharmacyMovementTypeName] AS [Patikai mozgásnem megnevezése]
, [PharmacyMovementTypeStorageMultiplier] AS [Készletszorzó]
, [ETLSessionID] AS [ETL betöltési ID]
FROM dm.DimPharmacyMovementType
