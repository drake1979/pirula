CREATE TABLE [com].[MappingSheet] (
    [MappingSheetId]    INT            IDENTITY (1, 1) NOT NULL,
    [MappingId]         INT            NOT NULL,
    [SourceSheetName]   NVARCHAR (200) NULL,
    [TableName]         VARCHAR (200)  NULL,
    [TableMapping]      NVARCHAR (MAX) NULL,
    [ExcelStartingCell] VARCHAR (10)   NULL,
    CONSTRAINT [PK_MappingSheets] PRIMARY KEY CLUSTERED ([MappingSheetId] ASC)
);

