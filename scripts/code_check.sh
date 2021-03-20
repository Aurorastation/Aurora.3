#!/bin/bash
echo "Working with counts: Macro-$MACRO_COUNT Gender-$GENDER_COUNT to_world-$TO_WORLD_COUNT"

if [ $# -ne 1 ]; then
    echo "Invalid argument count. specify path to run in as first argument"
    exit 1
fi

cd $1

ERROR_COUNT=0
echo "Starting Code Check" > code_error.log

echo "Checking for unscoped style tags in VueUI views:" >> code_error.log
grep -rP '<style[^>]*(?<!scoped)>' vueui/src/components/view >> code_error.log
if [ $? -eq 0 ]; then
  ERROR_COUNT=$(($ERROR_COUNT+1))
  echo "FAIL: Found unscoped style tags in VueUI views" >> code_error.log
else
  echo "PASS: Found no unscoped style tags in VueUI views" >> code_error.log
fi

echo "Checking for step_x and step_y in maps:" >> code_error.log
grep 'step_[xy]' maps/**/*.dmm >> code_error.log
if [ $? -eq 0 ]; then
    ERROR_COUNT=$(($ERROR_COUNT+1))
    echo "FAIL: Found step_x or step_y in maps" >> code_error.log
else
    echo "PASS: Found no step_x / step_y in maps:" >> code_error.log
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

echo "Found $ERROR_COUNT Errors while performing code check"

if [ $ERROR_COUNT -ne 0 ]; then
    cat code_error.log
fi

exit $ERROR_COUNT
