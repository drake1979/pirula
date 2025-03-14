CREATE TABLE [dm].[DimProductMedivus] (
    [ProductMedivusKey]  INT             IDENTITY (1, 1) NOT NULL,
    [ProductMedivusID]   INT             NULL,
    [PharmacyKey]        INT             NOT NULL,
    [ProductMedivusName] NVARCHAR (256)  NULL,
    [ProductTTTID]       NVARCHAR (9)    NULL,
    [ProductPackaging]   NVARCHAR (256)  NULL,
    [NetConsumerPrice]   DECIMAL (18, 3) NULL,
    [NetWholesalePrice]  DECIMAL (18, 3) NULL,
    [MaxPurchaseDate]    DATE            NULL,
    [MinPurchaseDate]    DATE            NULL,
    [RowHash]            BINARY (32)     NULL,
    [ImportFileId]       BIGINT          NOT NULL,
    [ETLSessionID]       BIGINT          NOT NULL,
    CONSTRAINT [PK_dm.DimProductMedivus] PRIMARY KEY NONCLUSTERED ([ProductMedivusKey] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_DimProductMedivus_ProductMedivusID_PharmacyKey]
    ON [dm].[DimProductMedivus]([ProductMedivusID] ASC)
    INCLUDE([PharmacyKey]);

