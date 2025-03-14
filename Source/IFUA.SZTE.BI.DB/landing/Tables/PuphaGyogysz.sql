CREATE TABLE [landing].[PuphaGyogysz] (
    [Landing_ID]              NVARCHAR (MAX)  NULL,
    [Landing_OEP_NEV]         NVARCHAR (MAX)  NULL,
    [Landing_OEP_TTT]         NVARCHAR (MAX)  NULL,
    [Landing_OEP_KSZ]         NVARCHAR (MAX)  NULL,
    [Landing_OEP_FAN]         NVARCHAR (MAX)  NULL,
    [Landing_OEP_NKAR]        NVARCHAR (MAX)  NULL,
    [Landing_HATOANYAG]       NVARCHAR (MAX)  NULL,
    [Landing_GYFORMA]         NVARCHAR (MAX)  NULL,
    [RowId]                   INT             IDENTITY (1, 1) NOT NULL,
    [ProductTTTID]            NVARCHAR (9)    NULL,
    [ProductPackaging]        NVARCHAR (256)  NULL,
    [ProductOEPNEV]           NVARCHAR (256)  NULL,
    [NetConsumerPrice]        INT             NULL,
    [NetWholesalePrice]       DECIMAL (18, 3) NULL,
    [ProductActiveIngredient] VARCHAR (128)   NULL,
    [ProductForm]             VARCHAR (128)   NULL,
    [PUPHAPublicationDate]    DATE            NULL,
    [RowHash]                 BINARY (32)     NULL,
    [ImportFileId]            BIGINT          NULL,
    [ErrorLevel]              INT             NULL,
    [ErrorDescription]        NVARCHAR (MAX)  NULL
);






GO



GO


