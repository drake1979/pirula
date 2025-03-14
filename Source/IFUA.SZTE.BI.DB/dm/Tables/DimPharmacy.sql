CREATE TABLE [dm].[DimPharmacy] (
    [PharmacyKey]   INT            IDENTITY (1, 1) NOT NULL,
    [PharmacyID]    NVARCHAR (50)  NULL,
    [UltiSiteId]    NVARCHAR (50)  NULL,
    [PharmacyEosID] NVARCHAR (50)  NULL,
    [PharmacyName]  NVARCHAR (255) NULL,
    [ImportFileId]  BIGINT         NOT NULL,
    [ETLSessionID]  BIGINT         NOT NULL,
    CONSTRAINT [PK_dm.DimPharmacy] PRIMARY KEY NONCLUSTERED ([PharmacyKey] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patika', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mesterséges elsődleges kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacy', @level2type = N'COLUMN', @level2name = N'PharmacyKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patika üzleti azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacy', @level2type = N'COLUMN', @level2name = N'PharmacyID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai megnevezése', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacy', @level2type = N'COLUMN', @level2name = N'PharmacyName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL betöltési ID', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacy', @level2type = N'COLUMN', @level2name = N'ETLSessionID';

