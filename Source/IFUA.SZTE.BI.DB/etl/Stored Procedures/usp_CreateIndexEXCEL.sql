





-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Létrehozzuk a landing táblán az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_CreateIndexEXCEL]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	--IX_LandingExcelWholesaleRefund_Datum_PharmacyKey_SupplierKey
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingExcelWholesaleRefund_Datum_PharmacyKey_SupplierKey')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingExcelWholesaleRefund_Datum_PharmacyKey_SupplierKey] ON [landing].[ExcelWholesaleRefund]
		(
			[Datum] ASC
		)
		INCLUDE([PharmacyKey],[SupplierKey]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END


	--IX_LandingExcelWholesaleRefund_RowHash
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingExcelWholesaleRefund_RowHash')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingExcelWholesaleRefund_RowHash] ON [landing].[ExcelWholesaleRefund]
		(
			[RowHash] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END


	ALTER INDEX [IX_DimSupplier_SupplierName] ON [dm].[DimSupplier] REORGANIZE
	ALTER INDEX [IX_FactWholesaleRefund_RowHash] ON [dm].[FactWholesaleRefund] REORGANIZE
	ALTER INDEX [IX_FactWholesaleRefund_WholsesaleRefundDate_PharmacyKey_SupplierKey] ON [dm].[FactWholesaleRefund] REORGANIZE


	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_CreateIndexEXCEL]',
		@DESCRIPTION  = @ELAPSED