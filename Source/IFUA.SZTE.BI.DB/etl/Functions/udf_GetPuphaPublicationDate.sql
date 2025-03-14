

-- =============================================
-- Author:		pabronits
-- Create date: 2022-07-13
-- Description:	Visszaadja a dátumot a fájl nevéből
-- =============================================
CREATE FUNCTION [etl].[udf_GetPuphaPublicationDate]
(
	@FILENAME NVARCHAR(255)
)
RETURNS DATE
AS
BEGIN
	DECLARE @PUBLICATIONDATE DATE

	SET @PUBLICATIONDATE = 
	(
		SELECT 
			TRY_CAST([value] AS DATE) 
		FROM 
			[etl].[udf_SplitIds] (@FILENAME, '_'  ) 
		WHERE 
			[ordinal] = 2
	)
	
	RETURN @PUBLICATIONDATE

END
