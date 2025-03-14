CREATE TABLE [landing].[MedsolEmsReceipt] (
    [Landing_eMS recept az.]        NVARCHAR (MAX)  NULL,
    [Landing_eRecept / eVény azon.] NVARCHAR (MAX)  NULL,
    [Landing_Klinika]               NVARCHAR (MAX)  NULL,
    [Landing_Klinika neve]          NVARCHAR (MAX)  NULL,
    [Landing_Oszt.]                 NVARCHAR (MAX)  NULL,
    [Landing_Osztály típus]         NVARCHAR (MAX)  NULL,
    [Landing_Felíró orvos]          NVARCHAR (MAX)  NULL,
    [Landing_Felírás dát.]          NVARCHAR (MAX)  NULL,
    [Landing_ATC kód]               NVARCHAR (MAX)  NULL,
    [Landing_TTT kód]               NVARCHAR (MAX)  NULL,
    [Landing_Támogatási kat]        NVARCHAR (MAX)  NULL,
    [Landing_Készítmény neve]       NVARCHAR (MAX)  NULL,
    [Landing_Menny.egys.]           NVARCHAR (MAX)  NULL,
    [Landing_Menny.]                NVARCHAR (MAX)  NULL,
    [Landing_BNO]                   NVARCHAR (MAX)  NULL,
    [RowId]                         BIGINT          IDENTITY (1, 1) NOT NULL,
    [ClinicID]                      CHAR (2)        NULL,
    [ClinicName]                    NVARCHAR (256)  NULL,
    [ClinicControllingID]           NVARCHAR (20)   NULL,
    [ClinicDepartmentID]            NVARCHAR (20)   NULL,
    [ClinicDepartmentName]          NVARCHAR (100)  NULL,
    [EMSPrescriptionID]             INT             NULL,
    [PrescriptionID]                VARCHAR (500)   NULL,
    [PharmacyProductKey]            INT             NULL,
    [PrescriptionDate]              DATE            NULL,
    [Quantity]                      DECIMAL (18, 3) NULL,
    [RowHash]                       BINARY (32)     NULL,
    [ImportFileId]                  BIGINT          NULL,
    [ErrorLevel]                    INT             NULL,
    [ErrorDescription]              NVARCHAR (MAX)  NULL,
    [ErrorLevelClinic]              INT             NULL,
    [RowHashClinic]                 BINARY (32)     NULL,
    [DoctorID]                      CHAR (5)        NULL,
    [ErrorLevelDoctor]              INT             NULL,
    [ErrorLevelClinicPrescriptions] INT             NULL,
    [RowHashClinicPrescriptions]    BINARY (32)     NULL,
    [ClinicKey]                     INT             NULL,
    [DoctorKey]                     INT             NULL,
    [PrescriptionDateKey]           INT             NULL,
    [RowHashProduct]                BINARY (32)     NULL,
    [ErrorLevelProduct]             INT             NULL,
    [ProductTTTID]                  NVARCHAR (9)    NULL,
    [ProductMedsolName]             NVARCHAR (256)  NULL,
    [PrescriptionUnit]              NVARCHAR (256)  NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinika', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedsolEmsReceipt', @level2type = N'COLUMN', @level2name = N'ClinicID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'eMS recept az.', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedsolEmsReceipt', @level2type = N'COLUMN', @level2name = N'EMSPrescriptionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'eRecept / eVény azon.', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedsolEmsReceipt', @level2type = N'COLUMN', @level2name = N'PrescriptionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TTT kód', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedsolEmsReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyProductKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Felírás dát.', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedsolEmsReceipt', @level2type = N'COLUMN', @level2name = N'PrescriptionDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Menny.', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedsolEmsReceipt', @level2type = N'COLUMN', @level2name = N'Quantity';


GO
CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_ProductTTTID_ProductMedsolName_PrescriptionUnit]
    ON [landing].[MedsolEmsReceipt]([ProductTTTID] ASC)
    INCLUDE([ProductMedsolName], [PrescriptionUnit]);


GO
CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_PrescriptionDate]
    ON [landing].[MedsolEmsReceipt]([PrescriptionDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_DoctorID]
    ON [landing].[MedsolEmsReceipt]([DoctorID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_LandingMedsolEmsReceipt_ClinicID]
    ON [landing].[MedsolEmsReceipt]([ClinicID] ASC);

