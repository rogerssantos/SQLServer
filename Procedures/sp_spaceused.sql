-- Retrieve the number of rows and the space used (by data and index) in KB
exec sp_spaceused 'sales.SalesOrderDetail';

Result:

name                                    rows                 reserved           data               index_size         unused
--------------------------------------- -------------------- ------------------ ------------------ ------------------ ------------------
SalesOrderDetail                        121317               17448 KB           9896 KB            6264 KB            1288 KB
