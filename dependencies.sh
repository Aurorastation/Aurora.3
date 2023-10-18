#!/bin/sh

if [ -z ${GITHUB_ENV+x} ]; then GITHUB_ENV=/dev/null; fi

export BYOND_MAJOR=514
echo "BYOND_MAJOR=$BYOND_MAJOR" >> "$GITHUB_ENV"
export BYOND_MINOR=1589
echo "BYOND_MINOR=$BYOND_MINOR" >> "$GITHUB_ENV"

export RUST_G_VERSION=v1.2.0+a5
echo "RUST_G_VERSION=$RUST_G_VERSION" >> "$GITHUB_ENV"
export FLYWAY_BUILD=9.21.1
echo "FLYWAY_BUILD=$FLYWAY_BUILD" >> "$GITHUB_ENV"
export SPACEMAN_DMM_VERSION=suite-1.7.3
echo "SPACEMAN_DMM_VERSION=$SPACEMAN_DMM_VERSION" >> "$GITHUB_ENV"

#node version
export NODE_VERSION=14
echo "NODE_VERSION=$NODE_VERSION" >> "$GITHUB_ENV"
export NODE_VERSION_PRECISE=14.16.1
echo "NODE_VERSION_PRECISE=$NODE_VERSION_PRECISE" >> "$GITHUB_ENV"

# Python version for mapmerge and other tools
# Ensure in https://www.python.org/ftp/python/<VERSION> there is a file called python-<VERSION>-embed-amd64.zip,
# that's what the mapmerge2 script looks for
export PYTHON_VERSION=3.9.13
echo "PYTHON_VERSION=$PYTHON_VERSION" >> "$GITHUB_ENV"
