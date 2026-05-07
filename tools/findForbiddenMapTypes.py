import json
import os
from pathlib import Path

def check_forbidden_types():
    # Read the forbidden type mappings
    json_path = Path("maps/forbiddenMapTypes.json")

    with open(json_path, 'r') as f:
        data = json.load(f)

    findings = []

    # Loop through each map configuration
    for map_config in data["maps"]:
        map_name = map_config["name"]
        forbidden_types = map_config["forbidden_types"]

        # Recursively search for the map file in maps/ directory
        map_path = None
        for root, dirs, files in os.walk(Path("maps")):
            if map_name in files:
                map_path = Path(root) / map_name
                break

        # Check if map file was found
        if map_path is None:
            print(f"Map file not found: {map_name} - Check maps/forbiddenMapTypes.json")
            sys.exit(1)

        # Read the map file
        with open(map_path, 'r') as f:
            map_content = f.read()

        # Search for each forbidden type
        for forbidden_type in forbidden_types:
            if forbidden_type in map_content:
                findings.append(f"- {map_name} - {forbidden_type}")

    # Print results
    if findings:
        print("Forbidden types found in map(s):")
        for finding in findings:
            print(finding)
        print("Check the listed maps for the selected types and remove them.")
        sys.exit(1)

if __name__ == "__main__":
    check_forbidden_types()
