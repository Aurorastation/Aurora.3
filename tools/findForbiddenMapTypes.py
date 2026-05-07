import json
import os
import sys
from pathlib import Path

def check_forbidden_types():
    # Read the forbidden type mappings
    json_path = Path("maps/forbiddenMapTypes.json")

    with open(json_path, 'r') as f:
        data = json.load(f)

    failed = False
    missing_maps = []
    illegal_types = []

    # Loop through each forbidden type mapping
    for mapping in data["forbidden_type_mappings"]:
        reason = mapping["reason"]
        maps = mapping["maps"]
        forbidden_types = mapping["forbidden_types"]
        print(f"Linting step: {reason}")
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
                missing_maps.append(f"- {map_name}")
                failed = True
                break

            # Read the map file
            with open(map_path, 'r') as f:
                map_content = f.read()

            # Search for each forbidden type
            for forbidden_type in forbidden_types:
                if forbidden_type in map_content:
                    illegal_types.append(f"- {map_name} - {forbidden_type} ({reason})")
                    failed = True

    # Print results
    if failed:
        print(" ===== LINT FAILED =====")
        if missing_maps:
            print("Maps not found:")
            for item in missing_maps:
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
