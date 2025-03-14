CREATE TABLE [hst].[DimProductMedivus] (
    [RowId]              INT             IDENTITY (1, 1) NOT NULL,
    [ProductMedivusKey]  INT             NOT NULL,
    [ProductMedivusID]   INT             NULL,
    [PharmacyKey]        INT             NULL,
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
    [ActionType]         INT             NOT NULL,
    [ActionEtlSessionId] BIGINT          NOT NULL,
    [ActionFields]       NVARCHAR (MAX)  NULL
);



