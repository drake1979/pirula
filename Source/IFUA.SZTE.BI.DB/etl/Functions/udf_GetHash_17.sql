








-- =============================================
-- Author:		pabronits
-- Create date: 2022.06.22
-- Description:	Visszaadja az üzleti adatok SHA2_256 HASH-t BINARY(32)-ben
-- =============================================
CREATE FUNCTION [etl].[udf_GetHash_17]
(
	@D01 NVARCHAR(max),
	@D02 NVARCHAR(max),
	@D03 NVARCHAR(max),
	@D04 NVARCHAR(max),
	@D05 NVARCHAR(max),
	@D06 NVARCHAR(max),
	@D07 NVARCHAR(max),
	@D08 NVARCHAR(max),
	@D09 NVARCHAR(max),
	@D10 NVARCHAR(max),
	@D11 NVARCHAR(max),
	@D12 NVARCHAR(max),
	@D13 NVARCHAR(max),
	@D14 NVARCHAR(max),
	@D15 NVARCHAR(max),
	@D16 NVARCHAR(max),
	@D17 NVARCHAR(max)
)
RETURNS BINARY(32)
AS
BEGIN
	
	RETURN [etl].[udf_GetHash_20] ( @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11,@D12, @D13, @D14, @D15, @D16, @D17, NULL, NULL, NULL)

END
