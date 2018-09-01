#!/bin/bash

# Pulls specified files from the cache.

filesToCache = "aurorastation.dme aurorastation.dmb"

if [ ! -d $1 ]; then
	echo "Cache directory doesn't exist. Unable to pull."
	return 1
fi

for file in $filesToCache; do
	fpath = "$1/$file"

	if [ ! -f $fpath ]; then
		echo "File ${file} not found in cache."
		return 1
	fi

	cp $fpath $file

	if [ $? -ne 0 ]; then
		echo "Copying file ${fpath} failed."
		return 1
	fi
done
