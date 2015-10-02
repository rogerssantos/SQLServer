SELECT 'select ' + 
stuff((select ', ' + c.column_name from INFORMATION_SCHEMA.COLUMNS C 
where C.TABLE_NAME = T.TABLE_NAME
for xml path('')), 1, 1, '') [INFORMATION_SCHEMA.TABLES/INFORMATION_SCHEMA.COLUMNS], 
 ' from ' + LOWER(T.TABLE_NAME)  + ';' as 'table_name'
FROM INFORMATION_SCHEMA.TABLES T 
where t.table_name like '%'
order by table_name asc