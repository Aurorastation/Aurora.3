#!/usr/bin/env bash

if python3 python_version_check.py
then
    read -p "Press [Enter] to continue..."
    exit
fi
pip3 install -r requirements.txt
$SHELL
