select
    format(ca.invoicedate, 'yyyy-MM') as invoicemonth,
    count(case when pr.productid = 'E1 Expander' then 1 end) as [e1 expander],
    count(case when pr.productid = 'E2 Expander' then 1 end) as [e2 expander],
    count(case when pr.productid = 'E2 Template E1' then 1 end) as [e2 template e1],
    count(case when pr.productid = 'E2 Template E2' then 1 end) as [e2 template e2],
    count(case when pr.productid = 'E2 Template E3' then 1 end) as [e2 template e3],
    count(case when pr.productid = 'E2 Template E4' then 1 end) as [e2 template e4],
    count(case when pr.productid = 'E2 Template E5' then 1 end) as [e2 template e5],
    count(case when pr.productid = 'E2 Template E6' then 1 end) as [e2 template e6],
    count(case when pr.productid = 'E3 Expander' then 1 end) as [e3 expander],
    count(case when pr.productid = 'E4 Expander' then 1 end) as [e4 expander],
    count(case when pr.productid = 'E5 Expander' then 1 end) as [e5 expander],
    count(case when pr.productid = 'E6 Expander' then 1 end) as [e6 expander],
    count(case when pr.productid = 'exp Acry bonded fan' then 1 end) as [
        exp acry bonded fan
    ],
    count(case when pr.productid = 'exp Acrylic bonded' then 1 end) as [
        exp acrylic bonded
    ],
    count(case when pr.productid = 'exp ant biteplate' then 1 end) as [
        exp ant biteplate
    ],
    count(case when pr.productid = 'exp arnold' then 1 end) as [exp arnold],
    count(case when pr.productid = 'exp fan' then 1 end) as [exp fan],
    count(case when pr.productid = 'exp haas' then 1 end) as [exp haas],
    count(case when pr.productid = 'exp haas shielded' then 1 end) as [
        exp haas shielded
    ],
    count(case when pr.productid = 'exp leaf' then 1 end) as [exp leaf],
    count(case when pr.productid = 'exp lower' then 1 end) as [exp lower],
    count(case when pr.productid = 'exp upper' then 1 end) as [exp upper],
    count(case when pr.productid = 'exp niti' then 1 end) as [exp niti],
    count(case when pr.productid = 'exp repair' then 1 end) as [exp repair],
    count(case when pr.productid = 'exp roncone' then 1 end) as [exp roncone],
    count(case when pr.productid = 'exp rpe' then 1 end) as [exp rpe],
    count(case when pr.productid = 'exp superscrew' then 1 end) as [exp superscrew],
    count(case when pr.productid = 'exp tigerscrew' then 1 end) as [exp tigerscrew],
    count(case when pr.productid = 'rpe sweep' then 1 end) as [rpe sweep],
    count(*) as [monthly total]
from dbo.cases as ca
left join dbo.caseproducts as pr on ca.caseid = pr.caseid
where
    ca.invoicedate >= '2025-01-01'
    and pr.productid in (
        'E1 Expander',
        'E2 Expander',
        'E2 Template E1',
        'E2 Template E2',
        'E2 Template E3',
        'E2 Template E4',
        'E2 Template E5',
        'E2 Template E6',
        'E3 Expander',
        'E4 Expander',
        'E5 Expander',
        'E6 Expander',
        'exp Acry bonded fan',
        'exp Acrylic bonded',
        'exp ant biteplate',
        'exp arnold',
        'exp fan',
        'exp haas',
        'exp haas shielded',
        'exp leaf',
        'exp lower',
        'exp upper',
        'exp niti',
        'exp repair',
        'exp roncone',
        'exp rpe',
        'exp superscrew',
        'exp tigerscrew',
        'rpe sweep'
    )
group by format(ca.invoicedate, 'yyyy-MM')
order by invoicemonth
;
