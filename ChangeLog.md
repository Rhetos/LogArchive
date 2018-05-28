# LogArchive release notes

## 1.0.0 (2018-05-29)

* New tables for the log archive (*Common.LogArchive* and *Common.LogRelatedItemArchive*).
* The archive table are included in the log reader views (*LogReader* and *LogRelatedItemReader*) so the rest of the application (auditing features) are not affected by migrating the log to the archive.
