SELECT 'SELECT' + 
STUFF((SELECT ', ' + c.column_name FROM INFORMATION_SCHEMA.COLUMNS C 
		WHERE C.TABLE_NAME = T.TABLE_NAME
		FOR XML PATH('')), 1, 1, '')
		+ ' FROM ' + T.TABLE_SCHEMA + '.' + LOWER(T.TABLE_NAME) + ';' AS 'table_name'
FROM INFORMATION_SCHEMA.TABLES T 
--WHERE t.table_name like '<table_name>'
ORDER BY table_name ASC;
