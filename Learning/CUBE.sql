-- CUBE EXEMPLE

SELECT CustomerID, SalesPersonID, TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY CUBE (CustomerID, SalesPersonID, TerritoryID)
ORDER BY TerritoryID;

-- OR

SELECT CustomerID, SalesPersonID, TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, SalesPersonID, TerritoryID WITH CUBE
ORDER BY TerritoryID;