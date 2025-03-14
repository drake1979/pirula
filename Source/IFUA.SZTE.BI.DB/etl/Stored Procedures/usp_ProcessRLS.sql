





-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.10.21
-- Description:	RLS forrásrendszer feldolgozása
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessRLS]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	/* TODO
	EXEC etl.usp_CreateIndexExcel
	*/

	EXEC [etl].[usp_ProcessRLSClinic] @ETLSESSIONID 
	EXEC [etl].[usp_ProcessRLSNavi] @ETLSESSIONID 

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessRLS]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
