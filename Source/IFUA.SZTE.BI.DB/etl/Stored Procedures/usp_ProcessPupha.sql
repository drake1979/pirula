





-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.12
-- Description:	PUPHA MS ACCESS fájl feldolgozása
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessPupha]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	EXEC [etl].[usp_CreateIndexPUPHA] @ETLSESSIONID

	EXEC [etl].[usp_ProcessPuphaGyogysz] @ETLSESSIONID 
	EXEC [etl].[usp_ProcessMedsolClinicPrescriptions] @ETLSESSIONID 

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessPupha]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
