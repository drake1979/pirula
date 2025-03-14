CREATE TABLE [dm].[DimDate] (
    [DateKey]           INT           IDENTITY (1, 1) NOT NULL,
    [Date]              DATE          NULL,
    [AbsoluteDay]       CHAR (10)     NOT NULL,
    [DayStart]          DATETIME      NOT NULL,
    [DayEnd]            DATETIME      NOT NULL,
    [DayOfWeek]         TINYINT       NOT NULL,
    [DayNameHU]         NVARCHAR (50) NOT NULL,
    [DayNameEN]         NVARCHAR (50) NOT NULL,
    [DayShortNameHU]    NVARCHAR (50) NOT NULL,
    [DayShortNameEN]    NVARCHAR (50) NOT NULL,
    [DayOfYear]         SMALLINT      NOT NULL,
    [Quarter]           TINYINT       NOT NULL,
    [ISOWeek]           TINYINT       NOT NULL,
    [YearMonth]         CHAR (7)      NOT NULL,
    [MonthNameHU]       NVARCHAR (50) NOT NULL,
    [MonthNameEN]       NVARCHAR (50) NOT NULL,
    [MonthShortNameHU]  NVARCHAR (50) NOT NULL,
    [MonthShortNameEN]  NVARCHAR (50) NOT NULL,
    [YearWeek]          CHAR (7)      NOT NULL,
    [YearHierarchy]     CHAR (4)      NOT NULL,
    [MonthHierarchy]    CHAR (2)      NOT NULL,
    [DayHierarchy]      CHAR (2)      NOT NULL,
    [Season]            CHAR (2)      NOT NULL,
    [Workdays]          CHAR (1)      NOT NULL,
    [WorkdayOfMonth]    TINYINT       NULL,
    [FiscalYear]        CHAR (7)      NULL,
    [FiscalYearWeekKey] INT           NULL,
    CONSTRAINT [PK_dm.DimDate] PRIMARY KEY NONCLUSTERED ([DateKey] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dátum dimenzió', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mesterséges elsődleges kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DateKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Abszolút nap', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'AbsoluteDay';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap kezdete', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayStart';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap vége', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayEnd';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hét napja', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayOfWeek';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap neve - magyar', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayNameHU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap neve - angol', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayNameEN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap rövid neve - magyar', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayShortNameHU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap rövid neve - angol', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayShortNameEN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Év napja', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayOfYear';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Negyedév', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'Quarter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ISO hét', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'ISOWeek';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Év hónapja', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'YearMonth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hónap név - magyar', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'MonthNameHU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hónap név - angol', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'MonthNameEN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hónap rövid név - magyar', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'MonthShortNameHU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hónap rövid név - angol', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'MonthShortNameEN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Év hete', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'YearWeek';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Év hierarchia', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'YearHierarchy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Hónap hierarchia', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'MonthHierarchy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nap hierarchia', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'DayHierarchy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Évszak', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'Season';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Munkanap jelőlő', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'Workdays';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Munkanap sorszáma a hónapban', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'WorkdayOfMonth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Pénzügyi év', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'FiscalYear';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Pénzügyi év hete kulcs', @level0type = N'SCHEMA', @level0name = N'dm', @level1type = N'TABLE', @level1name = N'DimDate', @level2type = N'COLUMN', @level2name = N'FiscalYearWeekKey';


GO
CREATE NONCLUSTERED INDEX [IX_DimDate_Date]
    ON [dm].[DimDate]([Date] ASC);

