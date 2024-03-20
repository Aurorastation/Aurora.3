#!/bin/bash
set -eo pipefail

echo "Download OpenDream Compiler."

cd $HOME

wget -v https://github.com/OpenDreamProject/OpenDream/releases/download/latest/DMCompiler_linux-x64.tar.gz

tar -xf DMCompiler_linux-x64.tar.gz
