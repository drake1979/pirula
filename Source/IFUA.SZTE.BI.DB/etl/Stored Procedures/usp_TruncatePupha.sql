



-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.07.01
-- Description:	PUPHA
-- =============================================
CREATE PROCEDURE [etl].[usp_TruncatePupha]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	TRUNCATE TABLE [landing].[PuphaGyogysz]

    EXEC [etl].[usp_DropIndexPUPHA] @ETLSESSIONID
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_TruncatePUPHA]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
