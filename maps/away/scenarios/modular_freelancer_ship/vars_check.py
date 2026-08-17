import re
import sys
from pathlib import Path

# Allowed variable modifications
ALLOWED_VARS = {"dir", "pixel_x", "pixel_y", "icon_state", "name"}

def scan_dmm_file(file_path: str):
    path = Path(file_path)
    if not path.is_file():
        print(f"Error: File '{file_path}' not found.")
        return

    content = path.read_text(encoding="utf-8", errors="ignore")

    # Matches /path/to/atom{ ... } blocks across multiple lines
    atom_block_regex = re.compile(r'(/[\w/]+)\s*\{([^}]+)\}', re.DOTALL)

    # Matches var_name = value, handling quoted strings and raw values
    var_assign_regex = re.compile(
        r'([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*("(?:\\.|[^"\\])*"|[^;,\n}]+)'
    )

    violations = []
    total_overrides = 0

    for block_match in atom_block_regex.finditer(content):
        atom_type = block_match.group(1).strip()
        var_block = block_match.group(2)

        for var_match in var_assign_regex.finditer(var_block):
            total_overrides += 1
            var_name = var_match.group(1).strip()
            var_val = var_match.group(2).strip()

            if var_name not in ALLOWED_VARS:
                violations.append((atom_type, var_name, var_val))

    print(f"Scanned: {path.name}")
    print(f"Total overrides inspected: {total_overrides}")
    print(f"Banned variable changes found: {len(violations)}\n")

    if violations:
        print(f"{'ATOM TYPE':<65} | {'BANNED VAR':<20} | {'VALUE'}")
        print("-" * 105)
        for atom_type, var_name, var_val in violations:
            print(f"{atom_type:<65} | {var_name:<20} | {var_val}")
    else:
        print("All variable changes are within the allowed list.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python check_map.py <path_to_map.dmm>")
    else:
        scan_dmm_file(sys.argv[1])
