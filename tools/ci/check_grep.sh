#!/bin/bash
echo "Working with counts: Macro-$MACRO_COUNT Gender-$GENDER_COUNT to_world-$TO_WORLD_COUNT"
echo "TGM check line: $TGM_CHECK"

if [ $# -ne 1 ]; then
    echo "Invalid argument count. specify path to run in as first argument"
    exit 1
fi

cd $1

ERROR_COUNT=0
echo "Starting Code Check" > code_error.log

echo "Checking for step_x and step_y in maps:" >> code_error.log
grep -r 'step_[xy]' --include \*.dmm maps >> code_error.log
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found step_x or step_y in maps" >> code_error.log
else
    echo "PASS: Found no step_x / step_y in maps:" >> code_error.log
fi

echo "Checking for non-TGM map files:" >> code_error.log
MAP_ERROR_COUNT=0
while read p; do if [[ "$(sed -n 1p "$p")" != *"$TGM_CHECK"* ]]; then MAP_ERROR_COUNT=$(($MAP_ERROR_COUNT+1)) && echo "FAIL: Found non-TGM mapfile in $p" >> code_error.log; fi;done <<< "$(find maps -name \*.dmm -type f)"
if [ $MAP_ERROR_COUNT -ne 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
else
    echo "PASS: All maps in maps/ are TGM format!" >> code_error.log
fi

echo "Checking for span tags with empty class in .dm files" >> code_error.log
grep -E "<\s*span\s+class\s*=\s*('[^'>]+|[^'>]+')\s*>" **/*.dm
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found incorrect span tags .dm files" >> code_error.log
else
    echo "PASS: Found no incorrect span in .dm files" >> code_error.log
fi

echo "Checking if UIDEBUG is defined" >> code_error.log
grep -r --include=\*.dm '#define UIDEBUG' ./
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: UIDEBUG is defined" >> code_error.log
else
    echo "PASS: UIDEBUG is not defined" >> code_error.log
fi

echo "Checking for link() in to_chat()" >> code_error.log
grep -r --include=\*.dm 'to_chat(.*,\s*link(' ./ >> code_error.log
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found link() in to_chat()" >> code_error.log
else
    echo "PASS: Found no link() in to_chat()" >> code_error.log
fi

echo "Verifying Formatting-Macro count matches: $MACRO_COUNT" >> code_error.log
MACRO_COUNT_FOUND=`grep -E '\\\\(red|blue|green|black|b|i[^mc])' **/*.dm | wc -l`
if [ $MACRO_COUNT -ne $MACRO_COUNT_FOUND ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Formatting-Macro count $MACRO_COUNT_FOUND does not match expected $MACRO_COUNT" >> code_error.log
else
    echo "PASS: Formatting-Macro count matches" >> code_error.log
fi

echo "Verifying Gender-Escpae count matches: $GENDER_COUNT" >> code_error.log
GENDER_COUNT_FOUND=`grep -EIr '\\\\(he|him|his|she|hers|He|His|She|himself|herself)\b' code | wc -l`
if [ $GENDER_COUNT -ne $GENDER_COUNT_FOUND ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Gender-Macro count $GENDER_COUNT_FOUND does not match expected $GENDER_COUNT" >> code_error.log
else
    echo "PASS: Gender-Macro count matches" >> code_error.log
fi

echo "Verifying to_world count matches: $TO_WORLD_COUNT" >> code_error.log
TO_WORLD_COUNT_FOUND=`grep -r --include \*.dm -oh to_world\( . | wc -w`
if [ $TO_WORLD_COUNT -ne $TO_WORLD_COUNT_FOUND ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: to_world count $TO_WORLD_COUNT_FOUND does not match expected $TO_WORLD_COUNT" >> code_error.log
else
    echo "PASS: to_world count matches" >> code_error.log
fi

echo "Checking for edge = 0/1 uses:" >> code_error.log
grep -r '\bedge\s*=\s*\d' **/*.dm >> code_error.log
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found edge = 0/1 in code" >> code_error.log
else
    echo "PASS: Did not find edge = 0/1 in code:" >> code_error.log
fi

echo "Checking for 515 proc syntax" >> code_error.log
grep '\.proc/' >> code_error.log
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo -e "FAIL: Outdated proc reference use detected in code, please use proc reference helpers."
else
    echo "PASS: Did not find outdated proc references."
fi

echo "Checking for erroneous map inclusion in the compiler" >> code_error.log
grep -rE '^#include "(.)*\.dmm"' >> code_error.log
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo -e "FAIL: You are trying to include a map in the compilation! Remove it."
else
    echo "PASS: Did not find any DMM being included to be compiled."
fi

# Check that all the files in sound/ are referenced with static paths
echo "Verifying sounds are referenced with static paths" >> code_error.log
DYNAMIC_SOUNDS_REFERENCES=`grep -r --include \*.dm -E --regexp='"(sound\/.+)"'`
if [[ $DYNAMIC_SOUNDS_REFERENCES != '' ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found sound files referenced with dynamic paths:" >> code_error.log
	echo $DYNAMIC_SOUNDS_REFERENCES >> code_error.log
else
    echo "PASS: All sounds are referenced with static paths" >> code_error.log
fi

echo "Found $ERROR_COUNT errors while performing code check"

if [ $ERROR_COUNT -ne 0 ]; then
    cat code_error.log
fi

exit $ERROR_COUNT
