





-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Töröljük a landing tábláról az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_DropIndexEXCEL]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingExcelWholesaleRefund_Datum_PharmacyKey_SupplierKey')
	BEGIN
		DROP INDEX [IX_LandingExcelWholesaleRefund_Datum_PharmacyKey_SupplierKey] ON [landing].[ExcelWholesaleRefund]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingExcelWholesaleRefund_RowHash')
	BEGIN
		DROP INDEX [IX_LandingExcelWholesaleRefund_RowHash] ON [landing].[ExcelWholesaleRefund]
	END

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_DropIndexEXCEL]',
		@DESCRIPTION  = @ELAPSED