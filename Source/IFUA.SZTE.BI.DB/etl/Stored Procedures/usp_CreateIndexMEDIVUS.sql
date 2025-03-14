







-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Létrehozzuk a landing táblán az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_CreateIndexMEDIVUS]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	--IX_LandingMedivusPharmacyReceipt_PharmacyID
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_PharmacyID')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedivusPharmacyReceipt_PharmacyID] ON [landing].[MedivusPharmacyReceipt]
		(
			[PharmacyID] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END


	--IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey] ON [landing].[MedivusPharmacyReceipt]
		(
			[ProductMedivusID] ASC
		)
		INCLUDE([PharmacyKey]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END

	--IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey_ProductTTTID_ProductPackaging
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey_ProductTTTID_ProductPackaging')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey_ProductTTTID_ProductPackaging] ON [landing].[MedivusPharmacyReceipt]
		(
			[ProductMedivusID] ASC
		)
		INCLUDE([PharmacyKey],[ProductTTTID],[ProductPackaging]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END

	--IX_LandingMedivusPharmacyReceipt_PurchaseDate
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_PurchaseDate')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedivusPharmacyReceipt_PurchaseDate] ON [landing].[MedivusPharmacyReceipt]
		(
			[PurchaseDate] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END

	--IX_LandingMedivusPharmacyReceipt_RowHashPharmacyTransactions
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_RowHashPharmacyTransactions')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedivusPharmacyReceipt_RowHashPharmacyTransactions] ON [landing].[MedivusPharmacyReceipt]
		(
			[RowHashPharmacyTransactions] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END
	
	ALTER INDEX [IX_DimProductMedivus_ProductMedivusID_PharmacyKey] ON [dm].[DimProductMedivus] REORGANIZE
	ALTER INDEX [IX_ComImportFile_FileName] ON [com].[ImportFile] REORGANIZE

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_CreateIndexMEDIVUS]',
		@DESCRIPTION  = @ELAPSED