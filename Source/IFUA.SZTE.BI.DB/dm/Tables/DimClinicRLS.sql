CREATE TABLE [dm].[DimClinicRLS] (
    [ClinicRLSKey] INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (256) NOT NULL,
    [Email]        NVARCHAR (256) NOT NULL,
    [ClinicID]     CHAR (2)       NOT NULL
);

