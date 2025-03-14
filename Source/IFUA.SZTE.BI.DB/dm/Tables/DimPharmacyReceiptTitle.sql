CREATE TABLE [dm].[DimPharmacyReceiptTitle] (
    [PharmacyReceiptTitleKey]       INT            IDENTITY (1, 1) NOT NULL,
    [PharmacyReceiptTitleMedivusID] INT            NOT NULL,
    [PharmacyReceiptTitleName]      NVARCHAR (256) NULL,
    [ImportFileId]                  BIGINT         NOT NULL,
    [ETLSessionID]                  BIGINT         NOT NULL,
    CONSTRAINT [PK_dm.DimPharmacyReceiptTitle] PRIMARY KEY NONCLUSTERED ([PharmacyReceiptTitleKey] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai kiváltás jogcíme', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyReceiptTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mesterséges elsődleges kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyReceiptTitle', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptTitleKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai kiváltás jogcím Medivus azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyReceiptTitle', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptTitleMedivusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai kiváltás jogcím megnevezése', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyReceiptTitle', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptTitleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL betöltési ID', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimPharmacyReceiptTitle', @level2type = N'COLUMN', @level2name = N'ETLSessionID';

