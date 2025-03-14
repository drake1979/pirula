



-- =============================================
-- Author:		pabronits
-- Create date: 2022.06.22
-- Description:	Esemény naplózása
-- =============================================
CREATE PROCEDURE [etl].[usp_LogEvent]
	@ETLSESSIONID BIGINT,
	@LOGTYPE INT,
	@COMPONENT NVARCHAR(1000),
	@DESCRIPTION NVARCHAR(MAX)
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	INSERT INTO [com].[TechnicalLog]
	(
		[LogType],
		[TimeStamp],
		[Component],
		[Description],
		[EtlSessionId]
	)
	VALUES
	(
		@LOGTYPE,
		GETDATE(),
		@COMPONENT,
		@DESCRIPTION,
		@ETLSESSIONID
	)

	DECLARE @TECHNICALLOGID BIGINT = SCOPE_IDENTITY()

RETURN @TECHNICALLOGID;
