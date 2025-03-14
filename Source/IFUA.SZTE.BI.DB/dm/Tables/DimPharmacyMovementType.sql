CREATE TABLE [dm].[DimPharmacyMovementType] (
    [PharmacyMovementTypeKey]               INT            IDENTITY (1, 1) NOT NULL,
    [PharmacyMovementTypeMedivusID]         INT            NOT NULL,
    [PharmacyMovementTypeName]              NVARCHAR (255) NULL,
    [PharmacyMovementTypeStorageMultiplier] SMALLINT       NULL,
    [ImportFileId]                          BIGINT         NOT NULL,
    [ETLSessionID]                          BIGINT         NOT NULL,
    CONSTRAINT [PK_dm.DimPharmacyMovementType] PRIMARY KEY NONCLUSTERED ([PharmacyMovementTypeKey] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai mozgásnem', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyMovementType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mesterséges elsődleges kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyMovementType', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai mozgásnem Medivus azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyMovementType', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeMedivusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mozgásnem megnevezés', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyMovementType', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Készletszorzó', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyMovementType', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeStorageMultiplier';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL betöltési ID', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyMovementType', @level2type = N'COLUMN', @level2name = N'ETLSessionID';

