#!/bin/bash
set -eo pipefail
dotnet $HOME/DMCompiler_linux-x64/DMCompiler.dll --suppress-unimplemented aurorastation.dme
