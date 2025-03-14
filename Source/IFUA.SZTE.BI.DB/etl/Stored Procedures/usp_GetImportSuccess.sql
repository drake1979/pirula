
-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	Visszaadja sikeres volt-e az adat import
-- =============================================

CREATE PROCEDURE [etl].[usp_GetImportSuccess]

	@ETLSESSIONID BIGINT

WITH RECOMPILE
AS
BEGIN
   DECLARE @RESULT AS INT
    
   SELECT @RESULT = COUNT(*)
     FROM [com].[ImportFile] i 
	WHERE [i].[EtlSessionId] = @ETLSESSIONID
      AND [i].[Status] = 3

   SELECT CASE WHEN @RESULT = 0 THEN 1 ELSE 0 END  AS ImportSuccess

END