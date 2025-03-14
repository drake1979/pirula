

CREATE VIEW [dm].[Wholesale Refund] AS 
SELECT [PharmacyKey] AS [Patika kulcs]
, [SupplierKey] AS [Szállító kulcs]
, [WholsesaleRefundDate] AS [Visszatérítés Dátuma]
, [NetRefund] AS [Nettó visszatérítés értéke]
, [ETLSessionID] AS [ETL betöltési ID]
FROM dm.FactWholesaleRefund
