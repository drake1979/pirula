CREATE TABLE [hst].[DimProductPupha] (
    [RowId]                   INT             IDENTITY (1, 1) NOT NULL,
    [ProductPuphaKey]         INT             NOT NULL,
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
    [ActionType]              INT             NOT NULL,
    [ActionEtlSessionId]      BIGINT          NOT NULL,
    [ActionFields]            NVARCHAR (MAX)  NULL
);

