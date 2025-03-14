






-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Töröljük a landing tábláról az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_DropIndexMEDIVUS]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_PharmacyID')
	BEGIN
		DROP INDEX [IX_LandingMedivusPharmacyReceipt_PharmacyID] ON [landing].[MedivusPharmacyReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey')
	BEGIN
		DROP INDEX [IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey] ON [landing].[MedivusPharmacyReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey_ProductTTTID_ProductPackaging')
	BEGIN
		DROP INDEX [IX_LandingMedivusPharmacyReceipt_ProductMedivusID_PharmacyKey_ProductTTTID_ProductPackaging] ON [landing].[MedivusPharmacyReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_PurchaseDate')
	BEGIN
		DROP INDEX [IX_LandingMedivusPharmacyReceipt_PurchaseDate] ON [landing].[MedivusPharmacyReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedivusPharmacyReceipt_RowHashPharmacyTransactions')
	BEGIN
		DROP INDEX [IX_LandingMedivusPharmacyReceipt_RowHashPharmacyTransactions] ON [landing].[MedivusPharmacyReceipt]
	END

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_DropIndexMEDIVUS]',
		@DESCRIPTION  = @ELAPSED