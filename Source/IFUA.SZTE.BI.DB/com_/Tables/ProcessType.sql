CREATE TABLE [com].[ProcessType] (
    [ProcessTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [ProcessName]   NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_ProcessType] PRIMARY KEY CLUSTERED ([ProcessTypeId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL process types', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ProcessType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Row technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ProcessType', @level2type = N'COLUMN', @level2name = N'ProcessTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Process name: CaponeRO=1, Finastic=2', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'ProcessType', @level2type = N'COLUMN', @level2name = N'ProcessName';

