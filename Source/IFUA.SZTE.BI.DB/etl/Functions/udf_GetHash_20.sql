



-- =============================================
-- Author:		pabronits
-- Create date: 2022.06.22
-- Description:	Visszaadja az üzleti adatok SHA2_256 HASH-t BINARY(32)-ben
-- =============================================
CREATE FUNCTION [etl].[udf_GetHash_20]
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
	@D17 NVARCHAR(max),
	@D18 NVARCHAR(max),
	@D19 NVARCHAR(max),
	@D20 NVARCHAR(max)
)
RETURNS BINARY(32)
AS
BEGIN
	DECLARE @HASH BINARY(32)

	DECLARE @DATA NVARCHAR(max) SET @DATA = 
		'|' + 
		ISNULL( @D01, '' ) + '|' + 
		ISNULL( @D02, '' ) + '|' + 
		ISNULL( @D03, '' ) + '|' + 
		ISNULL( @D04, '' ) + '|' + 
		ISNULL( @D05, '' ) + '|' + 
		ISNULL( @D06, '' ) + '|' + 
		ISNULL( @D07, '' ) + '|' + 
		ISNULL( @D08, '' ) + '|' + 
		ISNULL( @D09, '' ) + '|' + 
		ISNULL( @D10, '' ) + '|' + 
		ISNULL( @D11, '' ) + '|' + 
		ISNULL( @D12, '' ) + '|' + 
		ISNULL( @D13, '' ) + '|' + 
		ISNULL( @D14, '' ) + '|' + 
		ISNULL( @D15, '' ) + '|' + 
		ISNULL( @D16, '' ) + '|' + 
		ISNULL( @D17, '' ) + '|' + 
		ISNULL( @D18, '' ) + '|' + 
		ISNULL( @D19, '' ) + '|' + 
		ISNULL( @D20, '' ) + 
		'|'

	SET @HASH = HASHBYTES('SHA2_256', @DATA)

	RETURN @HASH

END
