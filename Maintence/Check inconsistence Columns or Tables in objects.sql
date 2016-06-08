SELECT
    object_name(referencing_id) AS 'object making reference',
    referenced_class_desc,
    referenced_schema_name,
    referenced_entity_name AS 'object name referenced',
    (SELECT object_id FROM sys.objects WHERE name = [referenced_entity_name]) AS 'Object Found?'
FROM sys.sql_expression_dependencies e
    LEFT JOIN sys.tables t
    ON e.referenced_entity_name = t.name;