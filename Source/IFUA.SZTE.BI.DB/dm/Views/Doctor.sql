CREATE VIEW [dm].[Doctor] AS 
SELECT [DoctorKey] AS [Orvos kulcs]
, [DoctorID] AS [Orvosi pecsétszám]
, [ETLSessionID] AS [ETL betöltési ID]
FROM dm.DimDoctor
