USE energov381407prod_ThousandOaksCA

SELECT
    COL_NAME(pkc.object_id, pkc.column_id) AS PrimaryKeyColumn,
    OBJECT_NAME(pk.parent_object_id) AS PrimaryKeyTable,
    OBJECT_NAME(fk.parent_object_id) AS ForeignKeyTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ForeignKeyColumn
FROM
    sys.key_constraints AS pk
INNER JOIN
    sys.index_columns AS pkc
    ON pk.parent_object_id = pkc.object_id
    AND pk.unique_index_id = pkc.index_id
INNER JOIN
    sys.foreign_key_columns AS fkc
    ON pk.parent_object_id = fkc.referenced_object_id
    AND COL_NAME(pkc.object_id, pkc.column_id) = COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id)
INNER JOIN
    sys.foreign_keys AS fk
    ON fkc.constraint_object_id = fk.object_id
WHERE
--foreign key
COL_NAME(fkc.parent_object_id, fkc.parent_column_id) = 'PMPERMITTYPECSSUPLOADSETTINGTYPEID'



--OR COL_NAME(pkc.object_id, pkc.column_id) = 'CACOMPUTEDFEEID'
--primary key
--COL_NAME(pkc.object_id, pkc.column_id) = 'CAFEETYPEID'
--pk.type = 'PK'

ORDER BY
    PrimaryKeyTable, ForeignKeyTable;