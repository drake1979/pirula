﻿
-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.10.21
-- Description:	SZTE_Pirula_RLS_Navi.xlsx Excel feldolgozás	
-- =============================================
CREATE PROCEDURE [etl].[usp_ProcessRLSNavi]
	
	@ETLSESSIONID BIGINT

WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()
	
	DECLARE @ERROR_MSG NVARCHAR(MAX)

	BEGIN TRY
	UPDATE [landing].[NaviRLS]
	SET [ErrorLevel] = 0

	UPDATE [landing].[NaviRLS]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Name: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Name] IS NULL

	UPDATE [landing].[NaviRLS]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Email: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Email] IS NULL

	UPDATE [landing].[NaviRLS]
	SET
		[ErrorLevel] = 1,
		[ErrorDescription] = ISNULL([ErrorDescription], '') + 'Page: cannot be NULL' + CHAR(10) + CHAR(13)
	WHERE
		[Landing_Page] IS NULL

	-- ERROR log
	INSERT INTO com.ImportError( [RowNumber], [ImportFileId], [ErrorDescription], [ErrorLevel], [EtlSessionId] )
	SELECT
		la.[RowId] + 1, -- Az első sor a header
		la.[ImportFileId],
		la.[ErrorDescription],
		la.[ErrorLevel],
		@ETLSESSIONID
	FROM
		[landing].[NaviRLS] la 
	WHERE
		[ErrorLevel] > 0
	
	BEGIN TRAN;

	TRUNCATE TABLE dm.DimNaviRLS
	INSERT INTO dm.DimNaviRLS
	([Name],
	 [Email],
	 [Page])
	 SELECT [Landing_Name],
	        [Landing_Email],
	        [Landing_Page]
	   FROM landing.[NaviRLS]
	  WHERE [ErrorLevel] = 0

	COMMIT TRAN;

	END TRY

	BEGIN CATCH
			
		ROLLBACK TRANSACTION

		SET @ERROR_MSG = (SELECT 'ERROR_PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'na') + '; ERROR_LINE: ' + ISNULL(CAST(ERROR_LINE() AS NVARCHAR(50)), 'na') + '; ERROR_MESSAGE: ' +  ISNULL(ERROR_MESSAGE(), 'na'))

		EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 3,
		@COMPONENT = '[etl].[usp_ProcessNaviRLS]',
		@DESCRIPTION  = @ERROR_MSG;

		THROW;

	END CATCH
	
	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_ProcessNaviRLS]',
		@DESCRIPTION  = @ELAPSED
		    
