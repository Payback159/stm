#!/usr/bin/env bash

set -eo pipefail

FILE=speedtest
DATA_FILE=speedtest-data.csv

function setup_python_environment {
  python3 -m venv ./venv
  ./venv/bin/pip install speedtest-cli influxdb datetime
}


if [ python3 --version ]; then
  sudo apt install python3-venv
  setup_python_environment
else
  sudo apt install python3 --yes
  sudo apt install python3-venv
  setup_python_environment
fi

exit 0

echo "Executing docker compose"
docker-compose up -d
