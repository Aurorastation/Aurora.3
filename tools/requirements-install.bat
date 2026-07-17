@echo off
python python_version_check.py
if ERRORLEVEL 1 (
    pause
    exit
)
python -m pip install -r requirements.txt
pause
