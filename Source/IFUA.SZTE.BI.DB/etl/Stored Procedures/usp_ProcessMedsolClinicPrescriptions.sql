



-- =============================================
-- Author:		pabronits
-- Create date: 2022.08.05
-- Description:	Medsol árak kalkulációja
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessMedsolClinicPrescriptions]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	DECLARE @ERROR_MSG NVARCHAR(MAX)

	DECLARE @PURCHASEDATE_DAYS_INTERVAL INT = 30 -- +/- 30 nap közötti vásárlásokat nézzük

	/*
		1.) E-vény felírták és kiváltották
			1.a.: NEM magisztrális esetén:	A kiváltás összegét osztjuk vissza mennyiséggel és szorozzuk fel a felírás mennyiséggel
			1.b.: Magisztrális esetén:		Össze kell adni a tranzakciós termék árakat a mennyiségek figyelembe vétele nélkül
		
		2.) Nem került kiváltásra eveny és Papír alapú vény került felírásra: hasonló tranzakciót keresünk dátum szerinti szüréssel
			2.a.: NEM magisztrális esetén:	DimProductMedsol.ProductTTTID = DimProductMedivus.ProductTTTID alapján 
											A kiváltás összegét osztjuk vissza mennyiséggel és szorozzuk fel a felírás mennyiséggel
			2.b.: Magisztrális esetén:		DimProductMedsol.ProductTTTID alapján keresünk tranzakcióhoz tartozó felírást amit a 
											felírás mennyiséggel arányosan korrigálunk

		3.) A fenti 1-2 ponton kívül eső esetekben PUPHA
	*/
		
	BEGIN TRY

	BEGIN TRAN;

		--TRUNCATE TABLE [dm].[FactClinicPrescriptionsPriceLog]

		/*
			1.a. NEM magisztrális
		*/
		INSERT INTO [dm].[FactClinicPrescriptionsPriceLog] ( [FactClinicPrescriptionsRowId], [SourceType], [FactPharmacyTransactionsRowId], [NetConsumerPrice], [NetWholesalePrice], [EtlSessionId] )
		SELECT
			fcp.[RowId], 
			1, 
			fpt.[RowId], 
			(fpt.[NetSalesValue] / fpt.Quantity) * fcp.[Quantity] AS [NetConsumerPrice],
			(fpt.[NetPurchaseValue] / fpt.Quantity) * fcp.[Quantity] AS [NetWholesalePrice],
			@ETLSESSIONID
		FROM
			[dm].[FactClinicPrescriptions] fcp
			INNER JOIN [dm].[DimProductMedsol] dpm ON
				dpm.ProductMedsolKey = fcp.PharmacyProductKey AND
				dpm.ProductTTTID NOT LIKE '1%' -- NEM magisztrális
			INNER JOIN [dm].[FactPharmacyTransactions] fpt ON
				fpt.PrescriptionID = fcp.PrescriptionID AND
				fpt.PrescriptionType = 0 AND
				fpt.Quantity > 0
			INNER JOIN [dm].[DimPharmacyMovementType] dpmt ON
				dpmt.PharmacyMovementTypeKey = fpt.PharmacyMovementTypeKey AND
				dpmt.PharmacyMovementTypeStorageMultiplier = -1

						
		
		/*
			1.b.: Magisztrális
		*/	
		INSERT INTO [dm].[FactClinicPrescriptionsPriceLog] ( [FactClinicPrescriptionsRowId], [SourceType], [FactPharmacyTransactionsRowId], [NetConsumerPrice], [NetWholesalePrice], [EtlSessionId] )
		SELECT
			fcp.[RowId], -- Vannak többes rekordok FactPharmacyTransactions szinten
			4,  -- evény kiváltva TELJES összeg
			MIN(fpt.[RowId]), -- Csak az 1.!
			SUM(fpt.[NetSalesValue]) AS [NetConsumerPrice], 
			SUM(fpt.[NetPurchaseValue]) AS [NetWholesalePrice],
			@ETLSESSIONID
		FROM
			[dm].[FactClinicPrescriptions] fcp
			INNER JOIN [dm].[DimProductMedsol] dpm ON
				dpm.ProductMedsolKey = fcp.PharmacyProductKey AND
				dpm.ProductTTTID LIKE '1%' -- Magisztrális
			INNER JOIN [dm].[FactPharmacyTransactions] fpt ON
				fpt.PrescriptionID = fcp.PrescriptionID AND
				fpt.PrescriptionType = 0
			INNER JOIN [dm].[DimPharmacyMovementType] dpmt ON
				dpmt.PharmacyMovementTypeKey = fpt.PharmacyMovementTypeKey AND
				dpmt.PharmacyMovementTypeStorageMultiplier = -1
		GROUP BY
			fcp.[RowId]
				
		/*
			2.a.: NEM magisztrális
		*/
		INSERT INTO [dm].[FactClinicPrescriptionsPriceLog] ( [FactClinicPrescriptionsRowId], [SourceType], [FactPharmacyTransactionsRowId], [NetConsumerPrice], [NetWholesalePrice], [EtlSessionId] )
		SELECT	
			T.[RowId], 
			T.[Type], 
			T.[SourceRowId],
			T.[NetConsumerPrice],
			T.[NetWholesalePrice],
			@ETLSESSIONID
		FROM
		(
			SELECT 
				C.[RowId], 
				2 AS [Type], 
				fpt.[RowId] AS [SourceRowId],
				(fpt.[NetSalesValue] / fpt.Quantity) * C.[Quantity]  AS [NetConsumerPrice],
				(fpt.[NetPurchaseValue] / fpt.Quantity) * C.[Quantity]  AS [NetWholesalePrice],
				ROW_NUMBER() OVER(PARTITION BY C.[RowId] ORDER BY ABS(C.PrescriptionDate - fpt.PurchaseDate)) AS [NearestMedivus]
			FROM
				(
					SELECT 
						fcp.[RowId],
						fcp.[Quantity],
						dpm.[ProductTTTID],
						fcp.[PrescriptionDate]
					FROM
						[dm].[FactClinicPrescriptions] fcp
						INNER JOIN [dm].[DimProductMedsol] dpm ON							
							dpm.ProductMedsolKey = fcp.PharmacyProductKey AND
							LEN(TRIM(ISNULL(dpm.ProductTTTID, ''))) > 0 AND
							dpm.ProductTTTID NOT LIKE '1%' -- NEM magisztrális
						LEFT JOIN [dm].[FactClinicPrescriptionsPriceLog] fcppl ON	
							fcppl.[EtlSessionId] = @ETLSESSIONID AND
							fcppl.[FactClinicPrescriptionsRowId] = fcp.[RowId]
					WHERE
						fcppl.[RowId] IS NULL -- Tehát evenyt nem váltották ki
						OR (fcppl.[RowId] IS NOT NULL AND (fcppl.[NetConsumerPrice] IS NULL OR fcppl.[NetWholesalePrice] IS NULL))

				)C
				INNER JOIN [dm].[DimProductMedivus] dpmv ON -- A history itt nem kell!
					dpmv.ProductTTTID = C.ProductTTTID
				INNER JOIN [dm].[FactPharmacyTransactions] fpt ON
					fpt.PharmacyProductKey = dpmv.ProductMedivusKey AND
					fpt.PurchaseDate BETWEEN C.PrescriptionDate - @PURCHASEDATE_DAYS_INTERVAL AND C.PrescriptionDate + @PURCHASEDATE_DAYS_INTERVAL AND
					fpt.Quantity > 0
				INNER JOIN [dm].[DimPharmacyMovementType] dpmt ON
					dpmt.PharmacyMovementTypeKey = fpt.PharmacyMovementTypeKey AND
					dpmt.PharmacyMovementTypeStorageMultiplier = -1

			)T
		WHERE
			T.[NearestMedivus] = 1


		/*
			2.b.: Magisztrális esetén
		*/
		INSERT INTO [dm].[FactClinicPrescriptionsPriceLog] ( [FactClinicPrescriptionsRowId], [SourceType], [FactPharmacyTransactionsRowId], [NetConsumerPrice], [NetWholesalePrice], [EtlSessionId] )
		
		SELECT
			T.FactClinicPrescriptionsRowId,
			5, -- 
			T.[RowId], -- !!! Itt a referencia [FactClinicPrescriptions].FactClinicPrescriptionsRowId mezőt adjuk meg !!!
			T.[NetSalesValue],
			T.[NetPurchaseValue],
			@ETLSESSIONID
		FROM
			(
				SELECT
					fcp.[RowId] AS [FactClinicPrescriptionsRowId],
					S.[RowId],
					(S.[NetSalesValue] / S.[Quantity]) * fcp.[Quantity] AS [NetSalesValue],
					(S.[NetPurchaseValue] / S.[Quantity]) * fcp.[Quantity] [NetPurchaseValue],
					ROW_NUMBER() OVER(PARTITION BY fcp.[RowId] ORDER BY ABS(S.[PrescriptionDate] - fcp.[PrescriptionDate])) AS [NearestClinicPrescriptions]
				FROM
					[dm].[FactClinicPrescriptions] fcp
					INNER JOIN [dm].[DimProductMedsol] dpm ON
						dpm.ProductMedsolKey = fcp.PharmacyProductKey AND
						dpm.ProductTTTID LIKE '1%' -- Magisztrális
					INNER JOIN 
					(
						SELECT 
							fcps.[RowId],
							fcps.[PrescriptionDate],
							fcps.[Quantity],
							fcps.[NetSalesValue],
							fcps.[NetPurchaseValue],							
							dpm.[ProductMedsolKey]
						FROM
							[dm].[FactClinicPrescriptionsPriceLog] fcpps
							INNER JOIN [dm].[FactClinicPrescriptions] fcps ON
								fcps.RowId = fcpps.FactClinicPrescriptionsRowId
							INNER JOIN [dm].[DimProductMedsol] dpm ON
								dpm.ProductMedsolKey = fcps.PharmacyProductKey AND
								dpm.ProductTTTID LIKE '1%' -- Magisztrális
						WHERE
							fcpps.[SourceType] = 2 AND
							fcpps.[EtlSessionId] = @ETLSESSIONID
					)S ON
						S.[RowId] <> fcp.[RowId] AND
						S.[ProductMedsolKey] = dpm.[ProductMedsolKey] AND
						S.[PrescriptionDate] BETWEEN fcp.[PrescriptionDate] -@PURCHASEDATE_DAYS_INTERVAL AND fcp.[PrescriptionDate] + @PURCHASEDATE_DAYS_INTERVAL
					LEFT JOIN [dm].[FactClinicPrescriptionsPriceLog] fcppl ON
						fcppl.[FactClinicPrescriptionsRowId] = fcp.[RowId] AND
						fcppl.[ETLSessionID] = @ETLSESSIONID
				WHERE
					fcppl.[RowId] IS NULL 
					OR (fcppl.[RowId] IS NOT NULL AND (fcppl.[NetConsumerPrice] IS NULL OR fcppl.[NetWholesalePrice] IS NULL))
			)T
			WHERE
				T.[NearestClinicPrescriptions] = 1


		/*
			Egyéb ág PUPHA-ból
		*/				
		INSERT INTO [dm].[FactClinicPrescriptionsPriceLog] ( [FactClinicPrescriptionsRowId], [SourceType], [ProductPuphaKey], [NetConsumerPrice], [NetWholesalePrice], [EtlSessionId] )
		SELECT T.[RowId], 3, T.[ProductPuphaKey], T.[NetConsumerPrice], T.[NetWholesalePrice], @ETLSESSIONID
		FROM
			(
				SELECT
					fcp.[RowId],					
					dpp.[ProductPuphaKey],
					dpp.[NetConsumerPrice] * fcp.[Quantity] AS [NetConsumerPrice],
					dpp.[NetWholesalePrice] * fcp.[Quantity] AS [NetWholesalePrice],
					ROW_NUMBER() OVER(PARTITION BY fcp.RowId ORDER BY ABS(dppd.[DateKey] - fcp.[PrescriptionDate] )) AS [NearestPupha]									
				FROM
					[dm].[FactClinicPrescriptions] fcp
					INNER JOIN [dm].[DimProductMedsol] dpm ON
						LEN(TRIM(ISNULL(dpm.ProductTTTID, ''))) = 9 AND
						dpm.ProductMedsolKey = fcp.PharmacyProductKey				
					INNER JOIN -- History!
					(
						SELECT [ProductPuphaKey], [ProductTTTID], [PUPHAPublicationDate], [NetConsumerPrice], [NetWholesalePrice] FROM [dm].[DimProductPupha] 
						UNION 
						SELECT [ProductPuphaKey], [ProductTTTID], [PUPHAPublicationDate], [NetConsumerPrice], [NetWholesalePrice] FROM [hst].[DimProductPupha]
					)dpp ON 
						dpp.ProductTTTID = dpm.ProductTTTID
					INNER JOIN [dm].[DimDate] dppd ON
						dppd.[Date] = dpp.[PUPHAPublicationDate]
					LEFT JOIN [dm].[FactClinicPrescriptionsPriceLog] fcppl ON	
							fcppl.[EtlSessionId] = @ETLSESSIONID AND
							fcppl.[FactClinicPrescriptionsRowId] = fcp.[RowId]
				WHERE
					fcppl.[RowId] IS NULL -- Még nincs ár
					OR (fcppl.[RowId] IS NOT NULL AND (fcppl.[NetConsumerPrice] IS NULL OR fcppl.[NetWholesalePrice] IS NULL))
			)T
		WHERE
			[NearestPupha] = 1
		
		ALTER INDEX [IX_FactClinicPrescriptionsPriceLog_Ids] ON [dm].[FactClinicPrescriptionsPriceLog] REORGANIZE
				
		-- Módosítások felülírása a [dm].[FactClinicPrescriptions] táblában
		UPDATE fcp SET
			fcp.[NetSalesValue] = fcppl.[NetConsumerPrice],
			fcp.[NetPurchaseValue] = fcppl.[NetWholesalePrice]
		FROM
			[dm].[FactClinicPrescriptions] fcp
			INNER JOIN [dm].[FactClinicPrescriptionsPriceLog] fcppl ON	
				fcppl.[EtlSessionId] = @ETLSESSIONID AND
				fcppl.[FactClinicPrescriptionsRowId] = fcp.[RowId]
		WHERE
			ISNULL(fcp.[NetSalesValue], -100000) <> fcppl.[NetConsumerPrice] OR
			ISNULL(fcp.[NetPurchaseValue], -100000) <> fcppl.[NetWholesalePrice]
								
	COMMIT TRAN;
	
	END TRY

	BEGIN CATCH
			
		ROLLBACK TRANSACTION

		SET @ERROR_MSG = (SELECT 'ERROR_PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'na') + '; ERROR_LINE: ' + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(50)), 'na') + '; ERROR_MESSAGE: ' +  ISNULL(ERROR_MESSAGE(), 'na'))

		EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 3,
		@COMPONENT = '[etl].[usp_ProcessMedsolClinicPrescriptions]',
		@DESCRIPTION  = @ERROR_MSG;

		THROW;

	END CATCH
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessMedsolClinicPrescriptions]',
		@DESCRIPTION  = @ELAPSED
		    
