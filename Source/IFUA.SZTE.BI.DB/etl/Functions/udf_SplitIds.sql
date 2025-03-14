
-- =============================================
-- Author:		pabronits
-- Create date: 2022-07-13
-- Description:	Visszaadja az összefűzött id-kat 
-- egy táblában, ordinal oszlopban 1-től számozva a pozíciót
-- =============================================
CREATE FUNCTION [etl].[udf_SplitIds]
(
	@IDS NVARCHAR(MAX),
	@SEPARATOR NVARCHAR(1)
)
RETURNS TABLE
AS
RETURN
	
	SELECT 
		[value],
		[ordinal]
	FROM
		STRING_SPLIT(@IDS, @SEPARATOR, 1)
	WHERE
		LEN( ISNULL([value], '') ) > 0
