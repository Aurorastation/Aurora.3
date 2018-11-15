#!/usr/bin/env python3
import os
from collections import defaultdict
import frontend
import shutil
from dmm import *

class DMM_TRAVIS(DMM):
    def _presave_checks(self):
        # last-second handling of bogus keys to help prevent and fix broken maps
        self._ensure_free_keys(0)
        max_key = max_key_for(self.key_length)
        bad_keys = {key: 0 for key in self.dictionary.keys() if key > max_key}
        if bad_keys:
            raise RuntimeError("Bad keys detected, please run mapmerge2 locally and fix errors.")

def merge_map(new_map, old_map, delete_unused=False):
    if new_map.key_length != old_map.key_length:
        print("Warning: Key lengths differ, taking new map")
        print(f"  Old: {old_map.key_length}")
        print(f"  New: {new_map.key_length}")
        raise RuntimeError()

    if new_map.size != old_map.size:
        print("Warning: Map dimensions differ, taking new map")
        print(f"  Old: {old_map.size}")
        print(f"  New: {new_map.size}")
        raise RuntimeError()

    key_length, size = old_map.key_length, old_map.size
    merged = DMM(key_length, size)
    merged.dictionary = old_map.dictionary.copy()

    known_keys = dict()  # mapping fron 'new' key to 'merged' key
    unused_keys = set(old_map.dictionary.keys())  # keys going unused

    # step one: parse the new version, compare it to the old version, merge both
    for z, y, x in new_map.coords_zyx:
        new_key = new_map.grid[x, y, z]
        # if this key has been processed before, it can immediately be merged
        try:
            merged.grid[x, y, z] = known_keys[new_key]
            continue
        except KeyError:
            pass

        def select_key(assigned):
            merged.grid[x, y, z] = known_keys[new_key] = assigned

        old_key = old_map.grid[x, y, z]
        old_tile = old_map.dictionary[old_key]
        new_tile = new_map.dictionary[new_key]

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
        elif old_tile not in new_map.dictionary.inv and old_key in unused_keys:
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
        for key in unused_keys:
            del merged.dictionary[key]
        raise RuntimeError("Notice: Trimming" + {len(unused_keys)} + "unused dictionary keys. Please run mapmerge2 locally to trim them.")

    # sanity check: that the merged map equals the new map
    for z, y, x in new_map.coords_zyx:
        new_tile = new_map.dictionary[new_map.grid[x, y, z]]
        merged_tile = merged.dictionary[merged.grid[x, y, z]]
        if new_tile != merged_tile:
            print(f"Error: the map has been mangled! This is a mapmerge bug!")
            print(f"At {x},{y},{z}.")
            print(f"Should be {new_tile}")
            print(f"Instead is {merged_tile}")
            raise RuntimeError()

    return merged

if __name__ == '__main__':

    list_of_files = list()
    for root, directories, filenames in os.walk("/maps/"):
        for filename in [f for f in filenames if f.endswith(".dmm")]:
            list_of_files.append(pathlib.Path(root, filename))

    for fname in list_of_files:
        shutil.copyfile(fname, fname + ".backup")
        old_map = DMM.from_file(fname + ".backup")
        new_map = DMM.from_file(fname)
        merge_map(new_map, old_map).to_file(fname, 1)
    print("Maps scanning complete, no issues were found.")
