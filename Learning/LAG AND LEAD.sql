/*LAG AND LEAD*/

SELECT
	SalesOrderId, CustomerID, TotalDue, 
	LAG(TotalDue, 1, 0) OVER (ORDER BY TotalDue DESC) AS [LAG],
	LEAD(TotalDue, 1, 0) OVER (ORDER BY TotalDue DESC) AS [LEAD]
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;