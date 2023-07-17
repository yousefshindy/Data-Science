SELECT
    C.CustomerName,
    p.CustomerID,
    sum(p.Quantity) as Quantities,
    SUM(p.Total) as TotalPrice
FROM
    PRODUCT_SALES p
JOIN  CUSTOMER c ON p.CustomerID = c.CustomerID
   
	join  TIMELINE t on t.TimeID=p.TimeID	
WHERE
    t.Date >= '2018-03-03'
    AND  t.Date <= '2018-05-31'
group by C.CustomerName,
    p.CustomerID





-----------------------------------------------------------------------------------------------------

SELECT
    C.CustomerName,p.CustomerID,
    AVG(p.Total) AS AverageOrder
FROM
    PRODUCT_SALES p
JOIN
    CUSTOMER C ON C.CustomerID = p.CustomerID
GROUP BY
    C.CustomerName,p.CustomerID
HAVING AVG(p.Total) > (SELECT AVG(Total) FROM PRODUCT_SALES)



-----------------------------------------------------------------------------------------------




SELECT
    p.CustomerID,
    C.CustomerName,
    P.ProductNumber,
    PR.ProductName,
    t.Date,
    LAG(t.Date) OVER (PARTITION BY p.CustomerID ORDER BY t.Date) AS EndDate,
    DATEDIFF(DAY, LAG(t.Date) OVER (PARTITION BY p.CustomerID ORDER BY t.Date), t.Date) AS Days_between_Product_Sales
FROM
    PRODUCT_SALES p
JOIN
    CUSTOMER C ON C.CustomerID = p.CustomerID

JOIN
    PRODUCT PR ON pr.ProductNumber = P.ProductNumber

	join TIMELINE t on t.TimeID=p.TimeID
ORDER BY
    C.CustomerID






---------------------------------------------------------------------------------------------------------




SELECT
    YEAR(t.Date) AS Year,
    DATEPART(QUARTER, t.Date) AS Quarter,
    SUM(p.Total) AS TotalSales
FROM
    PRODUCT_SALES p

join TIMELINE t on t.TimeID=p.TimeID
GROUP BY
    YEAR(t.Date),
    DATEPART(QUARTER, t.Date)