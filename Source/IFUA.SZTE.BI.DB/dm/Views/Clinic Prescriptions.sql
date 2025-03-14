


CREATE VIEW [dm].[Clinic Prescriptions] AS

WITH Clinic_CTE AS
(
	SELECT [ClinicKey]
      ,cp.[DoctorKey]
      ,[EMSPrescriptionID]
      ,[PrescriptionID]
      --,CAST(PrescriptionID AS nvarchar) AS [PrescriptionID]
	  ,[PharmacyProductKey]
      ,[PrescriptionDate]
      ,[Quantity]
      ,[NetPurchaseValue]
      ,[NetSalesValue]
      ,cp.[ETLSessionID]
	  ,CASE WHEN CAST(PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(PrescriptionID AS nvarchar)
		--ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) AS decimal(21,0)) END AS [Kulcs]
		ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) AS nvarchar) END AS [Kulcs]
	FROM dm.FactClinicPrescriptions cp
		LEFT JOIN [dm].[DimDoctor] d ON cp.DoctorKey = d.DoctorKey
		LEFT JOIN dm.DimProductMedsol sol ON cp.PharmacyProductKey = sol.ProductMedsolKey
)


SELECT distinct [ClinicKey] AS [Klinika kulcs]
, [DoctorKey] AS [Orvos kulcs]
, [EMSPrescriptionID] AS [EMS recept azonosító]
, cte.[PrescriptionID] AS [eRecept / eVény azonosító]
, cte.[PharmacyProductKey] AS [Patikai cikk kulcs]
, pm.ProductTTTID AS [TTT kód]
--, pt.[Patikai mozgásnem kulcs]
, pm.ProductMedsolName AS [Patikai cikk megnevezés]
, [PrescriptionDate] AS [Felírás időpontja]
, CASE 
	WHEN pm.ProductTTTID IS NULL then 'Egyéb termék'
	WHEN LEFT(pm.ProductTTTID, 1) = 1 THEN 'Magi'
	WHEN LEFT(pm.ProductTTTID, 1) = 3 THEN 'GYSE'
	WHEN LEFT(pm.ProductTTTID, 1) = 4 THEN 'Kötszer'
	WHEN LEFT(pm.ProductTTTID, 1) = 5 THEN 'Csomagolóanyag'
	WHEN LEFT(pm.ProductTTTID, 1) = 6 THEN 'Magi díj'
	WHEN LEFT(pm.ProductTTTID, 2) = 21 THEN 'Speci'
	WHEN LEFT(pm.ProductTTTID, 2) = 22 THEN 'Tápszer'
	WHEN LEFT(pm.ProductTTTID, 2) = 23 THEN 'Szérum'
	WHEN LEFT(pm.ProductTTTID, 2) = 29 THEN 'Egyedi importos speci'
	ELSE 'Homeopátia' END AS [Termékkategória]
, pm.PrescriptionUnit [Menny. egys.]
, cte.[Quantity] AS [Mennyiség]
, cte.[NetPurchaseValue] AS [Nettó beszerzési érték]
, cte.[NetSalesValue] AS [Nettó fogyasztói érték]
, cte.[NetSalesValue] - cte.[NetPurchaseValue] AS [Nettó kisker. árrés érték]
, ka.kivaltas_arany AS [Kiváltás valószínűsége]
, cte.[ETLSessionID] AS [ETL betöltési ID]
, cte.Kulcs AS Kulcs
, pt.[Patika kulcs] AS [Patikai kulcs]

/* Kiváltott nettó érték számítás */
, CASE WHEN cte.Kulcs = CAST(cte.PrescriptionID as varchar) THEN pt.[Nettó összérték]
	ELSE cte.NetSalesValue * ka.kivaltas_arany END AS [Recept nettó érték - Saját patikában kiváltott]

/* Nem kiváltott nettó érték számítás] */
, cte.NetSalesValue - ISNULL(CASE WHEN cte.Kulcs = CAST(cte.PrescriptionID as varchar) THEN pt.[Nettó összérték]
	ELSE ROUND(cte.NetSalesValue * ka.kivaltas_arany, 0) END, 0) as [Recept nettó érték - Más patikában kiváltott]
	
/* Aktuális darabszám logika */
, cte.Quantity * ka.kivaltas_arany AS [Recept db - Saját patikában kiváltott]
, cte.Quantity - ISNULL(cte.Quantity * ka.kivaltas_arany, 0) AS [Recept db - Más patikában kiváltott]

, CASE WHEN cte.Kulcs = CAST(cte.PrescriptionID as varchar) THEN pt.[Nettó árrés értéke]
	ELSE ROUND((cte.[NetSalesValue] - cte.[NetPurchaseValue]) * ka.kivaltas_arany, 0) END AS [Nettó árrés - Saját patikában kiváltott]

FROM Clinic_CTE cte
	LEFT JOIN dm.Dátum d on cte.PrescriptionDate = d.[Dátum kulcs]
	LEFT JOIN dm.[Kivaltas Arany] ka on cte.Kulcs = ka.Kulcs
	LEFT JOIN [dm].DimProductMedsol pm on cte.PharmacyProductKey = pm.ProductMedsolKey
	LEFT JOIN [dm].[Pharmacy Transactions] pt ON cte.Kulcs = pt.Kulcs


