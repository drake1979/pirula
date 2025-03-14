



-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.07.01
-- Description:	MEDSOL
-- =============================================
CREATE PROCEDURE [etl].[usp_TruncateMedsol]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	TRUNCATE TABLE [landing].[MedsolEmsReceipt]

	
    EXEC [etl].[usp_DropIndexMEDSOL] @ETLSESSIONID
		
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_TruncateMEDSOL]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
