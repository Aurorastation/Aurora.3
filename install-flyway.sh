#!/bin/sh
set -e
if [ -f "$HOME/flyway-${FLYWAY_BUILD}/flyway" ];
then
  echo "Using cached Flyway directory."
else
  echo "Setting up Flyway ${FLYWAY_BUILD}."
  cd "$HOME"
  curl "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_BUILD}/flyway-commandline-${FLYWAY_BUILD}.tar.gz" -o flyway.tar.gz
  tar -xf flyway.tar.gz
  cd "flyway-${FLYWAY_BUILD}"
  chmod +x flyway
fi

