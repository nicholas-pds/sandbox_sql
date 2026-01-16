select
    cu.practicename,
    count(ca.caseid) as cases,
    count(case when nullif(ltrim(rtrim(remake)), '') is not null then 1 end) as remakes
from dbo.cases as ca
inner join dbo.customers as cu on ca.customerid = cu.customerid
where invoicedate >= dateadd(day, -91, cast(getdate() as date))  -- last 91 days
group by cu.practicename
order by cu.practicename
;
