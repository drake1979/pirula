CREATE TABLE [com].[TechnicalLog] (
    [TechnicalLogId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [LogType]        INT             NOT NULL,
    [TimeStamp]      DATETIME        NOT NULL,
    [Component]      NVARCHAR (1000) NULL,
    [Description]    NVARCHAR (MAX)  NULL,
    [EtlSessionId]   BIGINT          NULL,
    CONSTRAINT [FK_TechnicalLog_EtlSession] FOREIGN KEY ([EtlSessionId]) REFERENCES [com].[EtlSession] ([EtlSessionId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Technical event logs.', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Row technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog', @level2type = N'COLUMN', @level2name = N'TechnicalLogId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Debug: 0; Information: 1; Warning: 2; Error: 3', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog', @level2type = N'COLUMN', @level2name = N'LogType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Event occured', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog', @level2type = N'COLUMN', @level2name = N'TimeStamp';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DB + SP + Part name', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog', @level2type = N'COLUMN', @level2name = N'Component';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Event description', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'com.EtlSession technical idetitifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'TechnicalLog', @level2type = N'COLUMN', @level2name = N'EtlSessionId';

