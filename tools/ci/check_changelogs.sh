#!/bin/bash
set -euo pipefail

echo "5ed5da1545365bd137f3d31168a69342 *html/changelogs/example.yml" | md5sum -c -
python3 tools/GenerateChangelog/ss13_genchangelog.py html/changelogs
