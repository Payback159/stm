#!/usr/bin/env bash

set -eo pipefail

FILE=speedtest
DATA_FILE=speedtest-data.csv

if [ -f "${FILE}" ]; then
  echo "Speedtest binary isn't older than 1 day - Skipped download"
else
  wget -O "${FILE}".tgz https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-aarch64-linux.tgz
  tar -xzvf "${FILE}".tgz
fi

if [ ! -f "${DATA_FILE}" ] && [ -f "${FILE}" ]; then
    echo "Running initial speedtest to create csv header"
    ./speedtest --format=csv --output-header > "${DATA_FILE}"
else
  echo "${DATA_FILE} exists! - skipping initial speedtest to create csv header"
fi

echo "Executing docker compose"
docker-compose up -d
