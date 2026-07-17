@echo off
rem Cheridan asked for this. - N3X
python ../python_version_check.py
if ERRORLEVEL 1 (
    pause
    exit
)
call python ss13_genchangelog.py ../../html/changelog.html ../../html/changelogs
pause
