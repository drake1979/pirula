







CREATE VIEW [dm].[Pharmacy Transactions] AS 

SELECT pt.[PharmacyKey] AS [Patika kulcs]
, [PharmacyMovementTypeKey] AS [Patikai mozgásnem kulcs]
, [PharmacyReceiptID] AS [Patikai bizonylat azonosítója]
, [PharmacyReceiptItemID] AS [Patikai bizonylattétel azonosítója]
, [PrescriptionID] AS [Vény azonosító]
, [PharmacyProductKey] AS [Patikai cikk kulcs]
, med.ProductTTTID AS [TTT kód]
, [PharmacyReceiptTitleKey] AS [Patikai kiváltás jogcím kulcs]
, [PurchaseDate] AS [Kiváltás időpontja]
, [Quantity] AS [Mennyiség]
, [NetPurchaseValue] AS [Nettó beszerzési érték]
, [NetPaidValue] AS [Nettó (fogyasztó által) fizetett érték]
, [NetSupportValue] AS [Nettó támogatási érték (NEAK)]
, [NetSalesValue] AS [Nettó összérték]
, [NetMargin] AS [Nettó árrés értéke]
, [NetMarginCorrection] AS [Nettó árrés korrekció]
, pt.[ETLSessionID] AS [ETL betöltési ID]
, CASE WHEN med.NetWholesalePrice <= 500 THEN 'A. 0 - 500'
	WHEN med.NetWholesalePrice <= 590 THEN 'B. 501 - 590'
	WHEN med.NetWholesalePrice <= 1500 THEN 'C. 591 - 1500'
	WHEN med.NetWholesalePrice <= 1737 THEN 'D. 1501 - 1737'
	WHEN med.NetWholesalePrice <= 3500 THEN 'E. 1738 - 3500'
	WHEN med.NetWholesalePrice <= 3911 THEN 'F. 3501 - 3911'
	WHEN med.NetWholesalePrice <= 5500 THEN 'G. 3912 - 5500'
	ELSE 'H. 5501 - ' END AS [Kisker. árrés kategória]
, CASE WHEN PrescriptionType = 0 THEN CAST(PrescriptionID as varchar)
	ELSE CAST(CONCAT(LEFT(PurchaseDate, 6), SUBSTRING(CAST(PrescriptionID as varchar), 6, 5), med.ProductTTTID) AS varchar) END as [Kulcs]
, CASE 
	WHEN med.ProductTTTID IS NULL then 'Egyéb termék'
	WHEN med.ProductTTTID=0 then 'Egyéb termék'
	WHEN LEFT(med.ProductTTTID, 1) = 1 THEN 'Magi'
	WHEN LEFT(med.ProductTTTID, 1) = 3 THEN 'GYSE'
	WHEN LEFT(med.ProductTTTID, 1) = 4 THEN 'Kötszer'
	WHEN LEFT(med.ProductTTTID, 1) = 5 THEN 'Csomagolóanyag'
	WHEN LEFT(med.ProductTTTID, 1) = 6 THEN 'Magi díj'
	WHEN LEFT(med.ProductTTTID, 2) = 21 THEN 'Speci'
	WHEN LEFT(med.ProductTTTID, 2) = 22 THEN 'Tápszer'
	WHEN LEFT(med.ProductTTTID, 2) = 23 THEN 'Szérum'
	WHEN LEFT(med.ProductTTTID, 2) = 29 THEN 'Egyedi importos speci'
	ELSE 'Homeopátia' END AS [Termékkategória] -- DOB 2023.01.25 szűrő miatt hozzáadva
FROM dm.FactPharmacyTransactions pt
	inner join dm.DimProductMedivus med on pt.PharmacyProductKey = med.ProductMedivusKey


