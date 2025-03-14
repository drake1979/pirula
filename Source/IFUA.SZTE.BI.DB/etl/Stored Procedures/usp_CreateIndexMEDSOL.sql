






-- =============================================
-- Author:		pabronits
-- Create date: 2023.01.16
-- Description:	Létrehozzuk a landing táblán az index-eket
-- =============================================
CREATE PROCEDURE [etl].[usp_CreateIndexMEDSOL]
	@ETLSESSIONID BIGINT
WITH RECOMPILE 
AS
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;  

	DECLARE @ELAPSED NVARCHAR(50)
	DECLARE @START_WATCH DATETIME2 = GETDATE()

	--IX_LandingMedsolEmsReceipt_ClinicID
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_ClinicID')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_ClinicID] ON [landing].[MedsolEmsReceipt]
		(
			[ClinicID] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END


	--IX_LandingMedsolEmsReceipt_DoctorID
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_DoctorID')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_DoctorID] ON [landing].[MedsolEmsReceipt]
		(
			[DoctorID] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END

	--IX_LandingMedsolEmsReceipt_PrescriptionDate
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_PrescriptionDate')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_PrescriptionDate] ON [landing].[MedsolEmsReceipt]
		(
			[PrescriptionDate] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END

	--IX_LandingMedsolEmsReceipt_ProductTTTID_ProductMedsolName_PrescriptionUnit
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME ='IX_LandingMedsolEmsReceipt_ProductTTTID_ProductMedsolName_PrescriptionUnit')
	BEGIN			
		CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_ProductTTTID_ProductMedsolName_PrescriptionUnit] ON [landing].[MedsolEmsReceipt]
		(
			[ProductTTTID] ASC
		)
		INCLUDE([ProductMedsolName],[PrescriptionUnit]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	END
	
	ALTER INDEX [IX_DimClinic_ClinicID] ON [dm].[DimClinic] REORGANIZE
	ALTER INDEX [IX_DimClinic_RowHash] ON [dm].[DimClinic] REORGANIZE
	ALTER INDEX [IX_DimDoctor_DoctorID] ON [dm].[DimDoctor] REORGANIZE
	ALTER INDEX [IX_DimProductMedsol_ProductTTTID_ProductMedsolName_PrescriptionUnit] ON [dm].[DimProductMedsol] REORGANIZE
	ALTER INDEX [IX_DimProductMedsol_RowHash] ON [dm].[DimProductMedsol] REORGANIZE
	ALTER INDEX [IX_FactClinicPrescriptions_PharmacyProductKey_PrescriptionID_EtlSessionId] ON [dm].[FactClinicPrescriptions] REORGANIZE
	ALTER INDEX [IX_FactClinicPrescriptions_RowHash] ON [dm].[FactClinicPrescriptions] REORGANIZE
	ALTER INDEX [IX_ComImportFile_FileName] ON [com].[ImportFile] REORGANIZE

	SET @ELAPSED = [etl].[udf_StopWatch] (@START_WATCH)

	EXEC [etl].[usp_LogEvent] 
		@ETLSESSIONID = @ETLSESSIONID,
		@LOGTYPE = 1,
		@COMPONENT = '[etl].[usp_CreateIndexMEDSOL]',
		@DESCRIPTION  = @ELAPSED