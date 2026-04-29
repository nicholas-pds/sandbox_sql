WITH ProductCategories AS
(
    SELECT
        ca.CaseID,
        ca.CaseNumber,
        pr.Category
    FROM dbo.Cases AS ca
    LEFT JOIN dbo.CaseProducts AS cp
        ON ca.CaseID = cp.CaseID
    LEFT JOIN dbo.Products AS pr
        ON cp.ProductID = pr.ProductID
    WHERE
        ca.CustomerID = 'Advance Ortho'
        AND ca.Deleted = 0
        AND ca.ShipDate >= DATEADD(YEAR, -1, GETDATE())
        AND pr.Category IS NOT NULL
),
PrioritizedCategories AS
(
    SELECT
        CaseID,
        CaseNumber,
        Category,
        ROW_NUMBER() OVER (
            PARTITION BY CaseNumber
            ORDER BY
                CASE
                    WHEN Category = 'Hybrid'              THEN 1
                    WHEN Category LIKE 'E%Expander%'      THEN 2
                    WHEN Category = 'Lab to Lab'          THEN 3
                    WHEN Category = 'Marpe'               THEN 4
                    WHEN Category = 'Metal'               THEN 5
                    WHEN Category = 'Clear'               THEN 6
                    WHEN Category = 'Wire Bending'        THEN 7
                    WHEN Category = 'Airway'              THEN 8
                    ELSE 99
                END
        ) AS PriorityRank
    FROM ProductCategories
)
SELECT
    ca.CaseNumber,
    ca.PatientFirst,
    ca.PatientLast,
    CAST(ca.ShipDate AS DATE) AS ShipDate,
    ca.[Status]
FROM dbo.Cases AS ca
INNER JOIN PrioritizedCategories AS pc
    ON ca.CaseID = pc.CaseID
    AND pc.PriorityRank = 1
WHERE
    pc.Category = 'Marpe'
ORDER BY
    ca.ShipDate DESC;
