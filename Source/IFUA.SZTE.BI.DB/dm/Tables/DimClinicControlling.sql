CREATE TABLE [dm].[DimClinicControlling] (
    [ClinicControllingKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClinicID]             CHAR (2)      NOT NULL,
    [ControllingKey]       NVARCHAR (20) NOT NULL,
    [ImportFileId]         BIGINT        NOT NULL,
    [ETLSessionID]         BIGINT        NOT NULL,
    CONSTRAINT [PK_DimClinicControlling] PRIMARY KEY CLUSTERED ([ClinicControllingKey] ASC)
);

