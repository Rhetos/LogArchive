-- Error handling initialization
DECLARE @InitialTranCount INT = @@TRANCOUNT;
DECLARE @TranName VARCHAR(38) = NEWID();
IF @InitialTranCount = 0 BEGIN TRANSACTION @TranName;
ELSE SAVE TRANSACTION @TranName;
DECLARE @Error INT = 0;

CREATE TABLE #moving (ID uniqueidentifier PRIMARY KEY);

INSERT INTO Common.LogArchive (ID, ItemId, TableName, Action, ContextInfo, Workstation, Created, Description, UserName)
OUTPUT INSERTED.ID INTO #moving (ID)
SELECT TOP 100000 ID, ItemId, TableName, Action, ContextInfo, Workstation, Created, Description, UserName
FROM Common.Log WITH (TABLOCKX); -- The Log is locked before the LogRelatedItem to minimize deadlocks.

SET @Error = @@ERROR;
IF @Error = 2627
BEGIN
    INSERT INTO #moving (ID)
    SELECT TOP 100000 l.ID
    FROM
        Common.Log l
        INNER JOIN Common.LogArchive la ON la.ID = l.ID;

    SET @Error = @@ERROR;
END
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

INSERT INTO Common.LogRelatedItemArchive (ID, LogID, ItemId, Relation, TableName)
SELECT ID, LogID, ItemId, Relation, TableName
FROM Common.LogRelatedItem WITH (TABLOCKX)
WHERE LogID IN (SELECT ID FROM #moving);

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

-- Some databases don't have cascade delete in database, depending on Rhetos configuration settings.
DELETE FROM Common.LogRelatedItem
WHERE LogID IN (SELECT ID FROM #moving);

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

DELETE FROM Common.Log
WHERE ID IN (SELECT ID FROM #moving);

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

-- Error handling cleanup
IF @InitialTranCount = 0 COMMIT TRANSACTION @TranName;
RETURN 0;
