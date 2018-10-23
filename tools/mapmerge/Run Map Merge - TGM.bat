@echo off
set MAPROOT="../../maps"
set TGM=1
py mapmerger.py %1 %MAPROOT% %TGM%
pause