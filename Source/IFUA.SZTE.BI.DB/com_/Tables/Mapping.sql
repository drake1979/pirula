CREATE TABLE [com].[Mapping] (
    [MappingId]      INT            IDENTITY (1, 1) NOT NULL,
    [SourceName]     NVARCHAR (200) NULL,
    [SourceFileName] NVARCHAR (200) NULL,
    CONSTRAINT [PK_Mapping] PRIMARY KEY CLUSTERED ([MappingId] ASC)
);

