CREATE TABLE [dm].[DimDoctor] (
    [DoctorKey]    INT      IDENTITY (1, 1) NOT NULL,
    [DoctorID]     CHAR (5) NOT NULL,
    [ImportFileId] BIGINT   NOT NULL,
    [ETLSessionID] BIGINT   NOT NULL,
    CONSTRAINT [PK_dm.DimDoctor] PRIMARY KEY NONCLUSTERED ([DoctorKey] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Orvos', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDoctor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mesterséges elsődleges kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDoctor', @level2type = N'COLUMN', @level2name = N'DoctorKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Orvosi pecsétszám', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDoctor', @level2type = N'COLUMN', @level2name = N'DoctorID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL betöltési ID', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDoctor', @level2type = N'COLUMN', @level2name = N'ETLSessionID';


GO
CREATE NONCLUSTERED INDEX [IX_DimDoctor_DoctorID]
    ON [dm].[DimDoctor]([DoctorID] ASC);

