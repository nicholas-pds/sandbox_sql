WITH LinkedPairs AS
(
    SELECT
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c1.CaseNumber ELSE c2.CaseNumber END AS OriginalCaseNumber,
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c2.CaseNumber ELSE c1.CaseNumber END AS RemakeCaseNumber,
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c1.CaseID     ELSE c2.CaseID     END AS OriginalCaseID,
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c2.CaseID     ELSE c1.CaseID     END AS RemakeCaseID,
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c1.ShipDate   ELSE c2.ShipDate   END AS OriginalShipDate,
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c2.ShipDate   ELSE c1.ShipDate   END AS RemakeShipDate,
        CASE WHEN c1.CaseNumber < c2.CaseNumber THEN c2.RemakeReason ELSE c1.RemakeReason END AS RemakeReason
    FROM dbo.ALLLinkedCases ac
    INNER JOIN dbo.Cases c1 ON ac.AnchorCaseID = c1.CaseID
    INNER JOIN dbo.Cases c2 ON ac.LinkCaseID   = c2.CaseID
    WHERE (c1.Remake IS NOT NULL OR c2.Remake IS NOT NULL)
      AND c1.CaseNumber <> c2.CaseNumber
),
ShippedCases AS
(
    SELECT 
        CaseID, 
        CaseNumber, 
        ShipDate,
        FORMAT(ShipDate, 'yyyy-MM') AS ShipMonth
    FROM dbo.Cases
    WHERE Status = 'Invoiced'
      AND ShipDate >= '2025-08-01'
),
QC_On_Original AS
(
    SELECT 
        cth.CaseID,
        cth.CompletedBy,
        cth.Task,
        CAST(cth.CompleteDate AS DATE) AS QCDate,
        sc.ShipMonth
    FROM dbo.CaseTasksHistory cth
    INNER JOIN ShippedCases sc ON cth.CaseID = sc.CaseID
    WHERE cth.Task IN ('qcadv','qcb','QCTANDEM','quality','vfrqc')
      AND cth.CompletedBy IN ('261','263','250','339','171','163','59','303','206','175','325','91')
)
-- FINAL MONTHLY REPORT
SELECT
    q.ShipMonth,
    q.CompletedBy AS TechnicianID,

    COUNT(DISTINCT q.CaseID) AS [QC'd Original Cases],

    COUNT(DISTINCT lp.RemakeCaseID) AS [QC'd → Remade],

    ROUND(100.0 * COUNT(DISTINCT lp.RemakeCaseID) / NULLIF(COUNT(DISTINCT q.CaseID), 0), 2) AS [Remake %]

FROM QC_On_Original q
LEFT JOIN LinkedPairs lp 
       ON q.CaseID = lp.OriginalCaseID
GROUP BY 
    q.ShipMonth, 
    q.CompletedBy
ORDER BY 
    q.ShipMonth DESC, 
    [QC'd Original Cases] DESC;