SET z_levels=6
cd

FOR %%f IN (../../maps/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/%%f.backup ../../maps/%%f ../../maps/%%f
)

FOR %%f IN (../../maps/Aurora-MapDev/*.dmm) DO (
  java -jar MapPatcher.jar -clean ../../maps/Aurora-MapDev/%%f.backup ../../maps/Aurora-MapDev/%%f ../../maps/Aurora-MapDev/%%f
)

pause
