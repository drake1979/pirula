CREATE TABLE [dm].[DimSupplier] (
    [SupplierKey]  INT            IDENTITY (1, 1) NOT NULL,
    [SupplierName] NVARCHAR (255) NOT NULL,
    [ImportFileId] BIGINT         NOT NULL,
    [ETLSessionID] BIGINT         NOT NULL,
    CONSTRAINT [PK_dm.DimSupplier] PRIMARY KEY NONCLUSTERED ([SupplierKey] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL betöltési ID', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimSupplier', @level2type = N'COLUMN', @level2name = N'ETLSessionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nagykereskedő megnevezése', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimSupplier', @level2type = N'COLUMN', @level2name = N'SupplierName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nagykereskedő kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimSupplier', @level2type = N'COLUMN', @level2name = N'SupplierKey';


GO
CREATE NONCLUSTERED INDEX [IX_DimSupplier_SupplierName]
    ON [dm].[DimSupplier]([SupplierName] ASC);

