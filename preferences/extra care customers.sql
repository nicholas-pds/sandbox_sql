SELECT  
    CustomerID, 
    CreateDate,
    CreatedBy, 
    AlertNotes,
    Case WHEN Expired = 1 THEN 'Yes' Else 'No' END AS IsExpired,
    Case WHEN AllowToExpire = 1 THEN 'Yes' Else 'No' END AS AllowToExpire
FROM 
    dbo.CaseAlerts 
WHERE 
    AlertNotes LIKE '%Care%'
    OR AlertNotes LIKE '%VIP%'
ORDER BY 
    CreateDate DESC;

-- search customer preferences. for care card
select cpf.*,
cu.PracticeName,
CONCAT(cu.FirstName,' ', cu.LastName) as DoctorName,
cu.Active, 
cu.Prospect
from [dbo].[CustomerPreferences] as cpf									
LEFT JOIN [dbo].[Customers] as cu ON cu.CustomerID = cpf.CustomerID	
WHERE PreferenceValue LIKE '%Care%'
OR PreferenceValue LIKE '%VIP%'
