@echo off
set MAPROOT=../../maps/
set TGM=1
python ../python_version_check.py
if ERRORLEVEL 1 (
    pause
    exit
)
python mapmerge.py
pause
