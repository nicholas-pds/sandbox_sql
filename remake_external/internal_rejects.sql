-- Changed column names for looker studio connector. Didn't want to remap the dashboard. 
SELECT 
    ca.casenumber AS Cases_CaseNumber,  
    ca.shipdate AS Cases_ShipDate,
    CASE 
        WHEN cth.rejected = 1 THEN 'Yes'
        ELSE 'No'
    END AS CaseTasksHistory_Rejected,
    cth.qcemployeeid AS CaseTasksHistory_QCEmployeeID,
    cth.createdate AS CaseTasksHistory_CreateDate,
    cth.rejectreason AS CaseTasksHistory_RejectReason,
    cth.completedby AS CaseTasksHistory_CompletedBy,
    cth.task AS CaseTasksHistory_Task
FROM dbo.cases AS ca
INNER JOIN dbo.casetaskshistory AS cth 
    ON cth.caseid = ca.caseid
WHERE cth.rejected = 1
  AND ca.createdate >= DATEADD(DAY, -184, CAST(GETDATE() AS DATE));