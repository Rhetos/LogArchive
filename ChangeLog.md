# LogArchive release notes

## 4.0.0 (TO BE RELEASED)

* Modified RepositoryUses type definition, for compatibility with Rhetos v6.
  * This LogArchive version is compatible with Rhesos v4.3.0 and later, including Rhetos v6.
    The previous LogArchive versions were compatible with Rhetos v2 - v5.

## 1.4.0 (2023-03-23)

* Increased SQL command timout for Actions `Common.MoveLogToArchive` and `Common.MoveLogToArchivePartial` to 30 minutes.
  The value is configurable, see [Readme.md](Readme.md).

## 1.3.0 (2021-03-05)

* Bugfix: Missing database dependencies may cause deployment to fail with an SQL error.

## 1.2.0 (2020-05-14)

* Detection of partially copied data.
* Bugfix: Missing SQL dependencies may cause deployment to fail with an SQL error.

## 1.1.0 (2018-10-23)

* New utility script "MoveLogToArchivePartial Runner.sql" for archiving the log in batches to avoid blocking of the database when moving a large log.
* Improved error handling.

## 1.0.0 (2018-05-29)

* New tables for the log archive (*Common.LogArchive* and *Common.LogRelatedItemArchive*).
* The archive table are included in the log reader views (*LogReader* and *LogRelatedItemReader*) so the rest of the application (auditing features) are not affected by migrating the log to the archive.
* Action *Common.MoveLogToArchive* and a stored procedure, for archiving the log records.
