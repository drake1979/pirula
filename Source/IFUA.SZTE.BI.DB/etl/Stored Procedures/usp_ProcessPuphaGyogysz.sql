
-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.12
-- Description:	PuphaGyogysz tábla feldolgozása
--				[dm].[DimProduct] SCD 4
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessPuphaGyogysz]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	DECLARE @ERROR_MSG NVARCHAR(MAX)
		
	DECLARE @HSTPRODUCT AS TABLE
	(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[ProductPuphaKey] [int] NULL,
		[ProductTTTID] [nvarchar](9) NULL,
		[ProductPackaging] [nvarchar](20) NULL,
		[ProductOEPNEV] [nvarchar](256) NULL,
		[PUPHAPublicationDate] DATE NULL,
		[NetConsumerPrice] int NULL,
		[NetWholesalePrice] int NULL,
		[ProductActiveIngredient] [varchar](128) NULL,
		[ProductForm] [varchar](128) NULL,
		[RowHash] [binary](32) NULL,
		[ImportFileId] [bigint] NULL,
		[ETLSessionID] [bigint] NULL,
		[ActionType] [varchar](20) NULL
	)

	BEGIN TRY
	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_TTT: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_TTT] IS NULL

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_TTT: length greater than 9' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_TTT] IS NOT NULL AND
		LEN( TRIM( [Landing_OEP_TTT] ) ) > 9

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_KSZ: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_KSZ] IS NULL

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_KSZ: length greater than 256' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_KSZ] IS NOT NULL AND
		LEN( TRIM( [Landing_OEP_KSZ] ) ) > 256

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_NEV: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_NEV] IS NULL

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_NEV: length greater than 256' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_NEV] IS NOT NULL AND
		LEN( TRIM( [Landing_OEP_NEV] ) ) > 256
			
	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_FAN: unable to cast int' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_FAN] IS NOT NULL AND
		TRY_CAST( [Landing_OEP_FAN] AS INT ) IS NULL

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'OEP_NKAR: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_OEP_NKAR] IS NOT NULL AND
		TRY_CAST( [Landing_OEP_NKAR] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'HATOANYAG: length greater than 128' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_HATOANYAG] IS NOT NULL AND
		LEN( TRIM( [Landing_HATOANYAG] ) ) > 128

	UPDATE [landing].[PuphaGyogysz]
	SET
		[ErrorLevel] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'GYFORMA: length greater than 128' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_GYFORMA] IS NOT NULL AND
		LEN( TRIM( [Landing_GYFORMA] ) ) > 128

	
	UPDATE l SET
		l.[ProductTTTID] = TRY_CAST(TRIM(l.[Landing_OEP_TTT]) AS NVARCHAR(9)),
		l.[ProductPackaging] = TRY_CAST(TRIM(l.[Landing_OEP_KSZ]) AS NVARCHAR(20)),
		l.[ProductOEPNEV] = TRY_CAST(TRIM(l.[Landing_OEP_NEV]) AS NVARCHAR(256)),
		l.[NetConsumerPrice] = TRY_CAST(TRIM(l.[Landing_OEP_FAN]) AS INT),
		l.[NetWholesalePrice] = TRY_CAST(TRIM(l.[Landing_OEP_NKAR]) AS DECIMAL(18,3)),
		l.[ProductActiveIngredient] = TRY_CAST(TRIM(l.[Landing_HATOANYAG]) AS VARCHAR(128)),
		l.[ProductForm] = TRY_CAST(TRIM(l.[Landing_GYFORMA]) AS VARCHAR(128)),
		l.[ErrorLevel] = ISNULL(l.[ErrorLevel], 0)
	FROM
		[landing].[PuphaGyogysz] l
		
	UPDATE l SET
		l.PUPHAPublicationDate = p.PUPHAPublicationDate
	FROM
		[landing].[PuphaGyogysz] l
		INNER JOIN 
		(
			SELECT 
				f.[ImportFileId],
				[etl].[udf_GetPuphaPublicationDate](f.[FileName]) AS [PUPHAPublicationDate]
			FROM
			(
				SELECT DISTINCT l.[ImportFileId], i.[FileName]
				FROM
					[landing].[PuphaGyogysz] l
					INNER JOIN [com].[ImportFile] i ON
						i.ImportFileId = l.ImportFileId
			)f
		)p ON p.ImportFileId = l.ImportFileId

	UPDATE [landing].[PuphaGyogysz] SET
		[RowHash] = [etl].[udf_GetHash_08]
		(  
			[Landing_ID],
			[Landing_OEP_NEV],
			[Landing_OEP_TTT],
			[Landing_OEP_KSZ],
			[Landing_OEP_FAN],
			[Landing_OEP_NKAR],
			[Landing_HATOANYAG],
			[Landing_GYFORMA]
		)
	

	BEGIN TRAN;

		-- [dm].[DimProductPupha]
		MERGE [dm].[DimProductPupha] AS TARGET
		USING [landing].[PuphaGyogysz] AS SOURCE
		ON (SOURCE.[ProductTTTID] = TARGET.[ProductTTTID])
		
		-- INSERT
		WHEN NOT MATCHED BY TARGET AND SOURCE.[ErrorLevel] < 2
		   THEN INSERT
		   (
				[ProductTTTID],
				[ProductPackaging],
				[ProductOEPNEV],
				[PUPHAPublicationDate],
				[NetConsumerPrice],
				[NetWholesalePrice],
				[ProductActiveIngredient],
				[ProductForm],
				[RowHash],
				[ImportFileId], 
				[ETLSessionID]
		   )
		   VALUES
		   (
				SOURCE.[ProductTTTID],
				SOURCE.[ProductPackaging],
				SOURCE.[ProductOEPNEV],
				SOURCE.[PUPHAPublicationDate],
				SOURCE.[NetConsumerPrice],
				SOURCE.[NetWholesalePrice],
				SOURCE.[ProductActiveIngredient],
				SOURCE.[ProductForm],
				SOURCE.[RowHash],
				SOURCE.[ImportFileId],
				@ETLSESSIONID
		   )

		-- UPDATE
		WHEN MATCHED AND TARGET.[RowHash] <> SOURCE.[RowHash] AND SOURCE.ErrorLevel < 2
			THEN UPDATE SET
		    TARGET.[ProductPackaging]		= SOURCE.[ProductPackaging],
			TARGET.[ProductOEPNEV]			= SOURCE.[ProductOEPNEV],
			TARGET.[PUPHAPublicationDate]	= SOURCE.[PUPHAPublicationDate],
			TARGET.[NetConsumerPrice]		= SOURCE.[NetConsumerPrice],
			TARGET.[NetWholesalePrice]		= SOURCE.[NetWholesalePrice],
			TARGET.[ProductActiveIngredient]= SOURCE.[ProductActiveIngredient],
			TARGET.[ProductForm]			= SOURCE.[ProductForm],

			TARGET.[RowHash]				= SOURCE.[RowHash],
			TARGET.[ImportFileId]			= SOURCE.[ImportFileId],
			TARGET.[EtlSessionId]			= @ETLSESSIONID
    		
		-- DELETE
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		OUTPUT 
			deleted.[ProductPuphaKey],
			deleted.[ProductTTTID],
			deleted.[ProductPackaging],
			deleted.[ProductOEPNEV],
			deleted.[PUPHAPublicationDate],
			deleted.[NetConsumerPrice],
			deleted.[NetWholesalePrice],
			deleted.[ProductActiveIngredient],
			deleted.[ProductForm],
			deleted.[RowHash],
			deleted.[ImportFileId],
			deleted.[EtlSessionId],
			$action as ActionType
		INTO @HSTPRODUCT;

		INSERT INTO [hst].[DimProductPupha]
		(
			[ProductPuphaKey],
			[ProductTTTID],
			[ProductPackaging],
			[ProductOEPNEV],
			[PUPHAPublicationDate],
			[NetConsumerPrice],
			[NetWholesalePrice],
			[ProductActiveIngredient],
			[ProductForm],
			[RowHash],
			[ImportFileId],
			[ETLSessionID],
			[ActionType],
			[ActionEtlSessionId],
			[ActionFields]
		)
		SELECT  
			h.[ProductPuphaKey],
			h.[ProductTTTID],
			h.[ProductPackaging],
			h.[ProductOEPNEV],
			h.[PUPHAPublicationDate],
			h.[NetConsumerPrice],
			h.[NetWholesalePrice],
			h.[ProductActiveIngredient],
			h.[ProductForm],
			h.[RowHash],
			h.[ImportFileId],
			h.[EtlSessionId],
		   CASE WHEN h.[ActionType] = 'UPDATE' THEN 1 ELSE 2 END,
		   @ETLSESSIONID,
		   CASE WHEN h.[ActionType] = 'UPDATE' THEN
				   IIF( ISNULL( h.[ProductTTTID], '') <> ISNULL( t.[ProductTTTID], ''), '[ProductTTTID]: ' + ISNULL(h.[ProductTTTID], 'NULL') + ' -> ' +  ISNULL( t.[ProductTTTID], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[ProductPackaging], '') <> ISNULL( t.[ProductPackaging], ''), '[ProductPackaging]: ' + ISNULL(h.[ProductPackaging], 'NULL') + ' -> ' +  ISNULL( t.[ProductPackaging], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[ProductOEPNEV], '') <> ISNULL( t.[ProductOEPNEV], ''), '[ProductOEPNEV]: ' + ISNULL(h.[ProductOEPNEV], 'NULL') + ' -> ' +  ISNULL( t.[ProductOEPNEV], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[PUPHAPublicationDate], '1900-01-01') <> ISNULL( t.[PUPHAPublicationDate], '1900-01-01'), '[PUPHAPublicationDate]: ' + ISNULL(CONVERT(NVARCHAR, h.[PUPHAPublicationDate], 120), 'NULL') + ' -> ' +  ISNULL(CONVERT(NVARCHAR, t.[PUPHAPublicationDate], 120), 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[NetConsumerPrice], -1000) <> ISNULL( t.[NetConsumerPrice], -1000), '[NetConsumerPrice]: ' + ISNULL( TRIM(CAST( h.[NetConsumerPrice] AS NVARCHAR(20))), 'NULL') + ' -> ' +  ISNULL( TRIM(CAST( t.[NetConsumerPrice] AS NVARCHAR(20))), 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[NetWholesalePrice], -1000) <> ISNULL( t.[NetWholesalePrice], -1000), '[NetWholesalePrice]: ' + ISNULL( TRIM(CAST( h.[NetWholesalePrice] AS NVARCHAR(20))), 'NULL') + ' -> ' +  ISNULL( TRIM(CAST( t.[NetWholesalePrice] AS NVARCHAR(20))), 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[ProductActiveIngredient], '') <> ISNULL( t.[ProductActiveIngredient], ''), '[ProductActiveIngredient]: ' + ISNULL(h.[ProductActiveIngredient], 'NULL') + ' -> ' +  ISNULL( t.[ProductActiveIngredient], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[ProductForm], '') <> ISNULL( t.[ProductForm], ''), '[ProductForm]: ' + ISNULL(h.[ProductForm], 'NULL') + ' -> ' +  ISNULL( t.[ProductForm], 'NULL'), ''  )

			ELSE NULL END
		FROM 
			@HSTPRODUCT h
			LEFT JOIN [landing].[PuphaGyogysz] t on 
				t.[ProductTTTID] = h.[ProductTTTID]	AND
				t.[ErrorLevel] < 2
		WHERE 
			h.ActionType <> 'INSERT';

	COMMIT TRAN;

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

	END TRY

	BEGIN CATCH
			
		ROLLBACK TRANSACTION

		SET @ERROR_MSG = (SELECT 'ERROR_PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'na') + '; ERROR_LINE: ' + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(50)), 'na') + '; ERROR_MESSAGE: ' +  ISNULL(ERROR_MESSAGE(), 'na'))

		EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 3,
		@COMPONENT = '[etl].[usp_ProcessPuphaGyogysz]',
		@DESCRIPTION  = @ERROR_MSG;

		THROW;

	END CATCH
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessPuphaGyogysz]',
		@DESCRIPTION  = @ELAPSED
		    
