@echo off

rem Note: since this is called by the server, all paths are relative to Baystation12.dmb

rem Check if we have an argument actually set properly.
if "%1" == "" (
	echo Command line arguments not set!
	pause
	exit /b 1
)

rem Check if the log file actually exists.
if not exist "data\logs\_runtime\%1-runtime.log" (
	echo File does not exist!
	pause
	exit /b 1
)

rem Copy the file over, and prep it for condensing.
copy "data\logs\_runtime\%1-runtime.log" "tools\Runtime Condenser\Input.txt"

rem Call the condenser and do the deed.
cd tools\Runtime Condenser
call RuntimeCondenser.exe -q

rem Copy the output file back into the FTP folder.
copy ".\Output.txt" "..\..\data\logs\_runtime\%1-runtime-condensed.log"
echo Done!

pause

exit /b 0
