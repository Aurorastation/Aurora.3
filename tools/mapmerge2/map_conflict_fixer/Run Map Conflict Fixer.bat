@echo off
SET RELATIVEROOT="../../../"
python ../../python_version_check.py
if ERRORLEVEL 1 (
    pause
    exit
)
python map_conflict_fixer.py %1 %RELATIVEROOT%
pause