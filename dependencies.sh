#!/bin/sh

if [ -z ${GITHUB_ENV+x} ]; then GITHUB_ENV=/dev/null; fi

export BYOND_MAJOR=515
echo "BYOND_MAJOR=$BYOND_MAJOR" >> "$GITHUB_ENV"
export BYOND_MINOR=1633
echo "BYOND_MINOR=$BYOND_MINOR" >> "$GITHUB_ENV"

export RUST_G_VERSION=v1.2.0+a5
echo "RUST_G_VERSION=$RUST_G_VERSION" >> "$GITHUB_ENV"
export FLYWAY_BUILD=9.21.1
echo "FLYWAY_BUILD=$FLYWAY_BUILD" >> "$GITHUB_ENV"
export SPACEMAN_DMM_VERSION=suite-1.8
echo "SPACEMAN_DMM_VERSION=$SPACEMAN_DMM_VERSION" >> "$GITHUB_ENV"

#node version
export NODE_VERSION=20
echo "NODE_VERSION=$NODE_VERSION" >> "$GITHUB_ENV"
export NODE_VERSION_LTS=20.12.0
echo "NODE_VERSION_LTS=$NODE_VERSION_LTS" >> "$GITHUB_ENV"


# Python version for mapmerge and other tools
# Ensure in https://www.python.org/ftp/python/<VERSION> there is a file called python-<VERSION>-embed-amd64.zip,
# that's what the mapmerge2 script looks for
export PYTHON_VERSION=3.11.9
echo "PYTHON_VERSION=$PYTHON_VERSION" >> "$GITHUB_ENV"
