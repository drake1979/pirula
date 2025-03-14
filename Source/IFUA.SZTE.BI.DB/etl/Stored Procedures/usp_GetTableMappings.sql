

-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	Visszadja a táblához tartozó mapping információkat JSON formátumban
-- =============================================
CREATE PROCEDURE [etl].[usp_GetTableMappings]
    @SOURCENAME VARCHAR(MAX),
	@FILENAME VARCHAR(MAX)
WITH RECOMPILE 
AS
BEGIN
	SET NOCOUNT ON; 
	--SET XACT_ABORT ON;  
    
	DECLARE @SOURCEFILENAME VARCHAR(MAX)
	DECLARE @ERRORMESSAGE VARCHAR(200)

	SET @SOURCEFILENAME =
	CASE 
	WHEN @SOURCENAME = 'EXCEL' THEN 
	      (SELECT REPLACE([value], '.xlsx', '') FROM STRING_SPLIT(@FILENAME, '_', 1) WHERE ordinal = 3)
	      /*
	      (SELECT [value] FROM STRING_SPLIT(@FILENAME, '_', 1) WHERE ordinal = 1) + '_' +
 		  (SELECT [value] FROM STRING_SPLIT(@FILENAME, '_', 1) WHERE ordinal = 2)
		  */
	WHEN @SOURCENAME = 'MEDIVUS' THEN
	     (SELECT [value] FROM STRING_SPLIT(@FILENAME, '-', 1) WHERE ordinal = 1)
	WHEN @SOURCENAME = 'MEDSOL' THEN
	      REPLACE(
	      (SELECT [value] FROM STRING_SPLIT(@FILENAME, '-', 1) WHERE ordinal = 3) + '-' +
		  (SELECT [value] FROM STRING_SPLIT(@FILENAME, '-', 1) WHERE ordinal = 4) +
		  (CASE WHEN RIGHT((SELECT [value] FROM STRING_SPLIT(@FILENAME, '-', 1) WHERE ordinal = 4), 7) <> '_p.xlsx' 
		        THEN '_p' ELSE '' END), 
		  '.xlsx', '')
	WHEN @SOURCENAME = 'PUPHA' THEN
	     (SELECT [value] FROM STRING_SPLIT(@FILENAME, '_', 1) WHERE ordinal = 1)
	WHEN @SOURCENAME = 'RLS' THEN
	     LEFT(@FILENAME, 20)
	     /*(SELECT [value] FROM STRING_SPLIT(@FILENAME, '.', 1) WHERE ordinal = 1) */
	END 

	IF @SOURCEFILENAME IS NULL
		     THROW 50000, 'Unable to match SourceFileName (fix part of input filename)' ,1

	IF NOT EXISTS(SELECT 1 
	                FROM com.Mapping m WHERE m.SourceName = @SOURCENAME 
	                 AND m.SourceFileName = @SOURCEFILENAME) 
	BEGIN
       SET @ERRORMESSAGE = 'No mapping for file: ' + @FILENAME;
	   THROW 50000, @ERRORMESSAGE, 1
	END

    SELECT ms.SourceSheetName AS SheetName, 
	       ms.TableName,
		   ms.TableMapping,
		   ms.ExcelStartingCell
	  FROM com.Mapping m 
 LEFT JOIN com.MappingSheet ms on ms.MappingId = m.MappingId
	 WHERE m.SourceName = TRIM(@SOURCENAME) 
	   AND m.SourceFileName = TRIM(@SOURCEFILENAME) 
END
