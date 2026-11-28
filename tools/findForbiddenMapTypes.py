import json
import os
import re
import sys
from pathlib import Path


MAP_KEY_PATTERN = re.compile(r'^"([^"]+)" = \($')
GRID_BLOCK_PATTERN = re.compile(r'^\(\d+,\d+,(\d+)\) = \{"$')


def map_content_without_z_levels(map_content, ignored_z_levels):
    """Return dictionary entries used outside ignored z-levels in a DMM or TGM map."""
    lines = map_content.splitlines()
    map_entries = {}
    grid_blocks = []
    line_index = 0
    current_key = None
    current_entry_lines = []

    while line_index < len(lines):
        stripped_line = lines[line_index].strip()
        key_match = MAP_KEY_PATTERN.match(stripped_line)
        if key_match:
            if current_key:
                map_entries[current_key] = "\n".join(current_entry_lines)
            current_key = key_match.group(1)
            current_entry_lines = [lines[line_index]]
        else:
            grid_match = GRID_BLOCK_PATTERN.match(stripped_line)
            if grid_match:
                if current_key:
                    map_entries[current_key] = "\n".join(current_entry_lines)
                    current_key = None
                    current_entry_lines = []
                z_level = int(grid_match.group(1))
                block_rows = []
                line_index += 1
                while line_index < len(lines) and lines[line_index].strip() != '"}':
                    block_rows.append(lines[line_index])
                    line_index += 1
                grid_blocks.append((z_level, block_rows))
            elif current_key:
                current_entry_lines.append(lines[line_index])
        line_index += 1

    if current_key:
        map_entries[current_key] = "\n".join(current_entry_lines)

    if not map_entries or not grid_blocks:
        raise ValueError("could not parse map dictionary or grid blocks")

    key_lengths = {len(key) for key in map_entries}
    if len(key_lengths) != 1:
        raise ValueError("map dictionary keys do not have a consistent length")
    key_length = key_lengths.pop()
    used_keys = set()

    for z_level, block_rows in grid_blocks:
        if z_level in ignored_z_levels:
            continue
        for row in block_rows:
            if len(row) % key_length:
                raise ValueError(f"grid row on z{z_level} is not divisible by map key length")
            used_keys.update(row[index:index + key_length] for index in range(0, len(row), key_length))

    unknown_keys = used_keys.difference(map_entries)
    if unknown_keys:
        raise ValueError(f"grid references unknown map keys: {', '.join(sorted(unknown_keys))}")

    return "\n".join(map_entries[key] for key in used_keys)


def check_forbidden_types():
    # Read the forbidden type mappings
    json_path = Path("maps/forbiddenMapTypes.json")

    with open(json_path, 'r') as f:
        data = json.load(f)

    failed = False
    missing_maps = []
    map_parse_errors = []
    illegal_types = []

    # Loop through each forbidden type mapping
    for mapping in data["forbidden_type_mappings"]:
        title = mapping["title"]
        maps = mapping["maps"]
        ignored_z_levels_by_map = mapping.get("ignored_z_levels", {})
        forbidden_types = mapping["forbidden_types"]
        print(f"Linting step - {title}")
        print(f"  - Maps: {', '.join(maps)}")
        print(f"  - Forbidden types: {', '.join(forbidden_types)}")

        # Loop through each map in this mapping
        for map_name in maps:
            # Recursively search for the map file in maps/ directory
            map_path = None
            for root, dirs, files in os.walk(Path("maps")):
                if map_name in files:
                    map_path = Path(root) / map_name
                    break

            # Check if map file was found
            if map_path is None:
                missing_maps.append(f"- {map_name} (step: {title})")
                failed = True
                break

            # Read the map file
            with open(map_path, 'r') as f:
                map_content = f.read()

            ignored_z_levels = set(ignored_z_levels_by_map.get(map_name, []))
            if ignored_z_levels:
                print(f"  - Ignored z-levels for {map_name}: {', '.join(str(level) for level in sorted(ignored_z_levels))}")
                try:
                    map_content = map_content_without_z_levels(map_content, ignored_z_levels)
                except ValueError as error:
                    map_parse_errors.append(f"- {map_name}: {error} (step: {title})")
                    failed = True
                    continue

            # Search for each forbidden type
            for forbidden_type in forbidden_types:
                # Match mapped atoms of this type or any subtype, but not type paths
                # embedded in map variable values such as spawn lists.
                pattern = rf"^{re.escape(forbidden_type)}(?:/|\s*[,{{])"
                if re.search(pattern, map_content, re.MULTILINE):
                    illegal_types.append(f"- {map_name} - {forbidden_type} (step: {title})")
                    failed = True

    # Print results
    if failed:
        print(" ===== LINT FAILED =====")
        if missing_maps:
            print("Maps not found:")
            for item in missing_maps:
                print(item)
        if map_parse_errors:
            print("Maps could not be parsed for z-level filtering:")
            for item in map_parse_errors:
                print(item)
        if illegal_types:
            print("Forbidden types found:")
            for item in illegal_types:
                print(item)
        sys.exit(1)
    else:
        print(" ===== LINT PASSED =====")

if __name__ == "__main__":
    check_forbidden_types()
