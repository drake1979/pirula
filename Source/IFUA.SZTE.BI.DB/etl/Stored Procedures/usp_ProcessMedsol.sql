





-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.14
-- Description:	Medsol forrásrendszer feldolgozása
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessMedsol]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	EXEC [etl].[usp_CreateIndexMEDSOL] @ETLSESSIONID

	EXEC [etl].[usp_ProcessMedsolEmsReceipt] @ETLSESSIONID 
	EXEC [etl].[usp_ProcessMedsolClinicPrescriptions] @ETLSESSIONID 

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessMedsol]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
