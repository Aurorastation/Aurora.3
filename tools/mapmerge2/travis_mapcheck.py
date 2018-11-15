#!/usr/bin/env python3
import os
from collections import defaultdict
import shutil
import pathlib
from dmm import *

class DMM_TRAVIS(DMM):

    @staticmethod
    def to_file(self, fname, tgm = True):
        try:
            self._presave_checks(fname)
            with open(fname, 'w', newline='\n', encoding=ENCODING) as f:
                (save_tgm if tgm else save_dmm)(self, f)
        except KeyTooLarge:
            print(KeyTooLarge)
            print("\nKey is too large, run mapmerge2 on {} locally and fix errors.".format(fname))
            raise RuntimeError()

    def _presave_checks(self, fname):
        # last-second handling of bogus keys to help prevent and fix broken maps
        self._ensure_free_keys(0)
        max_key = max_key_for(self.key_length)
        bad_keys = {key: 0 for key in self.dictionary.keys() if key > max_key}
        if bad_keys:
            print("Bad keys detected, please run mapmerge2 on {} locally and fix errors.".format(fname))
            raise RuntimeError()

def merge_map(new_map, old_map, name):
    if new_map.key_length != old_map.key_length:
        print("Warning: Key lengths differ, taking new map")
        print("  Old: {}".format(old_map.key_length))
        print("  New: {}".format(new_map.key_length))
        print("\nIn file {}".format(name))
        raise RuntimeError()

    if new_map.size != old_map.size:
        print("Warning: Map dimensions differ, taking new map")
        print("  Old: {}".format(old_map.size))
        print("  New: {}".format(new_map.size))
        print("\nIn file {}".format(name))
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
        print("Error: {} unused dictionary keys. Please run mapmerge2 on {} locally to trim them.".format(len(unused_keys), name))
        raise RuntimeError()

    # sanity check: that the merged map equals the new map
    for z, y, x in new_map.coords_zyx:
        new_tile = new_map.dictionary[new_map.grid[x, y, z]]
        merged_tile = merged.dictionary[merged.grid[x, y, z]]
        if new_tile != merged_tile:
            print("Error: the map has been mangled! This is a mapmerge bug!")
            print("At {},{},{}.".format(x, y, z))
            print("Should be {}".format(new_tile))
            print("Instead is {}".format(merged_tile))
            print("map name: {}".format(name))
            raise RuntimeError()

    return merged

if __name__ == '__main__':

    list_of_files = list()
    for root, directories, filenames in os.walk("/home/travis/build/Aurorastation/Aurora.3/maps/"):
        for filename in [f for f in filenames if f.endswith(".dmm")]:
            list_of_files.append(str(pathlib.Path(root, filename)))

    for fname in list_of_files:
        shutil.copyfile(fname, fname + ".backup")
        old_map = DMM_TRAVIS.from_file(fname + ".backup")
        new_map = DMM_TRAVIS.from_file(fname)
        merge_map(new_map, old_map, fname).to_file(fname, 1)
    print("Maps scanning complete, no issues were found.")
