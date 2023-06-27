#!/bin/bash
set -eo pipefail

git clone https://github.com/OpenDreamProject/OpenDream.git ../OpenDream
git -C ../OpenDream submodule update --init --recursive
dotnet restore ../OpenDream
dotnet build ../OpenDream/OpenDream.sln -c Release --property WarningLevel=1
