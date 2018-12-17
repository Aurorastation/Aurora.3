@echo off
set MAPROOT="../../maps"
set TGM=1
python mapmerger.py %1 %MAPROOT% %TGM%
pause
