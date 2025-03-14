







-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Töröljük a landing tábláról az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_DropIndexPUPHA]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingPuphaGyogysz_ProductTTTID')
	BEGIN
		DROP INDEX [IX_LandingPuphaGyogysz_ProductTTTID] ON [landing].[PuphaGyogysz]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingPuphaGyogysz_RowHash')
	BEGIN
		DROP INDEX [IX_LandingPuphaGyogysz_RowHash] ON [landing].[PuphaGyogysz]
	END
		
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_DropIndexPUPHA]',
		@DESCRIPTION  = @ELAPSED