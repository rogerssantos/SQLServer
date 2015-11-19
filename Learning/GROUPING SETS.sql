-- GROUPING SETS EXEMPLE

SELECT CustomerID, SalesPersonID, TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY GROUPING SETS
(
	(CustomerID, SalesPersonID, TerritoryID),
	(CustomerID, SalesPersonID),
	(CustomerID),
	()
)
ORDER BY TerritoryID;