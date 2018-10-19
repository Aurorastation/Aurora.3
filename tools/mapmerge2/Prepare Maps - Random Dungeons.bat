@echo off
cd ../../maps/dungeon_spawns

for /R %%f in (*.dmm) do copy "%%f" "%%f.backup"

cls
echo All dmm files in the maps/dungeon_spawns directory have been backed up.
echo Now you can make your changes...
echo ---
echo Remember to run mapmerge.bat just before you commit your changes!
echo ---
pause
