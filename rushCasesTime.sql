SELECT CaseNumber, CreateDate 
FROM dbo.cases 
WHERE (PanNumber LIKE 'R%' OR PanNumber LIKE 'r%') 
  AND LEN(PanNumber) < 4
  AND CreateDate >= '2025-12-23 00:00:00'