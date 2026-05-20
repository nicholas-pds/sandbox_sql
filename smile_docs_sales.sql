SELECT 
    sa.ProductID, 
    sa.category, 
    SUM(sa.Quantity) AS Total_Quantity_Ordered,
    SUM(sa.LYSales) AS Total_LY_Revenue,
    SUM(sa.LYQ4Sales) AS Total_LYQ4_Revenue,
    COUNT(DISTINCT sa.CustomerID) AS Number_of_Locations_Buying
FROM [dbo].[SalesData] AS sa
LEFT JOIN dbo.customers AS cu ON cu.CustomerID = sa.CustomerID
WHERE cu.DentalGroup = 'Smile Doctors'
GROUP BY sa.ProductID, sa.category
ORDER BY Total_Quantity_Ordered DESC;

select top 100 * from dbo.SalesData

SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE '%Order%' 
   OR table_name LIKE '%Trans%' 
   OR table_name LIKE '%Inv%';

   select top 100 * from dbo.Caseproducts

   --------------------------
   WITH PrioritizedCategories AS (
    SELECT 
        cp.CaseID,
        pr.Category,
        pr.Department,
        ROW_NUMBER() OVER (
            PARTITION BY cp.CaseID 
            ORDER BY 
                CASE 
                    WHEN pr.Category = 'Hybrid'                             THEN 1
                    WHEN pr.Category LIKE 'E%Expander%'                     THEN 2
                    WHEN pr.Category = 'Lab to Lab'                         THEN 3
                    WHEN pr.Category = 'Marpe'                              THEN 4
                    WHEN pr.Category = 'Metal'                              THEN 5
                    WHEN pr.Category = 'Clear'                              THEN 6
                    WHEN pr.Category IN ('Wire Bending', 'Retention')       THEN 7
                    WHEN pr.Category = 'Airway'                             THEN 8
                    ELSE 99  
                END
        ) AS CategoryRank
    FROM dbo.CaseProducts AS cp
    INNER JOIN dbo.Products AS pr ON cp.ProductID = pr.ProductID
    WHERE pr.Category IN (
        'Metal', 'Clear', 'Wire Bending', 'Retention', 'Marpe', 
        'Hybrid', 'E² Expanders', 'Lab to Lab', 'Airway'
    )
    OR pr.Category LIKE 'E%Expander%'
)
SELECT 
    ca.CaseNumber, 
    ca.CustomerID,
    cu.DentalGroup,
    CAST(cu.DateofFirstCase AS Date)    AS DateOfFirstCase,
    CAST(ca.InvoiceDate AS Date)        AS InvoiceDate,
    ca.TotalCharge,
    CASE 
        WHEN pc.Category = 'Marpe' 
             OR (pc.Category IN ('Wire Bending', 'Retention', 'Hybrid') AND pc.Department = 'Marpe') 
             THEN 'Airway'
        WHEN pc.Category = 'Lab to Lab' 
             OR (pc.Category IN ('Wire Bending', 'Retention', 'Hybrid') AND pc.Department = 'Lab to Lab') 
             THEN 'Metal'
        WHEN pc.Category LIKE 'E%Expander%'
             THEN 'E² Expanders'
        WHEN pc.Category IN ('Wire Bending', 'Retention')
             THEN 'Retention'
        WHEN pc.Category = 'Hybrid' THEN pc.Department
        WHEN pc.Category IS NULL THEN 'Misc'
        ELSE pc.Category 
    END AS Category
FROM dbo.cases AS ca 
LEFT JOIN dbo.customers AS cu
    ON ca.CustomerID = cu.CustomerID
LEFT JOIN PrioritizedCategories AS pc 
    ON ca.CaseID = pc.CaseID 
    AND pc.CategoryRank = 1
WHERE ca.InvoiceDate >= '2025-01-01'
  AND ca.InvoiceDate <  '2026-05-01'
  AND ca.[Type] = 'D'
  AND ca.[Deleted] = 0
ORDER BY ca.CaseNumber ASC;