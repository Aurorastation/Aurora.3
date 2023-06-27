#!/bin/bash
set -eo pipefail

git clone https://github.com/OpenDreamProject/OpenDream.git $HOME/OpenDream
git -C $HOME/OpenDream submodule update --init --recursive
dotnet restore $HOME/OpenDream
dotnet build $HOME/OpenDream/OpenDream.sln -c Release --property WarningLevel=1
