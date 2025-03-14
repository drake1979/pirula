CREATE TABLE [dm].[FactWholesaleRefund] (
    [PharmacyKey]          INT             NOT NULL,
    [SupplierKey]          INT             NOT NULL,
    [WholsesaleRefundDate] INT             NOT NULL,
    [NetRefund]            DECIMAL (18, 3) NULL,
    [RowHash]              BINARY (32)     NOT NULL,
    [ImportFileId]         BIGINT          NOT NULL,
    [ETLSessionID]         BIGINT          NOT NULL,
    CONSTRAINT [FK_dm_FactWholesaleRefund_SupplierKey] FOREIGN KEY ([SupplierKey]) REFERENCES [dm].[DimSupplier] ([SupplierKey])
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nagykereskedői utólagos engedmények', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactWholesaleRefund';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patika kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactWholesaleRefund', @level2type = N'COLUMN', @level2name = N'PharmacyKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Visszatérítés Dátuma', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactWholesaleRefund', @level2type = N'COLUMN', @level2name = N'WholsesaleRefundDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó visszatérítés értéke', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactWholesaleRefund', @level2type = N'COLUMN', @level2name = N'NetRefund';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nagykereskedő kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactWholesaleRefund', @level2type = N'COLUMN', @level2name = N'SupplierKey';


GO
CREATE NONCLUSTERED INDEX [IX_FactWholesaleRefund_WholsesaleRefundDate_PharmacyKey_SupplierKey]
    ON [dm].[FactWholesaleRefund]([WholsesaleRefundDate] ASC)
    INCLUDE([PharmacyKey], [SupplierKey]);


GO
CREATE NONCLUSTERED INDEX [IX_FactWholesaleRefund_RowHash]
    ON [dm].[FactWholesaleRefund]([RowHash] ASC);

