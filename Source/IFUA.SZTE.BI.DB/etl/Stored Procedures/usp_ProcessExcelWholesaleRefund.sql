
-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.05
-- Description:	Patikák_utólagos engedmény.xlsx Excel feldolgozás
--				SCD 1
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessExcelWholesaleRefund]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	DECLARE @ERROR_MSG NVARCHAR(MAX)

	BEGIN TRY
	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Datum: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Datum] IS NULL

	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Datum: unable to cast date' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Datum] IS NOT NULL AND
		TRY_CAST( TRIM([Landing_Datum]) AS DATE ) IS NULL

	UPDATE l
	SET
		l.[ErrorLevel] = 1,
		l.[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Datum: out of [dm].[DimDate] range' + CHAR(10) + CHAR(13)
	FROM
		[landing].[ExcelWholesaleRefund] l
		LEFT JOIN [dm].[DimDate] d ON
			d.[Date] = TRY_CAST(TRIM(l.[Landing_Datum]) AS DATE )
	WHERE
		l.[Landing_Datum] IS NOT NULL AND
		TRY_CAST( TRIM(l.[Landing_Datum]) AS DATE ) IS NOT NULL AND
		d.[DateKey] IS NULL


	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Patika: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Patika] IS NULL

	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Patika: length greater than 255' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Patika] IS NOT NULL AND
		LEN( TRIM([Landing_Patika]) ) > 255

	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Szallito: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Szallito] IS NULL

	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Szallito: length greater than 255' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Szallito] IS NOT NULL AND
		LEN( TRIM([Landing_Szallito]) ) > 255

	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Engedmeny: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Engedmeny] IS NULL

	UPDATE [landing].[ExcelWholesaleRefund]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Engedmeny: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Engedmeny] IS NOT NULL AND
		TRY_CAST( TRIM([Landing_Engedmeny]) AS DECIMAL(18,3) ) IS NULL

	UPDATE l
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Patika: missing dimension in [dm].[DimPharmacy]' + CHAR(10) + CHAR(13)
	FROM
		[landing].[ExcelWholesaleRefund] l
		LEFT JOIN [dm].[DimPharmacy] d ON
			d.[PharmacyEosID] = TRIM([Landing_Patika])
	WHERE		
		[Landing_Patika] IS NOT NULL AND
		d.[PharmacyKey] IS NULL

	-- ERROR log
	INSERT INTO com.ImportError( [RowNumber], [ImportFileId], [ErrorDescription], [ErrorLevel], [EtlSessionId] )
	SELECT
		la.[RowId] + 1, -- Az első sor a header
		la.[ImportFileId],
		la.[ErrorDescription],
		la.[ErrorLevel],
		@ETLSESSIONID
	FROM
		[landing].[ExcelWholesaleRefund] la 
	WHERE
		la.[ErrorLevel] > 0


	UPDATE l SET
		l.[Datum] = dd.[DateKey],
		l.[Patika] = TRY_CAST(TRIM(l.[Landing_Patika]) AS NVARCHAR(255)),
		l.[SupplierName] = TRY_CAST(TRIM(l.[Landing_Szallito]) AS NVARCHAR(255)),
		l.[Engedmeny] = TRY_CAST(TRIM(l.[Landing_Engedmeny]) AS DECIMAL(18,3)),
		l.[PharmacyKey] = dp.[PharmacyKey],			
		l.[ErrorLevel] = ISNULL(l.[ErrorLevel], 0)
	FROM
		[landing].[ExcelWholesaleRefund] l
		INNER JOIN [dm].[DimPharmacy] dp ON
		    dp.[PharmacyEosID] = TRY_CAST(TRIM(l.[Landing_Patika]) AS NVARCHAR(255))
		INNER JOIN [dm].[DimDate] dd ON
			dd.[Date] = TRY_CAST(TRIM(l.[Landing_Datum]) AS DATE)
	
	UPDATE [landing].[ExcelWholesaleRefund] SET
		[RowHash] = [etl].[udf_GetHash_04]( [Landing_Datum], [Landing_Patika], [Landing_Engedmeny], [Landing_Szallito] )
	

	BEGIN TRAN;

	INSERT INTO [dm].[DimSupplier] ( [SupplierName], [ImportFileId] , [ETLSessionID] )
	SELECT
		l.[SupplierName],
		l.[ImportFileId],
		@ETLSESSIONID
	FROM
		(
			SELECT
				[SupplierName],
				MIN([ImportFileId]) AS [ImportFileId]
			FROM
				[landing].[ExcelWholesaleRefund]
			WHERE
				LEN(ISNULL([SupplierName], '')) > 0
				
			GROUP BY
				[SupplierName]
		)l
		LEFT JOIN [dm].[DimSupplier] s ON
			s.[SupplierName] = l.[SupplierName]
	WHERE
		s.[SupplierKey] IS NULL

	UPDATE l
		SET l.[SupplierKey] = s.[SupplierKey]
	FROM
		[landing].[ExcelWholesaleRefund] l
		INNER JOIN [dm].[DimSupplier] s ON
			s.[SupplierName] = l.[SupplierName]

	UPDATE [landing].[ExcelWholesaleRefund]
		SET [SupplierKey] = -1
	WHERE
		[SupplierKey] IS NULL


	MERGE [dm].[FactWholesaleRefund] AS TARGET
	USING [landing].[ExcelWholesaleRefund] AS SOURCE
		ON (SOURCE.[Datum] = TARGET.[WholsesaleRefundDate] AND SOURCE.[PharmacyKey] = TARGET.[PharmacyKey] AND SOURCE.[SupplierKey] = TARGET.[SupplierKey])
		
		-- INSERT
		WHEN NOT MATCHED BY TARGET AND SOURCE.ErrorLevel < 2
		   THEN INSERT
		   (
				[PharmacyKey], 
				[SupplierKey],
				[WholsesaleRefundDate], 
				[NetRefund], 
				[RowHash], 
				[ImportFileId], 
				[ETLSessionID]
		   )
		   VALUES
		   (
				SOURCE.[PharmacyKey],
				SOURCE.[SupplierKey],
				SOURCE.[Datum],
				SOURCE.[Engedmeny],
				SOURCE.[RowHash],
				SOURCE.[ImportFileId],
				@ETLSESSIONID
		   )

		-- UPDATE
		WHEN MATCHED AND TARGET.[RowHash] <> SOURCE.[RowHash] AND SOURCE.ErrorLevel < 2
			THEN UPDATE SET
		    TARGET.[NetRefund]		= SOURCE.[Engedmeny],
			TARGET.[RowHash]        = SOURCE.[RowHash],
			TARGET.[ImportFileId]   = SOURCE.[ImportFileId],
			TARGET.[EtlSessionId]   = @ETLSESSIONID
    
		/*
		A törlés itt nem kivitelezhető mivel nem FULL EXTRACT-ot kapunk és az időszak sem beazonosítható
		*/
		-- DELETE
		--WHEN NOT MATCHED BY Source THEN
		--	DELETE
		;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH
			
		ROLLBACK TRANSACTION

		SET @ERROR_MSG = (SELECT 'ERROR_PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'na') + '; ERROR_LINE: ' + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(50)), 'na') + '; ERROR_MESSAGE: ' +  ISNULL(ERROR_MESSAGE(), 'na'))

		EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 3,
		@COMPONENT = '[etl].[usp_ProcessExcelWholesaleRefund]',
		@DESCRIPTION  = @ERROR_MSG;

		THROW;

	END CATCH
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessExcelWholesaleRefund]',
		@DESCRIPTION  = @ELAPSED
		    
