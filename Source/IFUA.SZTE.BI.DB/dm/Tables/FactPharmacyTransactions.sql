CREATE TABLE [dm].[FactPharmacyTransactions] (
    [RowId]                   INT             IDENTITY (1, 1) NOT NULL,
    [PharmacyKey]             INT             NOT NULL,
    [PharmacyMovementTypeKey] INT             NOT NULL,
    [PharmacyReceiptID]       INT             NOT NULL,
    [PharmacyReceiptItemID]   INT             NOT NULL,
    [PrescriptionID]          BIGINT          NULL,
    [PrescriptionType]        BIT             NULL,
    [PharmacyProductKey]      INT             NOT NULL,
    [PharmacyReceiptTitleKey] INT             NULL,
    [PurchaseDate]            INT             NOT NULL,
    [Quantity]                DECIMAL (18, 3) NULL,
    [NetPurchaseValue]        DECIMAL (18, 3) NULL,
    [NetPaidValue]            DECIMAL (18, 3) NULL,
    [NetSupportValue]         DECIMAL (18, 3) NULL,
    [NetSalesValue]           DECIMAL (18, 3) NULL,
    [NetMargin]               DECIMAL (18, 3) NULL,
    [NetMarginCorrection]     DECIMAL (18, 3) NULL,
    [RowHash]                 BINARY (32)     NULL,
    [ImportFileId]            BIGINT          NOT NULL,
    [ETLSessionID]            BIGINT          NOT NULL,
    CONSTRAINT [FK_dm_FactPharmacyTransactions_PharmacyKey] FOREIGN KEY ([PharmacyKey]) REFERENCES [dm].[DimPharmacy] ([PharmacyKey]),
    CONSTRAINT [FK_dm_FactPharmacyTransactions_PharmacyMovementTypeKey] FOREIGN KEY ([PharmacyMovementTypeKey]) REFERENCES [dm].[DimPharmacyMovementType] ([PharmacyMovementTypeKey]),
    CONSTRAINT [FK_dm_FactPharmacyTransactions_PharmacyProductKey] FOREIGN KEY ([PharmacyProductKey]) REFERENCES [dm].[DimProductMedivus] ([ProductMedivusKey]),
    CONSTRAINT [FK_dm_FactPharmacyTransactions_PharmacyReceiptTitleKey] FOREIGN KEY ([PharmacyReceiptTitleKey]) REFERENCES [dm].[DimPharmacyReceiptTitle] ([PharmacyReceiptTitleKey]),
    CONSTRAINT [FK_dm_FactPharmacyTransactions_PurchaseDate] FOREIGN KEY ([PurchaseDate]) REFERENCES [dm].[DimDate] ([DateKey])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai tranzakciókat tartalmazó tábla', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patika kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PharmacyKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai mozgásnem kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai bizonylat azonosítója', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai bizonylattétel azonosítója', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptItemID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Vény azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PrescriptionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai cikk kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PharmacyProductKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Patikai kiváltás jogcímének idegen kulcsa', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptTitleKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Kiváltás időpontja', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'PurchaseDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mennyiség', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'Quantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó beszerzési érték', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'NetPurchaseValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó (fogyasztó által) fizetett érték', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'NetPaidValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó támogatási érték (NEAK)', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'NetSupportValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó összérték', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'NetSalesValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó árrés értéke', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'NetMargin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nettó árrés korrekció', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactPharmacyTransactions', @level2type = N'COLUMN', @level2name = N'NetMarginCorrection';

