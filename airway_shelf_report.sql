SELECT DISTINCT

ca.CaseNumber,

ca.PanNumber,

ca.ShipDate,

ca.[Status],

ca.HoldStatus,

ca.HoldReason

FROM dbo.cases ca
INNER JOIN dbo.caseproducts cp ON cp.CaseID = ca.CaseID
INNER JOIN dbo.CaseTasks ct ON ct.CaseID = ca.CaseID
WHERE (
cp.productID LIKE '%marpe%' OR
cp.productID LIKE '%mse%' OR
cp.productID LIKE '%zoom%'
)
AND ca.[Status] IN ('In Production', 'On Hold')
AND ct.Task IN ('3dfin-exp', '3dd')
AND ct.CompleteDate IS NULL;