#!/usr/bin/env bash

DIRECTORY=./venv/

if [ ! -d "$DIRECTORY" ]; then
  virtualenv -p python3 venv
fi

./venv/bin/pip install -r requirements.txt
