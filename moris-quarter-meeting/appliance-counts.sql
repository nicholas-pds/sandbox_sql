SELECT
    CASE pr.ProductID
        WHEN 'E² Template E1'       THEN 'E2'
        WHEN 'E² Template E2'       THEN 'E2'
        WHEN 'E² Template E3'       THEN 'E2'
        WHEN 'E² Template E4'       THEN 'E2'
        WHEN 'E² Template E5'       THEN 'E2'
        WHEN 'E² Template E6'       THEN 'E2'
        WHEN 'essix 076'            THEN 'Essix'
        WHEN 'essix 1.5'            THEN 'Essix'
        WHEN 'essix 1mm'            THEN 'Essix'
        WHEN 'essix 2mm'            THEN 'Essix'
        WHEN 'Essix 3 Day'          THEN 'Essix'
        WHEN 'essix theroux'        THEN 'Essix'
        WHEN 'retain lower'         THEN 'Essix'
        WHEN 'retain upper'         THEN 'Essix'
        WHEN 'MARPE IntrusionFrame' THEN 'MARPE'
        WHEN 'MARPE LEONE 10'       THEN 'MARPE'
        WHEN 'MARPE LEONE 12'       THEN 'MARPE'
        WHEN 'MARPE SHIELD TS 12'   THEN 'MARPE'
        WHEN 'MARPE SHIELD TS 14'   THEN 'MARPE'
        WHEN 'MARPE TIGER 10'       THEN 'MARPE'
        WHEN 'MARPE TIGER 12'       THEN 'MARPE'
        WHEN 'MARPE TIGER 14'       THEN 'MARPE'
        WHEN 'MARPE TIGER 16'       THEN 'MARPE'
        WHEN 'MARPE TIGER 8'        THEN 'MARPE'
        WHEN 'MSE 10mm'             THEN 'MARPE'
        WHEN 'MSE 12mm'             THEN 'MARPE'
        WHEN 'MSE 8mm'              THEN 'MARPE'
        WHEN 'Ti MARPE'             THEN 'MARPE'
        WHEN 'exp rpe'              THEN 'RPE'
        WHEN 'exp lower'            THEN 'RPE'
        WHEN 'exp arnold'           THEN 'RPE'
        WHEN 'exp fan'              THEN 'RPE'
        WHEN 'exp haas'             THEN 'RPE'
        WHEN 'exp haas shielded'    THEN 'RPE'
        WHEN 'exp tigerscrew'       THEN 'RPE'
        WHEN 'exp leaf'             THEN 'RPE'
        WHEN 'exp niti'             THEN 'RPE'
    END AS Product,
    SUM(CASE WHEN MONTH(ca.InvoiceDate) = 1 THEN pr.Quantity ELSE 0 END) AS January,
    SUM(CASE WHEN MONTH(ca.InvoiceDate) = 2 THEN pr.Quantity ELSE 0 END) AS February,
    SUM(CASE WHEN MONTH(ca.InvoiceDate) = 3 THEN pr.Quantity ELSE 0 END) AS March,
    SUM(pr.Quantity) AS [Q1 Total]
FROM dbo.cases AS ca
LEFT JOIN dbo.caseproducts AS pr ON ca.CaseID = pr.CaseID
WHERE ca.InvoiceDate >= '2026-01-01'
  AND ca.InvoiceDate <  '2026-04-01'
  AND ca.Deleted = 0
  AND pr.ProductID IN (
        'E² Template E1','E² Template E2','E² Template E3',
        'E² Template E4','E² Template E5','E² Template E6',
        'essix 076','essix 1.5','essix 1mm','essix 2mm',
        'Essix 3 Day','essix theroux','retain lower','retain upper',
        'MARPE IntrusionFrame','MARPE LEONE 10','MARPE LEONE 12',
        'MARPE SHIELD TS 12','MARPE SHIELD TS 14','MARPE TIGER 10',
        'MARPE TIGER 12','MARPE TIGER 14','MARPE TIGER 16',
        'MARPE TIGER 8','MSE 10mm','MSE 12mm','MSE 8mm','Ti MARPE',
        'exp rpe','exp lower','exp arnold','exp fan','exp haas',
        'exp haas shielded','exp tigerscrew','exp leaf','exp niti'
  )
GROUP BY
    CASE pr.ProductID
        WHEN 'E² Template E1'       THEN 'E2'
        WHEN 'E² Template E2'       THEN 'E2'
        WHEN 'E² Template E3'       THEN 'E2'
        WHEN 'E² Template E4'       THEN 'E2'
        WHEN 'E² Template E5'       THEN 'E2'
        WHEN 'E² Template E6'       THEN 'E2'
        WHEN 'essix 076'            THEN 'Essix'
        WHEN 'essix 1.5'            THEN 'Essix'
        WHEN 'essix 1mm'            THEN 'Essix'
        WHEN 'essix 2mm'            THEN 'Essix'
        WHEN 'Essix 3 Day'          THEN 'Essix'
        WHEN 'essix theroux'        THEN 'Essix'
        WHEN 'retain lower'         THEN 'Essix'
        WHEN 'retain upper'         THEN 'Essix'
        WHEN 'MARPE IntrusionFrame' THEN 'MARPE'
        WHEN 'MARPE LEONE 10'       THEN 'MARPE'
        WHEN 'MARPE LEONE 12'       THEN 'MARPE'
        WHEN 'MARPE SHIELD TS 12'   THEN 'MARPE'
        WHEN 'MARPE SHIELD TS 14'   THEN 'MARPE'
        WHEN 'MARPE TIGER 10'       THEN 'MARPE'
        WHEN 'MARPE TIGER 12'       THEN 'MARPE'
        WHEN 'MARPE TIGER 14'       THEN 'MARPE'
        WHEN 'MARPE TIGER 16'       THEN 'MARPE'
        WHEN 'MARPE TIGER 8'        THEN 'MARPE'
        WHEN 'MSE 10mm'             THEN 'MARPE'
        WHEN 'MSE 12mm'             THEN 'MARPE'
        WHEN 'MSE 8mm'             THEN 'MARPE'
        WHEN 'Ti MARPE'             THEN 'MARPE'
        WHEN 'exp rpe'              THEN 'RPE'
        WHEN 'exp lower'            THEN 'RPE'
        WHEN 'exp arnold'           THEN 'RPE'
        WHEN 'exp fan'              THEN 'RPE'
        WHEN 'exp haas'             THEN 'RPE'
        WHEN 'exp haas shielded'    THEN 'RPE'
        WHEN 'exp tigerscrew'       THEN 'RPE'
        WHEN 'exp leaf'             THEN 'RPE'
        WHEN 'exp niti'             THEN 'RPE'
    END
ORDER BY [Q1 Total] DESC;