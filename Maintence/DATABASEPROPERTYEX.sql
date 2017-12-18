-- https://docs.microsoft.com/pt-br/sql/t-sql/functions/databasepropertyex-transact-sql

SELECT   
    DATABASEPROPERTYEX('AdventureWorks2014', 'Collation') AS Collation,  
    DATABASEPROPERTYEX('AdventureWorks2014', 'IsAutoShrink') AS IsAutoShrink,  
    DATABASEPROPERTYEX('AdventureWorks2014', 'IsAutoCreateStatistics') AS IsAutoCreateStatistics,  
    DATABASEPROPERTYEX('AdventureWorks2014', 'IsNullConcat') AS IsNullConcat  
    
    
Result:

Collation                           IsAutoShrink                IsAutoCreateStatistics                    IsNullConcat
----------------------------------- --------------------------- ----------------------------------------- --------------
SQL_Latin1_General_CP1_CI_AS        0                           1                                         1				
