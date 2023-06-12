#!/bin/bash
set -eo pipefail

git clone https://github.com/OpenDreamProject/OpenDream.git ../OpenDream
git -C ../OpenDream submodule update --init --recursive
dotnet restore
dotnet build ../OpenDream.sln -c Release --property WarningLevel=1
