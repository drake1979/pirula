CREATE TABLE [hst].[DimProductMedsol] (
    [RowId]               INT            IDENTITY (1, 1) NOT NULL,
    [ProductMedsolKey]    INT            NOT NULL,
    [ProductTTTID]        NVARCHAR (9)   NULL,
    [ProductMedsolName]   NVARCHAR (256) NULL,
    [PrescriptionUnit]    NVARCHAR (256) NULL,
    [MaxPrescriptionDate] DATE           NULL,
    [MinPrescriptionDate] DATE           NULL,
    [RowHash]             BINARY (32)    NULL,
    [ImportFileId]        BIGINT         NOT NULL,
    [ETLSessionID]        BIGINT         NOT NULL,
    [ActionType]          INT            NOT NULL,
    [ActionEtlSessionId]  BIGINT         NOT NULL,
    [ActionFields]        NVARCHAR (MAX) NULL
);

