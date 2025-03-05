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

# Check that only the expected amount of raw ref proc calls are present
echo "Verifying no raw ref proc calls are being added" >> code_error.log
RAW_REF_BUILTIN_PROCS=`grep -r --include \*.dm -P --regexp='[^\w_]ref[\(\[]' | wc -l`
if [[ $RAW_REF_BUILTIN_PROCS -ne 3 ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found new raw ref proc calls in code" >> code_error.log
else
    echo "PASS: Only the expected number of raw ref proc calls were found" >> code_error.log
fi

# Check that only the expected amount of raw ref proc calls are present
echo "Verifying no raw ref proc calls are being added" >> code_error.log
RAW_REF_BUILTIN_PROCS=`grep -r --include \*.dm -P --regexp='[^\w_]ref[\(\[]' | wc -l`
if [[ $RAW_REF_BUILTIN_PROCS -ne 3 ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found new raw ref proc calls in code" >> code_error.log
else
    echo "PASS: Only the expected number of raw ref proc calls were found" >> code_error.log
fi

# Check that the text proc is not being used
echo "Verifying no built in text proc calls are being added" >> code_error.log
BUILTIN_TEXT_PROC_CALLS=`grep -r --include \*.dm -P --regexp='[^\w_\/\.]text\('`
if [[ $BUILTIN_TEXT_PROC_CALLS != '' ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found builtin calls to the text proc, use string interpolation instead:" >> code_error.log
	echo $BUILTIN_TEXT_PROC_CALLS >> code_error.log
else
    echo "PASS: No builtin calls to the text proc were found" >> code_error.log
fi

# Check that only the expected amount of raw ref proc calls are present
echo "Verifying no raw ref proc calls are being added" >> code_error.log
RAW_REF_BUILTIN_PROCS=`grep -r --include \*.dm -P --regexp='[^\w_]ref[\(\[]' | wc -l`
if [[ $RAW_REF_BUILTIN_PROCS -ne 3 ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found new raw ref proc calls in code" >> code_error.log
else
    echo "PASS: Only the expected number of raw ref proc calls were found" >> code_error.log
fi

echo "516 Href Styles"
NON_516_HREFS=`grep -r --include \*.dm -P --regexp="href[\s='\"\\\\]*\?"`
if [[ $NON_516_HREFS != '' ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: BYOND requires internal href links to begin with \"byond://\":" >> code_error.log
	echo $NON_516_HREFS >> code_error.log
else
    echo "PASS: All href links are using 516 compatible syntax" >> code_error.log
fi

##########################################################
#	Proc signatures are respected, for general procs
##########################################################
echo "Verifying proc signatures are respected" >> code_error.log

SIGNATURES_TO_LOOK_FOR='\/attackby\((?!\))(?!obj\/item\/attacking_item,\s*mob\/user(?!,(?!\s*params))).*\)'

# Append the signatures like this after the first one: SIGNATURES_TO_LOOK_FOR+='|/proc/ref2'
SIGNATURES_TO_LOOK_FOR+='|\/attack\((?!\))(?!mob\/living\/target_mob,\s*mob\/living\/user(?!,(?!\s*target_zone))).*\)'

PROC_SIGNATURES_NOT_RESPECTED=`grep -r --include \*.dm -P --regexp=$SIGNATURES_TO_LOOK_FOR`
PROC_SIGNATURES_NOT_RESPECTED_COUNT=`echo -n $PROC_SIGNATURES_NOT_RESPECTED | wc -l`
if [[ $PROC_SIGNATURES_NOT_RESPECTED_COUNT -ne 0 ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Proc signatures are not respected in code!" >> code_error.log
	echo $PROC_SIGNATURES_NOT_RESPECTED >> code_error.log
else
    echo "PASS: All proc signatures are respected in code" >> code_error.log
fi

##############################################################
#	Use GLOB for anything new, no new unmanaged global vars
##############################################################
echo "Verifying no new unmanaged globals are being added" >> code_error.log

UNMANAGED_GLOBAL_VARS_REGEXP='^/*var/'
UNMANAGED_GLOBAL_VARS_COUNT=`grep -r -o --include \*.dm -P --regexp=$UNMANAGED_GLOBAL_VARS_REGEXP | wc -l`
if [[ $UNMANAGED_GLOBAL_VARS_COUNT -ne 180 ]]; then # THE COUNT CAN ONLY BE DECREASED, NEVER INCREASED
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: New unmanaged global vars, found $UNMANAGED_GLOBAL_VARS_COUNT of them! Use GLOB or update the count ONLY IF YOU ARE REMOVING THEM!" >> code_error.log
	grep -r --include \*.dm -P --regexp=$UNMANAGED_GLOBAL_VARS_REGEXP >> code_error.log
else
    echo "PASS: No new unmanaged globals are being added" >> code_error.log
fi

##############################################################
#	Armor is a list, make sure to use it that way
##############################################################
WRONG_ARMOR_REGEXP='\s+armor\s*=[\s*](?!(list\()|(null))'
WRONG_ARMORS=`grep -r -o --include \*.dm -P --regexp=$WRONG_ARMOR_REGEXP`
if [[ $WRONG_ARMORS != '' ]]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Armor was set incorrectly! It's a list!" >> code_error.log
    echo $WRONG_ARMORS >> code_error.log
else
    echo "PASS: All armors are correctly set" >> code_error.log
fi

#######################################
#	Output the result of the checks
#######################################
echo "Found $ERROR_COUNT errors while performing code check"

if [ $ERROR_COUNT -ne 0 ]; then
    cat code_error.log
fi

exit $ERROR_COUNT
