cd ../../maps/aurora

for f in *.dmm; do
    cp -- "$f" "${f%.dmm}.dmm.backup"
done

echo "All dmm files in the maps/aurora directory have been backed up."
echo "Now you can make your changes."
echo "---"
echo "Remember to run mapmerge.sh just before you commit your changes!"
echo "---"
