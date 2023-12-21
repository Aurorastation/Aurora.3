@ECHO OFF
REM Check if an argument is provided
IF "%~1"=="" (
    echo Provide a path to dreamchecker.exe!
    exit /b 1
)

set executable="%~1"

REM Call the executable
%executable%

REM Check the exit value
IF %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)
