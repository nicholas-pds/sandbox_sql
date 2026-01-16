select * 
from dbo.cases 
where [status] = 'Submitted' 
	AND [Deleted] = 0;

SELECT
    COUNT(*)
FROM
    dbo.cases
WHERE
    [status] = 'Submitted'
	AND [Deleted] = 0;

select * from dbo.products