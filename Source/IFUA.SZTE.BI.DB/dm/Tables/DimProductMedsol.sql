CREATE TABLE [dm].[DimProductMedsol] (
    [ProductMedsolKey]    INT            IDENTITY (1, 1) NOT NULL,
    [ProductTTTID]        NVARCHAR (9)   NULL,
    [ProductMedsolName]   NVARCHAR (256) NULL,
    [PrescriptionUnit]    NVARCHAR (256) NULL,
    [MaxPrescriptionDate] DATE           NULL,
    [MinPrescriptionDate] DATE           NULL,
    [RowHash]             BINARY (32)    NULL,
    [ImportFileId]        BIGINT         NOT NULL,
    [ETLSessionID]        BIGINT         NOT NULL,
    CONSTRAINT [PK_dm.DimProductMedsol] PRIMARY KEY NONCLUSTERED ([ProductMedsolKey] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_DimProductMedsol_RowHash]
    ON [dm].[DimProductMedsol]([RowHash] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DimProductMedsol_ProductTTTID_ProductMedsolName_PrescriptionUnit]
    ON [dm].[DimProductMedsol]([ProductTTTID] ASC)
    INCLUDE([ProductMedsolName], [PrescriptionUnit]);

