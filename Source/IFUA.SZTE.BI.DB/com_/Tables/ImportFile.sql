CREATE TABLE [com].[ImportFile] (
    [ImportFileId]   BIGINT          IDENTITY (1, 1) NOT NULL,
    [FilePath]       NVARCHAR (1000) NOT NULL,
    [FileName]       NVARCHAR (255)  NOT NULL,
    [ExtractDate]    DATE            NOT NULL,
    [Status]         INT             NOT NULL,
    [StartDate]      DATETIME        NOT NULL,
    [EndDate]        DATETIME        NULL,
    [EtlSessionId]   BIGINT          NOT NULL,
    [TechnicalLogId] BIGINT          NULL,
    CONSTRAINT [PK_ImportFile] PRIMARY KEY CLUSTERED ([ImportFileId] ASC),
    CONSTRAINT [FK_ImportFile_EtlSession] FOREIGN KEY ([EtlSessionId]) REFERENCES [com].[EtlSession] ([EtlSessionId])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Imported source CSV file', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Row technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'ImportFileId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Full path of imported file on Storage.', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'FilePath';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'File name', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'FileName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date part from file name', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'ExtractDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Import status; NONE=0, PROCESSING=1, SUCCESS=2, FAILED=3', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Start datetime of import', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'StartDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'End datetime of import', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'EndDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'com.EtlSession technical idetitifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportFile', @level2type = N'COLUMN', @level2name = N'EtlSessionId';


GO
CREATE NONCLUSTERED INDEX [IX_ComImportFile_FileName]
    ON [com].[ImportFile]([FileName] ASC);

