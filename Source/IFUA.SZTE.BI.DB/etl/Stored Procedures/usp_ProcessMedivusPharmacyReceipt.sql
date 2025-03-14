

-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.05
-- Description:	MEDIVUS [PharmacyID]-yyyy-[1-4].xls Excel tisztítása
--				[dm].[DimProduct]:				SCD 4
--				[dm].[DimPharmacyMovementType]: SCD 1
--				[dm].[DimPharmacy]:				SCD 1
--				[dm].[FactPharmacyTransactions] SCD 1
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessMedivusPharmacyReceipt]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	DECLARE @ERROR_MSG NVARCHAR(MAX)

	DECLARE @HSTPRODUCTMEDIVUS AS TABLE
	(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[ProductMedivusKey] [int] NULL,
		[ProductMedivusID] [int] NULL,
		[PharmacyKey] [int] NULL,
		[ProductMedivusName] [nvarchar](256) NULL,
		[ProductTTTID] [nvarchar](9) NULL,
		[ProductPackaging] [nvarchar](20) NULL,
		[NetConsumerPrice] decimal(18,3) NULL,
		[NetWholesalePrice] decimal(18,3) NULL,
		[MaxPurchaseDate] date NULL,
		[MinPurchaseDate] date NULL,
		[RowHash] [binary](32) NULL,
		[ImportFileId] [bigint] NULL,
		[ETLSessionID] [bigint] NULL,
		[ActionType] [varchar](20) NULL
	)
		
	DECLARE @TMPPRODUCT AS TABLE
	(	
		[ProductMedivusID] [int] NULL,
		[PharmacyKey] [int] NULL,
		[ProductMedivusName] [nvarchar](256) NULL,
		[ProductTTTID] [nvarchar](9) NULL,
		[ProductPackaging] [nvarchar](20) NULL,
		[NetConsumerPrice] decimal(18,3) NULL,
		[NetWholesalePrice] decimal(18,3) NULL,
		[MaxPurchaseDate] date NULL,
		[MinPurchaseDate] date NULL,
		[ImportFileId] [bigint] NULL,
		[RowHashProduct] binary(32) NULL,
		[DuplicateRank] INT NULL,
		[MaxPurchaseDateRank] INT NULL
	)

	DECLARE @TMPPRODUCTDUPLICATERANK AS TABLE
	(	
		[ProductMedivusID] [int] NULL,
		[PharmacyKey] [int] NULL,
		[ProductTTTID] [nvarchar](9) NULL,
		[ProductPackaging] [nvarchar](20) NULL,
		[DuplicateRank] INT NULL
	)

	DECLARE @NULLHASH BINARY(32) = (SELECT  [etl].[udf_GetHash_01] ( NULL))
			
	BEGIN TRY

	UPDATE [landing].MedivusPharmacyReceipt
	   SET [Landing_ARRESERTEK]     = REPLACE(REPLACE([Landing_ARRESERTEK], ',', '.'), ' ', ''),
		   [Landing_ARRESKORREKCIO] = REPLACE(REPLACE([Landing_ARRESKORREKCIO], ',', '.'), ' ', ''),
		   [Landing_MENNYISEG]      = REPLACE(REPLACE([Landing_Mennyiseg], ',', '.'), ' ', ''),
		   [Landing_NETTOBESZERTEK] = REPLACE(REPLACE([Landing_NETTOBESZERTEK], ',', '.'), ' ', ''),
           [Landing_NETTOFIZERTEK]  = REPLACE(REPLACE([Landing_NETTOFIZERTEK] , ',', '.'), ' ', ''),
           [Landing_NETTOOSSZERTEK] = REPLACE(REPLACE([Landing_NETTOOSSZERTEK], ',', '.'), ' ', ''),
           [Landing_NETTOTAMERTEK]  = REPLACE(REPLACE([Landing_NETTOTAMERTEK] , ',', '.'), ' ', ''),
		   [Landing_ERECEPTID] = 
		      CASE WHEN LEFT([Landing_ERECEPTID], 1) = '"' AND RIGHT([Landing_ERECEPTID], 1) = '"' 
			  THEN SUBSTRING([Landing_ERECEPTID], 2, LEN([Landing_ERECEPTID]) - 2)  
			  ELSE [Landing_ERECEPTID] 
			  END,
		  [Landing_NEAKVENYSZAM] = 
		      CASE WHEN LEFT([Landing_NEAKVENYSZAM], 1) = '"' AND RIGHT([Landing_NEAKVENYSZAM], 1) = '"' 
			  THEN SUBSTRING([Landing_NEAKVENYSZAM], 2, LEN([Landing_NEAKVENYSZAM]) - 2)  
			  ELSE [Landing_NEAKVENYSZAM] 
			  END,
          [Landing_MOZGASNEMNEV] =
          	  CASE WHEN LEFT([Landing_MOZGASNEMNEV], 1) = '"' AND RIGHT([Landing_MOZGASNEMNEV], 1) = '"' 
          	  THEN SUBSTRING([Landing_MOZGASNEMNEV], 2, LEN([Landing_MOZGASNEMNEV]) - 2)  
          	  ELSE [Landing_MOZGASNEMNEV] 
          	  END,
          [Landing_CIKKNEV] =
          	  CASE WHEN LEFT([Landing_CIKKNEV], 1) = '"' AND RIGHT([Landing_CIKKNEV], 1) = '"' 
          	  THEN SUBSTRING([Landing_CIKKNEV], 2, LEN([Landing_CIKKNEV]) - 2)  
          	  ELSE [Landing_CIKKNEV] 
          	  END,
          [Landing_CIKKISZERELES]=
          	  CASE WHEN LEFT([Landing_CIKKISZERELES], 1) = '"' AND RIGHT([Landing_CIKKISZERELES], 1) = '"' 
          	  THEN SUBSTRING([Landing_CIKKISZERELES], 2, LEN([Landing_CIKKISZERELES]) - 2)  
          	  ELSE [Landing_CIKKISZERELES] 
          	  END,
          [Landing_JOGCIMNEV]=
          	  CASE WHEN LEFT([Landing_JOGCIMNEV], 1) = '"' AND RIGHT([Landing_JOGCIMNEV], 1) = '"' 
          	  THEN SUBSTRING([Landing_JOGCIMNEV], 2, LEN([Landing_JOGCIMNEV]) - 2)  
          	  ELSE [Landing_JOGCIMNEV] 
          	  END,
          [Landing_BIZONYLATID]      = REPLACE([Landing_BIZONYLATID], ' ', ''),     
          [Landing_BIZONYLATTETELID] = REPLACE([Landing_BIZONYLATTETELID], ' ', ''),
          [Landing_CIKKID]           = REPLACE([Landing_CIKKID], ' ', ''),          
          [Landing_MOZGASNEMID]      = REPLACE([Landing_MOZGASNEMID], ' ', ''),
		  [Landing_CTTTKOD]		     = REPLACE([Landing_CTTTKOD], ' ', '')

	UPDATE l
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'PharmacyKey: unknown filename pattern!' + CHAR(10) + CHAR(13)
	FROM
		[landing].[MedivusPharmacyReceipt] l 
		INNER JOIN [com].[ImportFile] f ON f.ImportFileId = l.ImportFileId
	WHERE
		SUBSTRING(f.[FileName], 2, 1) <> '-'

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyMovementType] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'MOZGASNEMID: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_MOZGASNEMID] IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyMovementType] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'MOZGASNEMID: unable to cast int' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_MOZGASNEMID] IS NOT NULL AND
		TRY_CAST( [Landing_MOZGASNEMID] AS INT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyMovementType] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'MOZGASNEMNEV: length greater than 255' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_MOZGASNEMNEV] IS NOT NULL AND
		LEN( TRIM( [Landing_MOZGASNEMNEV] ) ) > 255

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'KESZLETSZORZO: unable to cast smallint' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_KESZLETSZORZO] IS NOT NULL AND
		TRY_CAST( [Landing_KESZLETSZORZO] AS SMALLINT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelProduct] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'CIKKID: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_CIKKID] IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelProduct] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'CIKKID: unable to cast int' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_CIKKID] IS NOT NULL AND
		TRY_CAST( [Landing_CIKKID] AS INT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelProduct] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'CIKKNEV: length greater than 256' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_CIKKNEV] IS NOT NULL AND
		LEN( TRIM( [Landing_CIKKNEV] ) ) > 256

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelProduct] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'CTTTKOD: length greater than 9' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_CTTTKOD] IS NOT NULL AND
		LEN( TRIM( [Landing_CTTTKOD] ) ) > 9

	
	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelProduct] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'CIKKISZERELES: length greater than 20' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_CIKKISZERELES] IS NOT NULL AND
		LEN( TRIM( [Landing_CIKKISZERELES] ) ) > 20

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyReceiptTitle] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'JOGCIMID: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_JOGCIMID] IS NULL 

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyReceiptTitle] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'JOGCIMID: unable to cast int' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_JOGCIMID] IS NOT NULL AND
		TRY_CAST( [Landing_JOGCIMID] AS INT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyReceiptTitle] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'JOGCIMNEV: length greater than 256' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_JOGCIMNEV] IS NOT NULL AND
		LEN( TRIM( [Landing_JOGCIMNEV] ) ) > 256

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'DATUMIDO: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_DATUMIDO] IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'DATUMIDO: unable to cast DATE' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_DATUMIDO] IS NOT NULL AND
		TRY_PARSE( [Landing_DATUMIDO] AS DATE ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'BIZONYLATID: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_BIZONYLATID] IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'BIZONYLATID: unable to cast INT' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_BIZONYLATID] IS NOT NULL AND
		TRY_CAST( [Landing_BIZONYLATID] AS INT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'BIZONYLATTETELID: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_BIZONYLATTETELID] IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorLevelPharmacyTransactions] = 2,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'BIZONYLATTETELID: unable to cast INT' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_BIZONYLATTETELID] IS NOT NULL AND
		TRY_CAST( [Landing_BIZONYLATTETELID] AS INT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'MENNYISEG: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_MENNYISEG] IS NOT NULL AND
		TRY_CAST( [Landing_MENNYISEG] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'NETTOBESZERTEK: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_NETTOBESZERTEK] IS NOT NULL AND
		TRY_CAST( [Landing_NETTOBESZERTEK] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'NETTOFIZERTEK: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_NETTOFIZERTEK] IS NOT NULL AND
		TRY_CAST( [Landing_NETTOFIZERTEK] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'NETTOTAMERTEK: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_NETTOTAMERTEK] IS NOT NULL AND
		TRY_CAST( [Landing_NETTOTAMERTEK] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'NETTOOSSZERTEK: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_NETTOOSSZERTEK] IS NOT NULL AND
		TRY_CAST( [Landing_NETTOOSSZERTEK] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'ARRESERTEK: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_ARRESERTEK] IS NOT NULL AND
		TRY_CAST( [Landing_ARRESERTEK] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'ARRESKORREKCIO: unable to cast DECIMAL(18,3)' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_ARRESKORREKCIO] IS NOT NULL AND
		TRY_CAST( [Landing_ARRESKORREKCIO] AS DECIMAL(18,3) ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'NEAKVENYSZAM: unable to cast BIGINT' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_NEAKVENYSZAM] IS NOT NULL AND
		TRY_CAST( [Landing_NEAKVENYSZAM] AS BIGINT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'ERECEPTID: unable to cast BIGINT' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_ERECEPTID] IS NOT NULL AND
		TRY_CAST( [Landing_ERECEPTID] AS BIGINT ) IS NULL

	UPDATE [landing].[MedivusPharmacyReceipt]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'SZTORNO: unable to cast BIT' + CHAR(10) + CHAR(13)
	WHERE
		TRY_CAST( [Landing_SZTORNO] AS BIT ) IS NULL
			
				

	UPDATE l SET
		l.[PharmacyMovementTypeMedivusID] = TRY_CAST( [Landing_MOZGASNEMID] AS INT ),
		l.[PharmacyMovementTypeName] = TRY_CAST(TRIM( [Landing_MOZGASNEMNEV] ) AS NVARCHAR(255)),
		l.[PharmacyMovementTypeStorageMultiplier] = TRY_CAST( [Landing_KESZLETSZORZO] AS SMALLINT ),
		l.[ProductMedivusID] = TRY_CAST( [Landing_CIKKID] AS INT ),
		l.[ProductMedivusName] = TRY_CAST(TRIM([Landing_CIKKNEV]) AS NVARCHAR(256)),
		l.[ProductTTTID] = TRY_CAST(TRIM([Landing_CTTTKOD]) AS NVARCHAR(9)),
		l.[ProductPackaging] = TRY_CAST(TRIM([Landing_CIKKISZERELES]) AS NVARCHAR(20)),
		l.[PharmacyReceiptTitleMedivusID] = TRY_CAST( [Landing_JOGCIMID] AS INT),
		l.[PharmacyReceiptTitleName]= TRY_CAST(TRIM( [Landing_JOGCIMNEV] ) AS NVARCHAR(256)),
		l.[PurchaseDate] = TRY_PARSE( [Landing_DATUMIDO] AS DATE ),
		l.[PharmacyReceiptID] = TRY_CAST( [Landing_BIZONYLATID] AS INT ),
		l.[PharmacyReceiptItemID] = TRY_CAST( [Landing_BIZONYLATTETELID] AS INT ),
		l.[NetPurchaseValue] = TRY_CAST( [Landing_NETTOBESZERTEK] AS DECIMAL(18,3)),
		l.[NetPaidValue] = TRY_CAST( [Landing_NETTOFIZERTEK] AS DECIMAL(18,3)),
		l.[NetSupportValue] = TRY_CAST( [Landing_NETTOTAMERTEK] AS DECIMAL(18,3)),
		l.[NetSalesValue] = TRY_CAST( [Landing_NETTOOSSZERTEK] AS DECIMAL(18,3)),
		l.[NetMargin] = TRY_CAST( [Landing_ARRESERTEK] AS DECIMAL(18,3)),
		l.[NetMarginCorrection] = TRY_CAST( [Landing_ARRESKORREKCIO] AS DECIMAL(18,3)),
		l.[PrescriptionID] = ISNULL( TRY_CAST( [Landing_ERECEPTID] AS BIGINT), TRY_CAST( [Landing_NEAKVENYSZAM] AS BIGINT) ), -- ERECEPTID kell elsősorban!
		l.[PrescriptionType] = 
								CASE 
									WHEN [Landing_ERECEPTID] IS NULL AND [Landing_NEAKVENYSZAM] IS NOT NULL THEN 1 
									WHEN [Landing_ERECEPTID] IS NULL AND [Landing_NEAKVENYSZAM] IS NULL THEN NULL
									ELSE 0 END,
		l.[Quantity] = TRY_CAST( [Landing_MENNYISEG] AS DECIMAL(18,3)),
		l.[Storno] = TRY_CAST( [Landing_SZTORNO] AS BIT),
		l.[ErrorLevel] = ISNULL(l.[ErrorLevel], 0),
		l.[ErrorLevelPharmacyReceiptTitle] = ISNULL(l.[ErrorLevelPharmacyReceiptTitle], 0),
		l.[ErrorLevelPharmacyMovementType] = ISNULL( l.[ErrorLevelPharmacyMovementType], 0),
		l.[ErrorLevelProduct] = ISNULL( l.[ErrorLevelProduct], 0),
		l.[ErrorLevelPharmacyTransactions] = ISNULL( l.[ErrorLevelPharmacyTransactions], 0)
	FROM
		[landing].[MedivusPharmacyReceipt] l

	UPDATE l SET
		[PharmacyID] = SUBSTRING(f.[FileName], 1, 1) -- Fájlnév első karaktere a gyógyszertár kódja
	FROM
		[landing].[MedivusPharmacyReceipt] l
		INNER JOIN [com].[ImportFile] f ON l.ImportFileId = f.ImportFileId
	WHERE
		SUBSTRING(f.[FileName], 2, 1) = '-'

	UPDATE [landing].[MedivusPharmacyReceipt] SET
		[NetConsumerPrice] = [NetSalesValue] / IIF(ISNULL( [Quantity], 0 ) = 0, 1, [Quantity]),
		[NetWholesalePrice] = [NetPurchaseValue] / IIF(ISNULL( [Quantity], 0 ) = 0, 1, [Quantity])

	UPDATE [landing].[MedivusPharmacyReceipt] SET
		[RowHash] = [etl].[udf_GetHash_18]( 
			[Landing_MOZGASNEMID], 
			[Landing_MOZGASNEMNEV], 
			[Landing_KESZLETSZORZO],
			[Landing_CIKKID],
			[Landing_CIKKNEV],
			[Landing_CTTTKOD],
			[Landing_CIKKISZERELES],
			[Landing_JOGCIMID],
			[Landing_JOGCIMNEV],
			[Landing_DATUMIDO],
			[Landing_ERECEPTID],
			[Landing_NEAKVENYSZAM],
			[Landing_NETTOBESZERTEK],
			[Landing_NETTOFIZERTEK],
			[Landing_NETTOTAMERTEK],
			[Landing_NETTOOSSZERTEK],
			[Landing_ARRESERTEK],
			[Landing_ARRESKORREKCIO]
			)

	UPDATE [landing].[MedivusPharmacyReceipt] SET
		[RowHashPharmacyTransactions] = [etl].[udf_GetHash_18]( 
			[Landing_MOZGASNEMID], 
			[Landing_KESZLETSZORZO],
			[Landing_DATUMIDO],
			[Landing_BIZONYLATID],
			[Landing_SZTORNO],
			[Landing_BIZONYLATTETELID],
			[Landing_CIKKID],
			[Landing_CIKKNEV],
			[Landing_CTTTKOD],
			[Landing_CIKKISZERELES],
			[Landing_JOGCIMID],
			[Landing_JOGCIMNEV],
			[Landing_NETTOBESZERTEK],
			[Landing_NETTOFIZERTEK],
			[Landing_NETTOTAMERTEK],
			[Landing_NETTOOSSZERTEK],
			[Landing_ARRESERTEK],
			[Landing_ARRESKORREKCIO]
			)
	
	--DELETE FROM @TMPPRODUCT WHERE DuplicateRank > 1
			
	BEGIN TRAN;

		
		/*
			[dm].[DimPharmacy] töltése SCD1
		*/
		INSERT INTO [dm].[DimPharmacy] ( [PharmacyID], [ImportFileId], [ETLSessionID]  )
		SELECT
			l.[PharmacyID], 
			l.[ImportFileId],
			@ETLSESSIONID
		FROM
			(
				SELECT 
					[PharmacyID], MIN( ImportFileId ) AS ImportFileId
				FROM
					[landing].[MedivusPharmacyReceipt]
				WHERE 
					[PharmacyID] IS NOT NULL
				GROUP BY 
					[PharmacyID]
			)l
			LEFT JOIN [dm].[DimPharmacy] d ON d.[PharmacyID] = l.[PharmacyID]
		WHERE
			d.[PharmacyKey] IS NULL


		-- Idegen kulcsok beállítása
		UPDATE l SET
			l.[PharmacyKey] = dp.[PharmacyKey]
		FROM
			[landing].[MedivusPharmacyReceipt] l
			INNER JOIN [dm].[DimPharmacy] dp ON
				dp.[PharmacyID] = l.[PharmacyID]
		WHERE
			l.[PharmacyID] IS NOT NULL
		/*
		A Medivus termék dumplikátum kiszűrési szabály:
			-	Ha van TTT kód az a rekord maradjon meg
			-	Ha van kiszerelés az a rekord maradjon meg
			-	Ha csak a név sorrendiségében van különbség, mindegy melyik marad meg
		*/
		INSERT INTO @TMPPRODUCTDUPLICATERANK(
				[ProductMedivusID],	
				[PharmacyKey],	
				[ProductTTTID],
				[ProductPackaging],	
				[DuplicateRank]
			)
			SELECT
				g.[ProductMedivusID],
				g.[PharmacyKey],
				g.[ProductTTTID],
				g.[ProductPackaging],	
				ROW_NUMBER() OVER(PARTITION BY g.[ProductMedivusID], g.[PharmacyKey]
									ORDER BY 
										IIF( LEN(ISNULL(TRIM(g.[ProductTTTID]), '')) > 1, 2, 0 ) + 
										IIF( LEN(ISNULL(TRIM(g.[ProductPackaging]), '')) > 0, 1, 0 )
									DESC) AS [DuplicateRank]
			FROM
				(
				SELECT
					l.[ProductMedivusID],
					l.[PharmacyKey],
					l.[ProductTTTID],
					l.[ProductPackaging]
				FROM
					[landing].[MedivusPharmacyReceipt] l
				WHERE
					l.[PharmacyMovementTypeStorageMultiplier] = -1 -- Kimenő árú 
					AND l.[PharmacyKey] IS NOT NULL
				GROUP BY
					l.[ProductMedivusID],
					l.[PharmacyKey],
					l.[ProductTTTID],
					l.[ProductPackaging]
				)g

		INSERT INTO @TMPPRODUCT(
				[ProductMedivusID],
				[PharmacyKey],
				[ProductMedivusName],
				[ProductTTTID],
				[ProductPackaging],	
				[NetConsumerPrice],
				[NetWholesalePrice],
				[MaxPurchaseDate],
				[MinPurchaseDate],
				[RowHashProduct],
				[ImportFileId],
				[MaxPurchaseDateRank]
			)
			SELECT
				g.[ProductMedivusID],
				g.[PharmacyKey],
				g.[ProductMedivusName],
				g.[ProductTTTID],
				g.[ProductPackaging],	
				g.[NetConsumerPrice],
				g.[NetWholesalePrice],
				g.[MaxPurchaseDate],
				g.[MinPurchaseDate],
				[etl].[udf_GetHash_08](
						g.[ProductMedivusID],
						g.[ProductMedivusName],
						g.[ProductTTTID],
						g.[ProductPackaging],	
						g.[NetConsumerPrice],
						g.[NetWholesalePrice],
						g.[MaxPurchaseDate],
						g.[MinPurchaseDate]) AS [RowHashProduct],
				g.[ImportFileId],
				ROW_NUMBER() OVER(PARTITION BY g.[ProductMedivusID], g.[PharmacyKey]
									ORDER BY [MaxPurchaseDate]
									DESC) AS [MaxPurchaseDateRank]
			FROM
				(
				SELECT
					l.[ProductMedivusID],
					l.[PharmacyKey],
					l.[ProductMedivusName],
					l.[ProductTTTID],
					l.[ProductPackaging],
					l.[NetConsumerPrice],
					l.[NetWholesalePrice],
					MAX(l.[PurchaseDate]) AS [MaxPurchaseDate],
					MIN(l.[PurchaseDate]) AS [MinPurchaseDate],
					MIN(l.[ImportFileId]) AS [ImportFileId]
				FROM
					[landing].[MedivusPharmacyReceipt] l
				WHERE
					l.[ErrorLevelProduct] < 2 
					AND l.[PharmacyMovementTypeStorageMultiplier] = -1 -- Kimenő árú AND
					AND l.[PharmacyKey] IS NOT NULL
				GROUP BY
					l.[ProductMedivusID],
					l.[PharmacyKey],
					l.[ProductMedivusName],
					l.[ProductTTTID],
					l.[ProductPackaging],
					l.[NetConsumerPrice],
					l.[NetWholesalePrice]
				)g

		UPDATE tp 
			SET tp.[DuplicateRank] = tpdr.[DuplicateRank]
		FROM
			@TMPPRODUCT tp 
			INNER JOIN @TMPPRODUCTDUPLICATERANK tpdr ON
				tpdr.[ProductMedivusID] = tp.[ProductMedivusID] AND
				tpdr.[PharmacyKey] = tp.[PharmacyKey] AND
				ISNULL(tpdr.[ProductTTTID], '') = ISNULL( tp.[ProductTTTID], '') AND
				ISNULL(tpdr.[ProductPackaging], '') = ISNULL(tp.[ProductPackaging], '')

					
		UPDATE l SET
			[ErrorLevel] = 1,
			[ErrorLevelProduct] = 2,
			[ErrorDescription] = ISNULL([ErrorDescription], '') + 'CIKKID: duplicated product' + CHAR(10) + CHAR(13)
		FROM
			[landing].[MedivusPharmacyReceipt] l
			INNER JOIN @TMPPRODUCTDUPLICATERANK t ON 
				t.[ProductMedivusID] = l.[ProductMedivusID] AND
				t.[PharmacyKey] = l.[PharmacyKey] AND
				ISNULL(t.[ProductTTTID], '') = ISNULL(l.[ProductTTTID], '') AND
				ISNULL(t.[ProductPackaging], '') = ISNULL(l.[ProductPackaging], '')
		WHERE
			t.DuplicateRank > 1

		UPDATE l SET
			[ErrorLevel] = 1,
			[ErrorLevelPharmacyTransactions] = 2,
			[ErrorDescription] = ISNULL([ErrorDescription], '') + 'RowHashPharmacyTransactions: record already exists in [dm].[FactClinicPrescriptions]' + CHAR(10) + CHAR(13)
		FROM
			[landing].[MedivusPharmacyReceipt] l
			INNER JOIN [dm].[FactClinicPrescriptions] f ON
				f.[RowHash] = l.[RowHashPharmacyTransactions]

		UPDATE l SET
			[ErrorLevel] = 1,
			[ErrorLevelPharmacyTransactions] = 2,
			[ErrorDescription] = ISNULL([ErrorDescription], '') + 'RowHashPharmacyTransactions: duplicated record in [landing].[MedivusPharmacyReceipt]' + CHAR(10) + CHAR(13)
		FROM		
			[landing].[MedivusPharmacyReceipt] l
			INNER JOIN 
			(
				SELECT
					[RowId],
					ROW_NUMBER() OVER(PARTITION BY c.[RowHashPharmacyTransactions]
									ORDER BY [RowId]
									ASC) AS [DuplicateRecordRank]
				FROM
					[landing].[MedivusPharmacyReceipt] c
			)t ON t.[RowId] = l.[RowId]
		WHERE
			t.[DuplicateRecordRank] > 1



		/*
			[dm].[DimPharmacyReceiptTitle] töltése SCD1
		*/		
		MERGE [dm].[DimPharmacyReceiptTitle] AS TARGET
		USING 
		(
			SELECT
				l.[PharmacyReceiptTitleMedivusID],
				l.[PharmacyReceiptTitleName],
				MIN( l.[ImportFileId] ) AS [ImportFileId]
			FROM
				[landing].[MedivusPharmacyReceipt] l
			WHERE
				l.[ErrorLevelPharmacyReceiptTitle] = 0
			GROUP BY
				l.[PharmacyReceiptTitleMedivusID],
				l.[PharmacyReceiptTitleName]
		)
		AS SOURCE
		ON (SOURCE.[PharmacyReceiptTitleMedivusID] = TARGET.[PharmacyReceiptTitleMedivusID] AND 
			ISNULL(SOURCE.[PharmacyReceiptTitleName], 'NULL') = ISNULL( TARGET.[PharmacyReceiptTitleName], 'NULL'))
		
		-- INSERT
		WHEN NOT MATCHED BY TARGET
			THEN INSERT
			(
				[PharmacyReceiptTitleMedivusID],
				[PharmacyReceiptTitleName],
				[ImportFileId], 
				[ETLSessionID]
			)
			VALUES
			(
				SOURCE.[PharmacyReceiptTitleMedivusID],
				SOURCE.[PharmacyReceiptTitleName],
				SOURCE.[ImportFileId],
				@ETLSESSIONID
			)

		/*
		Az UPDATE helyett felvesszük új entitásként a módosulást
		*/
		-- UPDATE
		--WHEN MATCHED AND  AND SOURCE.[ErrorLevelPharmacyReceiptTitle] = 0
		--	THEN UPDATE SET
		    
    
		/*
		A törlés itt nem kivitelezhető mivel nem FULL EXTRACT-ot kapunk és az időszak sem beazonosítható
		*/
		-- DELETE
		--WHEN NOT MATCHED BY Source THEN
		--	DELETE
		;


		/*
			[dm].[DimPharmacyMovementType] töltése SCD1
		*/
		MERGE [dm].[DimPharmacyMovementType] AS TARGET
		USING 
		(
			SELECT
				l.[PharmacyMovementTypeMedivusID],
				l.[PharmacyMovementTypeName],
				l.[PharmacyMovementTypeStorageMultiplier],
				MIN(l.[ImportFileId]) AS [ImportFileId]
			FROM
				[landing].[MedivusPharmacyReceipt] l
			WHERE
				l.[ErrorLevelPharmacyMovementType] = 0
			GROUP BY
				l.[PharmacyMovementTypeMedivusID],
				l.[PharmacyMovementTypeName],
				l.[PharmacyMovementTypeStorageMultiplier]
		) AS SOURCE
		ON (SOURCE.[PharmacyMovementTypeMedivusID] = TARGET.[PharmacyMovementTypeMedivusID] AND 
			SOURCE.[PharmacyMovementTypeName] = TARGET.[PharmacyMovementTypeName] AND -- PABRONITS, 2023.06.26: Bevezetve betöltés hiba miatt.
			ISNULL(SOURCE.[PharmacyMovementTypeName], 'NULL') = ISNULL(TARGET.[PharmacyMovementTypeName], 'NULL'))
		
		-- INSERT
		WHEN NOT MATCHED BY TARGET
		   THEN INSERT
		   (
				[PharmacyMovementTypeMedivusID],
				[PharmacyMovementTypeName],
				[PharmacyMovementTypeStorageMultiplier],
				[ImportFileId],
				[ETLSessionID]
		   )
		   VALUES
		   (
				SOURCE.[PharmacyMovementTypeMedivusID],
				SOURCE.[PharmacyMovementTypeName],
				SOURCE.[PharmacyMovementTypeStorageMultiplier],
				SOURCE.[ImportFileId],
				@ETLSESSIONID
		   )
		
		/* PABRONITS, 2023.06.26: Kivezetve betöltés hiba miatt.
		-- UPDATE
		WHEN MATCHED AND ISNULL(SOURCE.[PharmacyMovementTypeStorageMultiplier], -1000) <> ISNULL(TARGET.[PharmacyMovementTypeStorageMultiplier], -1000)
			THEN UPDATE SET
		    TARGET.[PharmacyMovementTypeStorageMultiplier]	= SOURCE.[PharmacyMovementTypeStorageMultiplier],
			TARGET.[ImportFileId]							= SOURCE.[ImportFileId],
			TARGET.[EtlSessionId]							= @ETLSESSIONID
		*/

		/*
		A törlés itt nem kivitelezhető mivel nem FULL EXTRACT-ot kapunk és az időszak sem beazonosítható
		*/
		-- DELETE
		--WHEN NOT MATCHED BY Source THEN
		--	DELETE
		;

		/*
			[dm].[DimProductMedivus] töltése
		*/


		/*
			[dm].[DimProductMedivus] töltése SCD4						
		*/
		MERGE [dm].[DimProductMedivus] AS TARGET
		USING @TMPPRODUCT AS SOURCE
		ON 
		(
			SOURCE.[ProductMedivusID] = TARGET.[ProductMedivusID] AND
			SOURCE.[PharmacyKey] = TARGET.[PharmacyKey] AND
			SOURCE.[MaxPurchaseDateRank] = 1
		)
		-- INSERT
		WHEN NOT MATCHED BY TARGET
		   THEN INSERT
		   (
				[ProductMedivusID],
				[PharmacyKey],
				[ProductMedivusName],
				[ProductTTTID],
				[ProductPackaging],
				[NetConsumerPrice],
				[NetWholesalePrice],
				[MaxPurchaseDate],
				[MinPurchaseDate],
				[RowHash],
				[ImportFileId],
				[ETLSessionID]
		   )
		   VALUES
		   (
				SOURCE.[ProductMedivusID],
				SOURCE.[PharmacyKey],
				SOURCE.[ProductMedivusName],
				SOURCE.[ProductTTTID],
				SOURCE.[ProductPackaging],
				SOURCE.[NetConsumerPrice],
				SOURCE.[NetWholesalePrice],
				SOURCE.[MaxPurchaseDate],
				SOURCE.[MinPurchaseDate],
				SOURCE.[RowHashProduct],
				SOURCE.[ImportFileId],
				@ETLSESSIONID
		   )
		   		
		-- UPDATE
		WHEN MATCHED AND 
				SOURCE.[RowHashProduct] <> TARGET.[RowHash]  AND
				SOURCE.[MaxPurchaseDateRank] = 1
			THEN UPDATE SET
		    TARGET.[ProductMedivusName]	= SOURCE.[ProductMedivusName],
			TARGET.[ProductTTTID]		= SOURCE.[ProductTTTID],
			TARGET.[ProductPackaging]	= SOURCE.[ProductPackaging],
			TARGET.[NetConsumerPrice]	= SOURCE.[NetConsumerPrice],
			TARGET.[NetWholesalePrice]	= SOURCE.[NetWholesalePrice],
			TARGET.[MaxPurchaseDate]	= IIF( SOURCE.[MaxPurchaseDate] > TARGET.[MaxPurchaseDate], SOURCE.[MaxPurchaseDate], TARGET.[MaxPurchaseDate]),
			TARGET.[MinPurchaseDate]	= IIF( SOURCE.[MinPurchaseDate] < TARGET.[MinPurchaseDate], SOURCE.[MinPurchaseDate], TARGET.[MinPurchaseDate]),
			TARGET.[RowHash]			= SOURCE.[RowHashProduct],
			TARGET.[ImportFileId]		= SOURCE.[ImportFileId],
			TARGET.[EtlSessionId]		= @ETLSESSIONID
		/*
		A törlés itt nem kivitelezhető mivel nem FULL EXTRACT-ot kapunk és az időszak sem beazonosítható
		*/
		-- DELETE
		--WHEN NOT MATCHED BY Source THEN
		--	DELETE
		OUTPUT 
			deleted.[ProductMedivusKey],
			deleted.[ProductMedivusID],
			deleted.[PharmacyKey],
			deleted.[ProductMedivusName],
			deleted.[ProductTTTID],
			deleted.[ProductPackaging],
			deleted.[NetConsumerPrice],
			deleted.[NetWholesalePrice],
			deleted.[MaxPurchaseDate],
			deleted.[MinPurchaseDate],
			deleted.[RowHash],
			deleted.[ImportFileId],
			deleted.[EtlSessionId],
			$action as ActionType
		INTO @HSTPRODUCTMEDIVUS;

		INSERT INTO [hst].[DimProductMedivus]
		(
			[ProductMedivusKey],
			[ProductMedivusID],
			[PharmacyKey],
			[ProductMedivusName],
			[ProductTTTID],
			[ProductPackaging],
			[NetConsumerPrice],
			[NetWholesalePrice],
			[MaxPurchaseDate],
			[MinPurchaseDate],
			[RowHash],
			[ImportFileId],
			[ETLSessionID],
			[ActionType],
			[ActionEtlSessionId],
			[ActionFields]
		)
		SELECT  
			h.[ProductMedivusKey],
			h.[ProductMedivusID],
			h.[PharmacyKey],
			h.[ProductMedivusName],
			h.[ProductTTTID],
			h.[ProductPackaging],
			h.[NetConsumerPrice],
			h.[NetWholesalePrice],
			h.[MaxPurchaseDate],
			h.[MinPurchaseDate],
			h.[RowHash],
			h.[ImportFileId],
			h.[EtlSessionId],
		   CASE WHEN h.[ActionType] = 'UPDATE' THEN 1 ELSE 2 END,
		   @ETLSESSIONID,
		   CASE WHEN h.[ActionType] = 'UPDATE' THEN
		   		   IIF( ISNULL( h.[ProductMedivusName], '') <> ISNULL( t.[ProductMedivusName], ''), '[ProductMedivusName]: ' + ISNULL(h.[ProductMedivusName], 'NULL') + ' -> ' +  ISNULL( t.[ProductMedivusName], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[ProductTTTID], '') <> ISNULL( t.[ProductTTTID], ''), '[ProductTTTID]: ' + ISNULL(h.[ProductTTTID], 'NULL') + ' -> ' +  ISNULL( t.[ProductTTTID], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[ProductPackaging], '') <> ISNULL( t.[ProductPackaging], ''), '[ProductPackaging]: ' + ISNULL(h.[ProductPackaging], 'NULL') + ' -> ' +  ISNULL( t.[ProductPackaging], 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[MaxPurchaseDate], '1900-01-01') <> ISNULL( t.[MaxPurchaseDate], '1900-01-01'), '[MaxPurchaseDate]: ' + ISNULL(CONVERT(NVARCHAR, h.[MaxPurchaseDate], 120), 'NULL')  + ' -> ' +  ISNULL(CONVERT(NVARCHAR, t.[MaxPurchaseDate], 120), 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[MinPurchaseDate], '1900-01-01') <> ISNULL( t.[MinPurchaseDate], '1900-01-01'), '[MinPurchaseDate]: ' + ISNULL(CONVERT(NVARCHAR, h.[MinPurchaseDate], 120), 'NULL')  + ' -> ' +  ISNULL(CONVERT(NVARCHAR, t.[MinPurchaseDate], 120), 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[NetConsumerPrice], -1) <> ISNULL( t.[NetConsumerPrice], -1), '[NetConsumerPrice]: ' + ISNULL(CAST(h.[NetConsumerPrice] AS NVARCHAR(20)), 'NULL') + ' -> ' +  ISNULL( CAST(t.[NetConsumerPrice] AS NVARCHAR(20)), 'NULL')  + ' ' + CHAR(13), '' ) +
				   IIF( ISNULL( h.[NetWholesalePrice], -1) <> ISNULL( t.[NetWholesalePrice], -1), '[NetWholesalePrice]: ' + ISNULL(CAST(h.[NetWholesalePrice] AS NVARCHAR(20)), 'NULL') + ' -> ' +  ISNULL( CAST(t.[NetWholesalePrice] AS NVARCHAR(20)), 'NULL'), '')
			ELSE NULL END
		FROM 
			@HSTPRODUCTMEDIVUS h
			LEFT JOIN @TMPPRODUCT t on 
				t.[ProductMedivusID] = h.[ProductMedivusID]	AND
				t.[PharmacyKey] = h.[PharmacyKey]	AND
				t.[RowHashProduct] = h.[RowHash]
		WHERE 
			h.ActionType <> 'INSERT';

		/*
		Itt vesszük fel azokat a termékeket, amelyeket közvetlenül a history-ba töltünk.
		*/
		INSERT INTO [hst].[DimProductMedivus]
		(
			[ProductMedivusKey],
			[ProductMedivusID],
			[PharmacyKey],
			[ProductMedivusName],
			[ProductTTTID],
			[ProductPackaging],
			[NetConsumerPrice],
			[NetWholesalePrice],
			[MaxPurchaseDate],
			[MinPurchaseDate],
			[RowHash],
			[ImportFileId],
			[ETLSessionID],
			[ActionType],
			[ActionEtlSessionId]
		)
		SELECT
			-2,
			[ProductMedivusID],
			[PharmacyKey],
			[ProductMedivusName],
			[ProductTTTID],
			[ProductPackaging],
			[NetConsumerPrice],
			[NetWholesalePrice],
			[MaxPurchaseDate],
			[MinPurchaseDate],
			[RowHashProduct],
			[ImportFileId],
			@ETLSESSIONID,
			4,
			@ETLSESSIONID
		FROM
			@TMPPRODUCT
		WHERE
			MaxPurchaseDateRank > 1

		/*
			[dm].[FactPharmacyTransactions] töltése SCD 1			
		*/
				
		UPDATE l SET			
			l.[PharmacyMovementTypeKey] = dpmt.[PharmacyMovementTypeKey]
		FROM
			[landing].[MedivusPharmacyReceipt] l			
			INNER JOIN [dm].[DimPharmacyMovementType] dpmt ON
				dpmt.[PharmacyMovementTypeMedivusID] = l.[PharmacyMovementTypeMedivusID] AND
				ISNULL(dpmt.[PharmacyMovementTypeName], 'NULL') = ISNULL(l.[PharmacyMovementTypeName], 'NULL') AND
				ISNULL(dpmt.[PharmacyMovementTypeStorageMultiplier], 255) = ISNULL(l.[PharmacyMovementTypeStorageMultiplier], 255)
		WHERE
			l.[ErrorLevelPharmacyTransactions] < 2

		UPDATE l SET
			l.[PharmacyReceiptTitleKey] = dprt.[PharmacyReceiptTitleKey]
		FROM
			[landing].[MedivusPharmacyReceipt] l			
			INNER JOIN [dm].[DimPharmacyReceiptTitle] dprt ON
				dprt.[PharmacyReceiptTitleMedivusID] = l.[PharmacyReceiptTitleMedivusID] AND
				ISNULL(dprt.[PharmacyReceiptTitleName], 'NULL') = ISNULL(l.[PharmacyReceiptTitleName], 'NULL')
		WHERE
			l.[ErrorLevelPharmacyTransactions] < 2

		UPDATE l SET
			l.[ProductKey] = dpr.[ProductMedivusKey]
		FROM
			[landing].[MedivusPharmacyReceipt] l			
			INNER JOIN [dm].[DimProductMedivus] dpr ON
				dpr.[ProductMedivusID] = l.[ProductMedivusID]
				AND dpr.[PharmacyKey] = l.[PharmacyKey]
		WHERE
			l.[ErrorLevelPharmacyTransactions] < 2

		UPDATE [landing].[MedivusPharmacyReceipt] SET
			[ErrorLevel] = 1,
			[ErrorLevelProduct] = 2,
			[ErrorLevelPharmacyTransactions] = 2,
			[ErrorDescription] = ISNULL([ErrorDescription], '') + 'ProductKey: Product not found in [dm].[DimProductMedivus]' + CHAR(10) + CHAR(13)
		WHERE
			[ErrorLevelPharmacyTransactions] < 2 AND
			[ProductKey] IS NULL


		-- Mivel a tranzakciónak nincs technikai azonosítója, a fájl név alapján törlünk és töltünk újra.
		DELETE f
		FROM 
			[dm].[FactPharmacyTransactions] f
		WHERE
			f.[ImportFileId] IN
			(
				SELECT DISTINCT fif.[ImportFileId]
				FROM
					[landing].[MedivusPharmacyReceipt] l
					INNER JOIN [com].[ImportFile] lif ON
						lif.[ImportFileId] = l.[ImportFileId]
					INNER JOIN [com].[ImportFile] fif ON
						lif.[FileName] = fif.[FileName]
				WHERE	
					l.[ErrorLevelPharmacyTransactions] < 2
			)
			

		INSERT INTO [dm].[FactPharmacyTransactions]
		( 
			[PharmacyKey],
			[PharmacyMovementTypeKey],
			[PharmacyReceiptID],
			[PharmacyReceiptItemID],
			[PrescriptionID],
			[PrescriptionType],
			[PharmacyProductKey],
			[PharmacyReceiptTitleKey],
			[PurchaseDate],
			[Quantity],
			[NetPurchaseValue],
			[NetPaidValue],
			[NetSupportValue],
			[NetSalesValue],
			[NetMargin],
			[NetMarginCorrection],
			[RowHash],
			[ImportFileId],
			[ETLSessionID]
		)
		SELECT
			l.[PharmacyKey],
			l.[PharmacyMovementTypeKey],
			l.[PharmacyReceiptID],
			l.[PharmacyReceiptItemID],
			l.[PrescriptionID],
			l.[PrescriptionType],
			l.[ProductKey],
			l.[PharmacyReceiptTitleKey],
			d.[DateKey],
			l.[Quantity],
			l.[NetPurchaseValue],
			l.[NetPaidValue],
			l.[NetSupportValue],
			l.[NetSalesValue],
			l.[NetMargin],
			l.[NetMarginCorrection],
			l.[RowHashPharmacyTransactions],
			l.[ImportFileId],
			@ETLSESSIONID
		FROM
			[landing].[MedivusPharmacyReceipt] l
			INNER JOIN [dm].[DimDate] d ON
				d.[Date] = l.[PurchaseDate]
		WHERE
			l.[Storno] = 0 AND
			l.[ErrorLevelPharmacyTransactions] < 2


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
		[landing].[MedivusPharmacyReceipt] la 
	WHERE
		la.[ErrorLevel] > 0

	END TRY

	BEGIN CATCH
			
		ROLLBACK TRANSACTION

		SET @ERROR_MSG = (SELECT 'ERROR_PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'na') + '; ERROR_LINE: ' + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(50)), 'na') + '; ERROR_MESSAGE: ' +  ISNULL(ERROR_MESSAGE(), 'na'))

		EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 3,
		@COMPONENT = '[etl].[usp_ProcessMedivusPharmacyReceipt]',
		@DESCRIPTION  = @ERROR_MSG;

		THROW;

	END CATCH
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessMedivusPharmacyReceipt]',
		@DESCRIPTION  = @ELAPSED
		    
