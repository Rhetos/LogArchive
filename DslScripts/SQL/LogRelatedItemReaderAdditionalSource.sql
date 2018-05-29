UNION ALL
SELECT
    ID,
    LogID,
    TableName,
    ItemId,
    Relation
FROM
    Common.LogRelatedItemArchive WITH (NOLOCK)
