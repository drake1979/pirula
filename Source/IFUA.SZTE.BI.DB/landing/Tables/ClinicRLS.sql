CREATE TABLE [landing].[ClinicRLS] (
    [Landing_Name]     NVARCHAR (MAX) NULL,
    [Landing_Email]    NVARCHAR (MAX) NULL,
    [Landing_ClinicID] NVARCHAR (MAX) NULL,
    [RowId]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ImportFileId]     BIGINT         NULL,
    [ErrorLevel]       INT            NULL,
    [ErrorDescription] NVARCHAR (MAX) NULL
);

