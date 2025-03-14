CREATE TABLE [com].[Configuration] (
    [Key]   NVARCHAR (100)  NOT NULL,
    [Value] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED ([Key] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Configuration key-value pairs', @level0type = N'SCHEMA', @level0name = N'com', @level1type = N'TABLE', @level1name = N'Configuration';

