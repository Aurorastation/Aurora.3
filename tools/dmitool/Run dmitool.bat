@echo off
python ../python_version_check.py
if ERRORLEVEL 1 (
    pause
    exit
)
python dmitool.py