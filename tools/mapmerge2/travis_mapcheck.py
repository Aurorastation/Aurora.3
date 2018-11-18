#!/usr/bin/env python3
import os
from collections import defaultdict
import shutil
import pathlib
from dmm import *

class DMM_TRAVIS(DMM):

    def _presave_checks(self, fname):
        # last-second handling of bogus keys to help prevent and fix broken maps
        try:
            self._ensure_free_keys(0)
            max_key = max_key_for(self.key_length)
        except KeyTooLarge:
            print("\nKey is too large, run mapmerge2 on {} locally and fix errors.".format(fname[42:len(fname)]))
            exit(1)
        bad_keys = {key: 0 for key in self.dictionary.keys() if key > max_key}
        if bad_keys:
            print("\nBad keys detected, please run mapmerge2 on {} locally and fix errors.".format(fname[42:len(fname)]))
            exit(1)

def map_check(map, name):

    key_length, size = map.key_length, map.size
    merged = DMM_TRAVIS(key_length, size)
    merged.dictionary = map.dictionary.copy()

    known_keys = dict()  # mapping fron 'new' key to 'merged' key
    unused_keys = set(map.dictionary.keys())  # keys going unused

    # step one: parse the new version, compare it to the old version, merge both
    for z, y, x in map.coords_zyx:
        new_key = map.grid[x, y, z]
        # if this key has been processed before, it can immediately be merged
        try:
            merged.grid[x, y, z] = known_keys[new_key]
            continue
        except KeyError:
            pass

        def select_key(assigned):
            merged.grid[x, y, z] = known_keys[new_key] = assigned

        old_key = map.grid[x, y, z]
        old_tile = map.dictionary[old_key]
        new_tile = map.dictionary[new_key]

        # this tile is the exact same as before, so the old key is used
        if new_tile == old_tile:
            select_key(old_key)
            unused_keys.remove(old_key)

        # the tile is different here, but if it exists in the merged dictionary, that key can be used
        elif new_tile in merged.dictionary.inv:
            newold_key = merged.dictionary.inv[new_tile]
            select_key(newold_key)
            unused_keys.remove(newold_key)

        # the tile is brand new and it needs a new key, but if the old key isn't being used any longer it can be used instead
        elif old_tile not in map.dictionary.inv and old_key in unused_keys:
            merged.dictionary[old_key] = new_tile
            select_key(old_key)
            unused_keys.remove(old_key)

        # all other options ruled out, a brand new key is generated for the brand new tile
        else:
            fresh_key = merged.generate_new_key()
            merged.dictionary[fresh_key] = new_tile
            select_key(fresh_key)

    # step two: delete unused keys
    if unused_keys:
        print("Error: {} unused dictionary keys. Please run mapmerge2 on {} locally to trim them.".format(len(unused_keys), name[42:len(name)]))
        exit(1)

    return merged

if __name__ == '__main__':
    list_of_files = list()
    for root, directories, filenames in os.walk("/home/travis/build/Aurorastation/Aurora.3/maps/"):
        for filename in [f for f in filenames if f.endswith(".dmm")]:
            list_of_files.append(str(pathlib.Path(root, filename)))

    for fname in list_of_files:
        map = DMM_TRAVIS.from_file(fname)
        map_check(map, fname)._presave_checks(fname)
    print("Maps scanning complete, no issues were found.")
