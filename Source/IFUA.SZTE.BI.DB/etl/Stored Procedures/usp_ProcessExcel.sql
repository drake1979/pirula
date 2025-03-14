




-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.05
-- Description:	Törli az Excel landing táblákat.
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessExcel]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
		
	EXEC [etl].[usp_CreateIndexEXCEL] @ETLSESSIONID
	
	EXEC [etl].[usp_ProcessExcelWholesaleRefund] @ETLSESSIONID 
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessExcel]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
