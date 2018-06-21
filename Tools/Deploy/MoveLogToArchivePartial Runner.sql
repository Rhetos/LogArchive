DECLARE @Error INT = 0;
if @@trancount > 0 rollback;

SELECT
    Log = (select count(*) from common.log with (nolock)),
    LogArchive = (select count(*) from common.LogArchive with (nolock)),
    LogRelatedItem = (select count(*) from common.LogRelatedItem with (nolock)),
    LogRelatedItemArchive = (select count(*) from common.LogRelatedItemArchive with (nolock));

while (select count(*) from common.log) > 0
begin
    EXEC @Error = Common.MoveLogToArchivePartial;
    SET @Error = ISNULL(NULLIF(@Error, 0), @@ERROR);
    IF @Error > 0 RETURN;

    SELECT
        Log = (select count(*) from common.log with (nolock)),
        LogArchive = (select count(*) from common.LogArchive with (nolock)),
        LogRelatedItem = (select count(*) from common.LogRelatedItem with (nolock)),
        LogRelatedItemArchive = (select count(*) from common.LogRelatedItemArchive with (nolock));

end