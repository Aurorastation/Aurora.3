@echo off
cd ../../maps/aurora-2

for /R %%f in (*.dmm) do copy "%%f" "%%f.backup"

cls
echo All dmm files in the maps/aurora-2 directory have been backed up.
echo Now you can make your changes...
echo ---
echo Remember to run Run Map Merge - TGM.bat just before you commit your changes!
echo ---
pause
