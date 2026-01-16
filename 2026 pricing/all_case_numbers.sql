
--select * from [dbo].[SalesByProducts]

--select * from [dbo].[SalesData]

--select  * from dbo.cases where InvoiceDate > '2025-10-05' and InvoiceDate < '2025-10-20'

--select ca.CaseNumber, ca.TotalCharge 
--from dbo.cases AS ca 
--LEFT JOIN dbo.CaseProducts AS cp ON cp.CaseID = ca.CaseId
--where InvoiceDate > '2025-10-05' 
--and InvoiceDate < '2025-10-20'
--ORDER BY CaseNumber ASC;

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
    ca.CaseNumber, 
    CAST(ca.InvoiceDate AS Date) AS InvoiceDate,
    ca.TotalCharge,
    CASE 
        WHEN pc.Category = 'Airway' THEN 'Marpe' 
        ELSE pc.Category 
    END AS Category
FROM dbo.cases AS ca 
LEFT JOIN PrioritizedCategories AS pc 
    ON ca.CaseID = pc.CaseID 
    AND pc.CategoryRank = 1
WHERE ca.InvoiceDate >= '2025-01-01' 
  AND ca.InvoiceDate <= '2025-12-31'
  AND ca.[Type] = 'D'
ORDER BY ca.CaseNumber ASC;