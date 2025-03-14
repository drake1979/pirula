


-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	Létrehozza a ETLSession-t.
-- =============================================
CREATE PROCEDURE [etl].[usp_StartEtlSession]
	@EtlSessionAlreadyExists BIT OUTPUT,
	@EtlSessionId BIGINT OUTPUT,
	@AdfSessionId VARCHAR(MAX),
	@SourceName NVARCHAR(100)
WITH RECOMPILE
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
		
	DECLARE @Now DATETIME = GETDATE()
	DECLARE @ProcessTypeId AS INT
		
	DECLARE @RUNNING_TETM_ETLSESSION_COUNT INT = 0
	
	SELECT 
		@RUNNING_TETM_ETLSESSION_COUNT = COUNT([EtlSessionId]) 
	FROM
		[com].[EtlSession]
	WHERE
		[EndSession] IS NULL AND
		[AdfSessionId] <> @AdfSessionId

    SET @ProcessTypeId = (SELECT ProcessTypeId FROM com.Sources WHERE Source = TRIM(@SourceName))
	
	IF @ProcessTypeId IS NULL 
	BEGIN
		SET @EtlSessionAlreadyExists = 1
		SET @EtlSessionId = -1;
		INSERT INTO com.TechnicalLog
		(LogType,
			TimeStamp,
			Component,
			[Description])
		VALUES
		(3,
			@Now,
			'ADF PipeLine',
			'ProcessTypeId was not found!');

		-- Ezzel szakítjuk meg az ADF végrehajtást
		THROW 99999, 'ProcessTypeId was not found!', 1
	END

	IF( @RUNNING_TETM_ETLSESSION_COUNT > 0 )
	BEGIN
		SET @EtlSessionAlreadyExists = 1
		SET @EtlSessionId = -1;
		INSERT INTO com.TechnicalLog
		(LogType,
			TimeStamp,
			Component,
			[Description])
		VALUES
		(3,
			@Now,
			'ADF PipeLine',
			'Another session is already active!');

		-- Ezzel szakítjuk meg az ADF végrehajtást
		THROW 99999, 'Another session is already active!', 1
	END
	ELSE
	BEGIN
		SET @EtlSessionAlreadyExists = 0;



		INSERT INTO [com].[EtlSession] 
			([StartSession], 
			[AdfSessionId], 
			[ProcessTypeId], 
			[Status],
			[CreatedBy])
		VALUES 
			(@Now, 
			@AdfSessionId, 
			@ProcessTypeId, 
			1,
			'ADF Pipeline');
		
		SET @EtlSessionId = SCOPE_IDENTITY()
	END

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_StartEtlSession]',
		@DESCRIPTION  = @ELAPSED

	-- ADF naplozási adatok
	SELECT @EtlSessionAlreadyExists AS EtlSessionAlreadyExists, @EtlSessionId AS EtlSessionId

RETURN 0;
