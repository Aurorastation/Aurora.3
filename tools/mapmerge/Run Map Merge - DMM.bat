@echo off
set MAPROOT="../../maps"
set TGM=0
python mapmerger.py %1 %MAPROOT% %TGM%
pause