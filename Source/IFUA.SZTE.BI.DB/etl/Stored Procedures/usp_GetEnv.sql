
-- =============================================
-- Author:		tvandorffy
-- Create date: 2022.06.22
-- Description:	Visszaadja az ADF futtatási paramétereket
-- =============================================
CREATE PROCEDURE [etl].[usp_GetEnv]
WITH RECOMPILE
AS
BEGIN

	DECLARE @RESOURCEGROUPNAME [varchar](30)
	DECLARE @SUBSCRIPTIONID [varchar](50)
	DECLARE @MODULENAME [varchar](50)

    SET @RESOURCEGROUPNAME = (SELECT [Value] from [com].[Configuration] where [Key] = 'RESOURCEGROUPNAME')
    SET @SUBSCRIPTIONID = (SELECT [Value] from [com].[Configuration] where [Key] = 'SUBSCRIPTIONID')
    SET @MODULENAME = (SELECT [Value] from [com].[Configuration] where [Key] = 'MODULENAME')

	IF @@ROWCOUNT = 0 OR @SUBSCRIPTIONID IS NULL OR @RESOURCEGROUPNAME IS NULL OR @MODULENAME IS NULL
		THROW 50001, 'Enviroment parameters are invalid!', 1
	ELSE
		SELECT
	        @RESOURCEGROUPNAME AS [ResourceGroupName],
			@SUBSCRIPTIONID AS [SubscriptionID],
			@MODULENAME AS [ModuleName]

END
