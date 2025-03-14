CREATE TABLE [landing].[MedivusPharmacyReceipt] (
    [Landing_DATUMIDO]                      NVARCHAR (MAX)  NULL,
    [Landing_MOZGASNEMID]                   NVARCHAR (MAX)  NULL,
    [Landing_MOZGASNEMNEV]                  NVARCHAR (MAX)  NULL,
    [Landing_BIZONYLATID]                   NVARCHAR (MAX)  NULL,
    [Landing_SZTORNO]                       NVARCHAR (MAX)  NULL,
    [Landing_BIZONYLATOTSTORNOZOID]         NVARCHAR (MAX)  NULL,
    [Landing_BIZONYLATTETELID]              NVARCHAR (MAX)  NULL,
    [Landing_EREDETIBIZONYLATTETELID]       NVARCHAR (MAX)  NULL,
    [Landing_CIKKID]                        NVARCHAR (MAX)  NULL,
    [Landing_CIKKNEV]                       NVARCHAR (MAX)  NULL,
    [Landing_CIKKISZERELES]                 NVARCHAR (MAX)  NULL,
    [Landing_CTTTKOD]                       NVARCHAR (MAX)  NULL,
    [Landing_KESZLETSZORZO]                 NVARCHAR (MAX)  NULL,
    [Landing_MENNYISEG]                     NVARCHAR (MAX)  NULL,
    [Landing_JOGCIMID]                      NVARCHAR (MAX)  NULL,
    [Landing_JOGCIMNEV]                     NVARCHAR (MAX)  NULL,
    [Landing_NEAKVENYSZAM]                  NVARCHAR (MAX)  NULL,
    [Landing_ERECEPTID]                     NVARCHAR (MAX)  NULL,
    [Landing_NETTOBESZERTEK]                NVARCHAR (MAX)  NULL,
    [Landing_NETTOFIZERTEK]                 NVARCHAR (MAX)  NULL,
    [Landing_NETTOTAMERTEK]                 NVARCHAR (MAX)  NULL,
    [Landing_NETTOOSSZERTEK]                NVARCHAR (MAX)  NULL,
    [Landing_ARRESERTEK]                    NVARCHAR (MAX)  NULL,
    [Landing_ARRESKORREKCIO]                NVARCHAR (MAX)  NULL,
    [RowId]                                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [PharmacyID]                            NVARCHAR (50)   NULL,
    [PharmacyMovementTypeMedivusID]         INT             NULL,
    [PharmacyMovementTypeName]              NVARCHAR (255)  NULL,
    [PharmacyMovementTypeStorageMultiplier] SMALLINT        NULL,
    [ProductMedivusID]                      INT             NULL,
    [ProductMedivusName]                    NVARCHAR (256)  NULL,
    [ProductTTTID]                          NVARCHAR (9)    NULL,
    [ProductPackaging]                      NVARCHAR (20)   NULL,
    [PharmacyReceiptTitleMedivusID]         INT             NULL,
    [PharmacyReceiptTitleName]              NVARCHAR (256)  NULL,
    [PurchaseDate]                          DATE            NULL,
    [PharmacyReceiptID]                     INT             NULL,
    [PharmacyReceiptItemID]                 INT             NULL,
    [PrescriptionID]                        BIGINT          NULL,
    [PrescriptionType]                      BIT             NULL,
    [Quantity]                              DECIMAL (18, 3) NULL,
    [NetPurchaseValue]                      DECIMAL (18, 3) NULL,
    [NetPaidValue]                          DECIMAL (18, 3) NULL,
    [NetSupportValue]                       DECIMAL (18, 3) NULL,
    [NetSalesValue]                         DECIMAL (18, 3) NULL,
    [NetMargin]                             DECIMAL (18, 3) NULL,
    [NetMarginCorrection]                   DECIMAL (18, 3) NULL,
    [NetConsumerPrice]                      DECIMAL (18, 3) NULL,
    [NetWholesalePrice]                     DECIMAL (18, 3) NULL,
    [Storno]                                BIT             NULL,
    [PharmacyKey]                           INT             NULL,
    [PharmacyMovementTypeKey]               INT             NULL,
    [PharmacyReceiptTitleKey]               INT             NULL,
    [ProductKey]                            INT             NULL,
    [RowHash]                               BINARY (32)     NULL,
    [RowHashProduct]                        BINARY (32)     NULL,
    [RowHashPharmacyTransactions]           BINARY (32)     NULL,
    [ImportFileId]                          BIGINT          NULL,
    [ErrorLevel]                            INT             NULL,
    [ErrorLevelPharmacyReceiptTitle]        INT             NULL,
    [ErrorLevelPharmacyMovementType]        INT             NULL,
    [ErrorLevelProduct]                     INT             NULL,
    [ErrorLevelPharmacyTransactions]        INT             NULL,
    [ErrorDescription]                      NVARCHAR (MAX)  NULL
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'XLS állomány név 1. kerekete', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MOZGASNEMID', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeMedivusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MOZGASNEMNEV', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'KESZLETSZORZO', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyMovementTypeStorageMultiplier';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CIKKID', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'ProductMedivusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CIKKNEV', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'ProductMedivusName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CTTTKOD', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'ProductTTTID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CIKKISZERELES', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'ProductPackaging';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'JOGCIMID', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptTitleMedivusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'JOGCIMNEV', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptTitleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dátum', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PurchaseDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BIZONYLATID', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BIZONYLATTETELID', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PharmacyReceiptItemID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Vény azonosító', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'PrescriptionID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MENNYISEG', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'Quantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NETTOBESZERTEK', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'NetPurchaseValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NETTOFIZERTEK', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'NetPaidValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NETTOTAMERTEK', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'NetSupportValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NETTOOSSZERTEK', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'NetSalesValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ARRESERTEK', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'NetMargin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ARRESKORREKCIO', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'NetMarginCorrection';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Itt jelöljük, hogy a dm.DimPharmacyReceiptTitle mezők hibássak-e?', @level0type = N'SCHEMA', @level0name = N'landing', @level1type = N'TABLE', @level1name = N'MedivusPharmacyReceipt', @level2type = N'COLUMN', @level2name = N'ErrorLevelPharmacyReceiptTitle';


GO



GO



GO



GO



GO


