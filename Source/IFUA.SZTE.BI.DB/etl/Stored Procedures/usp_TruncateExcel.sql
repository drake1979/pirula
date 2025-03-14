



-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.07.01
-- Description:	EXCEL
-- =============================================
CREATE PROCEDURE [etl].[usp_TruncateExcel]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	TRUNCATE TABLE [landing].[ExcelWholeSaleRefund]

	
    EXEC [etl].[usp_DropIndexEXCEL] @ETLSESSIONID
		
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_TruncateEXCEL]',
		@DESCRIPTION  = @ELAPSED

    --Dummy returning select
	SELECT 0 AS NORETURN;

RETURN 0;
