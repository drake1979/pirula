CREATE TABLE [dm].[DimProductPupha] (
    [ProductPuphaKey]         INT             IDENTITY (1, 1) NOT NULL,
    [ProductTTTID]            NVARCHAR (9)    NULL,
    [ProductPackaging]        NVARCHAR (256)  NULL,
    [ProductOEPNEV]           NVARCHAR (256)  NULL,
    [PUPHAPublicationDate]    DATE            NULL,
    [NetConsumerPrice]        DECIMAL (18, 3) NULL,
    [NetWholesalePrice]       DECIMAL (18, 3) NULL,
    [ProductActiveIngredient] VARCHAR (128)   NULL,
    [ProductForm]             VARCHAR (128)   NULL,
    [RowHash]                 BINARY (32)     NULL,
    [ImportFileId]            BIGINT          NOT NULL,
    [ETLSessionID]            BIGINT          NOT NULL,
    CONSTRAINT [PK_dm.DimProductPupha] PRIMARY KEY NONCLUSTERED ([ProductPuphaKey] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_DimProductPupha_RowHash]
    ON [dm].[DimProductPupha]([RowHash] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DimProductPupha_ProductTTTID]
    ON [dm].[DimProductPupha]([ProductTTTID] ASC);

