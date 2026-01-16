-- select cast(datein as date) as datein, count(*) as countstartingwith7
-- from [dbo]. [cases]
-- where pannumber is not null and datein >= '2025-09-01' and left(pannumber, 1) = '7'  -- PanNumber starts with 7
-- -- AND Status = 'Accepted'      -- Uncomment if needed
-- group by cast(datein as date)
-- order by datein
-- ;

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
    -- We include all relevant categories here so the ranking is accurate
    WHERE pr.Category IN ('Metal', 'Clear', 'Wire Bending', 'Marpe', 'Hybrid', 'E2 Expanders', 'Lab to Lab', 'Airway')
)
SELECT 
    CAST(c.datein AS DATE) AS datein, 
    COUNT(pc.CaseID) AS AirwayMarpeCount
FROM [dbo].[cases] AS c
INNER JOIN PrioritizedCategories AS pc ON c.CaseID = pc.CaseID
WHERE 
    pc.CategoryRank = 1                           -- Only look at the top-ranked category for each case
    AND pc.Category IN ('Airway', 'Marpe')        -- Filter final results for your specific needs
    AND c.datein >= '2025-12-01'                  -- Keeps your date range constraint
GROUP BY 
    CAST(c.datein AS DATE)
ORDER BY 
    datein DESC;