select
    main.datein as datein_time,
    cast(linked.shipdate as date) as [og_shipdate],
    cast(linked.duedate as date) as [og_duedate],
    linked.casenumber as [og_casenumber],
    main.casenumber as maincasenumber,
    cast(main.datein as date) as [datein],
    cast(main.shipdate as date) as [shipdate],
    cust.practicename,
    main.totalcharge,
    main.remakereason,
    main.remake,
    main.remakediscount,
    main. [status]

from dbo.caselinks as links
inner join dbo.cases as main on links.caseid = main.caseid
inner join dbo.cases as linked on links.linkcaseid = linked.caseid
inner join dbo.customers as cust on main.customerid = cust.customerid

where
    links.notes like '%Remake Of%'
    and main.datein >= dateadd(day, -60, cast(getdate() as date))
    and main. [status] in ('In Production', 'Invoiced', 'On Hold')
    and main.datein < '2025-11-22'
    and main.datein < '2025-11-23'
order by main.datein asc
;
