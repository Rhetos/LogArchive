SELECT TOP 1 ID FROM Common.Log WITH (TABLOCKX); -- The Log is locked before the LogRelatedItem to minimize deadlocks.
SELECT TOP 1 ID FROM Common.LogRelatedItem WITH (TABLOCKX);

INSERT INTO Common.LogArchive (ID, ItemId, TableName, Action, ContextInfo, Workstation, Created, Description, UserName)
SELECT ID, ItemId, TableName, Action, ContextInfo, Workstation, Created, Description, UserName
FROM Common.Log;

INSERT INTO Common.LogRelatedItemArchive (ID, LogID, ItemId, Relation, TableName)
SELECT ID, LogID, ItemId, Relation, TableName
FROM Common.LogRelatedItem;

TRUNCATE TABLE Common.LogRelatedItem;
DELETE FROM Common.Log;
