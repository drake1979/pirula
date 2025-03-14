CREATE TABLE [dm].[FactClinicPrescriptions] (
    [RowId]              INT             IDENTITY (1, 1) NOT NULL,
    [ClinicKey]          INT             NOT NULL,
    [DoctorKey]          INT             NOT NULL,
    [EMSPrescriptionID]  INT             NULL,
    [PrescriptionID]     BIGINT          NULL,
    [PharmacyProductKey] INT             NOT NULL,
    [PrescriptionDate]   INT             NOT NULL,
    [Quantity]           DECIMAL (18, 3) NULL,
    [NetPurchaseValue]   DECIMAL (18, 3) NULL,
    [NetSalesValue]      DECIMAL (18, 3) NULL,
    [RowHash]            BINARY (32)     NOT NULL,
    [ImportFileId]       BIGINT          NOT NULL,
    [ETLSessionID]       BIGINT          NOT NULL,
    CONSTRAINT [FK_dm_FactClinicPrescriptions_ClinicKey] FOREIGN KEY ([ClinicKey]) REFERENCES [dm].[DimClinic] ([ClinicKey]),
    CONSTRAINT [FK_dm_FactClinicPrescriptions_DoctorKey] FOREIGN KEY ([DoctorKey]) REFERENCES [dm].[DimDoctor] ([DoctorKey]),
    CONSTRAINT [FK_dm_FactClinicPrescriptions_PharmacyProductKey] FOREIGN KEY ([PharmacyProductKey]) REFERENCES [dm].[DimProductMedsol] ([ProductMedsolKey]),
    CONSTRAINT [FK_dm_FactClinicPrescriptions_PrescriptionDate] FOREIGN KEY ([PrescriptionDate]) REFERENCES [dm].[DimDate] ([DateKey])
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinikai felírások', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patika kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'ClinicKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai mozgásnem kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'DoctorKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'EMS vény azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'EMSPrescriptionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'eRecept / eVény azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'PrescriptionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai cikk kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'PharmacyProductKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Felírás időpontja', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'PrescriptionDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mennyiség', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptions', @level2type = N'COLUMN', @level2name = N'Quantity';


GO
CREATE NONCLUSTERED INDEX [IX_FactClinicPrescriptions_RowHash]
    ON [dm].[FactClinicPrescriptions]([RowHash] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_FactClinicPrescriptions_PharmacyProductKey_PrescriptionID_EtlSessionId]
    ON [dm].[FactClinicPrescriptions]([PharmacyProductKey] ASC)
    INCLUDE([PrescriptionID], [ETLSessionID]);

