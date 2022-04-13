export MAPROOT="../../maps/sccv_horizon/"
export TGM="1"
if python3 ../python_version_check.py
then
    read -p "Press [Enter] to continue..."
    exit
fi
python3 mapmerge.py

cd ../../maps/sccv_horizon

for f in *.dmm; do
    unix2dos $f
done
