SELECT
    cu.PracticeName                      AS Customer,
    ca.SalesPerson                       AS SalesRep,
    ca.CaseID,
    ca.CaseNumber                        AS OrderNum,
    CAST(ca.InvoiceDate AS Date)         AS InvoiceDate,
    ca.Status,
    pr.Description                       AS Product,
    cp.UnitPrice                         AS ProductCharge,
    ca.TotalCharge                       AS OrderTotal
FROM dbo.cases AS ca
LEFT JOIN dbo.customers AS cu
    ON ca.CustomerID = cu.CustomerID
LEFT JOIN dbo.CaseProducts AS cp
    ON ca.CaseID = cp.CaseID
LEFT JOIN dbo.Products AS pr
    ON cp.ProductID = pr.ProductID
WHERE cu.DentalGroup = 'Smile Doctors'
  AND ca.InvoiceDate >= '2025-01-01'
  AND ca.InvoiceDate <  '2026-05-01'
  AND ca.[Type]    = 'D'
  AND ca.[Deleted] = 0
ORDER BY ca.InvoiceDate DESC, ca.CaseNumber ASC;