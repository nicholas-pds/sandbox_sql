select
    cast(invoicedate as date) as invoicedate,
    sum(taxableamount + nontaxableamount) as revenue
from dbo.cases
where
    [status] not in ('Cancelled', 'Submitted', 'Sent for TryIn')
    and deleted = 0
    and [type] = 'D'
    and invoicedate >= dateadd(day, -62, cast(getdate() as date))  -- last 62 days
    and invoicedate < dateadd(day, 1, cast(getdate() as date))  -- excludes tomorrow 
group by cast(invoicedate as date)
order by invoicedate desc
;
