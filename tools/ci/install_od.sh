#!/bin/bash
set -eo pipefail

if [ -d "$HOME/OpenDream/" ];
then
  echo "Using cached OpenDream directory."

  git -C $HOME/OpenDream fetch origin
  git -C $HOME/OpenDream reset --hard origin/master

  git -C $HOME/OpenDream submodule update --init --recursive


else
  echo "Setting up OpenDream."

  git clone https://github.com/OpenDreamProject/OpenDream.git $HOME/OpenDream
  git -C $HOME/OpenDream submodule update --init --recursive
fi

dotnet restore $HOME/OpenDream
dotnet build $HOME/OpenDream/OpenDream.sln -c Release --property WarningLevel=1
