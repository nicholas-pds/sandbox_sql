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
    AND cp.ProductID IN ('essix 076', 'essix 1mm', 'essix 1.5', 'essix 2mm', 'Essix 3 Day', 'essix theroux','retain upper','retain lower')
    --AND cp.ProductID IN ('retain upper')--,'retain lower')
    -- Link filter
    AND links.Notes LIKE '%Remake Of%';