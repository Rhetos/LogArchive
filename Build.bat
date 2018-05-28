SETLOCAL
SET Version=1.0.0
SET Prerelease=auto

@SET Config=%1%
@IF [%1] == [] SET Config=Debug

CALL Tools\Build\FindVisualStudio.bat || GOTO Error0

REM Updating the version of all projects.
PowerShell -ExecutionPolicy ByPass .\Tools\Build\ChangeVersion.ps1 %Version% %Prerelease% || GOTO Error0

REM NuGet Automatic Package Restore requires "NuGet.exe restore" to be executed before the command-line build.
WHERE /Q NuGet.exe || ECHO ERROR: Please download the NuGet.exe command line tool. && GOTO Error0
NuGet.exe restore Rhetos.LogArchive.sln -NonInteractive || GOTO Error0
MSBuild.exe "Rhetos.LogArchive.sln" /target:rebuild /p:Configuration=%Config% /verbosity:minimal /fileLogger || GOTO Error0

IF NOT EXIST Install md Install
NuGet pack -OutputDirectory Install || GOTO Error0

REM Updating the version of all projects back to "dev" (internal development build), to avoid spamming git history.
PowerShell -ExecutionPolicy ByPass .\Tools\Build\ChangeVersion.ps1 %Version% dev || GOTO Error0

@REM ================================================

@ECHO.
@ECHO %~nx0 SUCCESSFULLY COMPLETED.
@EXIT /B 0

:Error0
@ECHO.
@ECHO %~nx0 FAILED.
@IF /I [%1] NEQ [/NOPAUSE] @PAUSE
@EXIT /B 1
