SELECT shipment_type, COUNT(*) AS unique_shipments
FROM (

    -- Carrier: one row per unique tracking number
    SELECT TrackingNumber, 'Carrier' AS shipment_type
    FROM dbo.cases
    WHERE ShipmentDate >= '2026-01-01'
        AND ShipmentDate < '2026-04-01'
        AND Deleted = 0
        AND TrackingNumber IS NOT NULL
        AND TrackingNumber NOT IN ('No Shipment', 'No Shipping', 'No shipment', 'Manually Shipped')
        AND ([Route] IS NULL OR [Route] NOT LIKE '%Pick%')
    GROUP BY TrackingNumber

    UNION ALL

    -- Local (no tracking): one row per case
    SELECT CAST(CaseID AS VARCHAR(50)), 'Local (no tracking)' AS shipment_type
    FROM dbo.cases
    WHERE ShipmentDate >= '2026-01-01'
        AND ShipmentDate < '2026-04-01'
        AND Deleted = 0
        AND [Route] LIKE '%Local%'
        AND TrackingNumber IS NULL

) AS shipments
GROUP BY shipment_type