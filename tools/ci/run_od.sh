#!/bin/bash
set -eo pipefail
dotnet OpenDream/OpenDream/DMCompiler/bin/Release/net7.0/DMCompiler.dll --suppress-unimplemented paradise.dme
