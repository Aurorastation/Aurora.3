export MAPROOT="../../maps/aurora/"
export TGM="1"
if python3 ../python_version_check.py
then
    read -p "Press [Enter] to continue..."
    exit
fi
python3 mapmerge.py

cd ../../maps/aurora

for f in *.dmm; do
    unix2dos $f
done
