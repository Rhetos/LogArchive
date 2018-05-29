SETLOCAL
SET Version=1.0.0
SET Prerelease=auto


REM Updating the version of all projects.
PowerShell -ExecutionPolicy ByPass .\Tools\Build\ChangeVersion.ps1 %Version% %Prerelease% || GOTO Error0

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
