




-- =============================================
-- Author:		pabronits
-- Create date: 2022.07.12
-- Description:	Medivus Excel feldolgozása
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessMedivus]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	EXEC [etl].[usp_CreateIndexMEDIVUS] @ETLSESSIONID

	EXEC [etl].[usp_ProcessMedivusPharmacyReceipt] @ETLSESSIONID 
	EXEC [etl].[usp_ProcessMedsolClinicPrescriptions] @ETLSESSIONID 
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessMedivus]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
