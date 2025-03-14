


-- =============================================
-- Author:		pabronits
-- Create date: 2022.10.28
-- Description:	Visszaadja a patikákat
-- =============================================
CREATE PROCEDURE [etl].[usp_GetDimPharmacies]
WITH RECOMPILE
AS
BEGIN

	SELECT 
		[PharmacyKey],
		[PharmacyID],
		[UltiSiteId],
		[PharmacyName]
	FROM 
		[dm].[DimPharmacy]
	ORDER BY 
		[UltiSiteId]

END
