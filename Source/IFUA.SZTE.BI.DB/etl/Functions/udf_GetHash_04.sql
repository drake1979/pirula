﻿






-- =============================================
-- Author:		pabronits
-- Create date: 2022.06.22
-- Description:	Visszaadja az üzleti adatok SHA2_256 HASH-t BINARY(32)-ben
-- =============================================
CREATE FUNCTION [etl].[udf_GetHash_04]
(
	@D01 NVARCHAR(max),
	@D02 NVARCHAR(max),
	@D03 NVARCHAR(max),
	@D04 NVARCHAR(max)
)
RETURNS BINARY(32)
AS
BEGIN
	
	RETURN [etl].[udf_GetHash_20] ( @D01, @D02, @D03, @D04, NULL,NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)

END
