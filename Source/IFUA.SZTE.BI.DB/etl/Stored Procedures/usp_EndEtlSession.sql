-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	Lezárja a futó ETL munkafolyamatot a [etl].[EtlSession] táblában
-- =============================================
CREATE PROCEDURE [etl].[usp_EndEtlSession]
	@ETLSESSIONID INT,
	@AdfSessionId VARCHAR(MAX),
	@SUCCESS BIT,
	@ERRORMESSAGE VARCHAR(MAX)
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  
		
	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	IF @SUCCESS = 0
	BEGIN
		
		EXEC [etl].[usp_LogEvent] 
			@ETLSESSIONID = @ETLSESSIONID,
			@LOGTYPE = 3,
			@COMPONENT = 'ADF PipeLine',
			@DESCRIPTION = @ERRORMESSAGE
	END

	/* <!Indexing!> Not needed at the moment Not needed in this project (according to AP)
	EXEC [etl].[usp_CreateIndex]	
	*/

	UPDATE [com].[EtlSession] SET 
		[Status]	   = @SUCCESS, 
		[EndSession]   = GETDATE()
	WHERE 
		EtlSessionId = @ETLSESSIONID; 

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_EndEtlSession]',
		@DESCRIPTION  = @ELAPSED

    -- ADF-nek visszaadjuk az EtlSessionId értékét.
    SELECT @ETLSESSIONID AS EtlSessionId

RETURN 0;
