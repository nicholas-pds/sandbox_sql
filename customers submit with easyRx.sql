-----preferances
									
select cpf.*, cu.PracticeName, CONCAT(cu.FirstName,' ', cu.LastName) as DoctorName, cu.Active, cu.Prospect  
from [dbo].[CustomerPreferences] as cpf									
LEFT JOIN [dbo].[Customers] as cu ON cu.CustomerID = cpf.CustomerID	
WHERE cu.active =1;	


SELECT DISTINCT 
    ca.CustomerID
FROM [dbo].[CaseAuditTrail] AS cat
INNER JOIN dbo.cases AS ca 
    ON ca.CaseID = cat.CaseID
WHERE cat.[Description] LIKE '%Sent by HUB%'  
    AND cat.CreateDate >= '2025-01-01';


    SELECT DISTINCT 
    ca.CustomerID,
    cu.PracticeName,
    CONCAT(cu.FirstName, ' ', cu.LastName) AS DoctorName
FROM [dbo].[cases] AS ca
INNER JOIN [dbo].[CaseAuditTrail] AS cat 
    ON ca.CaseID = cat.CaseID
INNER JOIN [dbo].[CustomerPreferences] AS cpf 
    ON ca.CustomerID = cpf.CustomerID
LEFT JOIN [dbo].[Customers] AS cu 
    ON ca.CustomerID = cu.CustomerID
WHERE 
    cat.[Description] LIKE '%Sent by HUB%' 
    AND cat.CreateDate >= '2025-01-01'
ORDER BY 
    ca.CustomerID;