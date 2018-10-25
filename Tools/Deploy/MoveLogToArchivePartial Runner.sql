DECLARE @Error INT = 0;
IF @@TRANCOUNT > 0 BEGIN PRINT 'ROLLBACK'; ROLLBACK; END

SELECT
    Log = (SELECT COUNT(*) FROM Common.Log WITH (NOLOCK)),
    LogArchive = (SELECT COUNT(*) FROM Common.LogArchive WITH (NOLOCK)),
    LogRelatedItem = (SELECT COUNT(*) FROM Common.LogRelatedItem WITH (NOLOCK)),
    LogRelatedItemArchive = (SELECT COUNT(*) FROM Common.LogRelatedItemArchive WITH (NOLOCK));

WHILE (SELECT COUNT(*) FROM Common.log) > 0
BEGIN
    EXEC @Error = Common.MoveLogToArchivePartial;
    SET @Error = ISNULL(NULLIF(@Error, 0), @@ERROR);
    IF @Error > 0 RETURN;

    SELECT
        Log = (SELECT COUNT(*) FROM Common.Log WITH (NOLOCK)),
        LogArchive = (SELECT COUNT(*) FROM Common.LogArchive WITH (NOLOCK)),
        LogRelatedItem = (SELECT COUNT(*) FROM Common.LogRelatedItem WITH (NOLOCK)),
        LogRelatedItemArchive = (SELECT COUNT(*) FROM Common.LogRelatedItemArchive WITH (NOLOCK));
END
