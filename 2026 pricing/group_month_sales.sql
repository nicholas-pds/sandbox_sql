WITH PrioritizedCategories AS (
    SELECT 
        cp.CaseID,
        pr.Category,
        ROW_NUMBER() OVER (
            PARTITION BY cp.CaseID 
            ORDER BY 
                CASE pr.Category
                    WHEN 'Hybrid'       THEN 1
                    WHEN 'E2 Expanders' THEN 2
                    WHEN 'Lab to Lab'   THEN 3
                    WHEN 'Marpe'        THEN 4
                    WHEN 'Metal'        THEN 5
                    WHEN 'Clear'        THEN 6
                    WHEN 'Wire Bending' THEN 7
                    WHEN 'Airway'       THEN 8
                    ELSE 99  
                END
        ) AS CategoryRank
    FROM dbo.CaseProducts AS cp
    INNER JOIN dbo.Products AS pr ON cp.ProductID = pr.ProductID
    WHERE pr.Category IN ('Metal', 'Clear', 'Wire Bending', 'Marpe', 'Hybrid', 'E2 Expanders', 'Lab to Lab', 'Airway')
)
SELECT 
    -- Groups by the first of the month
    DATEADD(MONTH, DATEDIFF(MONTH, 0, ca.InvoiceDate), 0) AS [Month],
    
    CASE 
        WHEN pc.Category = 'Airway' THEN 'Marpe' 
        ELSE ISNULL(pc.Category, 'Uncategorized')
    END AS Category,
    
    SUM(ca.TotalCharge) AS TotalRevenue,
    COUNT(ca.CaseID) AS CaseCount
FROM dbo.cases AS ca 
LEFT JOIN PrioritizedCategories AS pc 
    ON ca.CaseID = pc.CaseID 
    AND pc.CategoryRank = 1
WHERE 
    -- Captures everything from the very start of Jan 1st...
    ca.InvoiceDate >= '2025-01-01' 
    -- ...up to (but not including) the very start of Jan 1st 2026.
    -- This ensures all 24 hours of Dec 31st are included.
    AND ca.InvoiceDate < '2026-01-01' 
    AND ca.[Type] = 'D'
GROUP BY 
    DATEADD(MONTH, DATEDIFF(MONTH, 0, ca.InvoiceDate), 0),
    CASE 
        WHEN pc.Category = 'Airway' THEN 'Marpe' 
        ELSE ISNULL(pc.Category, 'Uncategorized') 
    END
ORDER BY 
    [Month] ASC, 
    TotalRevenue DESC;