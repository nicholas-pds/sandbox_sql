SELECT 
    sa.ProductID, 
    sa.category, 
    SUM(sa.Quantity) AS Total_Quantity_Ordered,
    SUM(sa.LYSales) AS Total_LY_Revenue,
    SUM(sa.LYQ4Sales) AS Total_LYQ4_Revenue,
    COUNT(DISTINCT sa.CustomerID) AS Number_of_Locations_Buying
FROM [dbo].[SalesData] AS sa
LEFT JOIN dbo.customers AS cu ON cu.CustomerID = sa.CustomerID
WHERE cu.DentalGroup = 'Smile Doctors'
GROUP BY sa.ProductID, sa.category
ORDER BY Total_Quantity_Ordered DESC;

select top 100 * from dbo.SalesData

SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE '%Order%' 
   OR table_name LIKE '%Trans%' 
   OR table_name LIKE '%Inv%';

   select top 100 * from dbo.Caseproducts