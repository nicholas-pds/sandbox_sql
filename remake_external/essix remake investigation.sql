SELECT DISTINCT
    linked.CaseNumber AS [OG_CaseNumber],
    main.CaseNumber AS [MainCaseNumber],
    main.CustomerID,
    cu.DentalGroup,
    cp.ProductID AS [Product],
    main.RemakeReason AS [Remake Reason],
    main.Remake
FROM
    dbo.CaseLinks AS links
INNER JOIN
    dbo.Cases AS main ON links.CaseID = main.CaseID
INNER JOIN
    dbo.Cases AS linked ON links.LinkCaseID = linked.CaseID
INNER JOIN
    dbo.CaseProducts AS cp ON main.CaseID = cp.CaseID
LEFT JOIN
    dbo.Customers AS cu ON main.CustomerID = cu.CustomerID
WHERE
    -- Date filter
    main.DateIn >= '2025-10-01'
    -- Remake filters
    AND main.Remake = 'Remake 100%'
    AND main.RemakeReason = 'Fit is poor'
    -- Product filter using ProductID
    ---- With Retain
    --AND cp.ProductID IN ('essix 076', 'essix 1mm', 'essix 1.5', 'essix 2mm', 'Essix 3 Day', 'essix theroux','retain upper','retain lower')
    ---- Without Retain
    AND cp.ProductID IN ('essix 076', 'essix 1mm', 'essix 1.5', 'essix 2mm', 'Essix 3 Day', 'essix theroux')
    ---- Only Retain
    --AND cp.ProductID IN ('retain upper')--,'retain lower')
    -- Link filter
    AND links.Notes LIKE '%Remake Of%';

------------------------------------------------------------------------------
---GROUPING for Charts
------------------------------------------------------------------------------
SELECT 
    -- Date Grouping
    FORMAT(main.DateIn, 'yyyy-MM') AS [YearMonth],
    DATEPART(week, main.DateIn) AS [WeekNumber],
    CAST(main.DateIn AS DATE) AS [ExactDate],
    
    -- Metrics
    COUNT(main.CaseID) AS [RemakeCount],
    
    -- Keep categories for Excel Slicers (optional)
    cp.ProductID AS [Product]
FROM 
    dbo.CaseLinks AS links
INNER JOIN 
    dbo.Cases AS main ON links.CaseID = main.CaseID
INNER JOIN 
    dbo.CaseProducts AS cp ON main.CaseID = cp.CaseID
WHERE 
    main.DateIn >= '2025-06-01'
    AND main.Remake = 'Remake 100%'
    AND main.RemakeReason = 'Fit is poor'
    AND cp.ProductID IN ('essix 076', 'essix 1mm', 'essix 1.5', 'essix 2mm', 'Essix 3 Day', 'essix theroux','retain lower','retain upper')
    --AND cp.ProductID IN ('retain lower','retain upper')
    AND links.Notes LIKE '%Remake Of%'
GROUP BY 
    FORMAT(main.DateIn, 'yyyy-MM'),
    DATEPART(week, main.DateIn),
    CAST(main.DateIn AS DATE),
    cp.ProductID
ORDER BY 
    [ExactDate] ASC;