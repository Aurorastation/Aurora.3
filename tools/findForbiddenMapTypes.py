import json
import os
import sys
from pathlib import Path

def check_forbidden_types():
    # Read the forbidden type mappings
    json_path = Path("maps/forbiddenMapTypes.json")

    with open(json_path, 'r') as f:
        data = json.load(f)

    output = []

    # Loop through each forbidden type mapping
    for mapping in data["forbidden_type_mappings"]:
        reason = mapping["reason"]
        maps = mapping["maps"]
        forbidden_types = mapping["forbidden_types"]
        print(f"Linting step: {reason}")

        # Loop through each map in this mapping
        for map_name in maps:
            print(f"  - Map: {map_name}")
            # Recursively search for the map file in maps/ directory
            map_path = None
            for root, dirs, files in os.walk(Path("maps")):
                if map_name in files:
                    map_path = Path(root) / map_name
                    break

            # Check if map file was found
            if map_path is None:
                output.append(f"- Map not found - {map_name}")
                break

            # Read the map file
            with open(map_path, 'r') as f:
                map_content = f.read()

            # Search for each forbidden type
            for forbidden_type in forbidden_types:
                print(f"    - Type: {forbidden_type}")
                if forbidden_type in map_content:
                    output.append(f"- Forbidden type found - {map_name} - {forbidden_type} ({reason})")

    # Print results
    if output:
        print("LINT FAILED: See reasons below.")
        for finding in output:
            print(finding)
        sys.exit(1) # This is the important line for CI checks - Fail if we had any issues
    else:
        print("LINT PASSED: No forbidden types found on any specified maps.")

if __name__ == "__main__":
    check_forbidden_types()
