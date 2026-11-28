#!/bin/sh
set -eu
: "${FLYWAY_BUILD:?FLYWAY_BUILD must be set}"

flyway_root="$HOME/flyway"
flyway_dir="$flyway_root/flyway-${FLYWAY_BUILD}"

if [ -x "$flyway_dir/flyway" ] && "$flyway_dir/flyway" -v; then
  echo "Using cached Flyway directory."
  exit 0
fi

if [ -e "$flyway_dir" ]; then
  echo "Cached Flyway ${FLYWAY_BUILD} is unusable; reinstalling." >&2
fi

echo "Setting up Flyway ${FLYWAY_BUILD}."
mkdir -p "$flyway_root"
install_dir="$(mktemp -d "$flyway_root/.install-XXXXXX")"
trap 'rm -rf -- "$install_dir"' 0
trap 'exit 1' HUP INT TERM

curl --fail --show-error --location --retry 3 \
  "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_BUILD}/flyway-commandline-${FLYWAY_BUILD}.tar.gz" \
  -o "$install_dir/flyway.tar.gz"
tar -xzf "$install_dir/flyway.tar.gz" -C "$install_dir"
chmod +x "$install_dir/flyway-${FLYWAY_BUILD}/flyway"
"$install_dir/flyway-${FLYWAY_BUILD}/flyway" -v

rm -rf -- "$flyway_dir"
mv "$install_dir/flyway-${FLYWAY_BUILD}" "$flyway_dir"
