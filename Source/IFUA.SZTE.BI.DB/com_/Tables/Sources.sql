CREATE TABLE [com].[Sources] (
    [Source]         VARCHAR (50) NOT NULL,
    [ProcessingMode] VARCHAR (10) NOT NULL,
    [ProcessTypeId]  INT          NOT NULL,
    CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED ([Source] ASC),
    CONSTRAINT [UQ_ProcessTypeId] UNIQUE NONCLUSTERED ([ProcessTypeId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Environment Storage Account info', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'Sources';

