select
    casenumber,
    pannumber,
    doctorname,
    concat(patientfirst, ' ', patientlast) as patientname,
    cast(shipdate as date) as shipdate,
    cast(holddate as date) as holddate,
    holdstatus,
    holdreason,

    -- Extract first date after "(FU)" in HoldReason
    case
        when holdreason like '%(FU)%'
        then
            try_cast(
                ltrim(
                    substring(holdreason, charindex('(FU)', holdreason) + 4, 20)
                ) as date
            )
        else null
    end as [fu date]

from dbo.cases
where
    [status] = 'On Hold'
    and ltrim(rtrim(pannumber)) like '7%'
    and holdstatus in ('Waiting on Scan(s)', 'How to Proceed')
order by [fu date] asc  -- Oldest FU Date first
;
