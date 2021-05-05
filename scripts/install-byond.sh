#!/bin/sh
set -e
if [ -f "$HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/DreamMaker" ];
then
  echo "Using cached BYOND directory."
else
  echo "Installing dependencies."
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install libstdc++6:i386 gcc-multilib g++-7 g++-7-multilib libssl1.1:i386 zlib1g:i386
  echo "Setting up BYOND."
  mkdir -p "$HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}"
  cd "$HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}"
  echo "Installing DreamMaker to $PWD"
  curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip
  unzip -o byond.zip
  cd byond
  make here
fi
