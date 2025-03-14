CREATE TABLE [landing].[ExcelWholesaleRefund] (
    [Landing_Datum]     NVARCHAR (MAX)  NULL,
    [Landing_Patika]    NVARCHAR (MAX)  NULL,
    [Landing_Szallito]  NVARCHAR (MAX)  NULL,
    [Landing_Engedmeny] NVARCHAR (MAX)  NULL,
    [RowId]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [Datum]             INT             NULL,
    [Patika]            NVARCHAR (255)  NULL,
    [SupplierName]      NVARCHAR (255)  NULL,
    [Engedmeny]         DECIMAL (18, 3) NULL,
    [PharmacyKey]       INT             NULL,
    [SupplierKey]       INT             NULL,
    [RowHash]           BINARY (32)     NULL,
    [ImportFileId]      BIGINT          NULL,
    [ErrorLevel]        INT             NULL,
    [ErrorDescription]  NVARCHAR (MAX)  NULL
);








GO



GO


