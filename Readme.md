# LogArchive

LogArchive is a plugin package for [Rhetos development platform](https://github.com/Rhetos/Rhetos).

It provides simple archive storage for the Common.Log table to improve the application's performance.
The archive is placed in the same database, it is integrated into existing auditing features,
and is automatically available to the log readers.

The purpose of this package is simply to **optimize the insert operations** to the current log tables, by reducing the number of the current log records. The indexes, the primary keys and the foreign key on the log tables can hinder the application's performance significantly when the log contains a large number of records (more than a million records).

## Features

### Archive log tables

This plugin creates the additional archive tables *Common.LogArchive* and *Common.LogRelatedItemArchive*, and includes then in views *LogReader* and *LogRelatedItemReader*, so that the rest of the application uses both current and archived records.

The archive tables are in the same database as the original log tables.

### Executing the initial log archiving

If the current database already contains more then 1 million log records, it is recommended to move the current log entries to the archive in smaller batches.
Execute "MoveLogToArchivePartial Runner.sql" script in SSMS to archive the log in batches of 100000.

### Set up the automatic log archiving

Note: This plugin does not automatically schedule the process to move the records from the log to the archive.

For a deployed environment, the administrator should create a daily (nightly) schedule for one of the following options:

1. A database job that periodically executes the stored procedure *Common.MoveLogToArchive*.
2. A Task Scheduler task that periodically calls the *Common.MoveLogToArchive* action over the Rhetos [REST API](https://github.com/Rhetos/RestGenerator/blob/master/Readme.md).

This action and stored procedure move the records from *Common.Log* and *Common.LogRelatedItem* to *Common.LogArchive* and *Common.LogRelatedItemArchive*.

## Installation and configuration

Installing this package to a Rhetos application:

1. Add "Rhetos.LogArchive" NuGet package, available at the [NuGet.org](https://www.nuget.org/) on-line gallery.

## Build

**Note:** This package is already available at the [NuGet.org](https://www.nuget.org/) online gallery.
You don't need to build it from source in order to use it in your application.

To build the package from source, run `Build.bat`.
The script will pause in case of an error.
The build output is a NuGet package in the "Install" subfolder.
