SELECT
    QuoteName(OBJECT_SCHEMA_NAME(referencing_id)) + '.'
        + QuoteName(OBJECT_NAME(referencing_id)) AS ProblemObject,
    o.type_desc,
    ISNULL(QuoteName(referenced_server_name) + '.', '')
    + ISNULL(QuoteName(referenced_database_name) + '.', '')
    + ISNULL(QuoteName(referenced_schema_name) + '.', '')
    + QuoteName(referenced_entity_name) AS MissingReferencedObject
FROM
    sys.sql_expression_dependencies sed
        LEFT JOIN sys.objects o
            ON sed.referencing_id=o.object_id
WHERE
    (is_ambiguous = 0)
    AND (OBJECT_ID(ISNULL(QuoteName(referenced_server_name) + '.', '')
    + ISNULL(QuoteName(referenced_database_name) + '.', '')
    + ISNULL(QuoteName(referenced_schema_name) + '.', '')
    + QuoteName(referenced_entity_name)) IS NULL)
ORDER BY
    ProblemObject,
    MissingReferencedObject
