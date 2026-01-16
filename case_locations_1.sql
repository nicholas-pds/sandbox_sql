/* Case Location – One Row Per CaseNumber (Unique)  */
with
    rankedcases as (
        select
            ca.casenumber,
            ca.pannumber,
            ct.task,
            ct.completedate,
            ct.department,
            cast(ca.shipdate as date) as shipdate,
            ca.lastlocationid,
            cll.description as locationdescription,
            ca.status,
            ca.localdelivery,
            row_number() over (
                partition by ca.casenumber
                order by
                    case when ct.completedate is null then 1 else 0 end,  -- completed first
                    ct.completedate desc,  -- newest date
                    ct.caseid desc  -- tie-breaker (or use ct.CaseTaskID if exists)
            ) as rn
        from dbo.cases as ca
        inner join dbo.casetasks as ct on ca.caseid = ct.caseid
        left join dbo.caseloglocations as cll on ca.lastlocationid = cll.id
        where ca.status = 'In Production'
    )
select
    casenumber,
    pannumber,
    task,
    completedate,
    department,
    shipdate,
    locationdescription,
    [status],
    localdelivery
from rankedcases
where rn = 1
order by casenumber
;


select *
from [dbo]. [mt_relations]

select top 10 *
from dbo.cases

select top 10 *
from dbo.casetasks

select top 10 *
from dbo.casetaskshistory

select top 10 *
from [casehistory_caseevents]

select top 10 *
from [caseproducts]
select top 10 *
from dbo.cases

select ca.caseid, ca.casenumber, pr.category
-- MAX(pr.Category) AS ProductCategory
from dbo.cases as ca
left join dbo.caseproducts as cp on ca.caseid = cp.caseid
left join dbo.products as pr on cp.productid = pr.productid
where
    -- ca.CaseNumber IN ('146181','146184','146178','146175')
    ca.casenumber = '145184' and ca.status = 'In Production'
-- AND pr.Category IN ('Metal', 'Clear', 'Wire Bending', 'Marpe', 'Hybrid', 'E2
-- Expanders', 'Lab to Lab')
-- GROUP BY ca.CaseNumber
order by ca.casenumber desc
;


-- HERE
select ca.caseid, ca.casenumber, pr.category
from dbo.cases as ca
left join dbo.caseproducts as cp on ca.caseid = cp.caseid
left join dbo.products as pr on cp.productid = pr.productid
where
    ca.status = 'In Production'
    and pr.category is not null
    and pr.category in (
        'Metal',
        'Clear',
        'Wire Bending',
        'Marpe',
        'Hybrid',
        'E2 Expanders',
        'Lab to Lab'
    )
order by ca.casenumber desc
;
