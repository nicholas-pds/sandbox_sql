DECLARE @cols NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

-- Build a comma-separated list of all ProductIDs as column names
select @cols = string_agg(quotename(productid), ',')
from (select distinct productid from dbo.caseproducts) as p
;

-- Build the dynamic SQL
set @sql = '
SELECT
    FORMAT(ca.InvoiceDate, ''yyyy-MM'') AS InvoiceMonth,
    ' + @cols + ',
    SUM(TotalPerMonth) AS [Monthly Total]
FROM (
    SELECT
        FORMAT(ca.InvoiceDate, ''yyyy-MM'') AS InvoiceMonth,
        pr.ProductID,
        COUNT(*) AS TotalPerMonth
    FROM dbo.cases AS ca
    LEFT JOIN dbo.caseproducts AS pr ON ca.caseid = pr.caseid
    WHERE ca.InvoiceDate >= ''2025-01-01''
    GROUP BY FORMAT(ca.InvoiceDate, ''yyyy-MM''), pr.ProductID
) AS src
PIVOT (
    SUM(TotalPerMonth)
    FOR ProductID IN (' + @cols + ')
) AS pvt
GROUP BY InvoiceMonth
ORDER BY InvoiceMonth;
'
;

-- Execute it
exec sp_executesql @sql
;
