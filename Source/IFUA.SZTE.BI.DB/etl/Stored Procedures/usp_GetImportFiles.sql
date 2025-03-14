

-- =============================================
-- Author:		pabronits
-- Create date: 2022.09.09
-- Description:	Visszaadja az eddig betöltött állomány listát CoospaceService-nek
-- =============================================
CREATE PROCEDURE [etl].[usp_GetImportFiles]
WITH RECOMPILE
AS
BEGIN

	SELECT 
		LOWER([FileName]) AS [FileName],
		MAX([FilePath]) AS [FilePath]
	FROM 
		[com].[ImportFile] 
	GROUP BY 
		[FileName]

END
