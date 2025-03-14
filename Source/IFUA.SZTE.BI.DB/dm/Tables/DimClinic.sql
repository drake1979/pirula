CREATE TABLE [dm].[DimClinic] (
    [ClinicKey]            INT            IDENTITY (1, 1) NOT NULL,
    [ClinicID]             CHAR (2)       NOT NULL,
    [ClinicName]           NVARCHAR (256) NULL,
    [ClinicControllingID]  NVARCHAR (20)  NULL,
    [ClinicDepartmentID]   NVARCHAR (20)  NULL,
    [ClinicDepartmentName] NVARCHAR (100) NULL,
    [RowHash]              BINARY (32)    NULL,
    [ImportFileId]         BIGINT         NOT NULL,
    [ETLSessionID]         BIGINT         NOT NULL,
    CONSTRAINT [PK_dm.DimClinic] PRIMARY KEY NONCLUSTERED ([ClinicKey] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinikák', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mesterséges elsődleges kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ClinicKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinika MedSol azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ClinicID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinika megnevezése', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ClinicName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinika kontrolling azonosítója', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ClinicControllingID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinikai osztály kódja', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ClinicDepartmentID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Klinikai osztály típusa', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ClinicDepartmentName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL betöltési ID', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimClinic', @level2type = N'COLUMN', @level2name = N'ETLSessionID';


GO
CREATE NONCLUSTERED INDEX [IX_DimClinic_RowHash]
    ON [dm].[DimClinic]([RowHash] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DimClinic_ClinicID]
    ON [dm].[DimClinic]([ClinicID] ASC);

