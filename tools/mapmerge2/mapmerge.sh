export MAPROOT="../../maps/aurora/"
export TGM="1"
python3 mapmerge.py

cd ../../maps/aurora

for f in *.dmm; do
    unix2dos $f
done
