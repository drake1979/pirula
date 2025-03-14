CREATE TABLE [landing].[NaviRLS] (
    [Landing_Name]     NVARCHAR (MAX) NULL,
    [Landing_Email]    NVARCHAR (MAX) NULL,
    [Landing_Page]     NVARCHAR (MAX) NULL,
    [RowId]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ImportFileId]     BIGINT         NULL,
    [ErrorLevel]       INT            NULL,
    [ErrorDescription] NVARCHAR (MAX) NULL
);

