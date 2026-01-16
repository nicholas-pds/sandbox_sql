select
    b. [catalog],
    a.active,
    a.prospect,
    count(distinct a.customerid) as uniquecustomercount,
    sum(case when b. [catalog] is null then 1 else 0 end) as nullcatalogcount
from dbo.customers as a
left join [dbo]. [customersettingsdefaultview] as b on a.customerid = b.customerid
group by b. [catalog], a.active, a.prospect
order by
    a.active desc,  -- Active first (assuming 1 = active)
    a.prospect desc  -- Then prospects (if applicable)


------------------------------------
------------------------------------ ASAP members price list
SELECT
    a.customerid,
    b.[catalog],
    a.active,
    a.prospect,
    -- Aggregate (SUM) the sales columns
    SUM(s.YTDSales) AS Total_YTDSales,
    SUM(s.Q1Sales) AS Total_Q1Sales,
    SUM(s.Q2Sales) AS Total_Q2Sales,
    SUM(s.Q3Sales) AS Total_Q3Sales,
    SUM(s.Q4Sales) AS Total_Q4Sales
FROM
    dbo.customers AS a
LEFT JOIN 
    [dbo].[customersettingsdefaultview] AS b 
    ON a.customerid = b.customerid
LEFT JOIN 
    [dbo].[SalesData] AS s 
    ON a.customerid = s.customerid
WHERE
    b.[catalog] = '2025 Show Pricing'
-- Group by all non-aggregated columns
GROUP BY
    a.customerid,
    b.[catalog],
    a.active,
    a.prospect
ORDER BY
    a.customerid;