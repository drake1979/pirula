
-- =============================================
-- Author:		pabronits
-- Create date: 2022.06.22
-- Description:	Stopper stop
-- =============================================
CREATE FUNCTION [etl].[udf_StopWatch]
(
	@START_WATCH DATETIME2
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @ELAPSED NVARCHAR(50)

	DECLARE @STOPT_WATCH DATETIME2 = GETDATE()
	SET @ELAPSED = (SELECT 'ELAPSED: ' + CONVERT(NVARCHAR(10), DATEDIFF(millisecond, @START_WATCH, @STOPT_WATCH)) + ' ms')

	RETURN @ELAPSED

END
