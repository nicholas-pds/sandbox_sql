select *
from [dbo]. [customers]
;


select [practicename], [customerid], [salesperson], active, prospect, [dentalgroup]
from [dbo]. [customers]
where dentalgroup in ('OrthopreneursRD', 'Orthopreneurs')
;


select dentalgroup, count(*) as customercount
from [dbo]. [customers]
where dentalgroup is not null
group by dentalgroup
order by dentalgroup
;


select *
from [dbo]. [catalogs]
;

select
    dentalgroup,
    count(*) as customercount,
    sum(case when active = 1 then 1 else 0 end) as activecount,
    sum(case when prospect = 1 then 1 else 0 end) as prospectcount
from [dbo]. [customers]
group by dentalgroup
order by dentalgroup
;
