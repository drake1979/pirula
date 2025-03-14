CREATE TABLE [dm].[FactClinicPrescriptionsPriceLog] (
    [RowId]                         INT             IDENTITY (1, 1) NOT NULL,
    [FactClinicPrescriptionsRowId]  INT             NOT NULL,
    [SourceType]                    INT             NOT NULL,
    [FactPharmacyTransactionsRowId] INT             NULL,
    [ProductPuphaKey]               INT             NULL,
    [NetConsumerPrice]              DECIMAL (18, 3) NULL,
    [NetWholesalePrice]             DECIMAL (18, 3) NULL,
    [EtlSessionId]                  BIGINT          NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_FactClinicPrescriptionsPriceLog_Ids]
    ON [dm].[FactClinicPrescriptionsPriceLog]([EtlSessionId] ASC, [SourceType] ASC, [FactClinicPrescriptionsRowId] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Technikai sor azonosító', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'RowId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FactClinicPrescriptions RowId mező értéke', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'FactClinicPrescriptionsRowId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Az árkalkuláció típusa; 1= evény kiváltva; 2= nem evény vagy nem váltotta ki; 3= Pupha; 4 evény kiváltva TELJES összeg; 5= nem evény vagy nem váltotta TELJES ÖSSZEG', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'SourceType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Forrásrekord technikai azonosítója 1. és 2 soucetype esetén', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'FactPharmacyTransactionsRowId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Forrásrekord technikai azonosítója 3. soucetype esetén', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'ProductPuphaKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ár', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'NetConsumerPrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ár', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'NetWholesalePrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Betöltés technikai azonosítója', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'FactClinicPrescriptionsPriceLog', @level2type = N'COLUMN', @level2name = N'EtlSessionId';

