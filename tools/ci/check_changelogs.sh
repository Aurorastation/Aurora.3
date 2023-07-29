#!/bin/bash
set -euo pipefail

echo "6a5ae087fe5bfa66e52e508655e57120 *html/changelogs/example.yml" | md5sum -c -
python3 tools/GenerateChangelog/ss13_genchangelog.py html/changelog.html html/changelogs --dry-run
