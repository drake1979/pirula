



-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	ImportFile rekord létrehozása
-- =============================================
CREATE PROCEDURE [etl].[usp_InsertImportFile]
    @ETLSESSIONID BIGINT,
	@FILEPATH NVARCHAR(1000),
	@FILENAME NVARCHAR(255),
	@EXTRACTDATE NVARCHAR(50)
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @IMPORTFILEID AS BIGINT

	INSERT INTO [com].[ImportFile]
	(
       [FilePath],
       [FileName],
       [ExtractDate],
       [Status],
       [StartDate],
       [EtlSessionId]
	)
	VALUES
	(
	   @FILEPATH,
	   @FILENAME,
	   SUBSTRING(@EXTRACTDATE,1,8),
	   1,
	   GetDate(),
	   @ETLSESSIONID
	)

	SET @IMPORTFILEID = SCOPE_IDENTITY()

	SELECT @IMPORTFILEID AS ImportedFileId

	RETURN 0;
