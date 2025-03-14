



-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	ImportFile rekord módosítása (EndDate és Status mezők)
-- =============================================
CREATE PROCEDURE [etl].[usp_UpdateImportFile]
    @ETLSESSIONID BIGINT,
    @IMPORTFILEID BIGINT,
	@COMPONENT VARCHAR(200),
	@STATUS INT,
	@ERRORMESSAGE NVARCHAR(max)

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  
	DECLARE @TECHNICALLOGID BIGINT = null
	
	EXEC @TECHNICALLOGID = [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = @COMPONENT,
		@DESCRIPTION  = @ERRORMESSAGE
    
	UPDATE [com].[ImportFile]
	SET 
		[EndDate] = GETDATE(),
		[Status] = @Status,
		[TechnicalLogId] = @TECHNICALLOGID
	WHERE 
		[ImportFileId] = @IMPORTFILEID

	-- Visszaadjuk az ADF-nek az új ImportedFileId azonosítót
	SELECT @IMPORTFILEID AS ImportedFileId

RETURN 0;
