-- Grouped by Ship Date
select
    cast(ca.shipdate as date) as shipdate,
    count(distinct ca.casenumber) as traditionalbandcases
from dbo.cases as ca
inner join dbo.casetasks as ct on ct.caseid = ca.caseid
where
    ct.task = 'band'
    and ct.completedate is null
    and ca.shipdate >= dateadd(day, -1, cast(getdate() as date))  -- starts yesterday (2025-11-10)
    and ca.shipdate < dateadd(day, 10, cast(getdate() as date))  -- up to but not including 2025-11-16
group by cast(ca.shipdate as date)
order by shipdate
;

-- With Case Numbers
select cast(ca.shipdate as date) as shipdate, ca.casenumber
from dbo.cases as ca
inner join dbo.casetasks as ct on ct.caseid = ca.caseid
where
    ct.task = 'band'
    and ct.completedate is null
    and ca.shipdate >= dateadd(day, -1, cast(getdate() as date))  -- starts today (2025-11-11)
    and ca.shipdate < dateadd(day, 10, cast(getdate() as date))  -- up to but not including 2025-11-16
order by shipdate, ca.casenumber
;
