





CREATE VIEW [dm].[ImportFile] AS

SELECT i.[ImportFileId]
      ,i.[FilePath]
      ,i.[FileName]
      ,i.[ExtractDate]
      ,i.[Status]
      ,i.[StartDate]
      ,i.[EndDate]
      ,i.[EtlSessionId]
	  ,t.[Component] AS [Component]
      ,t.[Description] AS [ErrorMessage]
  FROM [com].[ImportFile] i
  LEFT JOIN [com].[TechnicalLog] t on i.TechnicalLogId = t.TechnicalLogId 
