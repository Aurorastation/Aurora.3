#!/usr/bin/env python3
from collections import defaultdict
import shutil
import mapmerge
from dmm import *

if __name__ == '__main__':

    list_of_files = list()
    for root, directories, filenames in os.walk(settings.map_folder):
        for filename in [f for f in filenames if f.endswith(".dmm")]:
            list_of_files.append(pathlib.Path(root, filename))

    for fname in list_of_files:
        shutil.copyfile(fname, fname + ".before")
        old_map = DMM.from_file(fname + ".backup")
        new_map = DMM.from_file(fname)
        mapmerge.merge_map(new_map, old_map).to_file(fname, 1)
    print("Maps scanning complete, no issues were found.")
