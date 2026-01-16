SELECT
    -- Month Label Logic
    CASE
        WHEN GROUPING(MONTH(ca.InvoiceDate)) = 1 THEN 'Grand Total'
        ELSE DATENAME(MONTH, MAX(ca.InvoiceDate))
    END AS [Month],

    -- 1. How many separate orders/jobs were processed?
    -- We use DISTINCT so if a case has 2 lines, it's still just 1 case.
    COUNT(DISTINCT ca.CaseID) AS [Total Unique Cases],

    -- 2. How many actual products were made?
    -- We sum the quantity field.
    SUM(cp.Quantity) AS [Total Products Made]

FROM dbo.cases as ca
INNER JOIN dbo.caseproducts as cp
    ON ca.CaseID = cp.CaseID

WHERE ca.[Status] = 'Invoiced'
    AND ca.InvoiceDate >= '2025-01-01'
    AND ca.InvoiceDate < '2026-01-01'
    AND cp.ProductID IN (
'exp Acry bonded fan',
'exp Acrylic bonded',
'exp ant biteplate',
'exp arnold',
'exp fan',
'exp haas',
'exp haas shielded',
'exp leaf',
'exp lower',
'exp niti',
'exp repair',
'exp rpe',
'herbst rpe',
'rpe sweep'
    )

-- Groups by Month Number (1-12) and adds the Summary Row at the bottom
GROUP BY MONTH(ca.InvoiceDate) WITH ROLLUP

-- Sorts Jan -> Dec, with Grand Total last
ORDER BY MONTH(ca.InvoiceDate);