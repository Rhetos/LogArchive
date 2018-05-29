UNION ALL
SELECT
    ID,
    Created,
    UserName,
    Workstation,
    ContextInfo,
    Action,
    TableName,
    ItemId,
    Description
FROM
    Common.LogArchive WITH (NOLOCK)
