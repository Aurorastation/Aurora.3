#!/bin/bash

# Pushes the specified compile outputs into the _compile folder,
# for later unloading with cache-pop.sh.

filesToCache = "aurorastation.dme aurorastation.dmb"

if [ ! -d $1 ]; then
	echo "Cache directory doesn't exist. Creating."
	mkdir $1

	if [ ! -d $1 ]; then
		echo "Failed to create cache directory."
		return 1
	fi
fi

for file in $filesToCache; do
	if [ ! -f $file ]; then
		echo "File ${file} does not exist and cannot be cached."
		return 1
	else
		cp $file $1

		if [ $? -ne 0 ]; then
			echo "Copying file ${file} failed."
			return 1
		fi
	fi
done

echo "Cache set up complete."
