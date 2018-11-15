#!/bin/bash
declare -A map_names = ()
counter=0
export MAPROOT= /maps/
export TGM=1
for folder in /maps
do
    for filename in ${folder}/*.dmm
    do
        cp filename /maps/${folder}/${filename}.backup
        map_names[$counter]="$filename"
        counter=${counter}+1
    done
done
counter=0
while [ $counter != ${#array[@]} ]
do
    OUTPUT="${python tools/mapmerge2/mapmerge.py}"
    if [[ "$OUTPUT" == *"trimming"* ]]; then
        echo "Error: found unused keys in ${map_names[$counter]}. Please run mapmerge2."
        exit 1
    fi

    if [[ "$OUTPUT" == *"KeyTooLarge"* ]]; then
        echo "Error: key length is too large ${map_names[$counter]}. Please run mapmerge2."
        exit 1
    fi
    counter=${counter}+1
done
