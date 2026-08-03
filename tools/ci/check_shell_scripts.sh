#!/usr/bin/env bash

# Enforces an executable bit and static analysis on shell scripts.

set -uo pipefail

severity="${SHELLCHECK_SEVERITY:-error}"
status=0
ok() { printf   '  OK   %s\n' "$1"; }
fail() { printf '  FAIL %s\n' "$1"; status=1; }

mapfile -t scripts < <(git ls-files '*.sh')

echo "Checking executable bit"
for f in "${scripts[@]}"; do
    mode="$(git ls-files -s -- "$f" | awk '{print $1; exit}')"
    if [ "$mode" = "100755" ]; then ok "$f"; else fail "$f: not executable -> git update-index --chmod=+x '$f'"; fi
done

if command -v shellcheck >/dev/null 2>&1; then
    echo "shellcheck (severity=$severity)"
    for f in "${scripts[@]}"; do
        if shellcheck --severity="$severity" -- "$f"; then ok "$f"; else status=1; fi
    done
else
    echo "shellcheck not available"
fi

if [ "$status" -ne 0 ]; then echo "FAIL"; else echo "PASS"; fi
exit "$status"
