@echo off
cd ../../maps/Aurora-MapDev

for /R %%f in (*.dmm) do copy "%%f" "%%f.backup"

cls
echo All dmm files in Aurora-MapDev directories have been backed up
echo Now you can make your changes...
echo ---
echo Remember to run Run Map Merge - DMM.bat just before you commit your changes!
echo ---
pause
