--New Main table with createdby added
SELECT 
    ca.CaseNumber, 
    CAST(ca.InvoiceDate AS Date) AS InvoiceDate, 
    ca.CustomerID,
    cu.PracticeName, 
    ca.DoctorName,
    Audit.Createdby AS [Created By]
FROM dbo.cases AS ca
LEFT JOIN dbo.customers AS cu 
    ON cu.CustomerID = ca.CustomerID
-- This subquery ensures only 1 row is returned per CaseID
OUTER APPLY (
    SELECT TOP 1 cat.Createdby
    FROM dbo.CaseAuditTrail AS cat
    WHERE cat.CaseID = ca.CaseID 
      AND cat.[Type] = 'Accept Remote Case'
    ORDER BY cat.CaseID ASC -- Adjust this ID column name to your primary key if different
) AS Audit
WHERE ca.InvoiceDate > '2025-05-01'
  AND ca.ShipCountry = 'US'
  AND ca.status = 'Invoiced'
  AND ca.LocalDelivery = 0
  AND ca.CustomerID NOT IN ('Perfect Finish', 'EOL')
  AND ca.Remake IS NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.caseproducts AS cp
      WHERE cp.CaseID = ca.CaseID
      AND cp.ProductID IN ('Shipping Cost', 'SD Shipping', 'Shipping Retain','ShippingReturnLabel', 'Shipping','del ship n hand')
  )
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.caseproducts AS cp
      WHERE cp.CaseID = ca.CaseID
      GROUP BY cp.CaseID
      HAVING COUNT(cp.ProductID) = 1 
         AND MAX(cp.ProductID) IN ('marpe zoom', 'marpe email')
  )
ORDER BY ca.InvoiceDate ASC;

-------------------------------------------------------------------------
--*********************************************************************--
-------------------------------------------------------------------------
--Counts by Month
SELECT 
    YEAR(ca.InvoiceDate) AS InvoiceYear,
    MONTH(ca.InvoiceDate) AS InvoiceMonth,
    DATENAME(MONTH, ca.InvoiceDate) AS MonthName,
    COUNT(DISTINCT ca.CaseNumber) AS CaseCount
FROM dbo.cases AS ca
WHERE ca.InvoiceDate > '2025-05-01' 
  AND ca.ShipCountry = 'US'
  AND ca.status = 'Invoiced'
  AND ca.LocalDelivery = 0
  AND ca.CustomerID NOT IN ('Perfect Finish', 'EOL')
  AND ca.Remake IS NULL
  -- Exclude shipping-only cases
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.caseproducts AS cp
      WHERE cp.CaseID = ca.CaseID
        AND cp.ProductID IN ('Shipping Cost', 'SD Shipping', 'Shipping Retain','ShippingReturnLabel', 'Shipping','del ship n hand')
  )
  -- Exclude cases where 'marpe zoom' or 'marpe email' is the ONLY product
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.caseproducts AS cp
      WHERE cp.CaseID = ca.CaseID
      GROUP BY cp.CaseID
      HAVING COUNT(cp.ProductID) = 1 
         AND MAX(cp.ProductID) IN ('marpe zoom', 'marpe email')
  )
GROUP BY 
    YEAR(ca.InvoiceDate),
    MONTH(ca.InvoiceDate),
    DATENAME(MONTH, ca.InvoiceDate)
ORDER BY 
    YEAR(ca.InvoiceDate),
    MONTH(ca.InvoiceDate);

    -----
    --who checked in
    SELECT 
    Audit.Createdby AS [Accepted By],
    COUNT(DISTINCT ca.CaseNumber) AS CaseCount
FROM dbo.cases AS ca
-- This subquery ensures we only attribute the case to the first person who accepted it
OUTER APPLY (
    SELECT TOP 1 cat.Createdby
    FROM dbo.CaseAuditTrail AS cat
    WHERE cat.CaseID = ca.CaseID 
      AND cat.[Type] = 'Accept Remote Case'
    ORDER BY cat.CaseID ASC 
) AS Audit
WHERE ca.InvoiceDate > '2025-05-01'
  AND ca.ShipCountry = 'US'
  AND ca.status = 'Invoiced'
  AND ca.LocalDelivery = 0
  AND ca.CustomerID NOT IN ('Perfect Finish', 'EOL')
  AND ca.Remake IS NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.caseproducts AS cp
      WHERE cp.CaseID = ca.CaseID
      AND cp.ProductID IN ('Shipping Cost', 'SD Shipping', 'Shipping Retain','ShippingReturnLabel', 'Shipping','del ship n hand')
  )
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.caseproducts AS cp
      WHERE cp.CaseID = ca.CaseID
      GROUP BY cp.CaseID
      HAVING COUNT(cp.ProductID) = 1 
         AND MAX(cp.ProductID) IN ('marpe zoom', 'marpe email')
  )
GROUP BY 
    Audit.Createdby
ORDER BY 
    CaseCount DESC; -- Shows the person with the most cases at the top