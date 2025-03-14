
-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	Visszaadja az ADF futtatási paramétereket
-- =============================================
CREATE PROCEDURE [etl].[usp_GetSourceProcessingMode]
   @SOURCENAME NVARCHAR(200)
WITH RECOMPILE
AS 
BEGIN
   DECLARE @PROCESSINGMODE AS VARCHAR(10)
   DECLARE @ERRORMESSAGE AS NVARCHAR(400)

   SET @PROCESSINGMODE = (SELECT ProcessingMode FROM com.Sources WHERE Source = @SOURCENAME)
   IF @PROCESSINGMODE NOT IN ('sequential', 'parallel')
   BEGIN
      SET @ERRORMESSAGE = 	  
	     'Processingmode (Parallel or Sequential) is not found for source ' + @SOURCENAME + '!';
      THROW 50001, @ERRORMESSAGE, 1
  END

  SELECT @PROCESSINGMODE AS SourceProcessingMode

END
