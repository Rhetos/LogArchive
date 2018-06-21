-- Error handling initialization
DECLARE @InitialTranCount INT = @@TRANCOUNT;
DECLARE @TranName VARCHAR(38) = NEWID();
IF @InitialTranCount = 0 BEGIN TRANSACTION @TranName;
ELSE SAVE TRANSACTION @TranName;
DECLARE @Error INT = 0;

INSERT INTO Common.LogArchive (ID, ItemId, TableName, Action, ContextInfo, Workstation, Created, Description, UserName)
SELECT ID, ItemId, TableName, Action, ContextInfo, Workstation, Created, Description, UserName
FROM Common.Log WITH (TABLOCKX); -- The Log is locked before the LogRelatedItem to minimize deadlocks.

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

INSERT INTO Common.LogRelatedItemArchive (ID, LogID, ItemId, Relation, TableName)
SELECT ID, LogID, ItemId, Relation, TableName
FROM Common.LogRelatedItem WITH (TABLOCKX);

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

TRUNCATE TABLE Common.LogRelatedItem;

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

DELETE FROM Common.Log;

SET @Error = @@ERROR;
IF @Error > 0 BEGIN ROLLBACK TRANSACTION @TranName; RETURN @Error; END;

-- Error handling cleanup
IF @InitialTranCount = 0 COMMIT TRANSACTION @TranName;
RETURN 0;
