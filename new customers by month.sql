with
    monthrange as (
        select
            datefromparts(
                year(max(dateoffirstcase)), month(max(dateoffirstcase)), 1
            ) as maxmonthstart
        from [dbo]. [customers]
    ),
    last12months as (
        select dateadd(month, -17, maxmonthstart) as monthstart
        from monthrange
        union all
        select dateadd(month, 1, monthstart)
        from last12months
        where monthstart < (select maxmonthstart from monthrange)
    )
select format(m.monthstart, 'yyyy-MM') as month, count(c.dateoffirstcase) as casecount
from last12months m
left join
    [dbo]. [customers] c
    on c.dateoffirstcase >= m.monthstart
    and c.dateoffirstcase < dateadd(month, 1, m.monthstart)
group by m.monthstart
order by m.monthstart asc
;
