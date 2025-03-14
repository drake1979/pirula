CREATE TABLE [com].[EtlSession] (
    [EtlSessionId]  BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProcessTypeId] INT            NOT NULL,
    [Status]        INT            NOT NULL,
    [StartSession]  DATETIME       NOT NULL,
    [EndSession]    DATETIME       NULL,
    [AdfSessionId]  NVARCHAR (256) NULL,
    [CreatedBy]     NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_EtlSession] PRIMARY KEY CLUSTERED ([EtlSessionId] ASC),
    CONSTRAINT [FK_EtlSession_Sources] FOREIGN KEY ([ProcessTypeId]) REFERENCES [com].[Sources] ([ProcessTypeId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL workflow executions.', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Row technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'EtlSessionId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1: CaponeRO; 2: Finastic', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'ProcessTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NONE=0; START=1; SUCCESS = 2; FAILED=3;', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL session started', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'StartSession';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ETL session end', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'EndSession';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ADF workflow session technical identifier', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'AdfSessionId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Executer user name', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'EtlSession', @level2type = N'COLUMN', @level2name = N'CreatedBy';

