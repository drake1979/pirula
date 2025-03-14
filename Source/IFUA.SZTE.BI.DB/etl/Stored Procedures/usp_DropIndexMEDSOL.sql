






-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Töröljük a landing tábláról az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_DropIndexMEDSOL]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_ClinicID')
	BEGIN
		DROP INDEX [IX_LandingMedsolEmsReceipt_ClinicID] ON [landing].[MedsolEmsReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_DoctorID')
	BEGIN
		DROP INDEX [IX_LandingMedsolEmsReceipt_DoctorID] ON [landing].[MedsolEmsReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_PrescriptionDate')
	BEGIN
		DROP INDEX [IX_LandingMedsolEmsReceipt_PrescriptionDate] ON [landing].[MedsolEmsReceipt]
	END

	IF EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_ProductTTTID_ProductMedsolName_PrescriptionUnit')
	BEGIN
		DROP INDEX [IX_LandingMedsolEmsReceipt_ProductTTTID_ProductMedsolName_PrescriptionUnit] ON [landing].[MedsolEmsReceipt]
	END

	

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_DropIndexMEDSOL]',
		@DESCRIPTION  = @ELAPSED