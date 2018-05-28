# LogArchive

LogArchive is a plugin package for [Rhetos development platform](https://github.com/Rhetos/Rhetos).
It allows archiving the *Common.Log* in order to improve the performance of logging,
and integrates the log archive into the existing auditing features.

The purpose of this package is simply to **optimize the insert operations** to the current log tables, by reducing the number of the current log records. The indexes, the primary keys and the foreign key on the log tables can hinder the application's performance significantly when the log contains a large number of records (more than a million records).

## Features

This plugin creates the **additional tables** for archiving *Common.Log* and *Common.LogRelatedItem*, and includes then in *LogReader* and *LogRelatedItemReader* so that the rest of the application uses both current and archived records.

The archive tables are in the same database as the original log tables.

## Set up the automatic log archiving

Note: This plugin does not provide the automation for moving the records from the log to the archive.

For each deployment environment, a nightly SQL job should be created that periodically moves the records from *Common.Log* and *Common.LogRelatedItem* to *Common.LogArchive* and *Common.LogRelatedItemArchive*.

## Build

**Note:** This package is already available at the [NuGet.org](https://www.nuget.org/) online gallery.
You don't need to build it from source in order to use it in your application.

To build the package from source, run `Build.bat`.
The script will pause in case of an error.
The build output is a NuGet package in the "Install" subfolder.

## Installation

To install this package to a Rhetos server, add it to the Rhetos server's *RhetosPackages.config* file
and make sure the NuGet package location is listed in the *RhetosPackageSources.config* file.

* The package ID is "**Rhetos.LogArchive**".
  This package is available at the [NuGet.org](https://www.nuget.org/) online gallery.
  It can be downloaded or installed directly from there.
* For more information, see [Installing plugin packages](https://github.com/Rhetos/Rhetos/wiki/Installing-plugin-packages).
