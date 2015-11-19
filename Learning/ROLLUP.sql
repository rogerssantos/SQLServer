-- ROLLUP EXEMPLE

SELECT CustomerID, SalesPersonID, TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY ROLLUP (CustomerID, SalesPersonID, TerritoryID)
ORDER BY TerritoryID;

-- OR

SELECT CustomerID, SalesPersonID, TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, SalesPersonID, TerritoryID WITH ROLLUP
ORDER BY TerritoryID;