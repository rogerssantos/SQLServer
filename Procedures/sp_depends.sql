exec sp_depends 'sales.SalesOrderDetail';

-- Result:

No banco de dados atual, o objeto especificado faz referência a:                  
name                                                                               type                                updated selected column
---------------------------------------------------------------------------------- ----------------------------------- ------- -------- ---------------------
Sales.SalesOrderDetail                                                             user table                          no      no       OrderQty
Sales.SalesOrderDetail                                                             user table                          no      no       UnitPrice
Sales.SalesOrderDetail                                                             user table                          no      no       UnitPriceDiscount

No banco de dados atual, há uma referência ao objeto especificado por parte de:
name                                                                               type
---------------------------------------------------------------------------------- -----------------------------------
Sales.CK_SalesOrderDetail_OrderQty                                                 check cns
Sales.CK_SalesOrderDetail_UnitPrice                                                check cns
Sales.CK_SalesOrderDetail_UnitPriceDiscount                                        check cns
Sales.iduSalesOrderDetail                                                          trigger
Sales.SalesOrderDetail                                                             user table
