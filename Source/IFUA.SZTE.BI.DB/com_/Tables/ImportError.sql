CREATE TABLE [com].[ImportError] (
    [ImportErrorId]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [ImportFileId]     BIGINT         NOT NULL,
    [RowNumber]        BIGINT         NOT NULL,
    [ErrorDescription] NVARCHAR (MAX) NOT NULL,
    [ErrorLevel]       INT            NULL,
    [EtlSessionId]     BIGINT         NULL,
    CONSTRAINT [FK_ImportError_ImportFile] FOREIGN KEY ([ImportFileId]) REFERENCES [com].[ImportFile] ([ImportFileId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unified import CSV errors.', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportError';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Row technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportError', @level2type = N'COLUMN', @level2name = N'ImportErrorId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'com.ImportFile row technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportError', @level2type = N'COLUMN', @level2name = N'ImportFileId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Row number in CSV file', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportError', @level2type = N'COLUMN', @level2name = N'RowNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Concatenated error description on row level', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportError', @level2type = N'COLUMN', @level2name = N'ErrorDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1: Non crytical; 2: Crytical error', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ImportError', @level2type = N'COLUMN', @level2name = N'ErrorLevel';

