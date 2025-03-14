






-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Létrehozzuk a landing táblán az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_CreateIndexPUPHA]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	--IX_LandingPuphaGyogysz_ProductTTTID
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingPuphaGyogysz_ProductTTTID')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingPuphaGyogysz_ProductTTTID] ON [landing].[PuphaGyogysz]
		(
			[ProductTTTID] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END


	--IX_LandingPuphaGyogysz_RowHash
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingPuphaGyogysz_RowHash')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingPuphaGyogysz_RowHash] ON [landing].[PuphaGyogysz]
		(
			[RowHash] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END
	
	ALTER INDEX [IX_DimProductPupha_ProductTTTID] ON [dm].[DimProductPupha] REORGANIZE
	ALTER INDEX [IX_DimProductPupha_RowHash] ON [dm].[DimProductPupha] REORGANIZE
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_CreateIndexPUPHA]',
		@DESCRIPTION  = @ELAPSED