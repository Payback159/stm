#!/usr/bin/env bash

ENV_DIR=speedtest-env
INFLUXVERS="influxdb_2.0.0-beta.9_linux_arm64.tar.gz"

mkdir "${ENV_DIR}"
cd "${ENV_DIR}" || exit
wget -O speedtest.tgz https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-aarch64-linux.tgz
tar -xzvf speedtest.tgz

#Grafana OSS
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

sudo apt-get update
sudo apt-get install grafana

#InfluxDB
wget https://dl.influxdata.com/influxdb/releases/"${INFLUXVERS}"
tar --strip-component=1 xvzf "${INFLUXVERS}"
sudo cp ./{influx,influxd} /usr/local/bin/
sudo useradd -rs /bin/false influxdb
sudo cp influxdb2.service /lib/systemd/system

#Start all services
sudo systemctl daemon-reload
sudo systemctl start grafana-server.service
sudo systemctl start influxdb2.service
sudo systemctl enable grafana-server.service
sudo systemctl enable influxdb2.service
